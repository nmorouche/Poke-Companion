//
//  NetworkProvider.swift
//  NetworkLayer
//
//  Created by Nassim Morouche on 17/07/2023.
//

import Foundation

/// Request provider class.
/// Every requests should be made only through this class.
public class NetworkProvider<T: NetworkService> {
    /// Must be specified but left empty
    public init() { }
    
    /// The function used to make the webservice call
    /// - Parameter service: The NetworkService instance
    /// - Returns: Returns an AnyPublisher object
    public func load(service: T) async -> Result<Data, RequestError> {
        await call(service.urlRequest)
    }
}

extension NetworkProvider {
    /// Calls the webservice and returns its appropriate Data.
    /// - Parameter urlRequest: The URL Request related to the service.
    /// - Returns: The error related to the service.
    private func call(_ urlRequest: URLRequest) async -> Result<Data, RequestError> {
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            switch response.statusCode {
            case 200...299:
                return .success(data)
            case 401:
                return .failure(.unauthorized)
            default:
                return .failure(.unexpectedStatusCode)
            }
        } catch {
            return .failure(.unknown)
        }
    }
}
