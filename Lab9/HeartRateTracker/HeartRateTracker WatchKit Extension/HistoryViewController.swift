//
//  HistoryViewController.swift
//  HeartRateTracker WatchKit Extension
//
//  Created by Volodymyr Klymenko on 2019-03-27.
//  Copyright © 2019 Volodymyr Klymenko. All rights reserved.
//

import WatchKit

class HistoryViewController: WKInterfaceController {
    @IBOutlet weak var sessionsTable: WKInterfaceTable!
    

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        let heartRateHistory = UserDefaults.standard.value(forKey: "heartRateHistory") as! [[Int]]

        sessionsTable.setNumberOfRows(heartRateHistory.count, withRowType: "SessionRowController")
        for (i, session) in heartRateHistory.enumerated() {
            let sum = session.reduce(0, +)
            let avg = sum / session.count
            let sessionId = String(i+1)
            let max = String(session.max()!)
            let min = String(session.min()!)
            let row = sessionsTable.rowController(at: i) as! SessionRowController

            row.idLabel.setText(sessionId)
            row.minLabel.setText(min)
            row.maxLabel.setText(max)
            row.avgLabel.setText(String(avg))

        }
    }


    override func willActivate() {
        // This method is called when watch view controller is about to be
        // visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer
        // visible
        super.didDeactivate()
    }

}
