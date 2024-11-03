//
//  Item.swift
//  Flickr Search
//
//  Created by Ayush Shah on 11/3/24.
//

struct Item: Codable {
    let title: String
    let media: Media
    let author: String
}

struct Media: Codable {
    let m: String
}
