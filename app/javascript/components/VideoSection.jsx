import React from 'react';
import Video, { createLocalVideoTrack } from 'twilio-video';
import { MicButton, VideoCamButton, HangupButton, ChatButton } from './VideoControls';
import { MdPerson } from 'react-icons/lib/md';
import ChatSection from './ChatSection';

export default class VideoSection extends React.Component {
  constructor(props) {
  	super(props);

    const parsedToken = JSON.parse(this.props.twilioToken);

    this.activeRoom = null;
    this.twilioToken = parsedToken['token'];
    this.identity = parsedToken['identity'];

  	this.state = {
      previewVisible: true,
      isInActiveRoom: false,
      isCameraOn: true,
      isMicOn: true,
      isChatVisible: true,
      participants: [],
    };
  }

  componentDidMount() {
    // ensure video is ended before window is closed
    window.addEventListener("beforeunload", this.leaveRoomIfJoined);

    // start preview video
    if (this.state.previewVisible) {
      this.createLocalVideo();  
    }

    this.connectToRoom();
  };

  createLocalVideo = () => {
    createLocalVideoTrack().then(track => {
      var localMediaContainer = document.getElementById('local-media-ctr');
      localMediaContainer.appendChild(track.attach());
    });
  }

  connectToRoom = () => {
    const token = this.twilioToken;
    const roomName = this.props.meeting.room_name;

    Video.connect(token, {name:roomName})
      .then(room => {
        console.log('Successfully joined a Room: ', room);

        // this.joinMeetingBackendAPI();
        this.props.updateMeetingStatus(true);

        this.roomJoined(room);
    }, error => console.error('Unable to connect to Room: ' +  error.message));
  }

  joinMeetingBackendAPI = () => {
    const userEmail = this.props.user.email;
    const userToken = this.props.userToken;

    const url = this.props.baseURL + '/api/meetings/' + this.props.meeting.id + '/join?'
      + 'session[email]=' + encodeURIComponent(userEmail)
      + '&session[token]=' + encodeURIComponent(userToken);

    fetch(url, {
        method: 'post',
      })
      .then(results => results.json())
      .then(data => {

        console.log(data);

      });
  }

  roomJoined = (room) => {
    console.log("Joined as '" + this.identity + "'");

    // update room info
    this.activeRoom = room;
    window.room = room.name;

    this.setState({
      isInActiveRoom: true,
    });

    // Attach LocalParticipant's Tracks, if not already attached.
    var previewContainer = this.refs.localMedia;
    if (!previewContainer.querySelector("video")) {
      this.attachParticipantTracks(room.localParticipant, previewContainer);
    }

    var participantArray = [];

    // load participants into array
    room.participants.forEach((participant)=> {
      console.log("Already in Room: '" + participant.identity + "'");
      participantArray.push(participant);
    });
    
    // update state with participants
    this.setState({
      participants: participantArray,
    }, () => {
      // attach each participant to their given video div
      this.state.participants.forEach((participant) => {
        var previewContainer = document.getElementById("video-container-" + participant.identity);
        this.attachParticipantTracks(participant, previewContainer);
      })
    });

    room.on("participantConnected", this.participantConnected);
    room.on("trackAdded", this.trackAdded);
    room.on("trackRemoved", this.trackRemoved);
    room.on('trackEnabled', this.trackEnabled);
    room.on('trackDisabled', this.trackDisabled);
    room.on("participantDisconnected", this.participantDisconnected);
    room.on("disconnected", this.disconnected);
  }

  participantConnected = (participant) => {
    console.log("Joining: '" + participant.identity + "'");

    var participants = this.state.participants;
    participants.push(participant);
    this.setState({
      participants: participants,
    });
  }

  trackAdded = (track, participant) => {
    console.log(participant.identity + " added track: " + track.kind);
    var previewContainer = document.getElementById("video-container-" + participant.identity);

    this.attachTracks([track], previewContainer);

    var participants = this.state.participants;
    var index = participants.indexOf(participant);

    participants[index] = participant;
      
    this.setState({
      participants: participants,
    });
  }

  trackRemoved = (track, participant)=> {
    console.log(participant.identity + " removed track: " + track.kind);
    this.detachTracks([track]);

    var participants = this.state.participants;
    var index = participants.indexOf(participant);

    participants[index] = participant;
    
    this.setState({
      participants: participants,
    });
  }

  trackEnabled = (track, participant) => {
    var previewContainer = document.getElementById("video-container-" + participant.identity);
    this.attachTracks([track], previewContainer);
    console.log(participant.identity + " enabled track: " + track.kind);

    var participants = this.state.participants;
    var index = participants.indexOf(participant);

    participants[index] = participant;
    
    this.setState({
      participants: participants,
    });
  }

  trackDisabled = (track, participant) => {
    this.detachTracks([track]);
    console.log(participant.identity + " disabled track: " + track.kind);

    var participants = this.state.participants;
    var index = participants.indexOf(participant);

    participants[index] = participant;
    
    this.setState({
      participants: participants,
    });
  }

