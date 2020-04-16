import UIKit

public final class DKTableDataSource<T: DKCellType>: NSObject, UITableViewDataSource {
    public typealias ConfigureCell = (DKCellModel<T>, DKTableConfigurableCell) -> Void
    public typealias TitleForHeaderInSection = (DKTableDataSource, Int) -> String?
    public typealias TitleForFooterInSection = (DKTableDataSource, Int) -> String?
    public typealias CanEditRowAtIndexPath = (DKTableDataSource, IndexPath) -> Bool
    public typealias CanMoveRowAtIndexPath = (DKTableDataSource, IndexPath) -> Bool
    
    private let configureCell: ConfigureCell
    private let titleForHeaderInSection: TitleForHeaderInSection
    private let titleForFooterInSection: TitleForFooterInSection
    private let canEditRowAtIndexPath: CanEditRowAtIndexPath
    private let canMoveRowAtIndexPath: CanMoveRowAtIndexPath
    
    public var models: [DKCellModel<T>]
    
    public init(models: [DKCellModel<T>],
                configureCell: @escaping ConfigureCell = { $1.configure(with: $0) },
                titleForHeaderInSection: @escaping  TitleForHeaderInSection = { _, _ in nil },
                titleForFooterInSection: @escaping TitleForFooterInSection = { _, _ in nil },
                canEditRowAtIndexPath: @escaping CanEditRowAtIndexPath = { _, _ in false },
                canMoveRowAtIndexPath: @escaping CanMoveRowAtIndexPath = { _, _ in false }) {
        
        self.models = models
        self.configureCell = configureCell
        self.titleForHeaderInSection = titleForHeaderInSection
        self.titleForFooterInSection = titleForFooterInSection
        self.canEditRowAtIndexPath = canEditRowAtIndexPath
        self.canMoveRowAtIndexPath = canMoveRowAtIndexPath
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: model.type.info.identifier, for: indexPath) as? DKTableConfigurableCell else { return UITableViewCell() }
        
        configureCell(model, cell)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        titleForFooterInSection(self, section)
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        titleForHeaderInSection(self, section)
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        canEditRowAtIndexPath(self, indexPath)
    }
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        canMoveRowAtIndexPath(self, indexPath)
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = models[sourceIndexPath.row]
        models.remove(at: sourceIndexPath.row)
        models.insert(movedObject, at: destinationIndexPath.row)
    }
}

// MARK: - Helpers
extension DKTableDataSource {
    
    public func registerCells(for tableView: UITableView) {
        models.forEach {
            let cellInfo = $0.type.info
            tableView.register(cellInfo.cellClass, forCellReuseIdentifier: cellInfo.identifier)
        }
    }
    
    public func itemType(for indexPath: IndexPath) -> T {
        models[indexPath.row].type
    }
}
