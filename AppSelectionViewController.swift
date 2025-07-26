import UIKit

class AppSelectionViewController: UIViewController {
    
    var selectedApps: Set<String> = []
    var onSelectionChange: ((Set<String>) -> Void)?
    
    private let tableView = UITableView()
    private let mockApps = [
        "Instagram", "TikTok", "Facebook", "Twitter", "YouTube",
        "Snapchat", "WhatsApp", "Telegram", "Discord", "Reddit",
        "Netflix", "Spotify", "Games", "Safari", "Chrome"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Select Apps to Block"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AppCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func doneButtonTapped() {
        onSelectionChange?(selectedApps)
        navigationController?.popViewController(animated: true)
    }
}

extension AppSelectionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mockApps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppCell", for: indexPath)
        let appName = mockApps[indexPath.row]
        
        cell.textLabel?.text = appName
        cell.accessoryType = selectedApps.contains(appName) ? .checkmark : .none
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appName = mockApps[indexPath.row]
        
        if selectedApps.contains(appName) {
            selectedApps.remove(appName)
        } else {
            selectedApps.insert(appName)
        }
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}