//
//  ViewController.swift
//  Lab1
//
//  Created by Volodymyr Klymenko on 2019-01-16.
//  Copyright © 2019 Volodymyr Klymenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var timerLabel: UILabel!
	@IBOutlet weak var warningLabel: UILabel!
	@IBOutlet weak var timeInput: UITextField!
	@IBOutlet weak var startButton: UIButton!
	@IBOutlet weak var stopButton: UIButton!

	var timer = Timer()
	var secondsLeft: Int = 0

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		warningLabel.text = ""
		timerLabel.text = "00:00"
	}

	func updateLabel(){
		let minutes = Int(secondsLeft)/60
		let seconds =  secondsLeft%60
		timerLabel.text = "\(minutes):\(seconds)"
		print("\(minutes):\(seconds)")
	}

	@objc func updateTimer(){
		secondsLeft -= 1
		updateLabel()
		if secondsLeft < 0 {
			timer.invalidate()
		}
	}

	@IBAction func startTimer(_ sender: Any) {
		timerLabel.text = "00:00"
		timer.invalidate()
		if let givenTime = timeInput.text, let enteredTime = Int(givenTime) {
			if enteredTime >= 1 && enteredTime <= 60{
				secondsLeft = enteredTime * 60
				warningLabel.text = ""
				timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
			} else{
				warningLabel.text = "The number must be between 1 and 60"
			}
		} else{
			warningLabel.text = "The number must be between 1 and 60"
		}
	}

	@IBAction func stopTimer(_ sender: Any) {
		timer.invalidate()
		timerLabel.text = "00:00"
	}
}

