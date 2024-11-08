//
//  ItemView.swift
//  Flickr Search
//
//  Created by Ayush Shah on 11/3/24.
//

import SwiftUI

struct ItemView: View {
    @State var selectedItem: ViewItem?
    @State private var showingSheet = false
    var item: ViewItem
    let itemWidth: CGFloat
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.blue)
                .frame(height: itemWidth) // Make item height the same as item width for square items
                .overlay(
                    VStack{
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
                        }
                        .scaledToFit()
                        Text("\(item.title)")
                            .foregroundColor(.white)
                            .font(.caption)
                    }
                )
                .cornerRadius(10)
        }
        .accessibilityLabel("This is \(item.title), Tap on this to see more details")
        .onTapGesture(perform: { _ in
            selectedItem = item
            showingSheet.toggle()
        })
        .sheet(isPresented: $showingSheet) {
            ItemDetailView(item: $selectedItem)
        }
    }
}
