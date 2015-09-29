//
//  HighScoresTableViewController.swift
//  AlexSKGame
//
//  Created by Alexander Tsu on 5/12/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

import UIKit
import CloudKit

/*
*Code Source:
*Code to handle iCloud querying was referenced from CloudKit Tutorial by Shrikar Archa: http://shrikar.com/ios8-cloudkit-tutorial-part-2/
*/

protocol CloudKitDelegate {
    func errorUpdating(error: NSError)
    func modelUpdated()
}

class HighScoresTableViewController: UITableViewController {

    var delegate : CloudKitDelegate?
    var highScores = [HighScore]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Loading..."
        queryCloud()

    }

    /*
    override func viewDidAppear(animated: Bool) {
        queryCloud()
    }*/
    
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
                dispatch_async(dispatch_get_main_queue()) {
                    self.loadErrorMessage()
                    self.navigationItem.title = "Loading Error"
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
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                    self.navigationItem.title = "High Scores"
                    NSLog("Data Reloaded")
                    self.delegate?.modelUpdated()
                    return
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 5
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("hsCell", forIndexPath: indexPath) as! HighScoresTableViewCell
        
        if highScores.isEmpty == false {
            cell.hsName.text = highScores[indexPath.row].name
            cell.hsScore.text = String(highScores[indexPath.row].score)
        }
        
        return cell
    }
    
    func loadErrorMessage() {
        
        let alert = UIAlertView()
        alert.title = "Error"
        alert.message = "Could not connect to iCloud. Please check that you are signed into iCloud and that your internet connection is working."
        alert.addButtonWithTitle("OK")
        alert.show()
    }



}
