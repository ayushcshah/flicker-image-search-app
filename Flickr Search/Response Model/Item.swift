//
//  Item.swift
//  Flickr Search
//
//  Created by Ayush Shah on 11/3/24.
//

struct Item: Codable {
    let author: String
    let description: String
    let media: Media
    let published: String
    let title: String
}

struct Media: Codable {
    let m: String
}
