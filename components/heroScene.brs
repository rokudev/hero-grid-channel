' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********

'init(): 1st function that runs on channel startup
sub init()
  'To see debug, telnet on port 8089'
  print "[HeroScene] Init"
  ' HeroScreen Node with RowList
  m.HeroScreen = m.top.FindNode("HeroScreen")
  ' DetailsScreen Node with description & video player
  m.DetailsScreen = m.top.FindNode("DetailsScreen")
  ' The spinning wheel
  m.LoadingIndicator = m.top.findNode("LoadingIndicator")
end sub

' if content set, focus on GridScreen
sub OnChangeContent()
    m.HeroScreen.setFocus(true)
    m.loadingIndicator.control = "stop"
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
  ''? ">>> HomeScene >> OnkeyEvent"
  result = false
  'print "in HeroScene.xml onKeyEvent ";key;" "; press
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
  end if
  return result
end function
