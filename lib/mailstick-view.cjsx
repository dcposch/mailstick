{React,
 WorkspaceStore} = require 'nylas-exports'
{Menu,
 RetinaImg,
 Popover} = require 'nylas-component-kit'
WeeklyPunchcard = require './weekly-punchcard'

class MailstickView extends React.Component
  @displayName: 'MailstickView'

  @propTypes: {}

  render: =>
    mailStats =
      '2015-01-01': {'minInbox': 4, 'minInboxDelta': 4}
      '2015-01-02': {'minInbox': 0, 'minInboxDelta': -4}
      '2015-01-04': {'minInbox': 0, 'minInboxDelta': 0}
      '2015-01-05': {'minInbox': 39, 'minInboxDelta': 39}
      '2015-01-07': {'minInbox': 9, 'minInboxDelta': -30}
      '2015-01-08': {'minInbox': 0, 'minInboxDelta': -9}
      '2015-01-09': {'minInbox': 4, 'minInboxDelta': 4}

    <div className="mailstick">
      <h3>Inbox Zero</h3>
      <WeeklyPunchcard data={mailStats} palette={@_colorInboxZero} />
    </div>

  # Takes stats for a single day, returns a color for that day:
  # Green if you reached inbox zero, yellow-orange if your inbox got smaller
  # red-orange if it got bigger, gray if you didn't check your email that day
  _colorInboxZero: (emailStats) =>
    if !emailStats?
      '#666666'
    else if emailStats.minInbox == 0
      '#00aa00'
    else if emailStats.minInboxDelta <= 0
      '#779900'
    else
      '#997700'

module.exports = MailstickView
