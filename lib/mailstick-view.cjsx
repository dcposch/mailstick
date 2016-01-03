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
    @state.selectedDate = null

  componentDidMount: =>
    @unsubscribers = []
    @unsubscribers.push MailstickStore.listen =>
      @setState(@_getStateFromStores())

  componentWillUnmount: =>
    unsubscribe() for unsubscribe in @unsubscribers

  render: =>
    if @state.selectedDate
      stats = @state.mailStats[@state.selectedDate]
      if !stats
        detailMessage = "You didn't check your mail on " + @state.selectedDate
      else if stats.minInbox == 0
        detailMessage = "You made it to Inbox Zero on " + @state.selectedDate + "!"
      else if stats.minInbox == 1
        detailMessage = "You had one message" +
          " left in your inbox on " + @state.selectedDate
      else
        detailMessage = "You had " + stats.minInbox + " messages" +
          " left in your inbox on " + @state.selectedDate
    <div className="mailstick">
      <h3>Inbox Zero</h3>
      <WeeklyPunchcard data={@state.mailStats} palette={@_colorInboxZero}
        selectedDate={@state.selectedDate} onClick={@_onClickDate}/>
      <div>{detailMessage}</div>
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

  # Fires when the user clicks on one of the boxes to select a single day
  _onClickDate: (date) =>
    @setState({selectedDate: date})

module.exports = MailstickView
