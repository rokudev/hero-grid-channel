
'init(): 1st function that runs on channel startup
sub init()
  print "starting init"

  ' RowList Node
  m.rowList = m.top.FindNode("RowList")
  m.rowList.SetFocus(true)

  m.DetailsScreen = m.top.FindNode("DetailsScreen")

  m.LoadTask = CreateObject("roSGNode", "RowListContentTask")
  m.LoadTask.observeField("content","rowListContentChanged")
  m.LoadTask.control = "RUN"

  ' set focus on the Scene (which will set focus on the initialFocus node)
  'print "LABELLIST itemSize"; m.rowList.itemSize
  'print "LABELLIST translation"; m.rowList.translation
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
  print "in testList.xml onKeyEvent ";key;" "; press
  if press then
    if key = "back"
      print "back pressed"
    else if key = "home"
      print "home pressed"
    end if
  end if
  return false
end function

sub rowListContentChanged()
  print "rowListContentChanged()"
  m.RowList.content = m.LoadTask.content
end sub
