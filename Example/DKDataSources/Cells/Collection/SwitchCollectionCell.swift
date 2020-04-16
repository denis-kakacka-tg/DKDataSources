import DKDataSources

final class SwitchCollectionCellModel: DKCellModel<CollectionCellType> {
    override var type: CollectionCellType { .switch(self) }
    
    let title: String
    var isOn: Bool
    
    init(title: String, isOn: Bool) {
        self.title = title
        self.isOn = isOn
    }
}


protocol SwitchCollectionCellDelegate: class {
    func switchDidChange(isOn: Bool, cell: SwitchCollectionCell)
}

final class SwitchCollectionCell: UICollectionViewCell {
    
    private let titleLabel = UILabel()
    private let switchView = UISwitch()
    
    weak var delegate: SwitchCollectionCellDelegate?
            
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        switchView.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func switchValueChanged() {
        delegate?.switchDidChange(isOn: switchView.isOn, cell: self)
    }
}

extension SwitchCollectionCell: DKCollectionConfigurableCell {
    
    func configure<T>(with model: T) where T : DKCellModelProtocol {
        guard let model = model as? SwitchCollectionCellModel else { return assertionFailure() }
        
        titleLabel.text = model.isOn ? model.title + " is ON and cell is expanded, expanded, expanded, expanded, expanded, expanded" : model.title
        switchView.isOn = model.isOn
    }
}

//MARK: - Private
private extension SwitchCollectionCell {
    
    func setupUI() {
        backgroundColor = .white
        titleLabel.textColor = Color.darkBlue
        titleLabel.numberOfLines = 0
        
        switchView.onTintColor = Color.darkBlue
        switchView.thumbTintColor = Color.yellow
        
        [titleLabel, switchView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: switchView.leadingAnchor, constant: -22),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20),
            
            switchView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            switchView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            switchView.widthAnchor.constraint(equalToConstant: 52)
        ])
    }
}
