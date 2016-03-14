window.$ = window.jQuery = require('../node_modules/jquery')
gagWebPaneView = require './nGag-view'


{CompositeDisposable} = require 'atom'

module.exports = gagViewerPane =
  gagWebPaneView: null
  modalPanel: null
  subscriptions: null
  enlarged : false

  activate: (state) ->
    @gagWebPaneView = new gagWebPaneView(state.gagWebPaneViewState)
    @modalPanel = atom.workspace.addRightPanel(item: @gagWebPaneView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'nGag:toggle': => @toggle()

    $(document).ready ->
      height = $(window).height()
      console.log height
      width = $(window).width()
      $('.gagViewer').width(width / 3)
      $('.gagViewer').append('<webview id="nGag" src="http://m.9gag.com/" style="display:inline-block; float: right; width:' + width / 3 +'px; height:' + height + 'px;"></webview>')
      $(window).on 'resize' , ->
        height = $(window).height()
        width = $(window).width()
        $('.gagViewer').width(width / 3)
        $('.gagViewer').height(height)
        $('#nGag').width(width / 3)
        $('#nGag').height(height)



  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @gagWebPaneView.destroy()

  serialize: ->
    gagWebPaneViewState: @gagWebPaneView.serialize()

  toggle: ->
    console.log 'gagViewerPane was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()

  enlarge: ->
    if @enlarged == false
      $('#nGag').width($(window).width() / 2)
      $('.gagViewer').width($(window).width() / 2)
      @enlarged = true
    else
      $('#nGag').width($(window).width() / 3)
      $('.gagViewer').width($(window).width() / 3)
      @enlarged = false
