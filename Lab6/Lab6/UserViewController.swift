//
//  UserViewController.swift
//  Lab6
//
//  Created by Volodymyr Klymenko on 2019-03-05.
//  Copyright © 2019 Volodymyr Klymenko. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
	@IBOutlet var welcomeLabel: UILabel!

	var username: String?

    override func viewDidLoad() {
        super.viewDidLoad()
		welcomeLabel.text = "Hello, \(username ?? "user") 👋"
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
