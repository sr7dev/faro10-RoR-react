import React from 'react';

import VideoSection from './VideoSection';
import ChatSection from './ChatSection';
import UserListSection from './UserListSection';

export default class MeetingContainer extends React.Component {
  constructor(props) {
    super(props);
    console.log(this.props.meeting);
    this.state = {
      inActiveMeeting: false,
    };
  }

  updateMeetingStatus = (status) => {
    this.setState({
      inActiveMeeting: status,
    });
  }

  joinMeeting = () => {
    this.updateMeetingStatus(true);
  }

  render() {

    const { meeting } = this.props;
    const showSideBar = false

    return (
      <div className='meeting-view-container container'>
        {!this.state.inActiveMeeting && 
          <div className='join-info-container'>
            
            <div className='meeting-title'>
              {meeting.meeting_type}
            </div>

            <div className='info-row'>
              <div className='title'>Topic</div>
              <div className='value'>{meeting.topic}</div>
            </div>
            
            <div className='info-row'>
              <div className='title'>Focus</div>
              <div className='value'>{meeting.special_focus ? meeting.special_focus : 'not specified'}</div>
            </div>
            
            <div className='info-row'>
              <div className='title'>Host</div>
              <div className='value'>{meeting.host ? meeting.host : '-'}</div>
            </div>

            <button className='join-button' onClick={this.joinMeeting}>Join</button>
            
          </div>
        }
        {this.state.inActiveMeeting &&
          <div className='row full-height' >
          
          <div className='full-height no-padding'>
            <VideoSection 
              meeting={this.props.meeting}
              user={this.props.user}
              userToken={this.props.userToken}
              twilioToken={this.props.twilioToken} 
              baseURL={this.props.rootURL}
              updateMeetingStatus={this.updateMeetingStatus} />
          </div>

          {showSideBar && 
            <div className='col-md-3 meeting-sideview full-height'>
              <SideBar 
                meeting={this.props.meeting}
                user={this.props.user}
                userToken={this.props.userToken} 
                baseURL={this.props.rootURL} />
            </div>
          }

        </div>
        }
      </div>
    );
  }
}

export class SideBar extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      selectedSideTab: 'users',
    }
  }

  selectSideTab = (tab) => {
    this.setState({
      selectedSideTab: tab,
    });
  }

  render() {
    const { meeting, user, userToken } = this.props;
    
    const userName = user.user_id;
    const meetingID = meeting.id;

    const selectedSideTab = this.state.selectedSideTab;

    return (
      <div>

        <div className='meeting-information-container'>
          <div className='name'>
            {meeting.name}
          </div>
          <div className='topic'>
            {meeting.topic}
          </div>
        </div>

        <div className='members-chat-toggle-container'>
          <button className={'segment ' + (selectedSideTab === 'users' ? 'selected' : '')}
            onClick={() => this.selectSideTab('users')}>
            Users
          </button>
          <button className={'segment ' + (selectedSideTab === 'chat' ? 'selected' : '')}
            onClick={() => this.selectSideTab('chat')} >
            Chat
          </button>
        </div>

        {selectedSideTab === 'users' &&
          <div className='user-side-section'>
            <UserListSection 
              meeting={this.props.meeting}
              user={this.props.user}
              userToken={this.props.userToken} 
              baseURL={this.props.baseURL} />
          </div>
        }
          
        {selectedSideTab === 'chat' &&
          <ChatSection 
            meeting={this.props.meeting}
            user={this.props.user}
            userToken={this.props.userToken} 
            baseURL={this.props.baseURL} />
        }
      </div>
    );
  }
}

