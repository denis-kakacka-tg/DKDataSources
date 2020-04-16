import DKDataSources

final class TextFieldCellModel: DKCellModel<CellType> {
    override var type: CellType { .textField }
    
    let title: String
    let placeholder: String
    
    init(title: String, placeholder: String) {
        self.title = title
        self.placeholder = placeholder
    }
}


protocol TextFieldCellDelegate: class {
    func textFieldDidEndEditing(textField: UITextField, cell: TextFieldCell)
}

final class TextFieldCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let textField = UITextField()
    
    weak var delegate: TextFieldCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        textField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTitle(_ text: String?) {
        titleLabel.text = text
    }
}

extension TextFieldCell: DKTableConfigurableCell  {
    
    func configure<T>(with model: T) where T : DKCellModelProtocol {
        guard let model = model as? TextFieldCellModel else { return assertionFailure() }
        
        textField.placeholder = model.placeholder
        titleLabel.text = model.title
    }
}

extension TextFieldCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing(textField: textField, cell: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Private
private extension TextFieldCell {
    
    func setupUI() {
        selectionStyle = .none
        titleLabel.textColor = Color.darkBlue
        
        [titleLabel, textField].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = Color.darkBlue.cgColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftViewMode = .always
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            textField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
}
