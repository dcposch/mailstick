{React} = require 'nylas-exports'
{getWeek, getDayOfWeek, getMonth, getISODate, getLocalDateString, MS_PER_DAY} = require './dates'

MS_PER_MINUTE = 1000 * 60
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
    # Dimensions in pixels, date range
    now = new Date()
    options =
      squareSize: 12
      squareStride: 14
      labelLeft: 18
      labelTop: 20
      startDate: getLocalDateString(new Date(now.getTime() - 365*MS_PER_DAY))
      endDate: getLocalDateString(now) # eg '2015-12-01', local tz

    return @_render(options)

  # Pure function with nothing hard coded, for testability
  _render: (options) =>
    {squareSize, squareStride, labelLeft, labelTop, startDate, endDate} = options

    # Do date math using integer days since 1970-01-01
    start = Date.parse(startDate+'T00:00:00Z') // MS_PER_DAY
    end = Date.parse(endDate+'T00:00:00Z') // MS_PER_DAY
    startWeek = getWeek(start)

    # Each day gets a square, colored by whatever daily data we're visualizing
    dayBoxes = [start..end].map (day) =>
      week = getWeek(day)
      dayOfWeek = getDayOfWeek(day)
      data = @props.data[getISODate(day)]
      color = @props.palette(data)
      style =
        left: (week - startWeek) * squareStride + labelLeft
        top: dayOfWeek * squareStride + labelTop
        backgroundColor: color
        width: squareSize
        height: squareSize
      <div className="punchcard-day" style={style} />

    # Label months across the top
    monthLabels = [start..end]
      .filter (day) =>
        getDayOfWeek(day) == 0
      .filter (day) =>
        getMonth(day) != getMonth(day - 7)
      .map (day) =>
        week = getWeek(day)
        style =
          left: (week - startWeek) * squareStride + labelLeft
          top: 0
        text = MONTH_LABELS[getMonth(day) - 1]
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

module.exports = WeeklyPunchcard
