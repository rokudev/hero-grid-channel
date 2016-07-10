' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********

 'setting top interfaces
Sub Init()
  print "[Init] - Description.brs"
  m.top.Title             = m.top.findNode("Title")
  m.top.Description       = m.top.findNode("Description")
  m.top.PubDate           = m.top.findNode("PubDate")
End Sub

' Content change handler
' All fields population
Sub OnContentChanged()
  print "[OnContentChanged] - Description.brs"
  item = m.top.content

  title = item.title.toStr()
  if title <> invalid then
    m.top.Title.text = title.toStr()
  end if

  value = item.description
  if value <> invalid then
    if value.toStr() <> "" then
      m.top.Description.text = value.toStr()
    else
      m.top.Description.text = "No description"
    end if
  end if

  stop

  value = item.pubDate
  if value <> invalid then
    if value <> ""
      m.top.PubDate.text = value.toStr()
    else
      m.top.PubDate.text = "PubDate not available"
    end if
  end if
End Sub
