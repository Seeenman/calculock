import UIKit

class CalculusViewController: UIViewController {
    
    var onProblemSolved: (() -> Void)?
    
    private let titleLabel = UILabel()
    private let problemLabel = UILabel()
    private let answerTextField = UITextField()
    private let submitButton = UIButton(type: .system)
    private let hintButton = UIButton(type: .system)
    private let newProblemButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    
    private var currentProblem: CalculusProblem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        generateNewProblem()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        titleLabel.text = "Solve to Unblock Apps"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        problemLabel.font = .systemFont(ofSize: 18)
        problemLabel.textAlignment = .center
        problemLabel.numberOfLines = 0
        problemLabel.translatesAutoresizingMaskIntoConstraints = false
        
        answerTextField.borderStyle = .roundedRect
        answerTextField.placeholder = "Enter your answer"
        answerTextField.keyboardType = .numbersAndPunctuation
        answerTextField.textAlignment = .center
        answerTextField.font = .systemFont(ofSize: 16)
        answerTextField.translatesAutoresizingMaskIntoConstraints = false
        
        submitButton.setTitle("Submit Answer", for: .normal)
        submitButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        submitButton.backgroundColor = .systemBlue
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 10
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        
        hintButton.setTitle("Show Hint", for: .normal)
        hintButton.titleLabel?.font = .systemFont(ofSize: 16)
        hintButton.backgroundColor = .systemOrange
        hintButton.setTitleColor(.white, for: .normal)
        hintButton.layer.cornerRadius = 8
        hintButton.translatesAutoresizingMaskIntoConstraints = false
        hintButton.addTarget(self, action: #selector(hintButtonTapped), for: .touchUpInside)
        
        newProblemButton.setTitle("New Problem", for: .normal)
        newProblemButton.titleLabel?.font = .systemFont(ofSize: 16)
        newProblemButton.backgroundColor = .systemGreen
        newProblemButton.setTitleColor(.white, for: .normal)
        newProblemButton.layer.cornerRadius = 8
        newProblemButton.translatesAutoresizingMaskIntoConstraints = false
        newProblemButton.addTarget(self, action: #selector(newProblemButtonTapped), for: .touchUpInside)
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16)
        cancelButton.backgroundColor = .systemGray
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.layer.cornerRadius = 8
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        view.addSubview(titleLabel)
        view.addSubview(problemLabel)
        view.addSubview(answerTextField)
        view.addSubview(submitButton)
        view.addSubview(hintButton)
        view.addSubview(newProblemButton)
        view.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            problemLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            problemLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            problemLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            answerTextField.topAnchor.constraint(equalTo: problemLabel.bottomAnchor, constant: 30),
            answerTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            answerTextField.widthAnchor.constraint(equalToConstant: 200),
            answerTextField.heightAnchor.constraint(equalToConstant: 40),
            
            submitButton.topAnchor.constraint(equalTo: answerTextField.bottomAnchor, constant: 20),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: 180),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            
            hintButton.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
            hintButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -90),
            hintButton.widthAnchor.constraint(equalToConstant: 80),
            hintButton.heightAnchor.constraint(equalToConstant: 40),
            
            newProblemButton.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
            newProblemButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: 90),
            newProblemButton.widthAnchor.constraint(equalToConstant: 80),
            newProblemButton.heightAnchor.constraint(equalToConstant: 40),
            
            cancelButton.topAnchor.constraint(equalTo: hintButton.bottomAnchor, constant: 30),
            cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 100),
            cancelButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func generateNewProblem() {
        currentProblem = CalculusProblem.generateRandom()
        problemLabel.text = currentProblem?.question
        answerTextField.text = ""
    }
    
    @objc private func submitButtonTapped() {
        guard let answer = answerTextField.text?.trimmingCharacters(in: .whitespaces),
              !answer.isEmpty,
              let problem = currentProblem else {
            showAlert(title: "Invalid Answer", message: "Please enter an answer.")
            return
        }
        
        if problem.checkAnswer(answer) {
            showAlert(title: "Correct!", message: "Apps have been unblocked.") { [weak self] in
                self?.onProblemSolved?()
                self?.dismiss(animated: true)
            }
        } else {
            showAlert(title: "Incorrect", message: "Try again or get a hint.")
        }
    }
    
    @objc private func hintButtonTapped() {
        guard let hint = currentProblem?.hint else { return }
        showAlert(title: "Hint", message: hint)
    }
    
    @objc private func newProblemButtonTapped() {
        generateNewProblem()
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}

struct CalculusProblem {
    let question: String
    let answer: String
    let hint: String
    let tolerance: Double
    
    func checkAnswer(_ userAnswer: String) -> Bool {
        if let userValue = Double(userAnswer), let correctValue = Double(answer) {
            return abs(userValue - correctValue) <= tolerance
        }
        return userAnswer.lowercased() == answer.lowercased()
    }
    
    static func generateRandom() -> CalculusProblem {
        let problems = [
            CalculusProblem(
                question: "Find the derivative of f(x) = 3x²",
                answer: "6x",
                hint: "Use the power rule: d/dx(xⁿ) = n·xⁿ⁻¹",
                tolerance: 0.0
            ),
            CalculusProblem(
                question: "What is the derivative of sin(x)?",
                answer: "cos(x)",
                hint: "This is a basic trigonometric derivative",
                tolerance: 0.0
            ),
            CalculusProblem(
                question: "Find ∫ 2x dx",
                answer: "x²",
                hint: "Use the power rule for integration: ∫xⁿ dx = xⁿ⁺¹/(n+1) + C",
                tolerance: 0.0
            ),
            CalculusProblem(
                question: "What is the derivative of e^x?",
                answer: "e^x",
                hint: "The exponential function is its own derivative",
                tolerance: 0.0
            ),
            CalculusProblem(
                question: "Find the derivative of ln(x)",
                answer: "1/x",
                hint: "This is the derivative of the natural logarithm",
                tolerance: 0.0
            ),
            CalculusProblem(
                question: "What is ∫ 1/x dx?",
                answer: "ln(x)",
                hint: "This is the antiderivative of 1/x",
                tolerance: 0.0
            )
        ]
        
        return problems.randomElement()!
    }
}