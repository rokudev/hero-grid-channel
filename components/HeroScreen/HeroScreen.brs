' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********

sub Init()
  ? "[HeroGrid] Init"
  m.top.setFocus(true)

  'Get references to child nodes
  m.RowList       =   m.top.findNode("RowList")
  m.background    =   m.top.findNode("Background")

  'Create a task node to fetch the grid content
  m.UriHandler =   CreateObject("roSGNode", "UriHandler")
  m.UriHandler.observeField("response", "onContentChanged")
  'request("blargh")
  request("http://api.delvenetworks.com/rest/organizations/59021fabe3b645968e382ac726cd6c7b/channels/1cfd09ab38e54f48be8498e0249f5c83/media.rss")

  'Create observer events for when content is loaded
  'm.LoadTask.observeField("content","rowListContentChanged")
  m.top.observeField("visible", "onVisibleChange")
  m.top.observeField("focusedChild", "OnFocusedChildChange")
end sub

sub request(inputURI as String)
  context = createObject("roSGNode", "Node")
  uri = { uri: inputURI }
  if type(uri) = "roAssociativeArray"
    context.addFields({
      parameters: uri,
      response: {}
    })
    m.UriHandler.request = { context: context }
  end if
end sub

' onContentChanged(): observer to handle when content loads
sub onContentChanged()
  print "rowListContentChanged()!"
  m.top.ready = m.UriHandler.response.success
  print m.top.ready
  m.top.content = m.UriHandler.response.content
end sub

' set proper focus to RowList in case if return from Details Screen
sub onVisibleChange()
  if m.top.visible = true then
    m.rowList.setFocus(true)
  end if
end sub

' set proper focus to RowList in case if return from Details Screen
Sub OnFocusedChildChange()
  if m.top.isInFocusChain() and not m.rowList.hasFocus() then
    m.rowList.setFocus(true)
  end if
End Sub

' handler of focused item in RowList
sub OnItemFocused()
  itemFocused = m.top.itemFocused

  'When an item gains the key focus, set to a 2-element array,
  'where element 0 contains the index of the focused row,
  'and element 1 contains the index of the focused item in that row.
  if itemFocused.Count() = 2 then
    focusedContent            = m.top.content.getChild(itemFocused[0]).getChild(itemFocused[1])
    if focusedContent <> invalid then
      m.top.focusedContent    = focusedContent
      m.background.uri        = focusedContent.hdBackgroundImageUrl
    end if
  end if
end sub
