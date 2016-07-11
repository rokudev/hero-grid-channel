' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********

' A context node has a parameters and response field
' - parameters corresponds to everything related to an HTTP request
' - response corresponds to everything related to an HTTP response
' Component Variables:
'   m.port: the UriFetcher message port
'   m.jobsById: an AA containing a history of HTTP requests/responses

' init(): UriFetcher constructor
' Description: sets the execution function for the UriFetcher
' 						 and tells the UriFetcher to run
sub init()
  print "UriHandler.brs - [init]"
  ' create the message port
	m.port = createObject("roMessagePort")
  m.top.numRows = 4
  m.top.numRowsReceived = 0
  m.top.contentSet = false
  m.top.observeField("request", m.port)
  m.top.observeField("numRowsReceived", m.port)
	m.top.functionName = "go"
	m.top.control = "RUN"
end sub

' Callback function for when content has finished parsing
sub updateContent()
  print "UriHandler.brs - [updateContent]"
  if m.top.contentSet = true then return
  if m.top.numRows = m.top.numRowsReceived
    parent = createObject("roSGNode", "ContentNode")
    for i = 0 to (m.top.numRowsReceived - 1)
      oldParent = m.contentCache.getField(i.toStr())
      for j = 0 to (oldParent.getChildCount() - 1)
        oldParent.getChild(0).reparent(parent,true)
      end for
    end for
    print "All content has finished loading"
    m.top.contentSet = true
    m.top.content = parent
  else
    print "Not all content has finished loading yet"
  end if
end sub

' go(): The "Task" function.
'   Has an event loop which calls the appropriate functions for
'   handling requests made by the HeroScreen and responses when requests are finished
' variables:
'   m.jobsById: AA storing HTTP transactions where:
'			key: id of HTTP request
'  		val: an AA containing:
'       - key: context
'         val: a node containing request info
'       - key: xfer
'         val: the roUrlTransfer object
sub go()
  print "UriHandler.brs - [go]"
  m.jobsById = {}
  m.contentCache = m.top.findNode("contentCache")

	' UriFetcher event loop
	while true
		msg = wait(0, m.port)
		mt = type(msg)
		print "UriFetcher: received event type '"; mt; "'"
    ' If a request was made
		if mt = "roSGNodeEvent"
			if msg.getField()="request"
        print "received a request"
				if addRequest(msg.getData()) <> true then print "Invalid request"
			else if msg.getField()="numRowsReceived"
        print "finished parsing response"
        updateContent()
      else
				print "UriFetcher: unrecognized field '"; msg.getField(); "'"
			end if
    ' If a response was received
    else if mt="roUrlEvent"
      print "received a response"
			processResponse(msg)
    ' Handle unexpected cases
		else
			print "UriFetcher: unrecognized event type '"; mt; "'"
		end if
	end while
end sub

' addRequest():
'   Makes the HTTP request
' parameters:
'		request: a node containing the request params/context.
' variables:
'   m.jobsById: used to store a history of HTTP requests
' return value:
'   True if request succeeds
' 	False if invalid request
function addRequest(request as Object) as Boolean
  print "UriHandler.brs - [addRequest]"
	' If valid request
  if type(request) = "roAssociativeArray"
    context = request.context
  	if type(context) = "roSGNode"
      parameters = context.parameters
      if type(parameters)="roAssociativeArray"
      	uri = parameters.uri
        if type(uri) = "roString"
          urlXfer = createObject("roUrlTransfer")
          urlXfer.setUrl(uri)
          urlXfer.setPort(m.port)
          ' should transfer more stuff from parameters to urlXfer
          idKey = stri(urlXfer.getIdentity()).trim()
          ' AsyncGetToString returns false if the request couldn't be issued
          ok = urlXfer.AsyncGetToString()
          if ok then m.jobsById[idKey] = {
            context: request,
            xfer: urlXfer
          }
  		    print "UriFetcher: initiating transfer '"; idkey; "' for URI '"; uri; "'"; " succeeded: "; ok
        else
          print "UriFetcher: invalid uri: "; uri
          m.top.numBadRequests++
  			end if
      end if
  	else
  		return false
  	end if
  end if
  return true
end function

