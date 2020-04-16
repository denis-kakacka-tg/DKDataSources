
open class DKCellModel<T: DKCellType>: DKCellModelProtocol {
    
    public typealias CellsType = T
    
    open var type: T {
        fatalError("You need to override this and return proper type from enum conforming `CellTypeProtocol`")
    }
    
    public init() {}
}
