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
    let description: String
    let imageURL: String
    let title: String
    let published: String
    
    static let formatter = DateFormatter()
    static let todaysDate = Date()

}

extension ViewItem {
    init (_ item: Item) {
        self.author = item.author
        self.description = item.description
        self.imageURL = item.media.m
        self.published = item.published
        self.title = item.title
    }
}

extension ViewItem {
    var daysSincePosted: String? {
        let formatter = ViewItem.formatter
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        guard let postDate = formatter.date(from: published) else {
            return nil
        }

        let calendar = Calendar.current

        if let days = calendar.dateComponents([.day], from: postDate, to: ViewItem.todaysDate).day {
            return "\(days) days ago"
        } else {
            return nil
        }
    }
}
