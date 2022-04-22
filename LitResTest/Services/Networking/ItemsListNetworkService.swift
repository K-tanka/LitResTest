//
//  ItemsListNetworkService.swift
//  LitResTest
//
//  Created by Tatty on 20.04.2022.
//
import Foundation

protocol ItemsListNetworkService {
    typealias ItemsResult = Swift.Result<[Item], Error>
    
    func getItemsList(request: URLRequest, completion: @escaping (ItemsResult) -> Void)
}

final class ItemsListNetworkServiceImpl: ItemsListNetworkService {

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func getItemsList(request: URLRequest, completion: @escaping (ItemsResult) -> Void) {
        session.dataTask(with: request) { data, response, error in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return try ItemsListMapper.map(data, from: response)
                } else {
                    throw NetworkError.unexpectedDataRepresenation
                }
            })
        }.resume()
    }
}
