//
//  GameViewController.swift
//  AlexSKGame
//
//  Created by Alexander Tsu on 5/10/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

/*
* Author's Note:
* I've elected to leave the majority of this View Controller the same as default except for two things. First, I initialize the AVAudioPlayer in viewDidLoad. 
* Second, I've added code to handle the segues at the bottom.
*/

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController {

     var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            scene.viewController = self
            
            let url = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("pokemonBossTheme", ofType: "mp3")!)
            var error: NSError?
            
           
            audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            
            skView.presentScene(scene)
        }
    }

    override func viewDidDisappear(animated: Bool) {
        audioPlayer.stop()
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    //MARK: Segue Handlers
    
    //When user hits home bar button, present UIAlertView before segue
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        let alert = UIAlertView()
        alert.delegate = self
        alert.title = "Home"
        alert.message = "Are you sure you want to leave this game?"
        alert.addButtonWithTitle("No")
        alert.addButtonWithTitle("Yes")
        alert.show()

        return false
    }
    
    //Perform Segue if user selects "yes" in UIAlertView
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) -> Bool{
        let defaults = NSUserDefaults.standardUserDefaults()
        
        switch buttonIndex{
            
        case 1:
            NSLog("Yes");
            self.audioPlayer.stop()
            self.performSegueWithIdentifier("returnHome", sender: self)
            return true;
        case 0:
            NSLog("No");

            return false;
        default:
            NSLog("Default");
            return false;
        }
    }
    

}
