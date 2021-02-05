import React from 'react';
import { MdCallEnd, 
         MdMic, 
         MdMicOff, 
         MdVideocam, 
         MdVideocamOff, 
         MdPerson, 
         MdForum,
         MdPeople } from 'react-icons/lib/md';

export const MicButton = (props) => {
  return (
    <button 
      onClick={props.onClick}
      className={'no-padding control-button ' + 
        (props.isMicOn ? ' on-button' : ' off-button') + 
        (props.minimized ? ' minimized' : '')}>
      {props.isMicOn && <MdMic size={30} color={'white'} />}
      {!props.isMicOn && <MdMicOff size={30} color={'white'} />}
    </button>
  )
}

export const VideoCamButton = (props) => {
  return (
    <button 
      onClick={props.onClick}
      className={'no-padding control-button ' + 
        (props.isCameraOn ? ' on-button' : ' off-button') + 
        (props.minimized ? ' minimized' : '')}>
      {props.isCameraOn && <MdVideocam size={30} color={'white'} />}
      {!props.isCameraOn && <MdVideocamOff size={30} color={'white'} />}
    </button>
  );
}

export const HangupButton = (props) => {
  return (
    <button className={'hang-up-button control-button no-padding' + 
        (props.minimized ? ' minimized' : '')} 
        onClick={props.onClick}>
      <MdCallEnd size={30} color={'white'} />
    </button>
  );
}

export const ChatButton = (props) => {
  return (
    <button 
      onClick={props.onClick}
      className={'no-padding control-button relative' + 
        (' on-button ') + 
        (props.minimized ? ' minimized' : '')}>
      <MdForum size={30} color={'white'} />
      {props.displayUnreadIndicator && 
        <div className='unread-message-indicator' />
      }
    </button>
  );
}

export const ParticipantsButton = (props) => {
  return (
    <button onClick={props.onClick}
      className={'no-padding control-button ' + 
        (' on-button ') + 
        (props.minimized ? ' minimized' : '')}>
      <MdPeople size={30} color={'white'} />
    </button>
  );
}