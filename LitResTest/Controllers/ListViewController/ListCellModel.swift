//
//  ListCellModel.swift
//  LitResTest
//
//  Created by Tatty on 22.04.2022.
//
import UIKit

struct ListCellModel {
        
    let imageURL: URL
    let cellSize: CGSize
    
    init?(item: Item) {
        guard let imageURL = item.image?.url, let width = item.image?.width, let height = item.image?.height else {
            return nil
        }
        self.imageURL = imageURL
        cellSize = ListCellModel.cellSize(width, height)
    }
    
    private static func cellSize(_ width: CGFloat, _ height: CGFloat) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let scale = screenWidth / width
        return CGSize(width: screenWidth, height: height * scale)
    }
}
