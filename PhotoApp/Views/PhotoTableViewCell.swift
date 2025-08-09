//
//  PhotoTableViewCell.swift
//  PhotoApp
//
//  Created by Maksim Li on 03/08/2025.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    
    private let thumbnailImageView = UIImageView()
    private let titleLabel = UILabel()
    private var currentImageUrl: String?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.cornerRadius = 8
        thumbnailImageView.backgroundColor = .systemGray4
        
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textColor = .label
        titleLabel.lineBreakMode = .byWordWrapping
        
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 60),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: thumbnailImageView.heightAnchor, constant: 24)
        ])
        
        titleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    func configure(with photo: Photo) {
        titleLabel.text = photo.title
        
        thumbnailImageView.image = nil
        thumbnailImageView.backgroundColor = .systemGray4
        
        let imageUrl = photo.workingThumbnailUrl
        print("🔗 Configuring cell with config URL: \(imageUrl)")
        
        currentImageUrl = imageUrl
        
        ImageLoader.shared.loadImage(from: imageUrl) { [weak self] image in
            guard let strongSelf = self else { return }
            guard strongSelf.currentImageUrl == imageUrl else {
                print ("Image loaded for wrong URL. Ignoring.")
                return
            }
            
            DispatchQueue.main.async {
                if let loadedImage = image {
                    strongSelf.thumbnailImageView.image = loadedImage
                    strongSelf.thumbnailImageView.backgroundColor = .clear
                    print ("Image successfully loaded for URL: \(imageUrl)")
                } else {
                    strongSelf.thumbnailImageView.image = nil
                    strongSelf.thumbnailImageView.backgroundColor = .systemGray4
                    print ("Failed to load image for URL: \(imageUrl)")
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if let currentURL = currentImageUrl {
            ImageLoader.shared.cancelLoad(for: currentURL)
        }
        
        thumbnailImageView.image = nil
        thumbnailImageView.backgroundColor = .systemGray4
        currentImageUrl = nil
    }
}
