import React from 'react';
import Video, { createLocalVideoTrack } from 'twilio-video';

import MeetingPreview from './MeetingPreview';
import ChatSection from './ChatSection';
import ParticipantsContainer from './ParticipantsContainer';
import ParticipantInvitationModal from './ParticipantInvitationModal';

import { MicButton, VideoCamButton, HangupButton, ChatButton, ParticipantsButton } from './VideoControls';
import { MdPerson } from 'react-icons/lib/md';
import { FaBars } from 'react-icons/lib/fa';
import { getMeetingUser, 
         updateMeetingUser, 
         joinMeetingAPI, 
         leaveMeetingAPI, 
         rejoinMeetingAPI, 
         getMeetingUsers,
         validateMeetingPassword,
         getChatMessages,
         sendMessage,
         reportAbusiveUser,
         addContactFromMeeting,
         removeContact, 
         getContacts,
         removeUser } from './MeetingAPI';

export default class MeetingLayout extends React.Component {
	constructor(props) {
		super(props);

    console.log(this.props.meeting);
    console.log(this.props.user);
    console.log(this.props.contacts);

    const parsedToken = JSON.parse(this.props.twilioToken);

    this.activeRoom = null;
    this.twilioToken = parsedToken['token'];
    this.identity = parsedToken['identity'];
    this.localVideoTrack = null;

		this.state = {
      didJoinRoom: false,
      previewVisible: true,
      isInActiveRoom: false,
      leftSideOpen: true,
      rightSideOpen: true,
      isCameraOn: true,
      isMicOn: true,
      isChatVisible: true,
      participants: [],
      meetingUsers: [],
      disabledVideoList: [],
      messages: [],
      isChatExpanded: true,
      isParticipantsExpanded: true,
      hasUnreadChatMessages: false,
      messageInputText: '',
      participantTrackMap: {},
      isCreatingLocalVideo: false,
      displayName:this.props.user.user_id,
      isAnonymous: false,
      isShowingInvitiationModal: false,
      contacts: this.props.contacts,
    }

    this.memberTimer = null;
    this.chatTimer = null;
	}

  componentDidMount() {
    // ensure video is ended before window is closed
    window.addEventListener("beforeunload", this.leaveRoomIfJoined);

    // load who's already in meeting
    this.getMeetingUsers();

    // check for updates users periodically until meeting is joined
    this.memberTimer = setInterval(this.getMeetingUsers, 5000);

    // add keyboard listener for enter button
    document.addEventListener("keydown", this.enterPressedFunction, false);
  }

  componentWillUnmount() {
    clearTimeout(this.memberTimer);
    clearTimeout(this.chatTimer);
  }

  enterPressedFunction = (event) => {
    
    // enter button
    if (event.keyCode === 13) {
      this.sendMessage();
    }
  }

  getChatMessages = () => {
    const { user, userToken, rootURL, meeting } = this.props;

    getChatMessages(rootURL, user.email, userToken, meeting.id)
      .then(this.updateMessages);
  }

  updateMessages = (updatedMessages) => {
    const { messages, leftSideOpen, isChatExpanded, hasUnreadChatMessages } = this.state;

    // check if messages have changed
    const hasNewMessages = messages.length < updatedMessages.length;

    // should display new message indicator
    const shouldDisplayNewMessageIndicator = hasUnreadChatMessages || (hasNewMessages && (!leftSideOpen || !isChatExpanded));

    this.setState({
      messages: updatedMessages,
      hasUnreadChatMessages: shouldDisplayNewMessageIndicator,
    });
  }

  sendMessage = () => {
    const { user, userToken, rootURL, meeting } = this.props;
    const newMessage = this.state.messageInputText;

    if (!newMessage) {
      return;
    }

    sendMessage(rootURL, user, user.email, userToken, meeting.id, newMessage)
      .then(() => {
        this.getChatMessages();

        // reset text box
        this.setState({
          messageInputText: '',
        });
      })
  }

