//
//  SearchResponse.swift
//  Flickr Search
//
//  Created by Ayush Shah on 11/3/24.
//

struct SearchResponse: Codable {
    let title: String
    let items: [Item]
}
