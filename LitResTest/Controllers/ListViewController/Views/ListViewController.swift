//
//  ListViewController.swift
//  LitResTest
//
//  Created by Tatty on 20.04.2022.
//
import UIKit

protocol ListView where Self: UIViewController {
    
    func displayImages()
    func showError(with message: String)
}

final class ListViewController: UIViewController {
    
    private enum Constants {        
        static let minimumLineSpacing: CGFloat = 5
        static let reuseIdentifier = "ListCell"
        static let errorText = "Error!"
        static let closeButton = "Close"
    }
        
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constants.minimumLineSpacing
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: Constants.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var viewModel: ListViewModel
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupUIElements()
        viewModel.viewDidLoad()
    }
    
    private func presentAlertController(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: Constants.closeButton, style: .default)
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }
}

extension ListViewController: ListView {
    
    func displayImages() {
        onMain { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func showError(with message: String) {
        onMain {  [weak self] in
            self?.presentAlertController(title: Constants.errorText, message: message)
        }
    }
}

extension ListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.itemsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeue(cell: ListCell.self, for: indexPath)
    }
}

extension ListViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            viewModel.prefetchImageForCell(at: indexPath)
        }
    }
}

extension ListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? Imageble else { return }
        cell.showPreloading()
        viewModel.getImageForCell(at: indexPath, for: cell)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.didEndDisplayingCell(at: indexPath)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height {
            viewModel.requestAdditionalData()
        }
    }
}

extension ListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        viewModel.sizeForItem(at: indexPath)
    }
}

extension ListViewController {
    
    private func setupUIElements() {
        view.backgroundColor = .white
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
