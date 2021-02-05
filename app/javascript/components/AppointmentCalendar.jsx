import React from 'react';
import BigCalendar from 'react-big-calendar';
import moment from 'moment';

export default class AppointmentCalendar extends React.Component {

  constructor() {
    super();

    BigCalendar.momentLocalizer(moment);
  }

  getEvents() {
    let events = [];
    let appointments = JSON.parse(this.props.appointments);

    Object.keys(appointments).forEach(key => {
      const month = moment(key).month();

      console.log();

      let event = {
        'allDay': false,
        'title': appointments[key].title,
        'start': new Date(appointments[key].start_time),
        'end': new Date(appointments[key].end_time),
        'appointment_id': appointments[key].id
      }

      events.push(event);
    });

    return events;
  }

  showAppointment(appointment_id) {
    window.location.href = "/appointments/" + appointment_id;
  }

  render() {
    let todays_date = new Date();

    return (
      <BigCalendar
        defaultView='month'
        defaultDate={new Date()}
        events={this.getEvents()}
        onSelectEvent={event => this.showAppointment(event.appointment_id)}
        scrollToTime={new Date(1970,1,1,9)}
        style={{height: 800}}
        views={['month','week','day']}
      />
    )
  }
}
