//
//  Flickr_SearchApp.swift
//  Flickr Search
//
//  Created by Ayush Shah on 11/3/24.
//

import SwiftUI

@main
struct Flickr_SearchApp: App {
    var body: some Scene {
        WindowGroup {
            SearchView(searchCoordinator: SearchCoordinator(networkConfiguration: FlickerNetworkConfigurationProvider()))
        }
    }
}
