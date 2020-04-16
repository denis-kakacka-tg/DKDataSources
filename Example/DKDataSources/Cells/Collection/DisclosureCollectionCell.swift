import DKDataSources

final class DisclosureCollectionCellModel: DKCellModel<CollectionCellType> {
    
    enum ActionType {
        case action1, action2, action3, action4
    }
    
    override var type: CollectionCellType { .disclosure(self) }

    let title: String
    let action: ActionType
    
    init(title: String, action: ActionType) {
        self.title = title
        self.action = action
    }
}

final class DisclosureCollectionCell: UICollectionViewCell {
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DisclosureCollectionCell: DKCollectionConfigurableCell {
    
    func configure<T>(with model: T) where T : DKCellModelProtocol {
        guard let model = model as? DisclosureCollectionCellModel else { return }
        
        titleLabel.text = model.title
    }
}

// MARK: - Private
private extension DisclosureCollectionCell {
    
    func setupUI() {
        backgroundColor = .white
        titleLabel.textColor = Color.darkBlue
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}

