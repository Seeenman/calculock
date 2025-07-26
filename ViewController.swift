import UIKit

class ViewController: UIViewController {
    
    private var blockedApps: Set<String> = []
    private var blockEndTime: Date?
    private var appCategories: [String: [String]] = [:]
    
    private let titleLabel = UILabel()
    private let statusLabel = UILabel()
    private let selectAppsButton = UIButton(type: .system)
    private let blockDurationPicker = UIPickerView()
    private let startBlockButton = UIButton(type: .system)
    private let unblockButton = UIButton(type: .system)
    private let categoriesButton = UIButton(type: .system)
    
    private let blockDurations = [15, 30, 60, 120, 240, 480] // minutes
    private var selectedDuration = 60
    private var blockingTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
        startBlockingTimer()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "CalcuLock"
        
        titleLabel.text = "CalcuLock"
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        statusLabel.text = "No apps currently blocked"
        statusLabel.font = .systemFont(ofSize: 16)
        statusLabel.textAlignment = .center
        statusLabel.textColor = .systemGray
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        selectAppsButton.setTitle("Select Apps to Block", for: .normal)
        selectAppsButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        selectAppsButton.backgroundColor = .systemBlue
        selectAppsButton.setTitleColor(.white, for: .normal)
        selectAppsButton.layer.cornerRadius = 10
        selectAppsButton.translatesAutoresizingMaskIntoConstraints = false
        selectAppsButton.addTarget(self, action: #selector(selectAppsButtonTapped), for: .touchUpInside)
        
        blockDurationPicker.delegate = self
        blockDurationPicker.dataSource = self
        blockDurationPicker.translatesAutoresizingMaskIntoConstraints = false
        blockDurationPicker.selectRow(2, inComponent: 0, animated: false) // Default to 60 minutes
        
        startBlockButton.setTitle("Start Blocking", for: .normal)
        startBlockButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        startBlockButton.backgroundColor = .systemRed
        startBlockButton.setTitleColor(.white, for: .normal)
        startBlockButton.layer.cornerRadius = 10
        startBlockButton.translatesAutoresizingMaskIntoConstraints = false
        startBlockButton.addTarget(self, action: #selector(startBlockButtonTapped), for: .touchUpInside)
        
        unblockButton.setTitle("Solve Calculus to Unblock", for: .normal)
        unblockButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        unblockButton.backgroundColor = .systemOrange
        unblockButton.setTitleColor(.white, for: .normal)
        unblockButton.layer.cornerRadius = 10
        unblockButton.translatesAutoresizingMaskIntoConstraints = false
        unblockButton.addTarget(self, action: #selector(unblockButtonTapped), for: .touchUpInside)
        unblockButton.isHidden = true
        
        categoriesButton.setTitle("Manage Categories", for: .normal)
        categoriesButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        categoriesButton.backgroundColor = .systemGreen
        categoriesButton.setTitleColor(.white, for: .normal)
        categoriesButton.layer.cornerRadius = 8
        categoriesButton.translatesAutoresizingMaskIntoConstraints = false
        categoriesButton.addTarget(self, action: #selector(categoriesButtonTapped), for: .touchUpInside)
        
        view.addSubview(titleLabel)
        view.addSubview(statusLabel)
        view.addSubview(selectAppsButton)
        view.addSubview(blockDurationPicker)
        view.addSubview(startBlockButton)
        view.addSubview(unblockButton)
        view.addSubview(categoriesButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            statusLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            selectAppsButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 30),
            selectAppsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectAppsButton.widthAnchor.constraint(equalToConstant: 250),
            selectAppsButton.heightAnchor.constraint(equalToConstant: 50),
            
            blockDurationPicker.topAnchor.constraint(equalTo: selectAppsButton.bottomAnchor, constant: 20),
            blockDurationPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            blockDurationPicker.heightAnchor.constraint(equalToConstant: 120),
            
            startBlockButton.topAnchor.constraint(equalTo: blockDurationPicker.bottomAnchor, constant: 20),
            startBlockButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startBlockButton.widthAnchor.constraint(equalToConstant: 200),
            startBlockButton.heightAnchor.constraint(equalToConstant: 50),
            
            unblockButton.topAnchor.constraint(equalTo: startBlockButton.bottomAnchor, constant: 20),
            unblockButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            unblockButton.widthAnchor.constraint(equalToConstant: 250),
            unblockButton.heightAnchor.constraint(equalToConstant: 50),
            
            categoriesButton.topAnchor.constraint(equalTo: unblockButton.bottomAnchor, constant: 30),
            categoriesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoriesButton.widthAnchor.constraint(equalToConstant: 200),
            categoriesButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func updateUI() {
        if let endTime = blockEndTime, endTime > Date() {
            statusLabel.text = "Apps blocked until \(formatTime(endTime))"
            statusLabel.textColor = .systemRed
            startBlockButton.isHidden = true
            unblockButton.isHidden = false
            selectAppsButton.isEnabled = false
            blockDurationPicker.isUserInteractionEnabled = false
        } else {
            statusLabel.text = blockedApps.isEmpty ? "No apps currently blocked" : "\(blockedApps.count) apps selected for blocking"
            statusLabel.textColor = .systemGray
            startBlockButton.isHidden = false
            unblockButton.isHidden = true
            selectAppsButton.isEnabled = true
            blockDurationPicker.isUserInteractionEnabled = true
            blockEndTime = nil
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    @objc private func selectAppsButtonTapped() {
        let appSelectionVC = AppSelectionViewController()
        appSelectionVC.selectedApps = blockedApps
        appSelectionVC.onSelectionChange = { [weak self] selectedApps in
            self?.blockedApps = selectedApps
            self?.updateUI()
        }
        navigationController?.pushViewController(appSelectionVC, animated: true)
    }
    
    @objc private func startBlockButtonTapped() {
        guard !blockedApps.isEmpty else {
            showAlert(title: "No Apps Selected", message: "Please select apps to block first.")
            return
        }
        
        blockEndTime = Date().addingTimeInterval(TimeInterval(selectedDuration * 60))
        updateUI()
    }
    
    @objc private func unblockButtonTapped() {
        let calculusVC = CalculusViewController()
        calculusVC.onProblemSolved = { [weak self] in
            self?.blockEndTime = nil
            self?.updateUI()
        }
        present(calculusVC, animated: true)
    }
    
    @objc private func categoriesButtonTapped() {
        let categoriesVC = CategoriesViewController()
        categoriesVC.categories = appCategories
        categoriesVC.onCategoriesChange = { [weak self] categories in
            self?.appCategories = categories
        }
        navigationController?.pushViewController(categoriesVC, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func startBlockingTimer() {
        blockingTimer?.invalidate()
        blockingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.checkBlockingStatus()
        }
    }
    
    private func checkBlockingStatus() {
        if let endTime = blockEndTime, endTime <= Date() {
            blockEndTime = nil
            updateUI()
        }
    }
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return blockDurations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let duration = blockDurations[row]
        if duration < 60 {
            return "\(duration) minutes"
        } else {
            return "\(duration / 60) hours"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDuration = blockDurations[row]
    }
}