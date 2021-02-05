import React from 'react';
import { getChatMessages } from './MeetingAPI';
import { FaComments, FaChevronUp, FaChevronDown, FaBars } from 'react-icons/lib/fa';
import Expand from 'react-expand-animated';
import moment from 'moment';


export default class ChatSection extends React.Component {

  constructor(props) {
    super(props);

    this.state = {
      messages: [],
    }    

    this.chatTimer = null;
  }

  handleChange = (e) => {
    let change = {}
    change[e.target.name] = e.target.value
    this.setState(change)
  }

  updateMessages = (messages) => {
    this.setState({
      messages: messages,
    }, () => {
      this.refs.messageEnd.scrollIntoView({ behavior: "smooth" })
    });
  }

  componentDidUpdate(prevProps) {
    $("#messages-container-div").animate({ scrollTop: $('#messages-container-div').prop("scrollHeight")}, 300);
  }

  render() {
    const { isOpen, toggleOpen, messages, messageInputText, onChange, sendMessage, toggleLeftSide } = this.props;

    const messageRows = messages
      .sort((a, b) => a.id > b.id) 
      .map((message, index) => 
      <ChatMessage key={index} message={message} />
    );

    return (
      <div className='chat-side-section'>

        <div className='chat-section-title'>
          <div className='styled-title-indicator'>
            <div className='dot' />
            <div className='dot' />
            <div className='dot' />
            <div className='dot' />
            <div className='dot' />
            <div className='dot' />
          </div>
          <FaComments size={20} color={'#193130'} className='icon comment-icon' onClick={toggleOpen}/>
          <span className='conversations-label' onClick={toggleOpen}>Conversations</span>
          <div className='expand-indicator-container' onClick={toggleOpen}>
            {isOpen && <FaChevronDown size={15} color={'#193130'} />}
            {!isOpen && <FaChevronUp size={15} color={'#193130'} />}
          </div>
          <button onClick={toggleLeftSide} className='toggle-button left'>
            <FaBars size={20} color={'#4FA59F'} className='toggle-svg' />
          </button>
        </div>
                
        <Expand open={isOpen}>
          <div className='messages-container' id='messages-container-div'>
            {messageRows}
            <div ref='messageEnd' id='message-end'></div>
          </div>

          <div className='authoring-container'>
            <div className='message-text-input-container'>
              <input 
                className='message-text-input' 
                placeholder='Type your message'
                name='messageInputText'
                value={messageInputText}
                onChange={onChange} />
            </div>
            
            <button className='submit-message-button' onClick={sendMessage}>Send</button>
          </div>
        </Expand>

      </div>          
    )
  }

}

export class ChatMessage extends React.Component {
  constructor(props) {
    super(props);
    this.state={};
  }

  render() {
    const { message } = this.props;

    const timestamp = moment.utc(message.timestamp)
      .local()
      .format("h:mm a");

    return (
      <div className='chat-message-row'>
        <div className='chat-message'>
          <div className='chat-name'>
            {message.name}, {timestamp}
          </div>
          <div className='chat-text'>
            {message.text}
          </div>
        </div>
      </div>
    );
  }

}

