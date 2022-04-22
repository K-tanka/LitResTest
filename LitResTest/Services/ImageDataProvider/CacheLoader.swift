//
//  CacheLoader.swift
//  LitResTest
//
//  Created by Tatty on 20.04.2022.
//
import UIKit

protocol CacheLoader {
    
    func getImageFromCache(url: URL) -> UIImage?
    func saveImageToCache(url: URL, image: UIImage)
}

final class CacheLoaderImpl: CacheLoader {
    
    private enum Constants {
        static let imageCachePathComponent = "ImageCache"
        static let errorDescription = "Problems occured"
    }
    
    private let storeURL: URL
    
    init() throws {
        do {
            guard let documentDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
                throw NSError(domain: Constants.errorDescription, code: 123, userInfo: nil)
            }
            storeURL = documentDirectory.appendingPathComponent(Constants.imageCachePathComponent, isDirectory: true)
            
            if storeURL.hasDirectoryPath {
                try FileManager.default.createDirectory(at: storeURL, withIntermediateDirectories: true, attributes: nil)
            }
        } catch {
            throw NSError(domain: Constants.errorDescription, code: 134, userInfo: nil)
        }
    }
    
    func saveImageToCache(url: URL, image: UIImage) {
        guard let fileName = getFileUrl(url: url) else { return }
        
        let data = image.pngData()
        try? data?.write(to: fileName)
    }
    
    func getImageFromCache(url: URL) -> UIImage? {
        guard
            let fileName = getFileUrl(url: url),
            let data = try? Data(contentsOf: fileName),
            let image = UIImage(data: data)
        else { return nil }
        
        return image
    }
    
    private func getFileUrl(url: URL) -> URL? {
        guard let lastPath = url.pathComponents.last else { return nil }
        
        return storeURL.appendingPathComponent(lastPath)
    }
}
