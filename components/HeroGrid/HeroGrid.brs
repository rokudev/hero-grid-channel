' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********

sub Init()
  ? "[HeroGrid] Init"
  m.top.setFocus(true)

  'Get references to child nodes
  m.rowList       =   m.top.findNode("RowList")
  m.background    =   m.top.findNode("Background")

  'Create a task node to get the grid content
  m.LoadTask = CreateObject("roSGNode", "RowListContentTask")
  m.LoadTask.control = "RUN"

  'Create observer events for when content is loaded
  m.LoadTask.observeField("content","rowListContentChanged")
  m.top.observeField("visible", "onVisibleChange")
  m.top.observeField("focusedChild", "OnFocusedChildChange")
end sub

' rowListContentChanged(): observer to handle when content loads
sub rowListContentChanged()
  print "rowListContentChanged() - ContentReady!"
  m.RowList.content = m.LoadTask.content
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
