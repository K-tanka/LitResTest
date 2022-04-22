//
//  ItemsListMapper.swift
//  LitResTest
//
//  Created by Tatty on 20.04.2022.
//
import Foundation

final class ItemsListMapper {
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Item] {

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        guard
            response.isOK,
            let items = try? decoder.decode([Item].self, from: data)
        else {
            throw NetworkError.invalidData
        }
        return items
    }
}
