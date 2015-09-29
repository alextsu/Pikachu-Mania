//
//  MainViewController.swift
//  AlexSKGame
//
//  Created by Alexander Tsu on 5/11/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func howToPlay(sender: AnyObject) {
        let alert = UIAlertView()
        alert.title = "Instructions"
        alert.message = "Control Pikachu by tilting your iPhone. Tap to fire. Try to hit as many pokeballs as you can before time runs out!"
        alert.addButtonWithTitle("OK")
        alert.show()
    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
