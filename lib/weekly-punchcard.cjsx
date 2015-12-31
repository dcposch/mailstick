{React} = require 'nylas-exports'
moment = require 'moment'

MS_PER_DAY = 1000 * 3600 * 24
MONTH_LABELS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
DAY_LABELS = ['S', 'M', 'T', 'W', 'T', 'F', 'S']

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
    labelLeft = 18
    labelTop = 20

    # Do date math using integer days since 1970-01-01
    today = new Date().getTime() // MS_PER_DAY
    start = today - 365
    startWeek = @_getWeek(start)

    # Each day gets a square, colored by whatever daily data we're visualizing
    dayBoxes = [start..today].map (day) =>
      week = @_getWeek(day)
      dayOfWeek = @_getDayOfWeek(day)
      style =
        left: (week - startWeek) * squareStride + labelLeft
        top: dayOfWeek * squareStride + labelTop
        backgroundColor: '#00aa00' #@props.palette(data)
        width: squareSize
        height: squareSize
      <div className="punchcard-day" style={style} />

    # Label months across the top
    monthLabels = [start..today]
      .filter (day) =>
        @_getDayOfWeek(day) == 0
      .filter (day) =>
        @_getMonth(day) != @_getMonth(day - 7)
      .map (day) =>
        week = @_getWeek(day)
        style =
          left: (week - startWeek) * squareStride + labelLeft
          top: 0
        text = MONTH_LABELS[@_getMonth(day) - 1]
        <div className="punchcard-month-label" style={style}>{text}</div>

    # Label days M-W-F down the left side
    dayLabels = [1, 3, 5].map (dayOfWeek) =>
      style =
        left: 0
        top: dayOfWeek * squareStride + labelTop
        width: squareSize
        height: squareSize
        lineHeight: squareSize + 'px'
      text = DAY_LABELS[dayOfWeek]
      <div className="punchcard-day-label" style={style}>{text}</div>

    <div className="punchcard">
      {dayLabels}
      {monthLabels}
      {dayBoxes}
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

  # Takes an integer day since 1970-01-01
  # Returns January = 1, ..., December = 12
  _getMonth: (day) =>
    return new Date(day * MS_PER_DAY).getMonth() + 1

module.exports = WeeklyPunchcard
