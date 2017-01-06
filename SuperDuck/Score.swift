//
//  Score.swift
//  SuperDuck
//
//  Created by byuli on 2016. 3. 6..
//  Copyright © 2016년 byuli. All rights reserved.
//

import SpriteKit

class Score {
    
    var scoreField: UILabel!
    var score: Int!
    
    init() {
        
    }
    
    func setScoreFild (_ score_field:UILabel) {
        self.scoreField = score_field
    }
    
    func updateScore (_ _score:Int) {
        self.score = _score
        self.scoreField.text = String(self.score)
    }
    
}
