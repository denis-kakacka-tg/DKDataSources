import UIKit

class ViewControllerWithTable: UIViewController {
    let tableView = UITableView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.blue
        tableView.layer.cornerRadius = 12
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = Color.darkBlue
        tableView.separatorColor = Color.darkBlue
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
