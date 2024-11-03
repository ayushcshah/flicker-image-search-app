//
//  NetworkConfiguration.swift
//  Flickr Search
//
//  Created by Ayush Shah on 11/3/24.
//

protocol NetworkConfigurationProviding {
    var baseURL: String { get }
    var searchPath: String { get }
    var searchParameters: [String: String] { get }
}

// MARK: Flicker Config

class FlickerNetworkConfigurationProvider: NetworkConfigurationProviding {
    var baseURL: String = "https://api.flickr.com/"
    var searchParameters: [String: String] = [
        "format":"json",
        "nojsoncallback":"1"
    ]
    var searchPath: String = "services/feeds/photos_public.gne"
}
