{React} = require 'nylas-exports'
WeeklyPunchcard = require('../lib/weekly-punchcard')

describe "WeeklyPunchcard", ->
  it "should render axis labels and a colored box for each day", ->
    testData =
      '2015-01-01': '#a00'
      '2015-01-02': '#b00'
      '2015-01-04': '#c00'
      '2015-01-05': '#d00'
    testPalette = (color) -> if color then color else '#666'
    testOptions =
        squareSize: 8
        squareStride: 10
        labelLeft: 20
        labelTop: 20
        startDate: '2015-01-01'
        endDate: '2015-01-08'

    dut = new WeeklyPunchcard()
    dut.props =
      data: testData
      palette: testPalette

    expectedHTML =
      <div className="punchcard">
        <div className="punchcard-day-label" style={{left:0,top:30,width:8,height:8,lineHeight:'8px'}}>M</div>
        <div className="punchcard-day-label" style={{left:0,top:50,width:8,height:8,lineHeight:'8px'}}>W</div>
        <div className="punchcard-day-label" style={{left:0,top:70,width:8,height:8,lineHeight:'8px'}}>F</div>

        <div className="punchcard-month-label" style={{left:30,top:0}}>Jan</div>

        <div className="punchcard-day" style={{left:20,top:60,backgroundColor:'#a00',width:8,height:8}} />
        <div className="punchcard-day" style={{left:20,top:70,backgroundColor:'#b00',width:8,height:8}} />
        <div className="punchcard-day" style={{left:20,top:80,backgroundColor:'#666',width:8,height:8}} />
        <div className="punchcard-day" style={{left:30,top:20,backgroundColor:'#c00',width:8,height:8}} />
        <div className="punchcard-day" style={{left:30,top:30,backgroundColor:'#d00',width:8,height:8}} />
        <div className="punchcard-day" style={{left:30,top:40,backgroundColor:'#666',width:8,height:8}} />
        <div className="punchcard-day" style={{left:30,top:50,backgroundColor:'#666',width:8,height:8}} />
        <div className="punchcard-day" style={{left:30,top:60,backgroundColor:'#666',width:8,height:8}} />
      </div>

    expect(unroll(dut._render(testOptions))).toEqual(expectedHTML)

# Converts React array-of-arrays to simple arrays
# This lets you compare the result of a React render() method to some constant HTML
unroll = (obj) ->
  if obj and obj._store and obj._store.props and obj._store.props.children
    children = obj._store.props.children
    unrolledChildren = unrollArray(children)
    for i in [0...unrolledChildren.length]
      children[i] = unrolledChildren[i]
    for child in children
      unroll(child)
  obj

unrollArray = (arr) ->
  ret = []
  for elem in arr
    if Array.isArray(elem)
      ret.push.apply(ret, unrollArray(elem))
    else
      ret.push(elem)
  ret
