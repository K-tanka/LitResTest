//
//  ControllersFactory.swift
//  LitResTest
//
//  Created by Tatty on 22.04.2022.
//
import Foundation

enum ControllersFactory {
    
    static func initListViewController() -> ListViewController {
        
        let networkService = ItemsListNetworkServiceImpl()
        let networkLoader = ImageNetworkLoaderImpl()
        let cacheLoader = try? CacheLoaderImpl()
        let imageDataProvider = ImageDataProviderImpl(networkLoader: networkLoader, cacheLoader: cacheLoader)
        let viewModel = ListViewModelImpl(networkService: networkService, imageDataProvider: imageDataProvider)
        let controller = ListViewController(viewModel: viewModel)
        viewModel.view = controller
        return controller
    }
}
