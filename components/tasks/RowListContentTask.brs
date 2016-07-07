Sub Init()
  m.top.functionName = "loadContent"
End Sub

Sub loadContent()
  oneRow = GetApiArray()
  list = [
    {
        Title:"Big Hits"
        ContentList : SelectTo(oneRow, 25)
    }
    {
        Title:"Action"
        ContentList : SelectTo(oneRow, 9)
    }
    {
        Title:"Drama"
        ContentList : SelectTo(oneRow, 25)
    }
    {
        Title:"Explosions"
        ContentList : SelectTo(oneRow, 9)
    }
    {
        Title:"Everybody loves Chris"
        ContentList : SelectTo(oneRow, 25)
    }
  ]
  print "Creating Content Nodes"
  m.top.content = CreateGridContent(ParseXMLContent(list), list[0].contentList)
  print "Done"
End Sub

Function GetApiArray()
  url = CreateObject("roUrlTransfer")
  url.SetUrl("http://api.delvenetworks.com/rest/organizations/59021fabe3b645968e382ac726cd6c7b/channels/1cfd09ab38e54f48be8498e0249f5c83/media.rss")
  rsp = url.GetToString()

  responseXML = ParseResponse(rsp)
  If responseXML<>invalid then
    responseXML = responseXML.GetChildElements()
    responseArray = responseXML.GetChildElements()
  End If

  result = []

  for each xmlItem in responseArray
    if xmlItem.getName() = "item"
      itemAA = xmlItem.GetChildElements()
      if itemAA <> invalid
        item = {}
        for each xmlItem in itemAA
          item[xmlItem.getName()] = xmlItem.getText()
          if xmlItem.getName() = "media:content"
            item.stream = {url : xmlItem.url}
            item.url = xmlItem.getAttributes().url
            item.streamFormat = "mp4"

            mediaContent = xmlItem.GetChildElements()
            for each mediaContentItem in mediaContent
              if mediaContentItem.getName() = "media:thumbnail"
                item.HDPosterUrl = mediaContentItem.getattributes().url
                item.hdBackgroundImageUrl = mediaContentItem.getattributes().url
                item.uri = mediaContentItem.getAttributes().url
              end if
            end for
          end if
        end for
        result.push(item)
      end if
    end if
  end for

  return result
End Function

Function ParseResponse(str As String) As dynamic
  if str = invalid return invalid
  xml = CreateObject("roXMLElement")
  ' Return invalid if string can't be parsed
  if not xml.Parse(str) return invalid
  return xml
End Function

Function ParseXMLContent(list As Object)
  RowItems = createObject("RoSGNode","ContentNode")

  for each rowAA in list
    row = createObject("RoSGNode","ContentNode")
    row.Title = rowAA.Title

    for each itemAA in rowAA.ContentList
      item = createObject("RoSGNode","ContentNode")
      item.SetFields(itemAA)
      row.appendChild(item)
    end for
    RowItems.appendChild(row)
  end for

  return RowItems
End Function

Function CreateGridContent(RowItems As Object, list As Object)
  for i = 0 to list.count() step 4
    row = createObject("RoSGNode","ContentNode")
    if i = 0
      row.Title="THE GRID"
    end if
    for j = i to i+3
      item = createObject("RoSGNode","ContentNode")
      item.SetFields(list[j])
      row.appendChild(item)
    end for
    RowItems.appendChild(row)
  end for

  print "ok"
  return RowItems
End Function

function SelectTo(array as Object, num = 25 as Integer) as Object
   result = []
   for each item in array
     result.push(item)
     if result.Count() >= num then
       exit for
     end if
   end for
  return result
end Function