  participantDisconnected = (participant) => {
    console.log("Participant '" + participant.identity + "' left the room");
    this.detachParticipantTracks(participant);

    var participants = this.state.participants;
    participants.splice(participants.indexOf(participant), 1);
    this.setState({
      participants: participants,
    });
  }

  disconnected = () => {
    console.log("Left");
    if (this.previewTracks) {
        this.previewTracks.forEach((track)=> {
            track.stop();
        });
    }
    this.detachParticipantTracks(this.activeRoom.localParticipant);
    this.activeRoom.participants.forEach(this.detachParticipantTracks);
    this.activeRoom = null;
  }

  attachTracks = (tracks, container) => {
    tracks.forEach((track)=> {
      container.appendChild(track.attach());
    });
  }

  attachParticipantTracks = (participant, container) => {
    var tracks = Array.from(participant.tracks.values());
    this.attachTracks(tracks, container);
  }
    
  detachTracks = (tracks) => {
    tracks.forEach((track)=> {
      track.detach().forEach((detachedElement)=> {
        detachedElement.remove();
      });
    });
  }

  detachParticipantTracks = (participant) => {
    var tracks = Array.from(participant.tracks.values());
    this.detachTracks(tracks);
  }

  togglePreview = () => {
    const newPreviewVisibleState = !this.state.previewVisible;

    this.setState({
      previewVisible: newPreviewVisibleState,
    }, () => {
      if (this.state.previewVisible) {
        this.createLocalVideo();
      }
    });
  }

  toggleCamera = () => {
    const newCameraValue = !this.state.isCameraOn;

    this.activeRoom.localParticipant.videoTracks.forEach((track, trackId) => {
      track.enable(newCameraValue);
    })

    this.setState({
      isCameraOn: newCameraValue,
    });
  }

  toggleMic = () => {
    const newMicValue = !this.state.isMicOn;

    this.activeRoom.localParticipant.audioTracks.forEach((track, trackId) => {
      track.enable(newMicValue);
    })

    this.setState({
      isMicOn: newMicValue,
    }); 
  }

  leaveRoomIfJoined = () => {
    if (this.activeRoom) {
      this.activeRoom.disconnect();

      this.setState({
        isInActiveRoom: false,
        participants: [],
      });

      console.log('disconnected from room');
    }
  }

  getVideoElement = (remoteParticipant) => {
    const videoKeys = Array.from(remoteParticipant.videoTracks.keys());
    const remoteVideo = remoteParticipant.videoTracks.get(videoKeys[0]);

    if (remoteVideo) {
      return remoteVideo.attach();
    }

    return (
      <div></div>
    );
  }

  toggleChat = () => {
    const newChatValue = !this.state.isChatVisible;

    this.setState({
      isChatVisible: newChatValue,
    }); 
  }

  render() {
    const previewVisible = this.state.previewVisible;
    const isInActiveRoom = this.state.isInActiveRoom;
    const isCameraOn = this.state.isCameraOn;
    const isChatVisible = this.state.isChatVisible;
    const isMicOn = this.state.isMicOn;
    const meeting = this.props.meeting;

    const participants = this.state.participants.map((remoteParticipant, index) => {
      return (
        <RemoteParticipantVideoView 
          key={index} 
          participant={remoteParticipant}/>
      )
    });

    return (
  	  <div>
        <div className='meeting-name-container'>
          <span className='meeting-name'>{meeting.name}</span>
        </div>
        <div className='video-controls-container'>

          {!this.state.isInActiveRoom && <button onClick={() => this.connectToRoom()}>Join</button>}

          {this.state.isInActiveRoom && 
            <div>
              <div className='center-buttons'>
                <MicButton onClick={this.toggleMic} isMicOn={isMicOn} />
                <VideoCamButton onClick={this.toggleCamera} isCameraOn={isCameraOn} />
                <ChatButton isChatVisible={isChatVisible} onClick={this.toggleChat} />
                <HangupButton onClick={this.leaveRoomIfJoined} />
              </div>
            </div>
          }
          
          {false && <button onClick={() => this.togglePreview()}>Toggle Preview</button>}

          {previewVisible && <div ref='localMedia' id='local-media-ctr' />}

          <div className='grid-container'>
            <div id="remote-media" className='remote-participants-container video-section-grid-item-minus-right-side'>
              {participants}
            </div>

            {isChatVisible && 
              <div className='chat-section-grid-item'>
                <ChatSection 
                  meeting={this.props.meeting}
                  user={this.props.user}
                  userToken={this.props.userToken} 
                  baseURL={this.props.baseURL} />
              </div>
            }
          </div>

        </div>
      </div>
  	);
  }
}

export const RemoteParticipantVideoView = (props) => {
  return (
    <div id={'participant-' + props.participant.identity} className='participant-container'>
      <div 
        id={'video-container-' + props.participant.identity} 
        className='video-container'>
      </div>
      <MdPerson size={60} color={'black'} className='placeholder-icon' />
      <div className='user-identity'>{props.participant.identity}</div>
  </div>
  );
}
