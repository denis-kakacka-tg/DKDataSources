import DKDataSources

final class MainViewController: ViewControllerWithTable {
    
    lazy var section1DataSource = DKTableDataSource<CellType>(
        models: [
            DisclosureCellModel(title: "TableView", action: .action1),
            DisclosureCellModel(title: "SectionedTableView", action: .action2),
        ],
        
        titleForHeaderInSection:{ _, section in "TableView examples" })
    
    lazy var section2DataSource = DKTableDataSource<CellType>(
        models: [
            DisclosureCellModel(title: "CollectionView", action: .action3),
            DisclosureCellModel(title: "SectionedCollectionView", action: .action4),
        ],
        
        titleForHeaderInSection:{ _, section in "CollectionView examples" })
    
    lazy var dataSource = DKSectionedTableViewDataSource<CellType>(dataSources: [section1DataSource, section2DataSource])
}

extension MainViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.registerCells(for: tableView)
        tableView.dataSource = dataSource
        tableView.delegate = self
    }
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if case .disclosure = dataSource.itemType(for: indexPath) {
            return 54
        }
        
        return 44
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if case let .disclosure(model) = dataSource.itemType(for: indexPath) {
            switch model.action {
            case .action1:
                navigationController?.pushViewController(TableViewExampleViewController(), animated: true)
                print("didSelect `Disclosure 1` cell")
            case .action2:
                navigationController?.pushViewController(SectionedTableViewExampleViewController(), animated: true)
                print("didSelect `Disclosure 2` cell")
            case .action3:
                navigationController?.pushViewController(CollectionViewExampleViewController(), animated: true)
                print("didSelect `Disclosure 3` cell")
            case .action4:
                navigationController?.pushViewController(SectionedCollectionViewExampleController(), animated: true)
            }
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
