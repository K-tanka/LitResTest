//
//  ListCell.swift
//  LitResTest
//
//  Created by Tatty on 20.04.2022.
//
import UIKit

protocol Imageble where Self: UIView {
    
    func setImage(_ image: UIImage?)
}

final class ListCell: UICollectionViewCell {
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIElements()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}

extension ListCell: Imageble {
    
    func setImage(_ image: UIImage?) {
        onMain { [weak self] in
            self?.imageView.setImageAnimated(image)
            self?.hidePreloading()
        }
    }
}

extension ListCell {
    
    private func setupUIElements() {
        configureImageView()
    }
    
    private func configureImageView() {
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
