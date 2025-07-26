import UIKit

class CategoriesViewController: UIViewController {
    
    var categories: [String: [String]] = [:]
    var onCategoriesChange: (([String: [String]]) -> Void)?
    
    private let tableView = UITableView()
    private var categoryNames: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadCategories()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "App Categories"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addCategoryTapped)
        )
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        setupDefaultCategories()
    }
    
    private func setupDefaultCategories() {
        if categories.isEmpty {
            categories = [
                "Social Media": ["Instagram", "TikTok", "Facebook", "Twitter", "Snapchat"],
                "Entertainment": ["YouTube", "Netflix", "Spotify"],
                "Messaging": ["WhatsApp", "Telegram", "Discord"],
                "Games": ["Games"],
                "Browsers": ["Safari", "Chrome"]
            ]
        }
    }
    
    private func loadCategories() {
        categoryNames = Array(categories.keys).sorted()
        tableView.reloadData()
    }
    
    @objc private func addCategoryTapped() {
        let alert = UIAlertController(title: "New Category", message: "Enter category name", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Category name"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Create", style: .default) { [weak self] _ in
            guard let name = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespaces),
                  !name.isEmpty else { return }
            
            self?.categories[name] = []
            self?.loadCategories()
            self?.onCategoriesChange?(self?.categories ?? [:])
        })
        
        present(alert, animated: true)
    }
    
    private func editCategory(_ categoryName: String) {
        let categoryDetailVC = CategoryDetailViewController()
        categoryDetailVC.categoryName = categoryName
        categoryDetailVC.apps = categories[categoryName] ?? []
        categoryDetailVC.onAppsChange = { [weak self] apps in
            self?.categories[categoryName] = apps
            self?.onCategoriesChange?(self?.categories ?? [:])
        }
        navigationController?.pushViewController(categoryDetailVC, animated: true)
    }
    
    private func deleteCategory(_ categoryName: String) {
        let alert = UIAlertController(
            title: "Delete Category",
            message: "Are you sure you want to delete '\(categoryName)'?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.categories.removeValue(forKey: categoryName)
            self?.loadCategories()
            self?.onCategoriesChange?(self?.categories ?? [:])
        })
        
        present(alert, animated: true)
    }
}

extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CategoryCell")
        let categoryName = categoryNames[indexPath.row]
        let appCount = categories[categoryName]?.count ?? 0
        
        cell.textLabel?.text = categoryName
        cell.detailTextLabel?.text = "\(appCount) apps"
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let categoryName = categoryNames[indexPath.row]
        editCategory(categoryName)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let categoryName = categoryNames[indexPath.row]
            deleteCategory(categoryName)
        }
    }
}

class CategoryDetailViewController: UIViewController {
    
    var categoryName: String = ""
    var apps: [String] = []
    var onAppsChange: (([String]) -> Void)?
    
    private let tableView = UITableView()
    private let availableApps = [
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
        title = categoryName
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addAppTapped)
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
    
    @objc private func addAppTapped() {
        let availableToAdd = availableApps.filter { !apps.contains($0) }
        
        let alert = UIAlertController(title: "Add App", message: "Select an app to add", preferredStyle: .actionSheet)
        
        for app in availableToAdd {
            alert.addAction(UIAlertAction(title: app, style: .default) { [weak self] _ in
                self?.apps.append(app)
                self?.tableView.reloadData()
                self?.onAppsChange?(self?.apps ?? [])
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.barButtonItem = navigationItem.rightBarButtonItem
        }
        
        present(alert, animated: true)
    }
}

extension CategoryDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppCell", for: indexPath)
        cell.textLabel?.text = apps[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            apps.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            onAppsChange?(apps)
        }
    }
}