//
//  NetworkHelpers.swift
//  LitResTest
//
//  Created by Tatty on 20.04.2022.
//
import Foundation

enum URLRequestFactory {
    
    private static let baseURL = URL(string: "https://api.thecatapi.com")!
    
    private static let keyHeader = "x-api-key"
    private static let apiKey = "a22d953e-ae35-40b0-aeed-4610d0484b04"
    
    static func getListURLFactory() -> URLRequest? {
        var request = URLRequest(url: baseURL)
        request.url?.appendPathComponent("/v1/breeds")
        request.setValue(apiKey, forHTTPHeaderField: keyHeader)
        
        return request
    }
}

enum NetworkError: Error {
    
    case unexpectedDataRepresenation
    case invalidData
}
