//
//  ListViewModel.swift
//  LitResTest
//
//  Created by Tatty on 20.04.2022.
//
import UIKit

protocol ListViewModel {

    var itemsCount: Int { get }
    
    func viewDidLoad()
    func prefetchImageForCell(at indexPath: IndexPath)
    func getImageForCell(at indexPath: IndexPath, for object: Imageble)
    func didEndDisplayingCell(at indexPath: IndexPath)
    func sizeForItem(at indexPath: IndexPath) -> CGSize
    func requestAdditionalData()
}

final class ListViewModelImpl: ListViewModel {
    
    typealias ItemsListResult = ((Result<Void, Error>) -> Void)?

    private let networkService: ItemsListNetworkService
    private let imageDataProvider: ImageDataProvider
    private var cellModels = [ListCellModel]()
    weak var view: ListView?
    
    var itemsCount: Int {
        cellModels.count
    }
        
    init(networkService: ItemsListNetworkService, imageDataProvider: ImageDataProvider) {
        self.networkService = networkService
        self.imageDataProvider = imageDataProvider
    }
    
    func viewDidLoad() {
        requestItemsList { [weak self] result in
            switch result {
            case .success:
                self?.view?.displayImages()
            case .failure(let error):
                self?.view?.showError(with: error.localizedDescription)
            }
        }
    }
    
    func getImageForCell(at indexPath: IndexPath, for object: Imageble) {
        let imageUrl = cellModels[indexPath.row].imageURL
        imageDataProvider.getImage(imageUrl, for: object)
    }
    
    func prefetchImageForCell(at indexPath: IndexPath) {
        let imageUrl = cellModels[indexPath.row].imageURL
        imageDataProvider.prefetchImage(imageUrl)
    }
    
    func didEndDisplayingCell(at indexPath: IndexPath) {
        let imageUrl = cellModels[indexPath.row].imageURL
        imageDataProvider.cancelTask(imageUrl)
    }
    
    func sizeForItem(at indexPath: IndexPath) -> CGSize {
        return cellModels[indexPath.row].cellSize
    }
    
    func requestAdditionalData() {
        // Предполагается выполнение дополнительного запроса, но так как апи не поддерживает пагинацию
        let additionalModels = cellModels
        cellModels.append(contentsOf: additionalModels)
        view?.displayImages()
    }
        
    private func requestItemsList(_ completion: ItemsListResult) {
        guard let request = URLRequestFactory.getListURLFactory() else {
            assertionFailure()
            return
        }
        networkService.getItemsList(request: request) { [weak self] result in
            switch result {
            case .success(let images):
                self?.cellModels = images.compactMap { ListCellModel(item: $0) }
                completion?(.success(()))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}
