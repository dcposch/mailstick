{React} = require 'nylas-exports'
moment = require 'moment'

class WeeklyPunchcard extends React.Component
  @displayName: 'WeeklyPunchcard'

  @propTypes:
    data: React.PropTypes.object.isRequired
    palette: React.PropTypes.func.isRequired

  # Draws a grid of squares, each representing one day, going back a year
  # Every column represents one week
  # Inspired by Github's Contributions chart
  render: =>
    # Dimensions in pixels
    squareSize = 12
    squareStride = 14

    # Do date math using integer days since 1970-01-01
    today = new Date().getTime() / 1000 / 3600 / 24
    start = today - 365
    startWeek = _getWeek(start)
    dayElems = [start..today].map (day) ->
      week = _getWeek(day)
      dayOfWeek = _getDayOfWeek(day)
      style =
        left: (week - startWeek) * squareStride
        top: dayOfWeek * squareStride
        color: '#00aa00' #@props.palette(data)
        width: squareSize + 'px'
        height: squareSize + 'px'
        position: 'absolute'

      <div className="punchcard-day" style={style} />

    <div className="punchcard">
      SwagYolo
    </div>

  # Takes an integer day since 1970-01-01
  # Returns an integer week since 1970-01-01
  # Examples:
  # _getWeek(0) -> 0 # Thursday, Jan 1 1970
  # _getWeek(1) -> 0 # Friday, Jan 2 1970
  # _getWeek(3) -> 1 # Sunday, Jan 4 1970
  _getWeek: (day) =>
    return (day + 4) // 7

  # Takes an integer day since 1970-01-01
  # Returns Sunday = 0, ..., Saturday = 6
  _getDayOfWeek: (day) =>
    return (day + 4) % 7

module.exports = WeeklyPunchcard
