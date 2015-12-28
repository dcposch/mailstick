# Mailstick
{React,
 WorkspaceStore,
 ComponentRegistry} = require 'nylas-exports'
MailstickView = require './mailstick-view'

module.exports =
  # Activate is called when the package is loaded, gets prev saved state
  activate: (@state) ->
    # The Mailstick sheet shows two views side by side: the main sidebar and the mailstick view
    WorkspaceStore.defineSheet 'Mailstick', {root: true, name: 'Mailstick', supportedModes: ['list']},
      list: ['RootSidebar', 'Mailstick']

    # Add a sidebar link that takes you to the mailstick sheet
    @sidebarItem = new WorkspaceStore.SidebarItem
      sheet: WorkspaceStore.Sheet.Mailstick
      # NOTE: Nylas looks for mailstick@2x.png and mailstick@1x.png in
      # N1/static/images/source-list, not in the plugin assets directory,
      # so it looks like you can't actually specify your own icon here
      icon: 'mailstick.png'
      id: 'mailstick'
      name: 'Mailstick'
      section: 'Views'
    WorkspaceStore.addSidebarItem(@sidebarItem)

    # Add the mailstick view
    ComponentRegistry.register MailstickView,
      location: WorkspaceStore.Location.Mailstick

  # Serialize is called when the package is about to be unloaded, returns state
  serialize: ->

  # This **optional** method is called when the window is shutting down,
  # or when your package is being updated or disabled.
  deactivate: ->
    WorkspaceStore.undefineSheet 'Mailstick'