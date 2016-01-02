{getWeek, getDayOfWeek, getMonth, getISODate, getLocalDateString} = require '../lib/dates'

describe 'Dates', ->
  it 'should get year/month/day from an integer date' ->
    expect(getISODate(0)).toEqual('1970-01-01')
    expect(getISODate(1)).toEqual('1970-01-02')
    expect(getISODate(2)).toEqual('1970-01-03')
    expect(getISODate(3)).toEqual('1970-01-04')
    expect(getISODate(16800)).toEqual('2015-12-31')

    expect(getMonth(0)).toEqual(1)
    expect(getMonth(1)).toEqual(1)
    expect(getMonth(2)).toEqual(1)
    expect(getMonth(3)).toEqual(1)
    expect(getMonth(16800)).toEqual(12)

  it 'should get week info from an integer date' ->
    expect(getWeek(0)).toEqual(0) # Thursday, Jan 1 1970
    expect(getWeek(1)).toEqual(0)
    expect(getWeek(2)).toEqual(0)
    expect(getWeek(3)).toEqual(1) # Sunday, Jan 4 1970, start of a new week
    expect(getWeek(16800)).toEqual(2400)

    expect(getDayOfWeek(1)).toEqual(5)
    expect(getDayOfWeek(0)).toEqual(4)
    expect(getDayOfWeek(2)).toEqual(6) # Saturday = 6
    expect(getDayOfWeek(3)).toEqual(0) # Sunday = 0
    expect(getDayOfWeek(16800)).toEqual(4) # Thursday, Dec 31 2015

  it 'should extract the local date from a Date object'
    expect(getLocalDateString(new Date("Jan 1 2015"))).toEqual("2015-01-01")
    expect(getLocalDateString(new Date("Feb 29 2000"))).toEqual("2000-02-29")
