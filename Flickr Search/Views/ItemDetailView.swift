//
//  ItemDetailView.swift
//  Flickr Search
//
//  Created by Ayush Shah on 11/3/24.
//

import SwiftUI

struct ItemDetailView: View {
    @Binding var item: ViewItem?
    var body: some View {
        if let item {
            AsyncImage(url: URL(string: item.imageURL)) { phase in
                switch phase {
                case .failure:
                    Image(systemName: "photo")
                        .font(.largeTitle)
                case .success(let image):
                    image
                        .resizable()
                default:
                    ProgressView()
                }
            }.overlay(alignment: .topLeading, content: {
                Text(item.title)
                    .fontWeight(.heavy)
            })
            .scaledToFit()
            
            Text(item.description).border(.black, width: 1)
            Spacer()
            HStack{
                Text("Posted by ").bold()
                Text(item.author).foregroundColor(.blue)
                if let daysSincePosted = item.daysSincePosted {
                    Text(daysSincePosted).border(.black, width: 1)
                }
            }
        } else {
            Text("Loading...")
        }
    }
}
