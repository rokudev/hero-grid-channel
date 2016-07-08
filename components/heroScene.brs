' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********

' 1st function that runs on channel startup
sub init()
  'To see print statements/debug info, telnet on port 8089
  print "[init] - HeroScene.brs"
  ' HeroScreen Node with RowList
  m.HeroScreen = m.top.FindNode("HeroScreen")
  ' DetailsScreen Node with description & video player
  m.DetailsScreen = m.top.FindNode("DetailsScreen")
  ' The spinning wheel node
  m.LoadingIndicator = m.top.findNode("LoadingIndicator")
  ' Dialog box node. Appears if content can't be loaded
  m.WarningDialog = m.top.findNode("WarningDialog")
end sub

' Hero Grid Content handler fucntion. If content is set, stops the
' loadingIndicator and focuses on GridScreen.
sub OnChangeContent()
  print "[OnChangeContent] - HeroScene.brs"
  m.loadingIndicator.control = "stop"
  if m.top.content <> invalid
    m.HeroScreen.setFocus(true)
  else
    m.WarningDialog.visible = true
    m.top.dialog = m.WarningDialog
    m.top.dialog.setFocus(true)
  end if
end sub

' Row item selected handler function.
' On select any item on home scene, show Details node and hide Grid.
sub OnRowItemSelected()
  print "[OnRowItemSelected] - HeroScene.brs"
  m.HeroScreen.visible = "false"
  m.DetailsScreen.content = m.HeroScreen.focusedContent
  m.DetailsScreen.setFocus(true)
  m.DetailsScreen.visible = "true"
end sub

' Called when a key on the remote is pressed
function onKeyEvent(key as String, press as Boolean) as Boolean
  print ">>> HomeScene >> OnkeyEvent"
  result = false
  print "in HeroScene.xml onKeyEvent ";key;" "; press
  if press then
    if key = "back"
      print "back button pressed"
      ' if Details opened
      if m.HeroScreen.visible = false and m.DetailsScreen.videoPlayerVisible = false
        m.HeroScreen.visible = "true"
        m.detailsScreen.visible = "false"
        m.HeroScreen.setFocus(true)
        result = true
      ' if video player opened
      else if m.HeroScreen.visible = false and m.DetailsScreen.videoPlayerVisible = true
        m.DetailsScreen.videoPlayerVisible = false
        result = true
      end if
    else if key = "home"
      print "home pressed"
    end if
    else if key = "options"
      print "options pressed"
      m.top.dialog = invalid
      m.WarningDialog.visible = false
  end if
  return result
end function
