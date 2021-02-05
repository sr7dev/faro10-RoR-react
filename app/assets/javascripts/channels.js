$('.meetings.show').ready(function(){
    data = $('.meeting-room').data('current-user-token');
    console.log(data);
    // launchVideoChat(data);
});

$('.channels.index').ready(function(){
    togglePassword();
    document.getElementById('meeting_privacy').onclick = function() {
        togglePassword()
    }
});


var activeRoom;
var previewTracks;
var identity;
var token;
var roomName;
var localParticipant;
var allMuted = false;

function launchVideoChat(data) {
    console.log('launching video...');

    // Check for WebRTC
    if (!navigator.webkitGetUserMedia && !navigator.mozGetUserMedia) {
        alert('WebRTC is not available in your browser.  Please try Firefox or Google Chrome.');
    }

    // When we are about to transition away from this page, disconnect
    // from the room, if joined.
    window.addEventListener('beforeunload', leaveRoomIfJoined);

    identity = data.identity;
    token = data.token;

    document.getElementById('room-controls').style.display = 'block';

    // Bind button to join Room.
    document.getElementById('button-join').onclick = function() {
        roomName = document.getElementById('room-name').value;

        if (!roomName) {
            alert('Please enter a room name.');
            return;
        }

        log("Joining room '" + roomName + "'...");

        var connectOptions = {
            name: roomName,
            // logLevel: 'debug'
        };

        if (previewTracks) {
            connectOptions.tracks = previewTracks;
        }

        $.ajax({
            dataType: "json",
            url: window.location.href + "/join",
            method: "POST",
        });

        // Join the Room with the token and the LocalParticipant's Tracks.
        activeRoom = Twilio.Video.connect(token, connectOptions).then(roomJoined, function(error){
            log('Could not connect to Twilio: ' + error.message);
        });
    };
    // Bind button to leave Room.
    document.getElementById('button-leave').onclick = function() {
        log('Leaving room...');
        localParticipant.audioTracks.forEach(function (audioTrack) {
            audioTrack.disable();
        });
        localParticipant.videoTracks.forEach(function (videoTrack) {
            videoTrack.disable();
        });
        activeRoom.disconnect();
        document.getElementById('button-join').disabled = false;
        document.getElementById('button-leave').disabled = true;
        document.getElementById('button-preview').disabled = false;
        location.href = '/meetings';
    };

    // Preview LocalParticipant's Tracks.
    document.getElementById('button-preview').onclick = function() {
        var localTracksPromise = previewTracks
            ? Promise.resolve(previewTracks)
            : Twilio.Video.createLocalTracks({
                audio: true,
                video: { width: 320 },
            });

        localTracksPromise.then(function(tracks) {
            window.previewTracks = previewTracks = tracks;
            var previewContainer = document.getElementById('local-media-video');
            if (!previewContainer.querySelector('video')) {
                attachTracks(tracks, previewContainer);
            }
        }, function(error) {
            console.error('Unable to access local media', error);
            log('Unable to access Camera and Microphone');
        });
        document.getElementById('button-preview').disabled = true;
    };
    // Bind image to mute and unmute.
    document.getElementById('button-voice').onclick = function() {
        // mute only local media streams
        muteParticipant(localParticipant);
    };

    document.getElementById('button-voice-muted').onclick = function() {
        // unmute only local media streams
        unMuteParticipant(localParticipant);
    };

    // Bind image to mute and unmute.
    document.getElementById('button-video').onclick = function() {
        // disable local media streams
        disableVideo(localParticipant);
    };

    document.getElementById('button-video-muted').onclick = function() {
        // enable local media streams
        enableVideo()
    };

    document.getElementById('button-mute-all').onclick = function() {
        if (activeRoom != null) {
            if (allMuted == false) {
                muteAll();
            } else {
                unmuteAll();
            }
        }
    };
};

