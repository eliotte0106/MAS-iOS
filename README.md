# MAS iOS

## Description
* This app allows users to take photos of their current cars' status within some situations of robbery, accidents, and other things
* Then, users will submit their request including info(name, email, phone number) to the admin page
* From this info, the admin will be able see your request with info on the web

## Instructions
* Clone this repo or download a zip of this repo
* Open this app using preferred IDE (recommend XCode)
* The current build target is upper iOS 16.6 version
* If you need to run this app in your physical device, go to project setting and change Deployment settings in Build Settings
* If there is nothing to change, go to mas_iosApp.swift file, and build this app to run
* Make sure all the connected devices should be using same ip address to interact with the web app (go to 'safeCarService' under a folder named 'service' and change BASE_URL to your current ip address)

## Tech Stack
* Front: Swift
* Back: Firebase, MongoDB, NextAuth (Used in Web)
* Web Repo: https://github.com/eliotte0106/MAS

## Demo
* https://www.youtube.com/watch?v=d9Uew2PoKQ0

## References
* https://developer.apple.com/develop/
* https://docs.swift.org/swift-book/documentation/the-swift-programming-language/guidedtour/
* https://developer.apple.com/documentation/avfoundation/capture_setup/requesting_authorization_to_capture_and_save_media
* https://developer.apple.com/documentation/corelocation/requesting_authorization_to_use_location_services
* https://www.hackingwithswift.com/books/ios-swiftui/sending-and-receiving-orders-over-the-internet
* https://www.youtube.com/watch?v=QJHmhLGv-_0&t=418s
* https://www.youtube.com/watch?v=ZmPJBiwgZoQ
