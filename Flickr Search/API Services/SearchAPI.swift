//
//  SearchAPI.swift
//  Flickr Search
//
//  Created by Ayush Shah on 11/3/24.
//

import Foundation

enum SearchError: Error {
    case invalidURL
    case invalidResponse
    case httpErrorCode(Int)
    case serverError(Error)
}

protocol SearchAPIProviding {
    func search(tags: [String], handler: @escaping (Result<SearchResponse, SearchError>) -> Void)
}

class SearchAPIProvider: SearchAPIProviding {
    let networkConfiguration: NetworkConfigurationProviding
    
    private var dataTask: URLSessionDataTask?
    
    init(networkConfiguration: NetworkConfigurationProviding) {
        self.networkConfiguration = networkConfiguration
    }
    
    func search(tags: [String], handler: @escaping (Result<SearchResponse, SearchError>) -> Void) {
        dataTask?.cancel()

        var urlComponents = URLComponents(
            string: networkConfiguration.baseURL + networkConfiguration.searchPath
        )

        urlComponents?.queryItems = networkConfiguration.searchParameters.map({
            .init(name: $0.key,
                  value: $0.value)
        })
        urlComponents?.queryItems?.append(.init(name: "tags", value: tags.joined(separator: ",")))

        guard let url = urlComponents?.url else {
            handler(.failure(.invalidURL))
            return
        }
        
        dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                handler(.failure(.serverError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                    let data else {
                handler(.failure(.invalidResponse))
                return
            }
            
            if httpResponse.statusCode >= 400 {
                handler(.failure(.httpErrorCode(httpResponse.statusCode)))
                return
            }
            
            if let response = try? JSONDecoder().decode(SearchResponse.self, from: data) {
                handler(.success(response))
            }
        }
        
        dataTask?.resume()
    }
}
