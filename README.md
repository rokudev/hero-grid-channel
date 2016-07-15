# HeroTileExample
![Roku](https://img.shields.io/badge/Roku-Dev-blue.svg)

Hero Tile Sample Channel for the Roku Platform

## How to run this sample
- Zip up the entire project directory and follow the developer set-up guide here: https://blog.roku.com/developer/2016/02/04/developer-setup-guide/
- Alternatively, open up this project in Eclipse or Atom and use the corresponding plugin/package to export/deploy the channel.

## Features
- Showcases a Hulu-like UI, varying the display of content by manipulating the built-in Scene Graph component
  - Includes a (1) hero sized row, (2) normal row, (3) movie poster row, and (4) a grid row of content.
- Uses both built-in and custom made Scene Graph components
- Demonstrates how to handle multiple URL requests to fill in different rows of content (e.g. Movies, specific genres, etc.)
- Demonstrates how to handle deep-linking of content
- Demonstrates how to display information to the user in a dialog box in case of failures to load content (e.g. bad URL request)

## Directory Structure
- Components: The Scene Graph components
  - DetailsScreen: All code related to the details screen
  - FadingBackground: For the transitions between each grid tile element
  - HeroScreen: The main screen of the channel (i.e. all tiles of content)
  - Item: The individual tile element of the grid
  - LoadingIndicator: The spinning wheel
  - UriHandler: Handles URL request/response for populating the UI. Also does the parsing of the response for each grid tiles.
  - HeroScene.brs/xml: The main scene. Acts as the controller in the MVC pattern of the channel.
- Images: Contains image assets used in the channel
- Source: Contains the main brightscript file that runs right when the channel starts

## Channel Flow
This section explains what happens when the channel/app does and what the user
sees as a result.
- Event: Opening the channel starts several URL requests to get content for each row of content in the channel.
- User: While this occurs, a loading wheel is presented to the user.
- Event: The URL responses are parsed as they come in and stored until all requests are finished. When all requests have been received, sets the UI element to the content
- User: Sees the screen load with all the content
- Event: HeroScreen --> user can move around the grid to look at different content. The user presses OK on the remote to select content.  
- User: Upon pressing OK, a details screen opens up and displays info. about the content.
- Event: User presses the play button on the DetailsScreen
- User: The video starts playing
- Event: User presses the back button on the DetailsScreen
- User: User goes back to the main grid content screen.
- Event: User presses the back button on the video
- User: Sees the details screen.

### Features that still need to be implemented
- [ ] Proper warning dialogs to notify users of failures
- [ ] Possible warning: after 3 seconds, show dialog asking user if he/she wants the content from that feed -- if not, load the feed.
If so, try the feed request again
- [ ] Guide/Blog post showing how to use the sample channel / next steps
- [ ] Discuss deep linking next steps
- [ ] UI Fix

### Known issues
- The content may take a while to load (i.e. the loading wheel will be active for a long time) since the HTTP requests are asynchronous and the content is only loaded after all requests have their corresponding responses parsed for content. This is an issue with network latency and async requests. One way to mitigate this issue is to load content whenever you receive a response. However, the implementation is a bit tricky since the content may load in a different order than intended.
