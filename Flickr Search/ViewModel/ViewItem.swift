//
//  ViewItem.swift
//  Flickr Search
//
//  Created by Ayush Shah on 11/3/24.
//

import Foundation

struct ViewItem: Identifiable {
    let id = UUID()
    let author: String
    let imageURL: String
    let title: String
}

extension ViewItem {
    init (_ item: Item) {
        self.author = item.author
        self.imageURL = item.media.m
        self.title = item.title
    }
}
