//
//  ViewController.swift
//  calculater
//
//  Created by RASHID on 01/05/2026.
//

import UIKit

class ViewController: UIViewController {

    let displayLabel = UILabel()
    var currentNumber: Double = 0
    var previousNumber: Double = 0
    var currentOperation: String?
    var isTypingNumber = false
    
    func format(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(value))
        } else {
            return String(value)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        setupDisplay()
        setupButtons()
    }

    // MARK: - Display
    func setupDisplay() {
        displayLabel.text = "0"
        displayLabel.textColor = .white
        displayLabel.font = UIFont.systemFont(ofSize: 60, weight: .light)
        displayLabel.textAlignment = .right
        displayLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(displayLabel)

        NSLayoutConstraint.activate([
            displayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            displayLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            displayLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            displayLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    // MARK: - Buttons
    func setupButtons() {

        let rows: [[String]] = [
            ["⌫", "AC", "%", "÷"],
            ["7", "8", "9", "×"],
            ["4", "5", "6", "−"],
            ["1", "2", "3", "+"],
            ["+/-", "0", ".", "="]
        ]

        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.spacing = 12
        mainStack.distribution = .fillEqually
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        for row in rows {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 12
            rowStack.distribution = .fillEqually

            for title in row {
                let button = createButton(title: title)
                rowStack.addArrangedSubview(button)
            }

            mainStack.addArrangedSubview(rowStack)
        }

        view.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            mainStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            mainStack.topAnchor.constraint(equalTo: displayLabel.bottomAnchor, constant: 20)
        ])
    }

    // MARK: - Button Factory
    func createButton(title: String) -> UIButton {

        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 35
        button.clipsToBounds = true

        // Color logic
        if ["÷", "×", "−", "+", "="].contains(title) {
            button.backgroundColor = .systemOrange
        } else if ["AC", "%", "⌫", "+/-"].contains(title) {
            button.backgroundColor = .darkGray
        } else {
            button.backgroundColor = UIColor(white: 0.2, alpha: 1)
        }

        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

        return button
    }

    // MARK: - Action
    @objc func buttonTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }

        switch title {

        case "0"..."9":
            if isTypingNumber {
                displayLabel.text! += title
            } else {
                displayLabel.text = title
                isTypingNumber = true
            }

        case ".":
            if !(displayLabel.text?.contains(".") ?? false) {
                displayLabel.text! += "."
                isTypingNumber = true
            }

        case "+", "−", "×", "÷":
            previousNumber = Double(displayLabel.text!) ?? 0
            currentOperation = title
            isTypingNumber = false

        case "=":
            let current = Double(displayLabel.text!) ?? 0
            var result: Double = 0

            switch currentOperation {
            case "+": result = previousNumber + current
            case "−": result = previousNumber - current
            case "×": result = previousNumber * current
            case "÷": result = current == 0 ? 0 : previousNumber / current
            default: break
            }

            displayLabel.text = format(result)
            isTypingNumber = false

        case "AC":
            displayLabel.text = "0"
            currentNumber = 0
            previousNumber = 0
            currentOperation = nil
            isTypingNumber = false

        case "⌫":
            if isTypingNumber && displayLabel.text!.count > 1 {
                displayLabel.text!.removeLast()
            } else {
                displayLabel.text = "0"
                isTypingNumber = false
            }

        case "+/-":
            if let value = Double(displayLabel.text!) {
                displayLabel.text = format(-value)
            }

        case "%":
            if let value = Double(displayLabel.text!) {
                displayLabel.text = format(value / 100)
            }

        default:
            break
        }
    }
}
