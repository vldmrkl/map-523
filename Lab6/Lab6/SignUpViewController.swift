//
//  SignUpViewController.swift
//  Lab6
//
//  Created by Volodymyr Klymenko on 2019-03-05.
//  Copyright © 2019 Volodymyr Klymenko. All rights reserved.
//

import UIKit
import CoreData

class SignUpViewController: UIViewController {
	@IBOutlet var infoLabel: UILabel!
	@IBOutlet var usernameInput: UITextField!
	@IBOutlet var passwordInput: UITextField!
	@IBOutlet var ageInput: UITextField!
	@IBOutlet var addressInput: UITextField!
	@IBOutlet var signUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
		infoLabel.isHidden = true
    }
    
	@IBAction func signUp(_ sender: Any) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext

		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
		request.returnsObjectsAsFaults = false
		var userExists = false

		do {
			let result = try context.fetch(request)
			for data in result as! [NSManagedObject]{
				let username = data.value(forKey: "username") as! String
				if username == usernameInput.text {
					userExists = true
					infoLabel.isHidden = false
					infoLabel.text = "Username already exists"
					infoLabel.textColor = .red
					break
				}
			}
		} catch{
			print("Couldn't fetch data :(")
		}

		if !userExists {
			infoLabel.isHidden = true
			let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
			let newUser = NSManagedObject(entity: entity!, insertInto: context)

			newUser.setValue(usernameInput.text, forKey: "username")
			newUser.setValue(passwordInput.text, forKey: "password")
			newUser.setValue(addressInput.text, forKey: "address")
			newUser.setValue(Int16(ageInput.text!), forKey: "age")

			do {
				try context.save()
				infoLabel.text = "You were successfully added to the database 👍"
				infoLabel.textColor = .green
				infoLabel.isHidden = false
			} catch {
				print("Couldn't save data :(")
			}
		}
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
