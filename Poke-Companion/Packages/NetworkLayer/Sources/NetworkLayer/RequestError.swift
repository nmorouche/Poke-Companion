//
//  RequestError.swift
//  NetworkLayer
//
//  Created by Nassim Morouche on 17/07/2023.
//

/// The enum representing all error related to the request
public enum RequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown
}
