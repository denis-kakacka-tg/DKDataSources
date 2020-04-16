import UIKit

public final class DKSectionedTableViewDataSource<T: DKCellType>: NSObject, UITableViewDataSource {
    public typealias ConfigureCell = (DKCellModel<T>, DKTableConfigurableCell) -> Void
    public typealias SectionIndexTitles = (DKSectionedTableViewDataSource) -> [String]?
    public typealias SectionForSectionIndexTitle = (DKSectionedTableViewDataSource, _ title: String, _ index: Int) -> Int
        
    private let configureCell: ConfigureCell
    private let sectionIndexTitles: SectionIndexTitles
    private let sectionForSectionIndexTitle: SectionForSectionIndexTitle
    
    public var dataSources: [DKTableDataSource<T>]
    
    public init(dataSources: [DKTableDataSource<T>],
                configureCell: @escaping ConfigureCell = { _,_ in },
                sectionIndexTitles: @escaping SectionIndexTitles = { _ in nil },
                sectionForSectionIndexTitle: @escaping SectionForSectionIndexTitle = { _, _, index in index } ) {
        
        self.dataSources = dataSources
        self.configureCell = configureCell
        self.sectionIndexTitles = sectionIndexTitles
        self.sectionForSectionIndexTitle = sectionForSectionIndexTitle
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        dataSources.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataSource = dataSources[section]
        return dataSource.tableView(tableView, numberOfRowsInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataSource = dataSources[indexPath.section]
        let model = dataSource.models[indexPath.row]
        
        guard let cell = dataSource.tableView(tableView, cellForRowAt: indexPath) as? DKTableConfigurableCell else {
            return UITableViewCell()
        }
        
        configureCell(model, cell)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let dataSource = dataSources[section]
        return dataSource.tableView(tableView, titleForFooterInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dataSource = dataSources[section]
        return dataSource.tableView(tableView, titleForHeaderInSection: section)
    }
    
   public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let dataSource = dataSources[indexPath.section]
        return dataSource.tableView(tableView, canEditRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        let dataSource = dataSources[indexPath.section]
        return dataSource.tableView(tableView, canMoveRowAt: indexPath)
    }

    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceSection = dataSources[sourceIndexPath.section]
        let itemToMove = sourceSection.models.remove(at: sourceIndexPath.row)
        
        let destinationSection = dataSources[destinationIndexPath.section]
        destinationSection.models.insert(itemToMove, at: destinationIndexPath.row)
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionIndexTitles(self)
    }
    
    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return sectionForSectionIndexTitle(self, title, index)
    }
}

// MARK: - Helpers
extension DKSectionedTableViewDataSource {
    
    public func registerCells(for tableView: UITableView) {
        dataSources.forEach {
            $0.models.forEach { model in
                let cellInfo = model.type.info
                tableView.register(cellInfo.cellClass, forCellReuseIdentifier: cellInfo.identifier)
            }
        }
    }
    
    public func itemType(for indexPath: IndexPath) -> T {
        return dataSources[indexPath.section].models[indexPath.row].type
    }
}
