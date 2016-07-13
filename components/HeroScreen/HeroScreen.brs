' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********

' Called when the HeroScreen component is initialized
sub Init()
  'print "HeroScreen.brs - [init]"

  'Get references to child nodes
  m.RowList       =   m.top.findNode("RowList")
  m.background    =   m.top.findNode("Background")

  'Create a task node to fetch the UI content and populate the screen
  m.UriHandler    =   CreateObject("roSGNode", "UriHandler")
  m.UriHandler.observeField("content", "onContentChanged")

  'Make a request for each "row" in the UI
  request("http://api.delvenetworks.com/rest/organizations/59021fabe3b645968e382ac726cd6c7b/channels/1cfd09ab38e54f48be8498e0249f5c83/media.rss", 0)
  request("http://api.delvenetworks.com/rest/organizations/59021fabe3b645968e382ac726cd6c7b/channels/5a438a6cfe68407684832d54c4b58cbb/media.rss", 1)
  request("http://api.delvenetworks.com/rest/organizations/59021fabe3b645968e382ac726cd6c7b/channels/4cd8f3ec67c64c16b8f3bf87339503dd/media.rss", 2)
  request("http://api.delvenetworks.com/rest/organizations/59021fabe3b645968e382ac726cd6c7b/channels/c7f9e852f45044ceb0ae0d7748d675a5/media.rss", 3)

  'Create observer events for when content is loaded
  m.top.observeField("visible", "onVisibleChange")
  m.top.observeField("focusedChild", "OnFocusedChildChange")
end sub

' Issues a URL request to the UriHandler component
sub request(inputURI as String, feedNum as Integer)
  'print "HeroScreen.brs - [request]"
  context = createObject("roSGNode", "Node")
  uri = { uri: inputURI }
  if type(uri) = "roAssociativeArray"
    context.addFields({
      parameters: uri,
      num: feedNum,
      response: {}
    })
    m.UriHandler.request = { context: context }
  end if
end sub

' observer function to handle when content loads
sub onContentChanged()
  'print "HeroScreen.brs - [onContentChanged]"
  m.top.numBadRequests = m.UriHandler.numBadRequests
  m.top.content = m.UriHandler.content
end sub

' handler of focused item in RowList
sub OnItemFocused()
  'print "HeroScreen.brs - [onItemFocused]"
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

' sets proper focus to RowList in case channel returns from Details Screen
sub onVisibleChange()
  print "HeroScreen.brs - [onVisibleChange]"
  if m.top.visible = true then
    m.rowList.setFocus(true)
  end if
end sub

' set proper focus to RowList in case if return from Details Screen
Sub onFocusedChildChange()
  print "HeroScreen.brs - [onFocusedChildChange]"
  if m.top.isInFocusChain() and not m.rowList.hasFocus() then
    m.rowList.setFocus(true)
  end if
End Sub
