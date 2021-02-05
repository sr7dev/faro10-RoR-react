import React from 'react';
import Expand from 'react-expand-animated';
import { getMeetingUsers } from './MeetingAPI';
import { MdPeople } from 'react-icons/lib/md';
import { FaChevronUp, FaChevronDown, FaPlus } from 'react-icons/lib/fa';

export default class ParticipantsContainer extends React.Component {

  constructor(props) {
    super(props);
  }

  render() {
    const { participants, isOpen, toggleOpen, onOpenInvitationModalPressed } = this.props;

    const memberRows = participants.map(user =>
      <MemberRow user={user} key={user.id} />
    )

    return (
      <div className='member-list-section'>

        <div className='participants-section-title' onClick={toggleOpen}>
          <div className='styled-title-indicator'>
            <div className='dot' />
            <div className='dot' />
            <div className='dot' />
            <div className='dot' />
            <div className='dot' />
            <div className='dot' />
          </div>
          <MdPeople size={20} color={'#193130'} className='icon' />
          <span className='participants-title'>Participants</span>
          <div className='expand-indicator-container'>
            {isOpen && <FaChevronDown size={15} color={'#193130'} />}
            {!isOpen && <FaChevronUp size={15} color={'#193130'} />}
          </div>
        </div>

        <Expand open={isOpen}>
          <div className='member-list-container'>
            
            <div className='invite-container'>
              <button className='invite-participants-button' onClick={onOpenInvitationModalPressed}>
                Invite
                <FaPlus size={15} color={'#193130'} className='icon' />
              </button>
            </div>

            {memberRows.length > 0 && memberRows}
            {memberRows.length === 0 &&
              <div>Loading...</div>
            }
          </div>
        </Expand>

      </div>
    );
  }

}

class MemberRow extends React.Component {
  constructor(props) {
    super(props);
    this.state={};
  }

  getNameToDisplay = () => {
    const { user } = this.props;

    if (user.anonymous === true || !user.display_name) {
      return 'anonymous';
    }

    return user.display_name;
  }

  render() {
    const { user } = this.props;

    const name = this.getNameToDisplay();

    return (
      <div className='member-row'>
        <div className='avatar-container'>
        </div>
        {name}
      </div>
    );
  }
}