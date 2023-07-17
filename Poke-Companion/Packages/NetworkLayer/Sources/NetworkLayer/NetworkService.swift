//
//  NetworkService.swift
//  NetworkLayer
//
//  Created by Nassim Morouche on 17/07/2023.
//

import Foundation

/// A protocol representing a minimal interface for a KTNetworkProvider
public protocol NetworkService {
    /// The base URL
    var baseURL: String { get }

    /// The string who represents the path of the URL
    var path: String { get }

    /// The parameters of the request.
    /// For example for a get request, it will be the URL queries
    var parameters: [String: String]? { get }
    
    /// The body of the request
    var body: Data? { get }

    /// The HTTPMethod of the request
    var method: NetworkMethod { get }
}

extension NetworkService {
    public var urlRequest: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        if let body {
            request.httpBody = body
        }

        return request
    }

    /// The URL representing the complete URL with its path
    private var url: URL {
        guard let url = URL(string: baseURL),
              var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            fatalError("URL could not be built")
        }

        if !path.isEmpty {
            urlComponents.path += getPath()
        }

        if let parameters {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }

        return urlComponents.url ?? url
    }
    
    /// Returns the cleaned path by removing all  extras `/`.
    /// - Returns: String that represents the cleaned path.
    private func getPath() -> String {
        var path = path
        if baseURL.last == "/" && path.first == "/" {
            path.removeFirst()
        } else if baseURL.last != "/" && path.first != "/" {
            path.insert("/", at: path.startIndex)
        }
        
        if path.last == "/" {
            path.removeLast()
        }

        return path
    }
}
