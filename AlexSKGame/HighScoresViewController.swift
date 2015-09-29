//
//  HighScoresViewController.swift
//  AlexSKGame
//
//  Created by Alexander Tsu on 5/11/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

import UIKit
import CloudKit

/*
*Code Source:
*Code to handle iCloud querying was referenced from CloudKit Tutorial by Shrikar Archa: http://shrikar.com/ios8-cloudkit-tutorial-part-2/
*/

/*
protocol CloudKitDelegate {
    func errorUpdating(error: NSError)
    func modelUpdated()
}*/


class HighScoresViewController: UIViewController {
    
    var delegate : CloudKitDelegate?
    var highScores = [HighScore]()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var wcScore: UILabel!
    @IBOutlet weak var wcName: UILabel!
    @IBOutlet weak var wcDate: UILabel!
    
    @IBOutlet weak var secondPlace: UILabel!
    @IBOutlet weak var thirdPlace: UILabel!
    @IBOutlet weak var fourthPlace: UILabel!
    @IBOutlet weak var fifthPlace: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        startActivityIndicator()
        queryCloud()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Query iCloud for the high score records and store them as array of HighScore objects
    func queryCloud () {
        let container : CKContainer = CKContainer.defaultContainer()
        let sort = NSSortDescriptor(key: "Score", ascending: false)
        let publicDB : CKDatabase = container.publicCloudDatabase
        let query = CKQuery(recordType: "Score", predicate: NSPredicate(value: true))
        query.sortDescriptors = [sort]
        
        publicDB.performQuery(query, inZoneWithID: nil) {
            results, error in
            if error != nil {
                self.stopActivityIndicator()
                self.loadErrorMessage()
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate?.errorUpdating(error)
                    return
                }
            }
            else {
                //Remove any previous elements in the High Score Array and append newly queried high scores instead
                self.highScores.removeAll()
                for record in results {
                    let hs = HighScore(record: record as! CKRecord, database: publicDB)
                    self.highScores.append(hs)
                }
                
                //Load page text based on queried results
                self.loadPageText()
                self.stopActivityIndicator()
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate?.modelUpdated()
                    return
                }
            }
        }
    }
    
    //MARK: Activity Indicator Helpers
    
    func startActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.alpha = 0.0
    }
    
    //MARK: Display Helpers
    
    func loadPageText() {
        self.wcName.text = self.highScores[0].name
        self.wcScore.text = String(self.highScores[0].score)
        
        self.secondPlace.text = "2nd: " + self.highScores[1].name + " - " + String(self.highScores[1].score)
        self.thirdPlace.text = "3rd: " + self.highScores[2].name + " - " + String(self.highScores[2].score)
        self.fourthPlace.text = "4th: " + self.highScores[3].name + " - " + String(self.highScores[3].score)
        self.fifthPlace.text = "5th: " + self.highScores[4].name + " - " + String(self.highScores[4].score)
    }
    
    func loadErrorMessage() {
        let alert = UIAlertView()
        alert.title = "Error"
        alert.message = "Could not connect to iCloud. Please check your internet connection."
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    

}
