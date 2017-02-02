# Find a Pet

![Language](https://img.shields.io/badge/language-Swift%203-orange.svg)

## Notice
The current version is working with Xcode Version 8.

## Description

This project is a Capstone project for the Udacity iOS Developer Nanodegree. It demonstrates the following:

* Multiple views of content
* Multiple type of controls
* Iteracting with an API
* Networking code encapsulated into networking classes
* Activity indicators when waiting for data
* User alert for network connectivity
* Uses core data to persist data with multiple entities
* Using GCD with core data and URL data requests
* Location services and reverse geocoding
* FetchedResultsController and UITableView
* UIScrollView for zooming images

## Notes

* **API does not use https**
* Search results limited to 50 per search due to personal API license limits
* Search results have no distance limit. They will expand from your current location until record count requested is full
* Incorporates the **SwiftyJSON** library to parse JSON

## Installation

You must add your own API Key in PetFinderConstants.swift @ line 44. 
![]({{site.baseurl}}/search.png)

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D
