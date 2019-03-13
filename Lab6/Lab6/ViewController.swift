//
//  ViewController.swift
//  Lab6
//
//  Created by Volodymyr Klymenko on 2019-03-05.
//  Copyright © 2019 Volodymyr Klymenko. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
	@IBOutlet var usernameInput: UITextField!
	@IBOutlet var passwordInput: UITextField!
	@IBOutlet var loginButton: UIButton!
	@IBOutlet var signUpButton: UIButton!
	@IBOutlet var wrongInput: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		signUpButton.isHidden = true
		wrongInput.isHidden = true
	}

	@IBAction func login(_ sender: Any) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext

		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
		request.returnsObjectsAsFaults = false
		var userFound = false

		do {
			let result = try context.fetch(request)
			for data in result as! [NSManagedObject]{
				let username = data.value(forKey: "username") as! String
				if username == usernameInput.text {
					userFound = true					
					let pwd = data.value(forKey: "password") as! String
					if passwordInput.text == pwd{
						wrongInput.isHidden = true
						signUpButton.isHidden = true
						if let userVC = storyboard?.instantiateViewController(withIdentifier: "User") as? UserViewController {
							userVC.username = username
							navigationController?.pushViewController(userVC, animated: true)
						}
					} else{
						wrongInput.text = "Wrong password 🤔"
						wrongInput.isHidden = false
					}
					break
				}
			}
		} catch{
			print("Couldn't fetch data :(")
		}


		if !userFound {
			wrongInput.text = "User not found ☹️"
			wrongInput.isHidden = false
			signUpButton.isHidden = false
		}

	}
	@IBAction func goToSignUpPage(_ sender: Any) {
		if let signUpVC = storyboard?.instantiateViewController(withIdentifier: "SignUp") as? SignUpViewController {

			navigationController?.pushViewController(signUpVC, animated: true)
		}
	}
}

