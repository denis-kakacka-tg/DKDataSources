import DKDataSources

enum CellType: DKCellType {
    case disclosure(DisclosureCellModel)
    case `switch`(SwitchCellModel)
    case textField
    case banner
    
    var info: (cellClass: AnyClass, identifier: String) {
        switch self {
        case .disclosure:
            return (cellClass: DisclosureCell.self, identifier: NSStringFromClass(DisclosureCell.self))
        case .switch:
            return (cellClass: SwitchCell.self, identifier: NSStringFromClass(SwitchCell.self))
        case .banner:
            return (cellClass: BannerCell.self, identifier: NSStringFromClass(BannerCell.self))
        case .textField:
            return (cellClass: TextFieldCell.self, identifier: NSStringFromClass(TextFieldCell.self))
        }
    }
}

enum CollectionCellType: DKCellType {
    case disclosure(DisclosureCollectionCellModel)
    case `switch`(SwitchCollectionCellModel)
    case textField
    case banner
    
    var info: (cellClass: AnyClass, identifier: String) {
        switch self {
        case .disclosure:
            return (cellClass: DisclosureCollectionCell.self, identifier: NSStringFromClass(DisclosureCollectionCell.self))
        case .switch:
            return (cellClass: SwitchCollectionCell.self, identifier: NSStringFromClass(SwitchCollectionCell.self))
        case .banner:
            return (cellClass: BannerCollectionCell.self, identifier: NSStringFromClass(BannerCollectionCell.self))
        case .textField:
            return (cellClass: TextFieldCollectionCell.self, identifier: NSStringFromClass(TextFieldCollectionCell.self))
        }
    }
}
