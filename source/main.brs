' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********

sub Main(deepLinkingParams as Dynamic)
    print "################"
    print "Start of Channel"
    print "################"
    'TODO: Deep linking support. Test deep linking with Robert's code'
    if deepLinkingParams <> invalid
      if deepLinkingParams.reason = "ad" then
        'do ad stuff'
      else
        'do unspecified stuff'
      end if
      contentID = deepLinkingParams.contentID
      ' Call the service provider API to look up
      ' the content details, or right data from feed for id
    end if
    showHeroScreen()
end sub

sub showHeroScreen()
    print "in showMarkupSGScreen"
    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)
    scene = screen.CreateScene("HeroScene")
    screen.show()

    while(true)
      msg = wait(0, m.port)
      msgType = type(msg)
      if msgType = "roSGScreenEvent"
        if msg.isScreenClosed() then return
      end if
    end while
end sub
