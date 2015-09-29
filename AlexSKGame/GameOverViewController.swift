//
//  GameOverViewController.swift
//  AlexSKGame
//
//  Created by Alexander Tsu on 5/11/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

import UIKit
import CloudKit

class GameOverViewController: UIViewController, UITextFieldDelegate {
    
    var imputtedName: String!
    var scoreNumber: Int!
    
    @IBOutlet weak var scorePoints: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var scoreboardButton: UIButton!
    
    //Get score from default and display it
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var score = NSUserDefaults.standardUserDefaults().integerForKey("score")
        scorePoints.text = String(score)
        
        scoreNumber = score
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Save a record to CloudKit based on the name and score of the current user
    @IBAction func submitToScoreboard(sender: UIButton) {
        self.scoreboardButton.userInteractionEnabled = false
        self.scoreboardButton.alpha = 0
        self.imputtedName = self.nameField.text
        
        var container : CKContainer = CKContainer.defaultContainer()
        var publicDB : CKDatabase = container.publicCloudDatabase
        let privateDB : CKDatabase = container.privateCloudDatabase
        
        let scoreRecord = CKRecord(recordType: "Score")
        scoreRecord.setValue(scoreNumber, forKey: "Score")
        scoreRecord.setValue(imputtedName, forKey: "Name")
        publicDB.saveRecord(scoreRecord, completionHandler: { (record, error)  in
            NSLog("Saved to cloud kit")
        })
        
        let alert = UIAlertView()
        alert.title = "Score Submitted!"
        alert.message = "Thanks for submitting your score! Feel free to play again."
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
