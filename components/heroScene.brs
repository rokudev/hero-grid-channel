' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********

'init(): 1st function that runs on channel startup
sub init()
  'To see debug, telnet on port 8089'
  print "[HeroScene] Init"
  ' HeroGrid Node with RowList
  m.HeroGrid= m.top.FindNode("HeroGrid")
  ' DetailsScreen Node with description & video player
  m.DetailsScreen = m.top.FindNode("DetailsScreen")
  ' The spinning wheel
  m.LoadingIndicator = m.top.findNode("LoadingIndicator")
end sub

' if content set, focus on GridScreen
sub OnChangeContent()
    m.HeroGrid.setFocus(true)
    m.loadingIndicator.control = "stop"
end sub

' Row item selected handler
sub OnRowItemSelected()
  print "rowItemSelected()!!!!!"
  ' On select any item on home scene, show Details node and hide Grid
  m.HeroGrid.visible = "false"
  m.DetailsScreen.content = m.HeroGrid.focusedContent
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
      if m.HeroGrid.visible = false and m.DetailsScreen.videoPlayerVisible = false
        m.HeroGrid.visible = "true"
        m.detailsScreen.visible = "false"
        m.HeroGrid.setFocus(true)
        result = true
      ' if video player opened
      else if m.HeroGrid.visible = false and m.DetailsScreen.videoPlayerVisible = true
        m.DetailsScreen.videoPlayerVisible = false
        result = true
      end if
    else if key = "home"
      print "home pressed"
    end if
  end if
  return result
end function