// Successfully connected!
function roomJoined(room) {
    window.room = activeRoom = room;
    console.log(room);

    localParticipant = room.localParticipant;

    log("Joined as '" + identity + "'");
    document.getElementById('button-join').disabled = true;
    document.getElementById('button-leave').disabled = false;
    document.getElementById('button-preview').disabled = true;

    // Attach LocalParticipant's Tracks, if not already attached.
    var previewContainer = document.getElementById('local-media-video');
    if (!previewContainer.querySelector('video')) {
        attachParticipantTracks(room.localParticipant, previewContainer);
        muteParticipant(localParticipant);
        enableVideo(localParticipant);
    }

    // Attach the Tracks of the Room's Participants.
    room.participants.forEach(function(participant) {
        log("Already in Room: '" + participant.identity + "'");
        var previewContainer = document.getElementById('remote-media-video-' + participant.identity);
        attachParticipantTracks(participant, previewContainer);
    });

    // When a Participant joins the Room, log the event.
    room.on('participantConnected', function(participant) {
        log("Joining: '" + participant.identity + "'");
    });

    // When a Participant joins the Room, log the event.
    room.on('participantConnected', function(participant) {
        log("Joining: '" + participant.identity + "'");
    });

    // When a Participant adds a Track, attach it to the DOM.
    room.on('trackAdded', function(track, participant) {
        log(participant.identity + " added track: " + track.kind);
        var previewContainer;
        var userNameText;
        var userNode = document.querySelector('#remote\\-media\\-container');
        if (document.getElementById('remote-media-video-' + participant.identity) ==null) {
            var userVideo = 'remote-media-video-' + participant.identity;
            previewContainer = document.createElement("div");
            previewContainer.id = userVideo;
            previewContainer.className = 'remote-media-video';
            userNode.insertBefore(previewContainer, userNode.firstChild);
            //previewContainer = userNode.appendChild(document.createTextNode("<div id='" + userVideo + "'></div>"));
            userNameText = document.createElement("div");
            userNameText.id = 'remote-media-text-' + participant.identity;
            userNameText.className = 'remote-media-text';
            userNameText.innerHTML = participant.identity;
            previewContainer.appendChild(userNameText, null);
        }
        previewContainer = document.getElementById('remote-media-video-' + participant.identity);
        attachTracks([track], previewContainer);
    });

    // When a Participant removes a Track, detach it from the DOM.
    room.on('trackRemoved', function(track, participant) {
        log(participant.identity + " removed track: " + track.kind);
        detachTracks([track]);
    });

    // When a Participant leaves the Room, detach its Tracks.
    room.on('participantDisconnected', function(participant) {
        log("Participant '" + participant.identity + "' left the room");
        detachParticipantTracks(participant);
        var previewContainer = document.getElementById('remote-media-video-' + participant.identity);
        previewContainer.remove();
        var userTextName = document.getElementById('remote-media-text-' + participant.identity);
        userTextName.remove();
    });


// --------------------------------------------------------------------------

    // Once the LocalParticipant leaves the room, detach the Tracks
    // of all Participants, including that of the LocalParticipant.
    room.on('disconnected', function() {
        log('Left');
        if (previewTracks) {
            previewTracks.forEach(function(track) {
                track.stop();
            });
        }
        detachParticipantTracks(room.localParticipant);
        room.participants.forEach(detachParticipantTracks);
        activeRoom = null;
        document.getElementById('button-join').disabled = false;
        document.getElementById('button-leave').disabled = true;
        document.getElementById('button-preview').disabled = false;
        muteParticipant(localParticipant);
        disableVideo(localParticipant);
        var previewContainer = document.getElementById('remote-media-container');
        previewContainer.innerHTML="";
    });
}

// mute all
function muteAll() {
    console.log('muting');
    debugger;
    activeRoom.participants.forEach(function(participant) {
        participant.audioTracks.forEach(function (audioTrack) {
            audioTrack.disable();
        });
    });
    allMuted = true;
}

// unmute all
function unmuteAll() {
    console.log('unmuting');
    activeRoom.participants.forEach(function(participant) {
        participant.audioTracks.forEach(function (audioTrack) {
            audioTrack.enable();
        });
    });
    allMuted = false;
}

//Mute partiipant
function muteParticipant(partipant) {
    document.getElementById('button-voice').style.display = 'none';
    document.getElementById('button-voice-muted').style.display = 'inline';
    localParticipant.audioTracks.forEach(function (audioTrack) {
        audioTrack.disable();
    });
}

//unMute partiipant
function unMuteParticipant(partipant) {
    document.getElementById('button-voice').style.display = 'inline';
    document.getElementById('button-voice-muted').style.display = 'none';
    localParticipant.audioTracks.forEach(function (audioTrack) {
        audioTrack.enable();
    });
}

//disable Video
function disableVideo(partipant) {
    document.getElementById('button-video').style.display = 'none';
    document.getElementById('button-video-muted').style.display = 'inline';
    localParticipant.videoTracks.forEach(function (videoTrack) {
        videoTrack.disable();
    });
}

//enable Video
function enableVideo(partipant) {
    document.getElementById('button-video').style.display = 'inline';
    document.getElementById('button-video-muted').style.display = 'none';
    localParticipant.videoTracks.forEach(function (videoTrack) {
        videoTrack.enable();
    });

}

// Attach the Tracks to the DOM.
function attachTracks(tracks, container) {
    tracks.forEach(function(track) {
        container.appendChild(track.attach());
    });
}

// Attach the Participant's Tracks to the DOM.
function attachParticipantTracks(participant, container) {
    var tracks = Array.from(participant.tracks.values());
    attachTracks(tracks, container);
}

// Detach the Tracks from the DOM.
function detachTracks(tracks) {
    tracks.forEach(function(track) {
        track.detach().forEach(function(detachedElement) {
            detachedElement.remove();
        });
    });
}

// Detach the Participant's Tracks from the DOM.
function detachParticipantTracks(participant) {
    var tracks = Array.from(participant.tracks.values());
    detachTracks(tracks);
}

// Activity log.
function log(message) {
    var logDiv = document.getElementById('log');
    logDiv.innerHTML += '<p>&gt;&nbsp;' + message + '</p>';
    logDiv.scrollTop = logDiv.scrollHeight;
}

// Leave room
function leaveRoomIfJoined() {
    if (activeRoom) {
        activeRoom.disconnect();
    }
}
