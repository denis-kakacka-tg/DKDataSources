import DKDataSources

final class SectionedTableViewExampleViewController: ViewControllerWithTable {
    
    lazy var section1DataSource = DKTableDataSource<CellType>(
        models: [
            SwitchCellModel(title: "Switch 1", isOn: false),
            SwitchCellModel(title: "Switch 2", isOn: true),
            TextFieldCellModel(title: "TextField 1", placeholder: "Placeholder 1"),
            DisclosureCellModel(title: "Disclosure 1", action: .action1),
        ],
        
        titleForHeaderInSection:{ _, section in "This is section: \(section) header" })
    
    lazy var section2DataSource = DKTableDataSource<CellType>(
        models: [
            DisclosureCellModel(title: "Disclosure 2", action: .action2),
            BannerCellModel(imageName: "placeholder"),
            SwitchCellModel(title: "Switch 3", isOn: true),
        ],
        
        titleForHeaderInSection:{ _, section in "This is section: \(section) header" })
    
    lazy var section3DataSource = DKTableDataSource<CellType>(
        models: [
            BannerCellModel(imageName: "placeholder"),
            BannerCellModel(imageName: "placeholder"),
        ],
        
        titleForHeaderInSection:{ _, section in "This is section: \(section) header" })
    
    lazy var dataSource = DKSectionedTableViewDataSource<CellType>(
        dataSources: [section1DataSource, section2DataSource, section3DataSource],
        
        configureCell: { (model, cell) in
            
            if let cell = cell as? SwitchCell {
                cell.delegate = self
            }

            if let cell = cell as? TextFieldCell {
                cell.delegate = self
            }

            cell.configure(with: model)},
        
        sectionIndexTitles: { _ in [""] },
        sectionForSectionIndexTitle: { _, title, index in index }
    )
        
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SectionedTableViewExampleViewController {
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.registerCells(for: tableView)
        tableView.dataSource = dataSource
        tableView.delegate = self
    }
}

extension SectionedTableViewExampleViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch dataSource.dataSources[section] {
        case section1DataSource, section3DataSource:
            return 26
        case section2DataSource:
            return 44
        default:
            return 0
        }
    }
    
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
            default:
                break
            }
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension SectionedTableViewExampleViewController: SwitchCellDelegate {
    
    func switchDidChange(isOn: Bool, cell: SwitchCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return assertionFailure() }
        
        if case let .switch(model) = dataSource.itemType(for: indexPath) {
            model.isOn = isOn
        }
        
        tableView.reloadRows(at: [indexPath], with: .left)
    }
}

extension SectionedTableViewExampleViewController: TextFieldCellDelegate {
    
    func textFieldDidEndEditing(textField: UITextField, cell: TextFieldCell) {
        cell.setTitle(textField.text)
        textField.text = ""
    }
}
