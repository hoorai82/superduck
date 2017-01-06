//
//  Sprite.swift
//  SuperDuck
//
//  Created by byuli on 2016. 3. 6..
//  Copyright © 2016년 byuli. All rights reserved.
//

import SpriteKit

class Sprite {
    
    let duck = Duck()
    let spriteScale: CGFloat = 0.6
    
    init() {
        
    }
    
    func createDuck(_ _position:CGPoint, _duration:Double) -> SKSpriteNode {
        
        let sprite = SKAction.animate(with: self.duck.step(), timePerFrame: _duration)
        let fly = SKAction.sequence([SKAction.repeatForever(sprite)]);
        let flyDuck = SKSpriteNode(texture: self.duck.step1())
        

        flyDuck.name = "duck"
        
        flyDuck.position = _position
        flyDuck.setScale(spriteScale)
        flyDuck.run(fly)
        
        return flyDuck
    }
    
    func createMan(_ _position:CGPoint, _duration:Double, _name:String, _physics:Bool) -> SKSpriteNode {
        
        let man = SKAction.animate(with: self.duck.step(), timePerFrame: _duration)
        let fly = SKAction.sequence([SKAction.repeatForever(man)]);
        let flyMan = SKSpriteNode(texture: self.duck.step1())
 /*
        if _physics {
            flyMan.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 10.0, height: 10.0))
            flyMan.physicsBody?.categoryBitMask = UInt32(obstacleCategory)
            flyMan.physicsBody?.dynamic = true
            flyMan.physicsBody?.contactTestBitMask = UInt32(shipCategory)
            flyMan.physicsBody?.collisionBitMask = 0
        }
   */
        flyMan.name = _name
        flyMan.position = _position
        flyMan.setScale(spriteScale)
        flyMan.run(fly)
        
        return flyMan
    }
    
    
}
