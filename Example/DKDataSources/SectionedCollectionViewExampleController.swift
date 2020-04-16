import DKDataSources
final class SectionedCollectionViewExampleController: ViewControllerWithCollection {
    
    lazy var section1DataSource = DKCollectionDataSource<CollectionCellType>(
        models: [
            DisclosureCollectionCellModel(title: "Disclosure 1", action: .action1),
            DisclosureCollectionCellModel(title: "Disclosure 2", action: .action2),
            TextFieldCollectionCellModel(title: "TextField 1", placeholder: "Placeholder 1"),
    ])
    
    lazy var section2DataSource = DKCollectionDataSource<CollectionCellType>(
        models: [
            SwitchCollectionCellModel(title: "Switch 1", isOn: false),
            SwitchCollectionCellModel(title: "Switch 2", isOn: true),
    ])
    
    lazy var section3DataSource = DKCollectionDataSource<CollectionCellType>(
        models: [
            BannerCollectionCellModel(imageName: "placeholder"),
            BannerCollectionCellModel(imageName: "placeholder"),
    ])
    
    lazy var dataSource = DKSectionedCollectionDataSource<CollectionCellType>(
        dataSources: [section1DataSource, section2DataSource, section3DataSource],
        
        configureCell: { (model, cell) in
            
            if let cell = cell as? SwitchCollectionCell {
                cell.delegate = self
            }
            
            if let cell = cell as? TextFieldCollectionCell {
                cell.delegate = self
            }
            
            cell.configure(with: model)},
        
        viewForSupplementaryElement: { [unowned self] _, kind, indexPath in
            
            if kind == UICollectionElementKindSectionHeader,
                let supplementaryView = self.collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? CollectionSectionHeader {
                
                supplementaryView.label.text = "Header for section \(indexPath.section)"
                
                return supplementaryView
            } else {
                return UICollectionReusableView()
            }
        }
    )
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SectionedCollectionViewExampleController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(CollectionSectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        dataSource.registerCells(for: collectionView)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView.reloadData()
    }
}

extension SectionedCollectionViewExampleController: SwitchCollectionCellDelegate {
    
    func switchDidChange(isOn: Bool, cell: SwitchCollectionCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return assertionFailure() }
        
        if case let .switch(model) = dataSource.itemType(for: indexPath) {
            model.isOn = isOn
        }
        
        collectionView.reloadItems(at: [indexPath])
    }
}

extension SectionedCollectionViewExampleController: TextFieldCollectionCellDelegate {
    
    func textFieldDidEndEditing(textField: UITextField, cell: TextFieldCollectionCell) {
        cell.setTitle(textField.text)
        textField.text = ""
    }
}

extension SectionedCollectionViewExampleController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.frame.width - 20
        
        switch dataSource.itemType(for: indexPath) {
        case .banner:
            return CGSize(width: collectionWidth, height: 200)
        case .switch(let model) where model.isOn:
            return CGSize(width: collectionWidth, height: 112)
        case .switch:
            return CGSize(width: collectionWidth, height: 56)
        case .disclosure:
            let size = collectionWidth / 2
            return CGSize(width: size - 2, height: 128)
        case .textField:
            return CGSize(width: collectionWidth, height: 104)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch dataSource.dataSources[section] {
        case section1DataSource, section3DataSource:
            return CGSize(width: collectionView.bounds.width - 20, height: 26)
        default:
            return CGSize(width: collectionView.bounds.width - 20, height: 44)
        }
    }
}

extension SectionedCollectionViewExampleController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch dataSource.itemType(for: indexPath) {
        case .disclosure(let model):
            switch model.action {
            case .action1:
                print("didSelect `Disclosure 1` cell")
            case .action2:
                print("didSelect `Disclosure 2` cell")
            default:
                break
            }
        default:
            break
        }
    }
}
