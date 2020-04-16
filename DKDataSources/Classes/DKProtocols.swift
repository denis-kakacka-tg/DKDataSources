
public protocol DKCellType {
    var info: (cellClass: AnyClass, identifier: String) { get }
}

public protocol DKCellModelProtocol {
    associatedtype CellsType: DKCellType
    var type: CellsType { get }
}

public protocol DKTableConfigurableCell: UITableViewCell {
    func configure<T: DKCellModelProtocol>(with model: T)
}

public protocol DKCollectionConfigurableCell: UICollectionViewCell {
    func configure<T: DKCellModelProtocol>(with model: T)
}
