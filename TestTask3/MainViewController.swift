import UIKit

final class MainViewController: UIViewController {
    
    private var storage = [Company]()
    private var myTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.frame = CGRect(x: 0, y: 40, width: self.view.bounds.width, height: self.view.bounds.height)
        self.view.addSubview(myTableView)
        self.view.backgroundColor = .white
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.sectionHeaderHeight = 30
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkManager().fetchData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let info): self.storage = info
                self.myTableView.reloadData()
            case .failure: self.present(AlertBuilder().createAlertController(title: "Failed to get data", message: "Сheck your internet connection"), animated: true)
            }
        }
    }
}

//MARK: UITableViewDataSource, UITableViewDelegate

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return storage.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storage.first?.employees.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return storage.first?.name
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 122
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self)?.first as? MainTableViewCell {
            
            guard let person = storage.first?.employees[indexPath.item] else { return cell }

            cell.nameLabel.text = person.name
            cell.phoneLabel.text = person.phoneNumber
            cell.skillsLabel.text = person.skills.joined(separator: ", ")
            
            return cell
        }
        return UITableViewCell()
    }
}
