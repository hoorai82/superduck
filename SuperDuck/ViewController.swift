//
//  ViewController.swift
//  SuperDuck
//
//  Created by byuli on 2016. 2. 23..
//  Copyright © 2016년 byuli. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {
    
    let leftBoxCount:Int = 9

    @IBOutlet weak var scoreField: UILabel!
    @IBOutlet weak var gameView: SKView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("screen size :", self.view.frame.size.width, self.view.frame.size.height)
        
        
        self.gameView.showsFPS = true
        self.gameView.showsNodeCount = true
        self.gameView.scene?.scaleMode = .resizeFill
        self.gameView.presentScene(GameScene(size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height), score_field: scoreField))

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