' processResponse():
'   Processes the HTTP response.
'   Sets the node's response field with the response info.
' parameters:
' 	msg: a roUrlEvent (https://sdkdocs.roku.com/display/sdkdoc/roUrlEvent)
sub processResponse(msg as Object)
  print "UriHandler.brs - [processResponse]"
	idKey = stri(msg.GetSourceIdentity()).trim()
	job = m.jobsById[idKey]
	if job <> invalid
    context = job.context
    parameters = context.context.parameters
    jobnum = job.context.context.num
    uri = parameters.uri
		print "UriFetcher: response for transfer '"; idkey; "' for URI '"; uri; "'"
		result = {
      code:    msg.GetResponseCode(),
      headers: msg.GetResponseHeaders(),
      content: msg.GetString(),
      num:     jobnum
    }
		' could handle various error codes, retry, etc.
		m.jobsById.delete(idKey)
    job.context.context.response = result
    print msg.GetResponseCode()
    if msg.GetResponseCode() = 200
      parseResponse(result.content, result.num)
    else
      print "Status code was: " + (msg.GetResponseCode()).toStr()
      m.top.numBadRequests++
    end if
	else
		print "UriFetcher: event for unknown job "; idkey
	end if
end sub

' Parses the response string as XML'
sub parseResponse(str As String, num as Integer)
  print "UriHandler.brs - [parseResponse]"
  if str = invalid return
  xml = CreateObject("roXMLElement")
  ' Return invalid if string can't be parsed
  if not xml.Parse(str) return

  if xml <> invalid then
    xml = xml.getchildelements()
    responsearray = xml.getchildelements()
  end if

  result = []
  'responsearray - <channel>'
  for each xmlitem in responsearray
    ' <title>, <link>, <description>, <pubDate>, <image>, and lots of <item>'s
    if xmlitem.getname() = "item"
      ' All things related to one item (title, link, description, media:content, etc.)
      itemaa = xmlitem.getchildelements()
      if itemaa <> invalid
        item = {}
        ' Get all <item> attributes
        for each xmlitem in itemaa
          item[xmlitem.getname()] = xmlitem.gettext()
          if xmlitem.getname() = "media:content"
            item.stream = {url : xmlitem.url}
            item.url = xmlitem.getattributes().url
            item.streamformat = "mp4"

            mediacontent = xmlitem.getchildelements()
            for each mediacontentitem in mediacontent
              if mediacontentitem.getname() = "media:thumbnail"
                item.hdposterurl = mediacontentitem.getattributes().url
                item.hdbackgroundimageurl = mediacontentitem.getattributes().url
                item.uri = mediacontentitem.getattributes().url
              end if
            end for
          end if
        end for
        result.push(item)
      end if
    end if
  end for

  list = [
    {
        Title:"Big Hits"
        ContentList : result
    }
    {
        Title:"Action"
        ContentList : result
    }
    {
        Title:"Drama"
        ContentList : result
    }
    {
        Title:"Explosions"
        ContentList : result
    }
  ]
  contentAA = {}
  contentAA[num.toStr()] = createRow(list,num)
  m.contentCache.addFields(contentAA)
  m.top.numRowsReceived++
end sub

'Create a row of content
function createRow(list as object, num as Integer)
  print "UriHandler.brs - [createRow]"
  Parent = createObject("RoSGNode", "ContentNode")
  if num = 3 then return createGrid(list, num)
  row = createObject("RoSGNode", "ContentNode")
  row.Title = list[num].Title
  for each itemAA in list[num].ContentList
    item = createObject("RoSGNode","ContentNode")
    item.SetFields(itemAA)
    row.appendChild(item)
  end for
  Parent.appendChild(row)
  return Parent
end function

'Create a grid of content
function createGrid(list as object, num as integer)
  print "UriHandler.brs - [createGrid]"
  Parent = createObject("RoSGNode","ContentNode")
  for i = 0 to list[0].ContentList.count() step 4
    row = createObject("RoSGNode","ContentNode")
    if i = 0
      row.Title="THE GRID"
    end if
    for j = i to i + 3
      if list[0].ContentList[j] <> invalid
        item = createObject("RoSGNode","ContentNode")
        item.SetFields(list[0].ContentList[j])
        row.appendChild(item)
      end if
    end for
    Parent.appendChild(row)
  end for
  return Parent
end function

'Creates the content nodes to populate the UI
Function CreateContent(list As Object)
  print "UriHandler.brs - [CreateContent]"
  RowItems = createObject("RoSGNode","ContentNode")
  'Creates the 6 rows of content above the grid content
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
  'Create the grid content
  for i = 0 to list[0].ContentList.count() step 4
    row = createObject("RoSGNode","ContentNode")
    if i = 0
      row.Title="THE GRID"
    end if
    for j = i to i + 3
      if list[0].ContentList[j] <> invalid
        item = createObject("RoSGNode","ContentNode")
        item.SetFields(list[0].ContentList[j])
        row.appendChild(item)
      end if
    end for
    RowItems.appendChild(row)
  end for
  return RowItems
End Function

function select(array as object, first as integer, last as integer) as object
  print "UriHandler.brs - [select]"
  result = []
  for i = first to last
    result.push(array[i])
  end for
  return result
end function
