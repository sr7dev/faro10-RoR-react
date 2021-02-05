import React from 'react';
import SocialCalendar from './SocialCalendar';

export default class Socials extends React.Component {
  render() {
    return (
      <div className="socials">
        <div className="top-row">
          <div className="average-post-count">
            <h1>{this.props.averagePostCount}</h1>
            <div className="header">Average posts over previous week</div>
          </div>
          <h3 className="top-blurb">
            Look for insights by reviewing your social activity and comparing it to your Dashboard health metrics to determine how your mood may affect your social media habits, or if your social media habits impact your mood.
          </h3>
        </div>
        <SocialCalendar
          dates={this.props.dates}
        />
      </div>
    )
  }
}
