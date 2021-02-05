import React from 'react';
import { MicButton, VideoCamButton } from './VideoControls';
import Webcam from 'react-webcam';

export default class MeetingPreview extends React.Component {
	constructor(props) {
    super(props);
	}

  toggleMicPreview = () => {
    const { onToggleMic } = this.props;

    // call any super callbacks
    if (onToggleMic) {
      onToggleMic();
    }
  }

  toggleCameraPreview = () => {
    const { onToggleCamera } = this.props;

    // call any super callbacks
    if (onToggleCamera) {
      onToggleCamera();
    }
  }

  render() {
    const { 
      meeting, 
      meetingUsers, 
      onJoinPressed, 
      handleTextInputChanged, 
      passwordInput, 
      passwordError,
      isCameraOn,
      isMicOn,
      displayName,
      isAnonymous,
      checkboxChangeHandler } = this.props;

    // build meeting user count string
    var meetingUserCountString = 'waiting for others to join';
    if (meetingUsers.length === 1) {
      meetingUserCountString = '1 current member';
    } else if (meetingUsers.length > 1) {
      meetingUserCountString = meetingUsers.length + ' current members';
    }

    const isPasswordProtected = meeting.privacy;

    const isJoinButtonDisabled = isPasswordProtected && (!passwordInput || passwordInput.length === 0);

    const displayNameField = isAnonymous 
      ? 'anonymous'
      : displayName; 

    return (
      <div className='welcome-container'>

        <div className='welcome-preview-container'>
        
        {isCameraOn && <Webcam />}

        <div className='welcome-button-container'>
          <MicButton onClick={this.toggleMicPreview} isMicOn={isMicOn} className='welcome-mic-button'/>
          <VideoCamButton onClick={this.toggleCameraPreview} isCameraOn={isCameraOn} />
        </div>
          
        </div>

        <div className='welcome-meeting-name'>
          {meeting.name}
        </div>

        <div className='welcome-meeting-topic'>
          {meeting.topic}
        </div>

        <div className='welcome-meeting-current-member'>
          {meetingUserCountString}
        </div>

        <div className='display-name-section'>
          <div>
            <input 
              onChange={handleTextInputChanged}
              placeholder='display name' 
              className='block'
              name='displayName'
              value={displayNameField}
              disabled={isAnonymous} />
          </div>
          <div>
            <input 
              name='isAnonymous' 
              type='checkbox'
              onChange={checkboxChangeHandler}
              checked={isAnonymous} />
            <label htmlFor="isAnonymous">Join Anonymously</label>
          </div>
        </div>

        {isPasswordProtected && 
          <div className='password-section'>
            
            <input placeholder='enter password' 
                   name='meetingPassword' 
                   onChange={handleTextInputChanged}
                   value={passwordInput} />

            {passwordError && 
              <div className='incorrect-password-container'>
                Incorrect Password
              </div>
            }

            <div className='password-helper-text'>
              This meeting is password protected 
            </div>
          </div>
        }

        <button disabled={isJoinButtonDisabled} onClick={onJoinPressed} className='join-meeting-button'>Join Meeting</button>

      </div>
    );
  }
}