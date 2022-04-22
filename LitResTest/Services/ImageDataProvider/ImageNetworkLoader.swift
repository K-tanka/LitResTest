//
//  ImageNetworkLoader.swift
//  LitResTest
//
//  Created by Tatty on 20.04.2022.
//
import Foundation

typealias LoadImageResult = Result<Data, Error>

protocol ImageNetworkLoader {
    
    func loadImage(_ url: URL, completion: @escaping (LoadImageResult) -> Void)
    func cancelTask(for url: URL)
}

final class ImageNetworkLoaderImpl: ImageNetworkLoader {
    
    private let session: URLSession
    private var tasks = [URL: URLSessionDataTask]()
    
    init(session: URLSession = URLSession(configuration: .ephemeral)) {
        self.session = session
    }
    
    func loadImage(_ url: URL, completion: @escaping (LoadImageResult) -> Void) {
        cancelTask(for: url)
        
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, response.isOK else {
                return
            }
            completion(.success(data))
        }
        
        if tasks[url] == nil {
            tasks[url] = task
            task.resume()
        }
    }
    
    func cancelTask(for url: URL) {
        if let task = tasks[url] {
            task.cancel()
            tasks[url] = nil
        }
    }
}
