' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********

' 1st function that runs on channel startup
sub init()
  'To see debug, telnet on port 8089'
  print "[HeroScene] Init"
  ' HeroScreen Node with RowList
  m.HeroScreen = m.top.FindNode("HeroScreen")
  ' DetailsScreen Node with description & video player
  m.DetailsScreen = m.top.FindNode("DetailsScreen")
  ' The spinning wheel
  m.LoadingIndicator = m.top.findNode("LoadingIndicator")
  ' Dialog box appears if content can't be loaded
  m.WarningDialog = m.top.findNode("WarningDialog")
end sub

' if content set, focus on GridScreen
sub OnChangeContent()
  print "[OnChangeContent] HeroScene.brs"
  m.loadingIndicator.control = "stop"
  print m.top.ready
  if m.top.ready = true
    m.HeroScreen.setFocus(true)
  else
    m.WarningDialog.visible = true
    m.top.dialog = m.WarningDialog
    m.top.dialog.setFocus(true)
  end if
end sub

' Row item selected handler
sub OnRowItemSelected()
  print "rowItemSelected()!!!!!"
  ' On select any item on home scene, show Details node and hide Grid
  m.HeroScreen.visible = "false"
  m.DetailsScreen.content = m.HeroScreen.focusedContent
  m.DetailsScreen.setFocus(true)
  m.DetailsScreen.visible = "true"
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
  ? ">>> HomeScene >> OnkeyEvent"
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
      m.top.dialog = invalid
      m.WarningDialog.visible = false
  end if
  return result
end function
