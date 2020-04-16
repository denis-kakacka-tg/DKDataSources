import DKDataSources

final class BannerCollectionCellModel: DKCellModel<CollectionCellType> {
    override var type: CollectionCellType { .banner }

    var imageName: String
    
    init(imageName: String) {
        self.imageName = imageName
    }
}


final class BannerCollectionCell: UICollectionViewCell {
    private let bannerImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BannerCollectionCell: DKCollectionConfigurableCell {
    
    func configure<T>(with model: T) where T : DKCellModelProtocol {
        guard let model = model as? BannerCollectionCellModel else { return }
        
        bannerImageView.image = UIImage(named: model.imageName)
    }
}

// MARK: - Private
private extension BannerCollectionCell {
    
    func setupUI() {
        backgroundColor = .white
        bannerImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bannerImageView)
        
        bannerImageView.contentMode = .scaleAspectFill
        bannerImageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            bannerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            bannerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            bannerImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bannerImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
