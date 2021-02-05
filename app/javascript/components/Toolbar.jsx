import React from 'react';
import moment from 'moment';

export default class Toolbar extends React.Component {
  render() {
    return (
      <div className="toolbar">
        {moment(this.props.date).format('MMMM YYYY')}
      </div>
    )
  }
}
