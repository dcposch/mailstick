{React,
 WorkspaceStore} = require 'nylas-exports'
{Menu,
 RetinaImg,
 Popover} = require 'nylas-component-kit'
MailstickStore = require './mailstick-store'
WeeklyPunchcard = require './weekly-punchcard'

class MailstickView extends React.Component
  @displayName: 'MailstickView'

  @propTypes: {}

  constructor: ->
    @state = @_getStateFromStores()

  componentDidMount: =>
    @unsubscribers = []
    @unsubscribers.push MailstickStore.listen =>
      @setState(@_getStateFromStores())

  componentWillUnmount: =>
    unsubscribe() for unsubscribe in @unsubscribers

  render: =>
    <div className="mailstick">
      <h3>Inbox Zero</h3>
      <WeeklyPunchcard data={@state.mailStats} palette={@_colorInboxZero} />
    </div>

  # Takes stats for a single day, returns a color for that day:
  # Green if you reached inbox zero, yellow-orange if your inbox got smaller
  # red-orange if it got bigger, gray if you didn't check your email that day
  _colorInboxZero: (emailStats) =>
    if !emailStats?
      '#bbbbbb'
    else if emailStats.minInbox == 0
      '#238b45'
    else if emailStats.minInbox <= 10
      '#74c476'
    else
      '#bae4b3'

  _getStateFromStores: =>
    {mailStats: MailstickStore.getMailStats()}

module.exports = MailstickView
