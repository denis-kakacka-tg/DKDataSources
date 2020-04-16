import UIKit

public final class DKSectionedCollectionDataSource<T: DKCellType>: NSObject, UICollectionViewDataSource {
    public typealias ConfigureCell = (DKCellModel<T>, DKCollectionConfigurableCell) -> Void
    public typealias ViewForSupplementaryElement = (DKSectionedCollectionDataSource, String, IndexPath) -> UICollectionReusableView

    private let configureCell: ConfigureCell
    private let viewForSupplementaryElement: ViewForSupplementaryElement?
    
    public var dataSources: [DKCollectionDataSource<T>]

    public init(dataSources: [DKCollectionDataSource<T>],
                configureCell: @escaping ConfigureCell = { _,_ in },
                viewForSupplementaryElement: ViewForSupplementaryElement? = nil) {
        
        self.dataSources = dataSources
        self.configureCell = configureCell
        self.viewForSupplementaryElement = viewForSupplementaryElement
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSources.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let dataSource = dataSources[section]
        return dataSource.collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dataSource = dataSources[indexPath.section]
        let model = dataSource.models[indexPath.row]
        
        guard let cell = dataSource.collectionView(collectionView, cellForItemAt: indexPath) as? DKCollectionConfigurableCell else {
            return UICollectionViewCell()
        }
        
        configureCell(model, cell)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let dataSource = dataSources[indexPath.section]
        
        if let viewForSupplementaryElement = viewForSupplementaryElement {
            return viewForSupplementaryElement(self, kind, indexPath)
        }
        
        return dataSource.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        let dataSource = dataSources[indexPath.section]
        return dataSource.collectionView(collectionView, canMoveItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceSection = dataSources[sourceIndexPath.section]
        let itemToMove = sourceSection.models.remove(at: sourceIndexPath.row)
        
        let destinationSection = dataSources[destinationIndexPath.section]
        destinationSection.models.insert(itemToMove, at: destinationIndexPath.row)
    }
}

// MARK: - Helpers
extension DKSectionedCollectionDataSource {
    
    public func registerCells(for collectionView: UICollectionView) {
        dataSources.forEach {
            $0.models.forEach { model in
                let cellInfo = model.type.info
                collectionView.register(cellInfo.cellClass, forCellWithReuseIdentifier: cellInfo.identifier)
            }
        }
    }
    
    public func itemType(for indexPath: IndexPath) -> T {
        dataSources[indexPath.section].models[indexPath.row].type
    }
}
