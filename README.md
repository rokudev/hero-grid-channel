# Hero Grid Channel Example

Hero Grid Sample Channel for the Roku Platform. 

![Hero-Grid-1](https://raw.githubusercontent.com/rokudev/hero-grid-channel/master/images/HeroGridHome.jpg "HomeScreen-1")
![Hero-Grid-2](https://raw.githubusercontent.com/rokudev/hero-grid-channel/master/images/HeroGridHome2.jpg "HomeScreen-2")
![Hero-Grid-d](https://raw.githubusercontent.com/rokudev/hero-grid-channel/master/images/HeroGridDetails.jpg "HomeScreen-details")

## Use case
This sample channel should be used as a starter template for your channel development. It demonstrates how to display content in a fairly conventional Roku UI from multiple RSS feeds performant on all devices on the Roku platform.   

## How to run this sample
- Zip up the entire project directory and deploy to your roku device. Follow the developer set-up guide here for a quick guide on how to do so: https://blog.roku.com/developer/2016/02/04/developer-setup-guide/
- Alternatively, open up this project in Eclipse or Atom and use the corresponding plugin/package to export/deploy the channel.
  - Eclipse plugin documentation in the SDK docs: https://sdkdocs.roku.com/display/sdkdoc/Eclipse+Plugin+Guide 
  - The blog post for the Eclipse plugin: https://blog.roku.com/developer/2016/04/20/roku-eclipse-plugin/ 
  - Roku Deploy package for Atom: https://atom.io/packages/roku-deploy 
- If you don't want to zip up the project, this sample is also available as a private channel:
  - Version without screen animations: https://my.roku.com/account/add?channel=HP56R2
  - Current version: https://my.roku.com/account/add?channel=NDQJKJ

## Features
- Showcases a grid-based UI, varying the display of content by manipulating the built-in Scene Graph component
  - Includes a (1) hero sized row, (2) normal row, (3) movie poster row, and (4) a grid row of content.
- Showcases how to create multiple "screens" in a channel 
  - Includes the main grid screen, a details screen, and a screen that displays the video content.
- Demonstrates how to use both built-in and custom made Scene Graph components
- Demonstrates how to handle multiple URL requests to fill in different rows of content (e.g. Movies, specific genres, etc.)
- Demonstrates how to handle deep-linking of content
- Demonstrates how to display information to the user in a dialog box in case of failures to load content (e.g. bad URL request)

## Directory Structure
- **Components:** The Scene Graph components
  - **DetailsScreen:** All code related to the details screen
  - **Animations:** Currently only contains **fadingbackground.brs/xml**, which is used for the transitions between each grid tile element
  - **HeroScreen:** The main screen of the channel (i.e. the grid of content)
  - **Item:** The individual tile element that the grid is comprised of
  - **LoadingIndicator:** The spinning wheel displayed before content is available
  - **Content:** Contains all files related to handling content (URL request/response + parsing + content node creation for populating the UI). **UriHandler.brs/xml** handles URL requests/responses. **Parser.brs/xml** handles parsing of the response. **SGHelperFunctions.brs** includes functions that are/may be useful for SceneGraph development (currently only has 2 functions but will grow in size as more utilities become abstracted and conventionalized).  
  - **HeroScene.brs/xml:** The main scene. Acts as the controller in the MVC-like pattern of the channel.
- **Images:** Contains image assets used in the channel
- **Source:** Contains the main brightscript file that runs right when the channel starts

## Channel Flow
This section explains what happens when the channel/app does and what the user sees as a result.
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

## Issues / Feature Requests
- If you have an issue about this channel, please submit an issue on this repository or post on the Roku forums about this channel. 
- To create an issue: https://help.github.com/articles/creating-an-issue/ 
- The Roku forum: https://forums.roku.com/
- If you have features that you have implemented and want to contribute to this channel's development, submit a pull request! 
- To create a pull request: https://help.github.com/articles/creating-a-pull-request/
- What is a pull request? https://help.github.com/articles/about-pull-requests/ 

### Known issues
- The content may take a while to load (i.e. the loading wheel will be active for a long time) since the HTTP requests are asynchronous and the content is only loaded after all requests have their corresponding responses parsed for content. This is an issue with network latency and async requests. One way to mitigate this issue is to load content whenever you receive a response. However, the implementation is a bit tricky since the content may load in a different order than intended. Any suggestions/pull requests on this issue would be appreciated! 
