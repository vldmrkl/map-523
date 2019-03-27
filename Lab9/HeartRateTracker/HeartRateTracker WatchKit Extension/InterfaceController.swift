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
    @IBOutlet weak var recordButton: WKInterfaceButton!
    @IBOutlet weak var stopButton: WKInterfaceButton!
    var heartRate: Int = 80
    var heartRateSet: [Int] = []
    var timer: Timer?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        let heartRateHistory = UserDefaults.standard.value(forKey: "heartRateHistory")
        if heartRateHistory == nil {
            UserDefaults.standard.set([[Int]](), forKey: "heartRateHistory")
        }
        stopButton.setEnabled(false)
    }

    @IBAction func startSession() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {(timer) in
            self.updateHeartRate()
        })
        recordButton.setEnabled(false)
        stopButton.setEnabled(true)
    }

    func updateHeartRate(){
        heartRate = Int.random(in: 80...110)
        heartRateSet.append(heartRate)
    }
    
    @IBAction func stopSession() {
        timer?.invalidate()
        var heartRateHistory = UserDefaults.standard.value(forKey: "heartRateHistory") as! [[Int]]
        heartRateHistory.append(heartRateSet)
        UserDefaults.standard.set(heartRateHistory, forKey: "heartRateHistory")
        heartRateSet.removeAll()
        recordButton.setEnabled(true)
        stopButton.setEnabled(false)
    }

    @IBAction func showHistory() {
        let heartRateHistory = UserDefaults.standard.value(forKey: "heartRateHistory")
        if heartRateHistory != nil{
            pushController(withName: "HistoryViewController", context: self)
        }
    }

    @IBAction func clearHistory() {
        var heartRateHistory = UserDefaults.standard.value(forKey: "heartRateHistory") as! [[Int]]
        heartRateHistory.removeAll()
        UserDefaults.standard.set(heartRateHistory, forKey: "heartRateHistory")
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
