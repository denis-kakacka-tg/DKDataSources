import DKDataSources

final class TableViewExampleViewController: ViewControllerWithTable {
    
    lazy var dataSource = DKTableDataSource<CellType>(
        models: [
            DisclosureCellModel(title: "Disclosure 1", action: .action1),
            TextFieldCellModel(title: "TextField 1", placeholder: "Placeholder 1"),
            SwitchCellModel(title: "Switch 1", isOn: true),
            BannerCellModel(imageName: "placeholder"),
            SwitchCellModel(title: "Switch 2", isOn: false),
            BannerCellModel(imageName: "placeholder"),
            DisclosureCellModel(title: "Disclosure 2", action: .action2),
            TextFieldCellModel(title: "TextField 2", placeholder: "Placeholder 2"),
            BannerCellModel(imageName: "placeholder")
        ],
        
        configureCell: { (model, cell) in
            
            if let cell = cell as? SwitchCell {
                cell.delegate = self
            }
            
            if let cell = cell as? TextFieldCell {
                cell.delegate = self
            }
            
            cell.configure(with: model)},
        
        titleForHeaderInSection: { _, section in "" },
        titleForFooterInSection: { _, section in "" },
        canEditRowAtIndexPath: { _, indexPath in false },
        canMoveRowAtIndexPath: { _, indexPath in false }
    )
    
    init() {
        super.init(nibName: nil, bundle: nil)
        navigationController?.navigationBar.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TableViewExampleViewController {
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.registerCells(for: tableView)
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.separatorColor = Color.darkBlue
    }
}

extension TableViewExampleViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.contentView.backgroundColor = Color.darkBlue
            header.textLabel?.textColor = Color.yellow
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
         if let footer = view as? UITableViewHeaderFooterView {
            footer.contentView.backgroundColor = Color.darkBlue
            footer.textLabel?.textColor = Color.yellow
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch dataSource.itemType(for: indexPath) {
        case .switch(let model) where model.isOn:
            return 112
        case .switch, .disclosure:
            return 56
        case .textField:
            return 104
        case .banner:
            return 102
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if case let .disclosure(model) = dataSource.itemType(for: indexPath) {
            switch model.action {
            case .action1:
                print("didSelect `Disclosure 1` cell")
            case .action2:
                print("didSelect `Disclosure 2` cell")
            case .action3:
                print("didSelect `Disclosure 3` cell")
            default:
                break
            }
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension TableViewExampleViewController: SwitchCellDelegate {
    
    func switchDidChange(isOn: Bool, cell: SwitchCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return assertionFailure() }
        
        if case let .switch(model) = dataSource.itemType(for: indexPath) {
            model.isOn = isOn
        }
        
        tableView.reloadRows(at: [indexPath], with: .left)
    }
}

extension TableViewExampleViewController: TextFieldCellDelegate {
    
    func textFieldDidEndEditing(textField: UITextField, cell: TextFieldCell) {
        cell.setTitle(textField.text)
        textField.text = ""
    }
}
