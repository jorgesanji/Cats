# Cats
This app uses Imgur API for retrieving the top images of cats.

Please install cocoa pods before launching the project:

$ pod install

This app uses VIPER architecture. 
Swinject for dependency injection.
Moya for interaction with the API.

Has 4 main folders which are:

- Business: It contains all use cases for this app.
- DataAccess: It contains all kinds of repositories local, rest, and mock.
- DI: It contains the main class for introducing dependency injection on the app.
- UI: It contains the view controllers, custom views, and helpers for building the UI side.
