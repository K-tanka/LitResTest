//
//  UICollectionView+Extensions.swift
//  LitResTest
//
//  Created by Tatty on 20.04.2022.
//
import UIKit

extension UICollectionView {
    
    func dequeue <T: UICollectionViewCell>(cell identifier: T.Type, for indexPath: IndexPath) -> T {
        let identifierString = String(describing: identifier)
        return dequeueReusableCell(withReuseIdentifier: identifierString, for: indexPath) as! T
    }
}
