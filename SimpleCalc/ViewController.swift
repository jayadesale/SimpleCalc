//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Desale on 11/16/21.
//Create a delete button (that deletes the previously tapped number
//Have a decimal button and support decimal calculations

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var calcView: UIView!

  // local variables
  var firstNumber: Double = 0
  var secondNumber: Double = 0
  var selectedOperation: Operation?

  enum Operation {
    case divide, multiply, subtract, add
  }

  enum ButtonType {
    case special, number, topRowBtns
  }

  var resultLabel: UILabel = {
    let label = UILabel()
    label.text = "0"
    label.textAlignment = .right
    label.font = UIFont(name: "Avenir Medium", size: 30)
    label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    return label
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    setupButtonsAndLabels()
  }

  func setupButtonsAndLabels()  {
    let sizeOfButton = calcView.frame.size.width / 4
    // all trhese buttons will be arranged from bottom to top.
    let operations = ["=","+", "-", "x", "÷"]
    let specialBtns = ["0","Del", "."]
    let rowNum1 = ["7","8", "9"]
    let rowNum2 = ["4","5", "6"]
    let rowNum3 = ["1","2", "3"]
    let topButtons = ["AC","-/+", "%"]

    // Add "0": 21,"Del": 22, ".": 23 as a bottom row
    addButtons(names: specialBtns, tagPoint: 21, btnCount: 1, btnType: ButtonType.special)
    // Add "7": 8,"8": 9, "9": 10 as a second row from bottom
    addButtons(names: rowNum1, tagPoint: 8, btnCount: 2, btnType: ButtonType.number)
    // Add "4": 5,"5": 6, "6": 7 as a third row from bottom
    addButtons(names: rowNum2, tagPoint: 5, btnCount: 3, btnType: ButtonType.number)
    // Add "1": 2,"2": 3, "3": 4 as a fourth row from bottom
    addButtons(names: rowNum3, tagPoint: 2, btnCount: 4, btnType: ButtonType.number)
    // Add "AC": 13,"-/+": 14, "%": 15 as a very top row
    addButtons(names: topButtons, tagPoint: 13, btnCount: 5, btnType: ButtonType.topRowBtns)

    // Add "=": 16,"+": 17, "-": 18, "x": 19, "÷": 20 as a very top row
    for x in 0..<5 {
      let button = UIButton(frame: CGRect(x: sizeOfButton * 3, y: calcView.frame.size.height-(sizeOfButton * CGFloat(x+1)), width: sizeOfButton, height: sizeOfButton))
      button.setTitleColor(.white, for: .normal)
      button.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
      button.setTitle(operations[x], for: .normal)
      calcView.addSubview(button)
      button.tag = x+16
      button.addTarget(self, action: #selector(operationPressed(_:)), for: .touchUpInside)
    }

    //Following code will add a label to hold results
    resultLabel.frame = CGRect(x: 20, y: calcView.frame.size.height - (sizeOfButton * 6), width: calcView.frame.size.width - sizeOfButton, height: sizeOfButton)
    calcView.addSubview(resultLabel)
  }

  func addButtons(names: [String], tagPoint: Int, btnCount: Int, btnType: ButtonType) {
    let sizeOfButton = calcView.frame.size.width / 4
    for i in 0..<3 {
      let button = UIButton(frame: CGRect(x: sizeOfButton * CGFloat(i), y: calcView.frame.size.height-(sizeOfButton * CGFloat(btnCount)), width: sizeOfButton, height: sizeOfButton))
      button.setTitleColor(.black, for: .normal)
      button.backgroundColor = #colorLiteral(red: 0.7571992796, green: 0.7571992796, blue: 0.7571992796, alpha: 1)
      button.setTitle(names[i], for: .normal)
      calcView.addSubview(button)
      button.tag = i + tagPoint
      if btnType == .number {
        button.addTarget(self, action: #selector(numberPressed(_:)), for: .touchUpInside)
      } else if btnType == .special {
        button.addTarget(self, action: #selector(specialBtnsPressed(_:)), for: .touchUpInside)
      } else if btnType == .topRowBtns {
        button.addTarget(self, action: #selector(topBtnsPressed(_:)), for: .touchUpInside)
      }
    }
  }

  @objc func numberPressed(_ sender: UIButton) {
    let tag = sender.tag - 1
    if resultLabel.text == "0" {
      resultLabel.text = "\(tag)"
    } else if let text = resultLabel.text {
      resultLabel.text = "\(text)\(tag)"
    }
  }

  @objc func specialBtnsPressed(_ sender: UIButton) {
    let tag = sender.tag
    if tag == 21, let text = resultLabel.text {
        resultLabel.text = "\(text)\(tag - 21)"
    } else if tag == 22 && resultLabel.text != "0" {
      // Delete last number entered
      if let text = (resultLabel.text)?.dropLast() {
          resultLabel.text = "\(text)"
        }
    } else if tag == 23 {
      // Handle Decimal point clicked
      if resultLabel.text == "0" {
        // Decimal at the start means add a zero
        resultLabel.text = "0.0"
      } else if resultLabel.text!.contains(".") {
        // Don’t add another decimal point!
      } else {
        // To get number from label
        if let number = Int(resultLabel.text!) {
          // Use the number here
          resultLabel.text = "\(number)."
        }
      }
    }
  }

  @objc func topBtnsPressed(_ sender: UIButton) {
    let tag = sender.tag
    if tag ==  13 {
      clearAll()
    } else if tag == 14 {
      print("Call +/-")
    } else if tag == 15 {
      print("Call % ")
    }
  }

  @objc func operationPressed(_ sender: UIButton) {
    let tag = sender.tag

    if let text = resultLabel.text, let value = Double(text), firstNumber == 0 {
      firstNumber = value
      resultLabel.text = "0"
    }

    if tag == 16 {
      if let operation = selectedOperation {
        var secondNumber: Double = 0
        if let text = resultLabel.text, let value = Double(text) {
          secondNumber = value
        }
        switch operation {
          case .add:
            let result = firstNumber + secondNumber
            resultLabel.text = "\(result)"
            break
          case .subtract:
            let result = firstNumber - secondNumber
            resultLabel.text = "\(result)"
            break
          case .multiply:
            let result = firstNumber * secondNumber
            resultLabel.text = "\(result)"
            break
          case .divide:
            if secondNumber == 0 {
              resultLabel.text = "Divide by Zero"
            } else {
              let result = Double(firstNumber) / Double(secondNumber)
              resultLabel.text = "\(result)"
            }
            break
        }
      }
    } else if tag == 17 {
      selectedOperation = .add
    } else if tag == 18 {
      selectedOperation = .subtract
    } else if tag == 19 {
      selectedOperation = .multiply
    } else if tag == 20 {
      selectedOperation = .divide
    }

  }

  func clearAll() {
    resultLabel.text = "0"
    selectedOperation = nil
    firstNumber = 0
  }

}



