//
//  SearchCoordinatorTest.swift
//  Flickr SearchTests
//
//  Created by Ayush Shah on 11/3/24.
//

import Testing
@testable import Flickr_Search

struct SearchCoordinatorTest {
    var searchCoordinator: SearchCoordinator!
    var mockSearchAPIProvider: MockSearchAPIProvider!
    
    @MainActor
    init() {
        mockSearchAPIProvider = .init()
        searchCoordinator = .init(networkConfiguration: MockNetworkConfigurationProvider(), searchAPIProvider: mockSearchAPIProvider)
    }

    @Test mutating func searchCoordinatorFailure() async throws {
        mockSearchAPIProvider.result = .failure(.invalidURL)
        
        await searchCoordinator.search(tags: ["abc"])
        
        #expect(mockSearchAPIProvider.result == .failure(.invalidURL))
    }
    
    @Test mutating func searchCoordinatorSuccess() async throws {
        let result: Result<SearchResponse, SearchError> = .success(
            .init(title: "abc",
                  items: [.init(author: "author 1",
                                description: "description 1",
                                media: .init(m: "m"),
                                published: "",
                                title: "123")]
                 )
        )
        mockSearchAPIProvider.result = result
        
        await searchCoordinator.search(tags: ["abc"])
        
        #expect(mockSearchAPIProvider.result == result)
    }

}

struct TestDaysAgo {
    @Test("Days since Post valid Date")
    func daysSincePostedValidDate() async throws {
        let viewItem = ViewItem(author: "author 1",
                                description: "description 1",
                                imageURL: "m",
                                title: "",
                                published: "2024-11-03T04:37:23Z")
        #expect(viewItem.daysSincePosted != nil)
    }
    
    @Test("Days since Post Invalid Date")
    func daysSincePostedInvalidDate() async throws {
        let viewItem = ViewItem(author: "author 1",
                                description: "description 1",
                                imageURL: "m",
                                title: "",
                                published: "abc")
        #expect(viewItem.daysSincePosted == nil)
    }
}

struct MockNetworkConfigurationProvider: NetworkConfigurationProviding {
    var baseURL: String = ""
    var searchPath: String = ""
    var searchParameters: [String : String] = [:]
}

struct MockSearchAPIProvider: SearchAPIProviding {
    var result: Result<SearchResponse, SearchError> = .failure(.invalidURL)
    
    func search(tags: [String], handler: @escaping (Result<SearchResponse, SearchError>) -> Void) {
        handler(result)
    }
}

extension SearchError: Equatable {
    public static func == (lhs: Flickr_Search.SearchError, rhs: Flickr_Search.SearchError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL): return true
        case(.invalidResponse, .invalidResponse): return true
        case(.httpErrorCode( let lCode), .httpErrorCode(let rCode)): return lCode == rCode
        case(.serverError, .serverError): return true
        default: return false
        }
    }
}

extension SearchResponse: Equatable {
    public static func == (lhs: Flickr_Search.SearchResponse, rhs: Flickr_Search.SearchResponse) -> Bool {
        return lhs.title == rhs.title && lhs.items.count == rhs.items.count
    }
}