  onChangeHandler = (e) => {

    let change = {}
    change[e.target.name] = e.target.value
    this.setState(change)

    console.log(this.state);
  }

  checkboxChangeHandler = (e) => {
    let change = {}
    change[e.target.name] = e.target.checked
    this.setState(change)

    console.log(this.state); 
  }

  createLocalVideo = () => {
    const { isCreatingLocalVideo } = this.state;

    // prevent multiple video creations
    if (isCreatingLocalVideo) {
      return;
    }

    this.setState({
      isCreatingLocalVideo: true,
    }, () => {
      createLocalVideoTrack().then(track => {
        

        this.localVideoTrack = track;

        if (this.activeRoom) {
          this.activeRoom.localParticipant.publishTrack(track)
            .then(() => {
              
              // add to UI
              var localMediaContainer = document.getElementById('local-media-ctr');
              localMediaContainer.appendChild(track.attach());

              // update state
              this.setState({
                isCreatingLocalVideo: false,
              });      
            });
        }
      });  
    });
    
  }

  joinPressed = () => {
    const { user, userToken, rootURL, meeting } = this.props;
    const { meetingPassword } = this.state;

    // room isn't password protected
    if (!meeting.privacy) {
      this.startRoomConnection();
      return;
    }

    this.setState({
      passwordError: false,
      meetingPassword: '',
    }, () => {
      validateMeetingPassword(rootURL, user.email, userToken, meeting.id, meetingPassword)
      .then(isValid => {
        if (isValid) {
          this.startRoomConnection();
        } else {
          this.setState({
            passwordError: true,
          });
        }
      });  
    })
  }

  startRoomConnection = () => {

    this.setState({
      didJoinRoom: true,
    }, () => this.connectToRoom());
  }

  getMeetingUsers = () => {
    const { user, userToken, rootURL, meeting } = this.props;
    const { meetingUsers } = this.state;
    
    getMeetingUsers(rootURL, user.email, userToken, meeting.id)
      .then(data => {

        // update name values for each meeting member
        data.forEach(member => {

          // get display name
          const displayName = this.getMeetingDisplayNameFromData(data, member.user_id);

          $('#user-identity-value-' + member.user_id).text(displayName);

          if (meeting.user_id === member.user_id) {
            $(`#participant-${member.user_id}-host-indicator`).removeClass('hidden');
          }
        });

        // only update state if meeting users has changed
        if (this.activeRoom && this.activeRoom.participants.size !== data.length - 1) {
          this.getMeetingUsers();
          return;
        }

        const dataIsUnchanged = meetingUsers.length === data.length && 
          meetingUsers.sort().every(function(value, index) { 
            return value.user_id === data.sort()[index].user_id
          });

        if (dataIsUnchanged) {
          return;
        }

        this.setState({
          meetingUsers: data,
        });
      }
    );
  }

  connectToRoom = async () => {
    const token = this.twilioToken;
    const roomName = this.props.meeting.room_name;
    const { isCameraOn, isMicOn } = this.state;

    await this.joinMeetingAPI();

    Video.connect(token, {
      name:roomName,
      video: false,
      audio: true,
    })
    .then(async room => {
      console.log('Successfully joined a Room: ', room);
      console.log("Joined as '" + this.identity + "'");

      // update room info
      this.activeRoom = room;
      window.room = room.name;
        
      // no longer need to periodically check members
      clearTimeout(this.memberTimer);

      // check for meeting messages now and periodically
      this.getChatMessages();
      this.chatTimer = setInterval(this.getChatMessages, 5000);

      await this.getMeetingUsers();

      this.roomJoined(room);

      this.setState({
        isInActiveRoom: true,
      });

    }, error => console.error('Unable to connect to Room: ' +  error.message));
  }

