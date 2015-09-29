//
//  HighScore.swift
//  AlexSKGame
//
//  Created by Alexander Tsu on 5/11/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

import Foundation
import CloudKit

//Object representing High Scores from CloudKit. Stores name and score
class HighScore {
    var name: String!
    var score: Int!
    var record: CKRecord
    var database: CKDatabase
    
    init(record: CKRecord, database: CKDatabase) {
        self.record = record
        self.database = database
        
        self.name = record.objectForKey("Name") as! String
        self.score = record.objectForKey("Score") as! Int
    }
}