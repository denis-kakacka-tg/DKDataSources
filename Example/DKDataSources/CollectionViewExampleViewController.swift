import DKDataSources

final class CollectionViewExampleViewController: ViewControllerWithCollection {
    
    lazy var dataSource = DKCollectionDataSource<CollectionCellType>(
        models: [
            DisclosureCollectionCellModel(title: "Disclosure 1", action: .action1),
            DisclosureCollectionCellModel(title: "Disclosure 2", action: .action2),
            TextFieldCollectionCellModel(title: "TextField 1", placeholder: "Placeholder 1"),
            SwitchCollectionCellModel(title: "Switch 1", isOn: false),
            DisclosureCollectionCellModel(title: "Disclosure 3", action: .action3),
            DisclosureCollectionCellModel(title: "Disclosure 4", action: .action4),
            SwitchCollectionCellModel(title: "Switch 2", isOn: true),
            BannerCollectionCellModel(imageName: "placeholder"),
        ],
        
        configureCell: { (model, cell) in
            
            if let cell = cell as? SwitchCollectionCell {
                cell.delegate = self
            }
            
            if let cell = cell as? TextFieldCollectionCell {
                cell.delegate = self
            }
            
            cell.configure(with: model)},
        
        canMoveRowAtIndexPath: { _, indexPath in false }
    )
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CollectionViewExampleViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.registerCells(for: collectionView)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView.reloadData()
    }
}

extension CollectionViewExampleViewController: SwitchCollectionCellDelegate {
    
    func switchDidChange(isOn: Bool, cell: SwitchCollectionCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return assertionFailure() }
        
        if case let .switch(model) = dataSource.itemType(for: indexPath) {
            model.isOn = isOn
        }
        
        collectionView.reloadItems(at: [indexPath])
    }
}

extension CollectionViewExampleViewController: TextFieldCollectionCellDelegate {
    
    func textFieldDidEndEditing(textField: UITextField, cell: TextFieldCollectionCell) {
        cell.setTitle(textField.text)
        textField.text = ""
    }
}

extension CollectionViewExampleViewController: UICollectionViewDelegateFlowLayout {
    
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
}

extension CollectionViewExampleViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch dataSource.itemType(for: indexPath) {
        case .disclosure(let model):
            switch model.action {
            case .action1:
                print("didSelect `Disclosure 1` cell")
            case .action2:
                print("didSelect `Disclosure 2` cell")
            case .action3:
                print("didSelect `Disclosure 3` cell")
            case .action4:
                print("didSelect `Disclosure 4` cell")
            }
        default:
            break
        }
    }
}
