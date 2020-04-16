import DKDataSources

final class BannerCellModel: DKCellModel<CellType> {
    override var type: CellType { .banner }

    var imageName: String
    
    init(imageName: String) {
        self.imageName = imageName
    }
}


final class BannerCell: UITableViewCell {
    private let bannerImageView = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BannerCell: DKTableConfigurableCell {
    
    func configure<T>(with model: T) where T : DKCellModelProtocol {
        guard let model = model as? BannerCellModel else { return }
        
        bannerImageView.image = UIImage(named: model.imageName)
    }
}

// MARK: - Private
private extension BannerCell {
    
    func setupUI() {
        selectionStyle = .none
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
