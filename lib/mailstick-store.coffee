NylasStore = require 'nylas-store'
{DatabaseStore, Thread, Label, Folder} = require 'nylas-exports'
_ = require 'underscore'
{getLocalDateString} = require './dates'

# Keeps track of the combined size of your inbox across all accounts
# Tracks your smallest inbox size on each date, so you know which days you hit Inbox Zero
class MailstickStore extends NylasStore
  constructor: ->
    # Maps dates to email stats for that date
    # '2015-01-01': {'minInbox': 4}
    # '2015-01-02': {'minInbox': 0}
    @_mailStats = {}
    @_countsDirty = true
    @_fetchInboxCategories (categories) =>
      @_inboxCategories = categories
      @_fetchIfNecessary()

    @listenTo DatabaseStore, @_onDataChanged

  getMailStats: ->
    @_mailStats

  setMailStats: (mailStats) ->
    @_mailStats = mailStats
    @trigger()

  _onDataChanged: (change) =>
    if change.objectClass is Thread.name
      # If we created a new thread, moved a thread, etc, then recheck inbox size
      @_countsDirty = true

  # Runs once a second. Fetches inbox counts if anything has changed.
  _fetchIfNecessary: =>
    if @_countsDirty
      @_countsDirty = false
      @_fetchInboxSize =>
        _.delay(@_fetchIfNecessary, 1000)
    else
      _.delay(@_fetchIfNecessary, 1000)

  # Finds the inbox label or folder for each account, calls back
  # with the complete list of Label and Folder objects
  _fetchInboxCategories: (callback) =>
    ret = []
    DatabaseStore.findAll(Label, [
      Label.attributes.name.equal('inbox')
    ]).then (labels) =>
      Array::push.apply ret, labels
      DatabaseStore.findAll(Folder, [
        Folder.attributes.name.equal('inbox')
      ]).then (folders) =>
        Array::push.apply ret, folders
        callback(ret)

  # Gets the total number of threads in each account's inbox,
  # updates @_mailStats, calls back when done
  _fetchInboxSize: (callback) =>
    now = new Date
    today = getLocalDateString(now) # eg '2015-12-31'
    stats = if @_mailStats[today] then @_mailStats[today] else {}
    @_mailStats[today] = stats

    @_fetchEachInboxSize 0, 0, (inboxSize) =>
      if typeof stats.minInbox != 'number' || inboxSize < stats.minInbox
        stats.minInbox = inboxSize
        @trigger()
        callback()

  _fetchEachInboxSize: (index, sumSoFar, callback) =>
    if index == @_inboxCategories.length
      return callback(sumSoFar)
    category = @_inboxCategories[index]
    if category instanceof Label
      predicate = Thread.attributes.labels.contains(category.id)
    else
      predicate = Thread.attributes.folders.contains(category.id)
    DatabaseStore.count(Thread, [predicate]).then (inboxSize) =>
      @_fetchEachInboxSize(index + 1, sumSoFar + inboxSize, callback)

module.exports = new MailstickStore()
