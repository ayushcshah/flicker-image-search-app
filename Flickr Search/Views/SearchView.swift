//
//  SearchView.swift
//  Flickr Search
//
//  Created by Ayush Shah on 11/3/24.
//

import SwiftUI

struct SearchView: View {
    @StateObject var searchCoordinator: SearchCoordinator
    @State private var searchText: String = ""
    @State private var selectedItem: ViewItem?
    @State private var showingSheet = false
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                let screenWidth = geometry.size.width
                let itemWidth: CGFloat = 150
                let spacing: CGFloat = 10
                
                let numberOfColumns = max(Int(screenWidth / (itemWidth + spacing)), 1)
                let columns = Array(repeating: GridItem(.flexible(), spacing: spacing), count: numberOfColumns)
                
                VStack{
                    TextField(String(localized: "search"), text: $searchText)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .onChange(of: searchText) { _, newValue in
                            searchCoordinator.search(tags: newValue.components(separatedBy: .whitespaces))
                        }
                    if searchCoordinator.isLoading {
                        ProgressView(String(localized: "loading"))
                    }
                    
                    if let error = searchCoordinator.error {
                        VStack {
                            Text("Error: \(error)")
                                .font(.headline)
                                .foregroundColor(.red)
                            Button("Retry") { searchCoordinator.search(tags: searchText.components(separatedBy: .whitespaces)) }
                        }
                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: spacing) {
                                ForEach(searchCoordinator.items, id: \.id) { item in
                                    ItemView(item: item, itemWidth: itemWidth)
                                }
                            }
                            .padding(.horizontal, spacing)
                        }
                    }
                }
            }
            .navigationTitle("Awesome Search App")
        }
    }
}

#Preview {
    SearchView(searchCoordinator: SearchCoordinator(networkConfiguration: FlickerNetworkConfigurationProvider()))
}
