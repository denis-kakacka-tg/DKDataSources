import UIKit

public final class DKCollectionDataSource<T: DKCellType>: NSObject, UICollectionViewDataSource {
    public typealias ConfigureCell = (DKCellModel<T>, DKCollectionConfigurableCell) -> Void
    public typealias ViewForSupplementaryElement = (DKCollectionDataSource, String, IndexPath) -> UICollectionReusableView
    public typealias CanMoveRowAtIndexPath = (DKCollectionDataSource, IndexPath) -> Bool
    
    private let configureCell: ConfigureCell
    private let viewForSupplementaryElement: ViewForSupplementaryElement?
    private let canMoveRowAtIndexPath: CanMoveRowAtIndexPath
    
    public var models: [DKCellModel<T>]
    
    public init(models: [DKCellModel<T>],
                configureCell: @escaping ConfigureCell = { $1.configure(with: $0) },
                viewForSupplementaryElement: ViewForSupplementaryElement? = nil,
                canMoveRowAtIndexPath: @escaping CanMoveRowAtIndexPath = { _, _ in false }) {
        
        self.models = models
        self.configureCell = configureCell
        self.viewForSupplementaryElement = viewForSupplementaryElement
        self.canMoveRowAtIndexPath = canMoveRowAtIndexPath
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        models.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = models[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: model.type.info.identifier, for: indexPath) as? DKCollectionConfigurableCell else { return UICollectionViewCell() }
        
        configureCell(model, cell)
        
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let viewForSupplementaryElement = viewForSupplementaryElement {
            return viewForSupplementaryElement(self, kind, indexPath)
        }
        
        return UICollectionReusableView()
    }

    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        canMoveRowAtIndexPath(self, indexPath)
    }
        
    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = models[sourceIndexPath.row]
        models.remove(at: sourceIndexPath.row)
        models.insert(movedObject, at: destinationIndexPath.row)
    }
}

// MARK: - Helpers
extension DKCollectionDataSource {
    
    public func registerCells(for collectionView: UICollectionView) {
        models.forEach {
            let cellInfo = $0.type.info
            collectionView.register(cellInfo.cellClass, forCellWithReuseIdentifier: cellInfo.identifier)
        }
    }
    
    public func itemType(for indexPath: IndexPath) -> T {
        models[indexPath.row].type
    }
}
