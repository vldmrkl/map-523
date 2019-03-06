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
	@IBOutlet var wrongPwdLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		signUpButton.isHidden = true
		wrongPwdLabel.isHidden = true
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
					print("Found user!")
					userFound = true
					
					let pwd = data.value(forKey: "password") as! String
					if passwordInput.text == pwd{
						wrongPwdLabel.isHidden = true
						print("Hello \(username)")
					} else{
						wrongPwdLabel.isHidden = false
					}
					break
				}
			}
		} catch{
			print("Couldn't fetch data :(")
		}


		if !userFound {
			signUpButton.isHidden = false
		}

//		let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
//		let newUser = NSManagedObject(entity: entity!, insertInto: context)
//
//		newUser.setValue(usernameInput.text, forKey: "username")
//		newUser.setValue(passwordInput.text, forKey: "password")
//
//		do {
//			try context.save()
//		} catch {
//			print("Couldn't save data :(")
//		}

	}
}

