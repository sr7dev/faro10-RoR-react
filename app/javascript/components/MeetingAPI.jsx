export const getMeetingUsers = (baseURL, email, token, meetingID) => {
  const url = baseURL + '/api/meetings/' + meetingID + '/meeting_users?'
    + 'session[email]=' + encodeURIComponent(email)
    + '&session[token]=' + encodeURIComponent(token);

  return fetch(url)
    .then(results => results.json())
    .then(data => {

      // ensure we're only adding unique entries per user_id
      var meetingUsers = [];
      
      data.meetings
        .filter(user => !user.departed)
        .forEach(user => {

          // check user is not already in list
          const matchingUsers = meetingUsers
            .filter(existingUser => 
              existingUser.user_id === user.user_id);

          // add to meeting users list
          if (matchingUsers.length === 0) {
            meetingUsers.push(user);
          }
        });

      console.log(meetingUsers);

      return meetingUsers;
    });
}

export const getMeetingUser = (baseURL, email, token, meetingID, user) => {
  const url = baseURL + '/api/meetings/' + meetingID + '/meeting_users/' + user.id + '?'
    + 'session[email]=' + encodeURIComponent(email)
    + '&session[token]=' + encodeURIComponent(token);

  return fetch(url, {
      method: 'get',
    })
    .then(results => results.json())
    .then(data => {
      return data;
    });
}

export const updateMeetingUser = (baseURL, email, token, meetingID, user) => {
  const url = baseURL + '/api/meetings/' + meetingID + '/meeting_users/' + user.id + '?'
    + 'session[email]=' + encodeURIComponent(email)
    + '&session[token]=' + encodeURIComponent(token)
    + '&meeting_user[display_name]=' + user.user_id;

  fetch(url, {
      method: 'put',
    })
    .then(results => results.json())
    .then(data => {

      console.log(data);

    });
}

export const joinMeetingAPI = (baseURL, email, token, meetingID, user, isAnonymous, displayName) => {
  const url = baseURL + '/api/meetings/' + meetingID + '/join?'
    + 'session[email]=' + encodeURIComponent(email)
    + '&session[token]=' + encodeURIComponent(token)
    + '&meeting_user[anonymous]=' + isAnonymous
    + '&meeting_user[display_name]=' + displayName;

  return fetch(url, {
      method: 'post',
    })
    .then(results => results.json())
    .then(data => {
      return data;
    });
}

export const rejoinMeetingAPI = (baseURL, email, token, meetingID, user, isAnonymous, displayName) => {
  const url = baseURL + '/api/meetings/' + meetingID + '/meeting_users/' + user.id + '?'
    + 'session[email]=' + encodeURIComponent(email)
    + '&session[token]=' + encodeURIComponent(token)
    + '&meeting_user[departed]=' + false
    + '&meeting_user[anonymous]=' + isAnonymous
    + '&meeting_user[display_name]=' + displayName;

  return fetch(url, {
      method: 'put',
    });
}

export const leaveMeetingAPI = (baseURL, email, token, meetingID, user) => {
  const url = baseURL + '/api/meetings/' + meetingID + '/meeting_users/' + user.id + '?'
    + 'session[email]=' + encodeURIComponent(email)
    + '&session[token]=' + encodeURIComponent(token)
    + '&meeting_user[departed]=' + true;

  return fetch(url, {
      method: 'put',
    });
}

export const validateMeetingPassword = (baseURL, email, token, meetingID, meetingPassword) => {
  const url = baseURL + '/api/meetings/' + meetingID + '/verify_password_valid' + '?'
    + 'session[email]=' + encodeURIComponent(email)
    + '&session[token]=' + encodeURIComponent(token)
    + '&meeting[password]=' + meetingPassword;

  return fetch(url, {
      method: 'post',
    })
    .then(results => results.json())
    .then(data => {
      return data.is_valid;
    });
}

export const getChatMessages = (baseURL, email, token, meetingID) => {
  const url = baseURL + '/api/meetings/' + meetingID + '/meeting_messages?'
    + 'session[email]=' + encodeURIComponent(email)
    + '&session[token]=' + encodeURIComponent(token);

  return fetch(url)
    .then(results => results.json())
    .then(data => {

      console.log(data);

      // message array
      const messages = [];

      // iterate messages
      data['meeting_messages'].forEach(message => {

        // create message object
        let newMessage = {
          name: message.attendee_name,
          text: message.body,
          timestamp: message.updated_at,
          id: message.id,
        };

        // add to list
        messages.push(newMessage);
      })

      return messages;
    });
}

export const sendMessage = (baseURL, user, email, token, meetingID, body) => {
  if (!body) {
    return;
  }

  const url = baseURL + '/api/meetings/' + meetingID + '/meeting_messages?'
    + 'session[email]=' + encodeURIComponent(email)
    + '&session[token]=' + encodeURIComponent(token)
    + '&meeting_message[body]=' + body
    + '&meeting_message[meeting_id]=' + meetingID
    + '&meeting_message[attendee_name]=' + user.user_id
    + '&meeting_message[attendee_id]=' + user.id;

  return fetch(url, {
    method: 'post',
  });
}

export const sendInvitations = (baseURL, email, token, meetingID, userIDs) => {
  const url = baseURL + '/api/meetings/' + meetingID + '/invite_users?'
    + 'session[email]=' + encodeURIComponent(email)
    + '&session[token]=' + encodeURIComponent(token);

  const body = JSON.stringify({
    "user_invitations": userIDs,
  });

  return fetch(url, {
    method: 'post',
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    },
    body: body,
  });
}

export const reportAbusiveUser = (baseURL, email, token, meetingID, userID) => {
  const url = baseURL + '/api/meetings/' + meetingID + '/meeting_users/' + userID + '?'
    + 'session[email]=' + encodeURIComponent(email)
    + '&session[token]=' + encodeURIComponent(token)
    + '&meeting_user[abuse_reported]=' + true;

  return fetch(url, {
      method: 'put',
    });
}

export const getContacts = (baseURL, email, token) => {
  const url = baseURL + '/api/observations_on_me?'
    + 'session[email]=' + encodeURIComponent(email)
    + '&session[token]=' + encodeURIComponent(token);

  return fetch(url, {
    method: 'get',
  })
  .then(results => results.json())
  .then(data => {
    return data;
  });;  
}

export const addContactFromMeeting = (baseURL, email, token, targetUserEmail) => {
  let relationship = 'Contact from Meeting';

  const url = baseURL + '/api/observations_on_me?'
    + 'session[email]=' + encodeURIComponent(email)
    + '&session[token]=' + encodeURIComponent(token)
    + '&observation[observer_email]=' + encodeURIComponent(targetUserEmail)
    + '&observation[relationship]=' + relationship
    + '&observation[guardian]=false';

  return fetch(url, {
    method: 'post',
  });
}

export const removeContact = (baseURL, email, token, idOfObserverEntry) => {
   
  const url = baseURL + '/api/observers/' + idOfObserverEntry
    + '?session[email]=' + encodeURIComponent(email)
    + '&session[token]=' + encodeURIComponent(token);

  return fetch(url, {
    method: 'delete',
  });
}

export const removeUser = (baseURL, email, token, meetingID, meetingUserID) => {
  const url = baseURL + '/api/meetings/' + meetingID + '/meeting_users/' + meetingUserID + '/remove'
    + '?session[email]=' + encodeURIComponent(email)
    + '&session[token]=' + encodeURIComponent(token);

  return fetch(url, {
    method: 'POST',
  }); 
}

