import UIKit

class ViewControllerWithCollection: UIViewController {
    let collectionLayout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.blue
        collectionView.layer.cornerRadius = 12
        collectionView.backgroundColor = Color.darkBlue
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionLayout.minimumLineSpacing = 4
        collectionLayout.minimumInteritemSpacing = 4
        collectionLayout.scrollDirection = .vertical
    }
}
