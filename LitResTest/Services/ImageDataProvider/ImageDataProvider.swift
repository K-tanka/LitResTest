//
//  ImageDataProvider.swift
//  LitResTest
//
//  Created by Tatty on 20.04.2022.
//
import UIKit

protocol ImageDataProvider {
    
    func prefetchImage(_ url: URL)
    func getImage(_ url: URL, for object: Imageble)
    func cancelTask(_ url: URL)
}

final class ImageDataProviderImpl: ImageDataProvider {
    
    private var images = [URL: UIImage]()
    private let cacheLoader: CacheLoader?
    private let networkLoader: ImageNetworkLoader
    
    init(networkLoader: ImageNetworkLoader, cacheLoader: CacheLoader?) {
        self.networkLoader = networkLoader
        self.cacheLoader = cacheLoader
    }
    
    func prefetchImage(_ url: URL) {
        guard
            images[url] == nil,
            cacheLoader?.getImageFromCache(url: url) == nil
        else {
            return
        }
        
        networkLoader.loadImage(url) { [weak self] result in
            if let data = try? result.get(), let image = UIImage(data: data) {
                self?.cacheLoader?.saveImageToCache(url: url, image: image)
                self?.images[url] = image
            }
        }
    }
    
    func getImage(_ url: URL, for object: Imageble) {
        if let image = images[url] {
            object.setImage(image)
        } else if let image = cacheLoader?.getImageFromCache(url: url) {
            object.setImage(image)
        } else {
            networkLoader.loadImage(url) { [weak self] result in
                switch result {
                case .success(let data):
                    guard let image = UIImage(data: data) else {
                        assertionFailure()
                        return
                    }
                    self?.cacheLoader?.saveImageToCache(url: url, image: image)
                    self?.images[url] = image
                    object.setImage(image)
                case .failure(_):
                    //здесь можно сделать обработку ошибок: запись в логи,в различном виде отображение ошибки и т.п.
                    assertionFailure()
                }
            }
        }
    }
    
    func cancelTask(_ url: URL) {
        networkLoader.cancelTask(for: url)
    }
}
