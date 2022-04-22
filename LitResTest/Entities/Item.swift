//
//  Item.swift
//  LitResTest
//
//  Created by Tatty on 20.04.2022.
//
import UIKit

struct Item: Decodable {
    
    let image: Image?
}

struct Image: Decodable {
    
    let url: URL?
    let width: CGFloat?
    let height: CGFloat?
}
