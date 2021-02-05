import React from 'react';
import Toolbar from './Toolbar';
import BigCalendar from 'react-big-calendar';
import moment from 'moment';

const modalStyles = {
  margin: '15% auto',
  padding: '5px',
  width: '400px',
  maxHeight: '650px',
  overflow: 'auto',
  backgroundColor: '#fff',
  boxShadow: '1px 1px 1px rgba(0,0,0,0.5)',
}

export default class SocialCalendar extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      displayModal: false,
      facebook_posts: [],
    }

    BigCalendar.momentLocalizer(moment);
    this.toggleEventModal = this.toggleEventModal.bind(this);
  }

  getEvents() {
    let events = [];
    let dates = JSON.parse(this.props.dates);

    Object.keys(dates).forEach(key => {
      const month = moment(key).month();

      let event = {
        'allDay': true,
        'title': '*',
        'start': new Date(key),
        'end': new Date(key)
      }

      events.push(event);
    });

    return events;
  }

  getEventStyles = (event, start, end, isSelected) => {
    let opacity, style;
    let dates = JSON.parse(this.props.dates);
    let date = moment(event.start).format();

    Object.keys(dates).forEach(key => {
      if (moment(key).format() == date) {
        let color;

        switch (dates[key].variance) {
          case "severe_down":
            color = "#0E88FF"
            break;
          case "mild_down":
            color = "#96CAFD"
            break;
          case "average":
            color = "#d3d3d3"
            break;
          case "mild_up":
            color = "#E96175"
            break;
          case "severe_up":
            color = "#E60022"
            break;
          default:
            color = null;
        }

        style = {
          backgroundColor: color
        }
      }
    });

    return { style: style };
  }

  renderMonths() {
    let calendars = [];
    let months = [];

    [...Array(12).keys()].forEach((month, index) => {
      months.push(this.renderMonth(month))
    });

    return months;
  }

  renderMonth(month) {
    let date = new Date();
    date.setMonth(month);

    const components = {
      toolbar: Toolbar
    };

    return (
      <div className="month" key={month}>
        <BigCalendar
          components={components}
          defaultDate={date}
          events={this.getEvents()}
          eventPropGetter={this.getEventStyles}
          views={['month']}
          selectable={true}
          onSelectEvent={event => this.toggleEventModal(event)}
        />
      </div>
    )
  }

  toggleEventModal(event = {}) {
    if(!this.state.displayModal) {

      let start = event.start
      let end = moment(start).add(1, 'days').toDate()

      let self = this;

      $.get({
        url: "/facebook_posts",
        data: {
          start: start,
          end: end
        }
      })
      .done(function(data){
        self.setState({ facebook_posts: data.facebook_posts });
      });
    }

    this.setState({displayModal: !this.state.displayModal})
  }

  render() {

    const posts = this.state.facebook_posts.map(facebook_post =>
      <div className="post" key={facebook_post.id}>{facebook_post.message}</div>
    )

    return (
      <div className="calendar">
        <div className="months">
          {this.renderMonths()}
        </div>
        <div className="legend">
          <div className="legend-item">
            <div className="severe-down square" />
            <div className="legend-text">
              Many fewer posts than average
            </div>
          </div>
          <div className="legend-item">
            <div className="mild-down square" />
            <div className="legend-text">
              Fewer posts than average
            </div>
          </div>
          <div className="legend-item">
            <div className="average square" />
            <div className="legend-text">
              Average number of posts
            </div>
          </div>
          <div className="legend-item">
            <div className="mild-up square" />
            <div className="legend-text">
              More posts than average
            </div>
          </div>
          <div className="legend-item">
            <div className="severe-up square" />
            <div className="legend-text">
              Many more posts than average
            </div>
          </div>
        </div>
        <div className="modal" style={{display: this.state.displayModal ? 'block' : 'none'}}>
          <div className="modal-box" style={modalStyles}>
            <div className="modal-header">
              <button className="btn" onClick={this.toggleEventModal}>x</button>
            </div>
            <div className="modal-body">
              {posts}
            </div>
          </div>
        </div>
      </div>
    )
  }
}
