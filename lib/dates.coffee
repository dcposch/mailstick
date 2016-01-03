MS_PER_DAY = 1000 * 3600 * 24

# Takes an integer day since 1970-01-01
# Returns an integer week since 1970-01-01
# Examples:
# getWeek(0) -> 0 # Thursday, Jan 1 1970
# getWeek(1) -> 0 # Friday, Jan 2 1970
# getWeek(3) -> 1 # Sunday, Jan 4 1970
getWeek = (day) ->
  (day + 4) // 7

# Takes an integer day since 1970-01-01
# Returns Sunday = 0, ..., Saturday = 6
getDayOfWeek = (day) ->
  (day + 4) % 7

# Takes an integer day since 1970-01-01
# Returns January = 1, ..., December = 12
getMonth = (day) ->
  new Date(day * MS_PER_DAY).getUTCMonth() + 1

# Takes an integer day since 1970-01-01
# Returns the ISO representation.
# getISODate(0) -> "1970-01-01"
getISODate = (day) ->
  date = new Date(day * MS_PER_DAY)
  pad = (num) -> (if num >= 10 then '' else '0') + num
  date.getUTCFullYear() + '-' + pad(date.getUTCMonth() + 1) + '-' + pad(date.getUTCDate())

# Takes a JS date object
# Returns "YYYY-MM-DD" in the local timezone
getLocalDateString = (date) ->
  pad = (num) -> (if num >= 10 then '' else '0') + num
  return date.getFullYear() + '-' + pad(date.getMonth() + 1) + '-' + pad(date.getDate())

module.exports = {getWeek, getDayOfWeek, getMonth, getISODate, getLocalDateString, MS_PER_DAY}
