//
//  UIView+Preloading.swift
//  LitResTest
//
//  Created by Tatty on 20.04.2022.
//
import UIKit

extension UIView {
    
    func showPreloading() {
        let preloaderView = UIActivityIndicatorView()
        preloaderView.style = .large
        preloaderView.color = .red
        preloaderView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(preloaderView)
        bringSubviewToFront(preloaderView)
        NSLayoutConstraint.activate([
            preloaderView.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloaderView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        preloaderView.startAnimating()
    }
    
    func hidePreloading() {
        for subView in subviews {
            if let preloaderView = subView as? UIActivityIndicatorView {
                preloaderView.stopAnimating()
                preloaderView.removeFromSuperview()
            }
        }
    }
}

func onMain(_ function: @escaping () -> Void) {
    if Thread.isMainThread {
        function()
    } else {
        DispatchQueue.main.async {
            function()
        }
    }
}
