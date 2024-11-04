//
//  SearchCoordinator.swift
//  Flickr Search
//
//  Created by Ayush Shah on 11/3/24.
//

import Foundation
import Combine

enum SearchViewModel {
    case loading
    case loaded(items: [ViewItem])
    case failed(error: String)
}

@MainActor
protocol SearchCoordinating {
    var viewModel: SearchViewModel { get }
    var isLoading: Bool { get }
    var items: [ViewItem] { get }
    var error: String? { get }
    
    func search(tags: [String])
}

class SearchCoordinator: ObservableObject, SearchCoordinating {
    let networkConfiguration: NetworkConfigurationProviding
    let searchAPIProvider: SearchAPIProviding
    
    @Published var viewModel: SearchViewModel = .loading
    @Published var isLoading: Bool = true
    @Published var items: [ViewItem] = []
    @Published var error: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(networkConfiguration: NetworkConfigurationProviding,
         searchAPIProvider: SearchAPIProviding? = nil) {
        self.networkConfiguration = networkConfiguration
        if let searchAPIProvider {
            self.searchAPIProvider = searchAPIProvider
        } else {
            self.searchAPIProvider = SearchAPIProvider(networkConfiguration: networkConfiguration)
        }
        $viewModel.sink { [weak self] viewModel in
            switch viewModel {
            case .loading:
                self?.isLoading = true
            case .loaded(let items):
                self?.isLoading = false
                self?.items = items
                self?.error = nil
            case .failed(let error):
                self?.isLoading = false
                self?.error = error
                self?.items = []
            }
        }.store(in: &cancellables)
    }
    
    func search(tags: [String]) {
        isLoading = true
        searchAPIProvider.search(tags: tags) { result in
            Task {
                switch result {
                case .success(let response):
                    self.viewModel = .loaded(items: response.items.map({ViewItem($0)}))
                case .failure(let error):
                    self.viewModel = .failed(error: error.localizedDescription)
                }
            }
        }
    }
}

