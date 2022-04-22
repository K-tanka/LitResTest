//
//  HTTPURLResponse+StatusCode.swift
//  LitResTest
//
//  Created by Tatty on 20.04.2022.
//
import Foundation

extension HTTPURLResponse {
    
    private static var OK_200: Int { 200 }
    
    var isOK: Bool {
        statusCode == HTTPURLResponse.OK_200
    }
}
