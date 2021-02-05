import React from 'react';

export default class UserListSection extends React.Component {

  constructor(props) {
    super(props);

    this.state = {
      users: [],
    }
  }

  componentDidMount() {
    this.getMeetingUsers();
    // this.getUserInfo(2);
  }

  componentWillUnmount() {
    
  }

  getMeetingUsers = () => {
    const userEmail = this.props.user.email;
    const userToken = this.props.userToken;

    const url = this.props.baseURL + '/api/meetings/' + this.props.meeting.id + '/meeting_users?'
      + 'session[email]=' + encodeURIComponent(userEmail)
      + '&session[token]=' + encodeURIComponent(userToken);

    fetch(url)
      .then(results => results.json())
      .then(data => {

        console.log(data);

      });
  }

  getUserInfo = (id) => {
    const userEmail = this.props.user.email;
    const userToken = this.props.userToken;

    const url = this.props.baseURL + '/api/users/2?'
      + 'session[email]=' + encodeURIComponent(userEmail)
      + '&session[token]=' + encodeURIComponent(userToken);

    fetch(url)
      .then(results => results.json())
      .then(data => {

        console.log(data);

      });
  }

  render() {
    const users = this.state.users.map((user, index) => 
      <div>{user}</div>
    );

    return (
      <div className='user-side-section'>
        {users}
      </div>          
    )
  }

}