  joinMeetingAPI = () => {
    const { rootURL, user, userToken, meeting } = this.props;
    const { isAnonymous, displayName } = this.state;

    getMeetingUser(rootURL, user.email, userToken, meeting.id, user)
      .then(response => {
        
        // user has not been in meeting yet, join
        if (!response.meeting_user) {
          joinMeetingAPI(rootURL, user.email, userToken, meeting.id, user);
        } else {
          // user was already a member - update them to not be departed
          rejoinMeetingAPI(rootURL, user.email, userToken, meeting.id, user, isAnonymous, displayName);
        }
      });
  }

  roomJoined = (room) => {
    const { isCameraOn, isMicOn } = this.state;

    if (isCameraOn) {
      this.createLocalVideo();
    }

    this.activeRoom.localParticipant.audioTracks.forEach((track, trackId) => {
      track.enable(isMicOn);
    })

    // load participants into array
    var participantArray = [];
    room.participants.forEach((participant)=> {
      console.log("Already in Room: '" + participant.identity + "'");
      // participantArray.push(participant);

      $( "#remote-media" ).append(RemoteParticipantTemplate({userID: participant.identity}));

      // add onclick handler
      this.addParticipantOptionsOnClickHandler(participant);
      this.addAbuseReportedOnClickHandler(participant);
      this.addAddContactOnClickHandler(participant);
      this.addRemoveContactOnClickHandler(participant);
      this.addToggleParticipantAudioClickHandler(participant);
      this.addToggleParticipantVideoClickHandler(participant);
      this.addRemoveParticipantClickHandler(participant);
      
      var previewContainer = document.getElementById("video-container-" + participant.identity);

      // attach tracks
      this.attachParticipantTracks(participant, previewContainer);
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
    const { user, userToken, rootURL, meeting } = this.props;
    const { meetingUsers } = this.state;

    console.log("Joining: '" + participant.identity + "'");

    // add participant layout info
    $( "#remote-media" ).append(RemoteParticipantTemplate({userID: participant.identity}));

    // we need to have the latest participants list from the backend
    // before we can assign these action handlers
    getMeetingUsers(rootURL, user.email, userToken, meeting.id)
      .then(data => {

        // update name values for each meeting member
        data.forEach(member => {

          // get display name
          const displayName = this.getMeetingDisplayNameFromData(data, member.user_id);

          $('#user-identity-value-' + member.user_id).text(displayName);

          // check if we need to show host indicator
          if (meeting.user_id === member.user_id) {
            $(`#participant-${member.user_id}-host-indicator`).removeClass('hidden');
          }
          
        });

        // only update state if meeting users has changed
        if (this.activeRoom && this.activeRoom.participants.size !== data.length - 1) {
          this.getMeetingUsers();
          return;
        }

        const dataIsUnchanged = meetingUsers.length === data.length && 
          meetingUsers.sort().every(function(value, index) { 
            return value.user_id === data.sort()[index].user_id
          });

        if (dataIsUnchanged) {
          this.addParticipantOptionsOnClickHandler(participant);
          this.addAbuseReportedOnClickHandler(participant);
          this.addAddContactOnClickHandler(participant);
          this.addRemoveContactOnClickHandler(participant);
          this.addToggleParticipantAudioClickHandler(participant);
          this.addToggleParticipantVideoClickHandler(participant);
          this.addRemoveParticipantClickHandler(participant);
          return;
        }

        this.setState({
          meetingUsers: data,
        }, () => {
          // add onclick handler
          this.addParticipantOptionsOnClickHandler(participant);
          this.addAbuseReportedOnClickHandler(participant);
          this.addAddContactOnClickHandler(participant);
          this.addRemoveContactOnClickHandler(participant);
          this.addToggleParticipantAudioClickHandler(participant);
          this.addToggleParticipantVideoClickHandler(participant);
          this.addRemoveParticipantClickHandler(participant);
        });
      }
    );
  }

  addRemoveParticipantClickHandler = (participant) => {
    const { rootURL, user, userToken, meeting } = this.props;
    const { meetingUsers, contacts } = this.state;

    // hide option if current user is not host
    const isHost = meeting.user_id === user.id;

    if (!isHost) {
      $("#remove-user-" + participant.identity).addClass('hidden');
    }

    $("#remove-user-" + participant.identity).on('click', function(event) {

        // determine which contact option to show
        let targetUser = meetingUsers.filter(meetingUser => meetingUser.user_id === Number(participant.identity))[0];
        if (!targetUser) {
          return;
        }

        removeUser(rootURL, user.email, userToken, meeting.id, targetUser.id)
          .then(() => console.log('kicked'))
          .catch((error) => console.log(error));
    });
  }

  addToggleParticipantAudioClickHandler = (participant) => {

    $("#toggle-audio-" + participant.identity).on('click', function(event) {
        // get track
      var audioTrack = $('#video-container-' + participant.identity).find('audio')[0];

      // check if currently muted
      var isMuted = $(audioTrack).prop('muted');

      let updatedButtonText = isMuted ? 'Mute Audio' : 'Enable Audio';

      $("#toggle-audio-" + participant.identity).html(updatedButtonText);

      console.log("audio is muted: " + isMuted);

      // set to opposite value
      audioTrack.muted = !isMuted;
    });
  }

  addToggleParticipantVideoClickHandler = (participant) => {
    $("#toggle-video-" + participant.identity).on('click', function(event) {
        // get track
      var videoTrack = $('#video-container-' + participant.identity).find('video')[0];

      // check if currently muted
      var isHidden = $(videoTrack).hasClass('hidden');

      console.log("video is muted: " + isHidden);

      let updatedButtonText = isHidden ? 'Hide Video' : 'Show Video';

      $("#toggle-video-" + participant.identity).html(updatedButtonText);

      // set to opposite value
      if (isHidden) {
        $(videoTrack).removeClass('hidden');
      } else {
        $(videoTrack).addClass('hidden');
      }
    });
  }

  addParticipantOptionsOnClickHandler = (participant) => {
    const { meetingUsers, contacts } = this.state;

    $("#participant-options-button-" + participant.identity).on('click', event => {

      // get container
      var optionsContainer = $("#participant-options-" + participant.identity);

      // toggle current visibility status
      let isCurrentlyHidden = optionsContainer.hasClass('hidden');
      if (isCurrentlyHidden) {
        // show options
        $("#participant-options-" + participant.identity).removeClass('hidden');  
        
        // determine which contact option to show
        let targetUser = meetingUsers.filter(meetingUser => meetingUser.user_id === Number(participant.identity))[0];
        if (!targetUser) {
          return;
        }

        let contact = this.state.contacts[targetUser.display_name];
        let isActiveContact = contact && contact.status === "active";

        if (isActiveContact) {
          $("#add-contact-" + participant.identity).addClass('hidden');
          $("#remove-contact-" + participant.identity).removeClass('hidden');
        } else {
          $("#add-contact-" + participant.identity).removeClass('hidden');
          $("#remove-contact-" + participant.identity).addClass('hidden');
        }
      } else {
        $("#participant-options-" + participant.identity).addClass('hidden');  
      }

    });
  }

  addAbuseReportedOnClickHandler = (participant) => {
    const { rootURL, user, userToken, meeting } = this.props;

    $("#report-abuse-" + participant.identity).on('click', function(event) {
    
      console.log('report abuse ' + participant.identity);
    
      let userID = participant.identity;
      
      reportAbusiveUser(rootURL, user.email, userToken, meeting.id, userID)
        .then(data => {
          $("#participant-options-" + participant.identity).addClass('hidden');  
        });
    });

  }

  isActiveContact = (userID) => {
    const { contacts } = this.state;

    let contact = contacts[userID];

    return contact && contact.status === "active";
  }

  addAddContactOnClickHandler = (participant) => {
    const { rootURL, user, userToken, meeting } = this.props;
    const { meetingUsers } = this.state;

    $("#add-contact-" + participant.identity).on('click', event => {
      
      console.log('add contact ' + participant.identity);

      let targetUser = meetingUsers.filter(meetingUser => meetingUser.user_id === Number(participant.identity))[0];
      if (!targetUser) {
        return;
      }

      addContactFromMeeting(rootURL, user.email, userToken, targetUser.email)
        .then(() => {

          $("#add-contact-" + participant.identity).addClass('hidden');
          $("#remove-contact-" + participant.identity).removeClass('hidden');
          $("#participant-options-" + participant.identity).addClass('hidden');

          getContacts(rootURL, user.email, userToken)
            .then(data => {
              console.log(data);
              this.setState({contacts: data});
            });
        })
    });
  }

  addRemoveContactOnClickHandler = (participant) => {
    const { rootURL, user, userToken, meeting } = this.props;
    const { meetingUsers, contacts } = this.state;

    $("#remove-contact-" + participant.identity).on('click', event => {
      
      console.log('remove contact ' + participant.identity);

      let targetUser = meetingUsers.filter(meetingUser => meetingUser.user_id === Number(participant.identity))[0];
      if (!targetUser) {
        return;
      }

      let idOfObserverEntry = this.state.contacts[targetUser.display_name].id

      removeContact(rootURL, user.email, userToken, idOfObserverEntry)
        .then(() => {

          $("#add-contact-" + participant.identity).removeClass('hidden');
          $("#remove-contact-" + participant.identity).addClass('hidden');
          $("#participant-options-" + participant.identity).addClass('hidden');

          getContacts(rootURL, user.email, userToken)
            .then(data => {
              console.log(data);
              this.setState({contacts: data});
            });
        })
    });
  }

  trackAdded = (track, participant) => {
    console.log(participant.identity + " added track: " + track.kind);

    // get participants containers
    var previewContainer = document.getElementById("video-container-" + participant.identity);

    // attach tracks
    this.attachTracks([track], previewContainer);
  }

  trackRemoved = (track, participant)=> {
    console.log(participant.identity + " removed track: " + track.kind);

    // remove track from container
    this.detachTracks([track]);
  }

  trackEnabled = (track, participant) => {
    // const { disabledVideoList } = this.state;

    console.log(participant.identity + " enabled track: " + track.kind);

    const isAudioTrack = track.kind === "audio";

    if (isAudioTrack) {
      return;
    }

    $( "#video-container-" + participant.identity ).find("video").removeClass( "hidden" );
  }

  trackDisabled = (track, participant) => {
    const { disabledVideoList } = this.state;

    const isAudioTrack = track.kind === "audio";

    // this.detachTracks([track]);
    console.log(participant.identity + " disabled track: " + track.kind);

    if (isAudioTrack) {
      return;
    }

    $( "#video-container-" + participant.identity  ).find("video").addClass( "hidden" );
  }

  participantDisconnected = (participant) => {
    const { disabledVideoList, participants } = this.state;

    console.log("Participant '" + participant.identity + "' left the room");

    // remove tracks
    this.detachParticipantTracks(participant);

    $( "#participant-" + participant.identity).remove();

    // update meeting users
    this.getMeetingUsers();
  }

  disconnected = () => {
    const { rootURL, user, userToken, meeting } = this.props;

    console.log("Left");
    if (this.previewTracks) {
        this.previewTracks.forEach((track)=> {
            track.stop();
        });
    }
    this.detachParticipantTracks(this.activeRoom.localParticipant);
    this.activeRoom.participants.forEach(this.detachParticipantTracks);
    this.activeRoom = null;

    // start timer again to check members
    this.memberTimer = setInterval(this.getMeetingUsers, 5000);

    leaveMeetingAPI(rootURL, user.email, userToken, meeting.id, user)
      .then(() => {
        const meetingsPage = rootURL + '/meetings';
        window.location = meetingsPage;        
      });
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

  didPressChatButton = () => {
    this.setState({
      leftSideOpen: true,
      isChatExpanded: true,
      hasUnreadChatMessages: false,
    });
  }

  didPressParticipantsButton = () => {
    this.setState({
      leftSideOpen: true,
      isParticipantsExpanded: true,
    });
  }

  toggleCamera = () => {
    const { isCameraOn, isCreatingLocalVideo } = this.state;
    const newCameraValue = !isCameraOn;

    if (isCreatingLocalVideo) {
      return;
    }

    if (newCameraValue) {
      this.createLocalVideo();
    } else {
      this.localVideoTrack.stop();
      var detached = this.localVideoTrack.detach();

      detached.forEach(function(el) {
        el.remove();
      });

      this.activeRoom.localParticipant.videoTracks.forEach((track, trackId) => {
        track.enable(false);  
        this.activeRoom.localParticipant.removeTrack(track);
      });
    }

    this.setState({
      isCameraOn: newCameraValue,
    });
  }

  toggleCameraPreview = () => {
    const newCameraValue = !this.state.isCameraOn;
    
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

  toggleMicPreview = () => {
    const newMicValue = !this.state.isMicOn;

    this.setState({
      isMicOn: newMicValue,
    }); 
  }

  leaveRoomIfJoined = () => {
    const { localVideoTrack } = this.state;
    const { rootURL } = this.props;

    if (this.activeRoom) {
      
      // disable camera
      if (localVideoTrack) {
        localVideoTrack.disable();
        localVideoTrack.stop();  

        // remove from dom
        var detachedElements = localVideoTrack.detach();
        detachedElements.forEach(function(el) {
          el.remove();
        });
      }

      this.activeRoom.localParticipant.videoTracks.forEach((track, trackId) => {
        track.disable(true);
        track.stop();
        track.detach();
      });

      this.activeRoom.disconnect();

      console.log('disconnecting from room');
    }
  }

  updateUserToDeparted = () => {
    const { rootURL, user, userToken, meeting } = this.props;

    return 
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

  toggleLeftSide = () => {
    let currentValue = this.state.leftSideOpen;
    
    this.setState({
      leftSideOpen: !currentValue,
    })
  }

  toggleRightSide = () => {
    const { rightSideOpen } = this.state;
    
    this.setState({
      rightSideOpen: !rightSideOpen,
    });
  }

  toggleChatSectionExpand = () => {
    const { isChatExpanded } = this.state;

    this.setState({
      isChatExpanded: !isChatExpanded,
      hasUnreadChatMessages: false,
    });
  }

  toggleParticipantsSectionExpand = () => {
    const { isParticipantsExpanded } = this.state;

    this.setState({
      isParticipantsExpanded: !isParticipantsExpanded,
    });
  }

  isUserInVideoDisabledList = (userID) => {
    const { disabledVideoList } = this.state;
    
    return disabledVideoList.indexOf(userID) !== -1;
  }

  getMeetingUserDisplayName = (userID) => {
    const { meetingUsers } = this.state;

    const matchingUser = meetingUsers.filter(meetingUser => 
      meetingUser.user_id === Number(userID));

    if (matchingUser.length === 0) {
      // what should we do in this case?
      return "";
    }

    if (matchingUser[0].anonymous === true) {
      return "anonymous";
    }

    return matchingUser[0].display_name;
  }

  getMeetingDisplayNameFromData = (data, userID) => {
    const matchingUser = data.filter(meetingUser => 
      meetingUser.user_id === Number(userID));

    if (matchingUser.length === 0) {
      // what should we do in this case?
      return "";
    }

    if (matchingUser[0].anonymous === true) {
      return "anonymous";
    }

    return matchingUser[0].display_name;
  }

  openInvitationModal = () => {
    this.setState({
      isShowingInvitiationModal: true,
    });
  }

  closeInvitationModal = () => {
    this.setState({
      isShowingInvitiationModal: false,
    });
  }

  render() {
    const { meeting, user, userToken, rootURL } = this.props;
    const { 
      rightSideOpen, 
      leftSideOpen, 
      isInActiveRoom, 
      didJoinRoom, 
      meetingUsers, 
      meetingPassword, 
      passwordError,
      isParticipantsExpanded,
      isChatExpanded,
      messages,
      hasUnreadChatMessages,
      messageInputText,
      isCameraOn,
      isMicOn,
      displayName,
      isAnonymous,
      isShowingInvitiationModal,
      contacts } = this.state;

    const participantVideoViews = this.state.participants.map((remoteParticipant, index) => {
      return (
        <RemoteParticipantVideoView 
          key={index} 
          participant={remoteParticipant}
          displayName={this.getMeetingUserDisplayName(remoteParticipant.identity)}
          isVideoInDisabledList={this.isUserInVideoDisabledList(remoteParticipant.identity)} />
      )
    });

    var meetingUserCountString = 'waiting for others to join';
    if (meetingUsers.length === 1) {``
      meetingUserCountString = '1 current member';
    } else if (meetingUsers.length > 1) {
      meetingUserCountString = meetingUsers.length + ' current members';
    }

    return (
      <div className='meeting-layout-container'>

        {isShowingInvitiationModal &&
          <ParticipantInvitationModal 
            user={user}
            userToken={userToken} 
            baseURL={rootURL} 
            contacts={contacts} 
            meetingID={meeting.id} 
            closeModal={this.closeInvitationModal}/>
        }

        {!didJoinRoom &&
          <MeetingPreview 
            meeting={meeting} 
            meetingUsers={meetingUsers} 
            onJoinPressed={this.joinPressed} 
            onToggleMic={this.toggleMicPreview} 
            onToggleCamera={this.toggleCameraPreview} 
            isCameraOn={isCameraOn}
            isMicOn={isMicOn}
            handleTextInputChanged={this.onChangeHandler} 
            passwordInput={meetingPassword} 
            passwordError={passwordError}
            displayName={displayName}
            isAnonymous={isAnonymous} 
            checkboxChangeHandler={this.checkboxChangeHandler} />
        }
        
        {didJoinRoom &&
          <div>
                  <div className={'left-sidebar-container ' + (this.state.leftSideOpen ? ' ' : ' closed')}>
          
          {false && <div className='text-align-right'>
            <button onClick={this.toggleLeftSide} className='toggle-button left'>
              <FaBars size={30} color={'white'} className='toggle-svg' />
            </button>
          </div>
        }

          {leftSideOpen &&
            <ChatSection 
              meeting={meeting}
              user={user}
              userToken={userToken} 
              baseURL={rootURL} 
              isOpen={isChatExpanded} 
              toggleOpen={this.toggleChatSectionExpand}
              messages={messages} 
              messageInputText={messageInputText}
              onChange={this.onChangeHandler}
              sendMessage={this.sendMessage}
              toggleLeftSide={this.toggleLeftSide}/>
          }

          {leftSideOpen &&
            <ParticipantsContainer 
              meeting={meeting}
              user={user}
              userToken={userToken} 
              baseURL={rootURL}
              participants={meetingUsers} 
              isOpen={isParticipantsExpanded} 
              toggleOpen={this.toggleParticipantsSectionExpand} 
              onOpenInvitationModalPressed={this.openInvitationModal}/>
          }

          {!leftSideOpen &&
            <div className='left-side-button-container'>
              <div className='closed-toggle-container'>
                <button onClick={this.toggleLeftSide} className='toggle-button'>
                  <FaBars size={20} color={'#4FA59F'} className='toggle-svg' />
                </button>
              </div>
              <ChatButton minimized onClick={this.didPressChatButton} displayUnreadIndicator={hasUnreadChatMessages} />
              <ParticipantsButton minimized onClick={this.didPressParticipantsButton} />
            </div>
          }

        </div>

        <div 
          className={'center-container' + 
            (this.state.leftSideOpen ? ' ' : ' left-side-closed ') + 
            (this.state.rightSideOpen ? ' ' : ' right-side-closed')}>

            <div id="remote-media" className='remote-participants-container video-section-grid-item-minus-right-side'>
              
            </div>

        </div>        

        <div className={'right-sidebar-container ' + (this.state.rightSideOpen ? ' ' : ' closed')}>
          
          <div className='right-side-header-container'>
            
            <div className='toggle-button-container'>
              <button onClick={this.toggleRightSide} className='toggle-button right' >
                <FaBars size={20} color={'#4FA59F'} className='toggle-svg' />
              </button>
            </div>
            
            {rightSideOpen &&
              <div className='meeting-name-container'>
                <span>{meeting.meeting_type}</span>
                <div className='styled-title-indicator styled-right'>
                  <div className='dot' />
                  <div className='dot' />
                  <div className='dot' />
                  <div className='dot' />
                  <div className='dot' />
                  <div className='dot' />
                </div>
              </div>
            }
          </div>

          <div ref='localMedia' id='local-media-ctr' className={(rightSideOpen ? '' : ' display-none')} />

          <div className='open-button-container'>
            <MicButton onClick={this.toggleMic} isMicOn={this.state.isMicOn} minimized={!rightSideOpen} />
            <VideoCamButton onClick={this.toggleCamera} isCameraOn={this.state.isCameraOn} minimized={!rightSideOpen} />
            <HangupButton onClick={this.leaveRoomIfJoined} minimized={!rightSideOpen} />
          </div>
          
          {rightSideOpen && 
            <div className='meeting-information'>

              <div className='info-row'>
                <div className='title'>Title</div>
                <div className='value'>{meeting.name}</div>
              </div>

              <div className='info-row'>
                <div className='title'>Topic</div>
                <div className='value'>{meeting.topic}</div>
              </div>
              
              <div className='info-row last'>
                <div className='title'>Focus</div>
                <div className='value'>{meeting.special_focus ? meeting.special_focus : 'not specified'}</div>
              </div>
            </div>
          }

        </div>
          </div>
        }


      </div>
    );
  }
}

const RemoteParticipantTemplate = ({ userID }) => `
    <div id='participant-${userID}' class='participant-container'>
      <div class='user-placeholder'>
        <i class="fa fa-user-circle fa-5x"></i>
      </div>
      <div id='video-container-${userID}' class='video-container'>
        <div id='participant-options-${userID}' class='participant-options-container hidden'>
          <button id='toggle-audio-${userID}' class='participant-option-button'>Mute Audio</button>
          <button id='toggle-video-${userID}' class='participant-option-button'>Hide Video</button>
          <button id='report-abuse-${userID}' class='participant-option-button'>Report Abusive Behavior</button>
          <button id='add-contact-${userID}' class='participant-option-button'>Add Contact</button>
          <button id='remove-contact-${userID}' class='participant-option-button'>Remove Contact</button>
          <button id='remove-user-${userID}' class='participant-option-button'>Remove User</button>
        </div>
      </div>
      <div class='user-identity'>
        <span id='user-identity-value-${userID}' class='user-identity-value'>
        </span>
        <span id='participant-${userID}-host-indicator' class='hidden'>(host)</span>
        <button id='participant-options-button-${userID}' class='participant-options-button'>
          <i class="fa fa-ellipsis-h"></i>
        </button>
      </div>
  </div>
`;

const RemoteParticipantVideoView = (props) => {
  return (
    <div id={'participant-' + props.participant.identity} className='participant-container'>
      <div 
        id={'video-container-' + props.participant.identity} 
        className={'video-container' + (props.isVideoInDisabledList ? ' hidden' : '')}>
      </div>
      <MdPerson size={60} color={'black'} className='placeholder-icon' />
      <div className='user-identity'>
        <span className='user-identity-value'>
          {props.displayName}
        </span>
      </div>
  </div>
  );
}