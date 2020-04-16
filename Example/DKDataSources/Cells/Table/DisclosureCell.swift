import DKDataSources

final class DisclosureCellModel: DKCellModel<CellType> {
    
    enum ActionType {
        case action1, action2, action3, action4
    }
    
    override var type: CellType { .disclosure(self) }

    let title: String
    let action: ActionType
    
    init(title: String, action: ActionType) {
        self.title = title
        self.action = action
    }
}




final class DisclosureCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textLabel?.textColor = Color.darkBlue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DisclosureCell: DKTableConfigurableCell {
    
    func configure<T>(with model: T) where T : DKCellModelProtocol {
        guard let model = model as? DisclosureCellModel else { return }
        
        textLabel?.text = model.title
    }
}
