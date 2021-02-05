import React from 'react';

import { sendInvitations } from './MeetingAPI'; 

export default class ParticipantInvitationModal extends React.Component {
	
  constructor(props) {
    super(props);

    // convert object to list
    var contactList = [];
    Object.keys(props.contacts).forEach(function(key,index) {
      var user = props.contacts[key];
      user.user_id = key;

      contactList.push(user);
    });

    this.state = {
      contacts: contactList,
      selectedList: [],
    };
	}

  didSelectedUser = (e, user) => {
    const { selectedList } = this.state;

    var updatedList = [...selectedList];

    if (e.target.checked) {
      updatedList.push(user);
    } else {
      updatedList.splice(updatedList.indexOf(user), 1);
    }

    this.setState({
       selectedList: updatedList,
    });
  }

  isUserSelected = (user) => {
    const { selectedList } = this.state;

    return selectedList.indexOf(user) !== -1;
  }

  sendInvites = () => {
    const { user, userToken, baseURL, meetingID, closeModal } = this.props;
    const { selectedList } = this.state;

    const inviteArray = selectedList.map(user => user.observer_id);

    sendInvitations(baseURL, user.email, userToken, meetingID, inviteArray)
      .then(response => {
        console.log(response);
        closeModal();
      });
  }

  cancel = () => {
    const { closeModal } = this.props;

    closeModal();
  }

  noContactsView = () => {
    return (
      <div className='no-contacts-container'>
        You don't have any contacts
      </div>
    );
  }

  render() {
    const { contacts, selectedList } = this.state;

    const contactRows = contacts.map(contact => 
      <div key={contact.user_id} className='contact-row'>
        
        <input 
          name={'invite-checkbox-' + contact.user_id} 
          type='checkbox' 
          onChange={(e) => this.didSelectedUser(e, contact)} 
          checked={this.isUserSelected(contact)}/>

        <label htmlFor={'invite-checkbox-' + contact.user_id}>
          {contact.user_id}
        </label>
      </div>
    );

    const canSendInvites = selectedList.length > 0;

    return (
      <div className='popup-modal'>
        <div className='modal-content'>

          <div className='invitation-header'>
            Contacts
          </div>

          <div className='rows-container'>
            { contacts.length > 0 && contactRows }
            { contacts.length === 0 && this.noContactsView()}
          </div>
          
          <div className='submit-container'>
            <button className='invite-button' 
              onClick={this.sendInvites}
              disabled={!canSendInvites}>
                Send Invitations
              </button>
            <button className='cancel-button'
              onClick={this.cancel}>Cancel</button>
          </div>

        </div>
      </div>
    )
  }

}