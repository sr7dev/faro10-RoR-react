import React, { Component } from 'react';
import AppointmentCalendar from './AppointmentCalendar';
import BrowserSupport, { detectBrowser } from 'react-browser-support/dist/index';

const minBrowserVersions = {
    chrome: '42',
    edge: '15',
    firefox: '22',
    ie: '11',
    opera: '47',
    safari: '10.1',
}

export default class Appointments extends Component {

  componentDidMount() {
    let browser = detectBrowser();
    this.setState({ browser: browser })
  }

  onCheck(browser) {
    this.setState({browser})
  }

  render() {

    return this.state ? (
      <div className="appointments">
        <BrowserSupport
          onCheck={this.onCheck} 
          supported={minBrowserVersions} 
          className='alert alert-danger'>
          <p>
            Your browser, {this.state.browser.name} version {this.state.browser.version} is unsupported.  Please upgrade to the newest version of <a href='https://support.microsoft.com/en-us/help/17621/internet-explorer-downloads'>Internet Explorer</a> or use <a href='https://www.google.com/chrome/browser/desktop/index.html'>Chrome</a>
            , <a href='https://www.mozilla.org/en-US/firefox/new/'>Firefox</a>, or <a href='https://apple.com/safari'>Safari</a> for an optimal experience.
          </p>
        </BrowserSupport>
        { this.state.browser.supported ? <AppointmentCalendar appointments={this.props.appointments} /> : null }
      </div>
    ) : null
  }
}
