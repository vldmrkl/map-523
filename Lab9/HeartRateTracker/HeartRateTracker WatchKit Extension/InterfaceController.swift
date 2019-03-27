//
//  InterfaceController.swift
//  HeartRateTracker WatchKit Extension
//
//  Created by Volodymyr Klymenko on 2019-03-27.
//  Copyright © 2019 Volodymyr Klymenko. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    @IBAction func showHistory() {
        print("History")
    }

    @IBAction func clearHistory() {
        print("Clear")
    }
    

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
