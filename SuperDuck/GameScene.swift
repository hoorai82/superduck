//
//  GameScene.swift
//  SuperDuck
//
//  Created by byuli on 2016. 2. 23..
//  Copyright © 2016년 byuli. All rights reserved.
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate
{
    let leftBoxCount:Int = 9
    var topBoxCount:Int?
    
    let score = Score()
    let sprite = Sprite()
    
    let spriteScale: CGFloat = 0.6
    var moveSize: CGFloat = 40
    var mapSize: CGSize?
    
    var superDuck = [SKSpriteNode]()
    var superDuckPostion: [String : [CGFloat]] = [String : [CGFloat]]()
    
    var helpMan: [String : SKSpriteNode] = [String : SKSpriteNode]()
    var slotFlag:[[Bool]] = [[Bool]]()
    
    
    var duration:Double = 0.2
    var gameStatus:NSString?
    
    var moveStatus: NSString?
    var addHelpManTime: CFTimeInterval = 0.0
    var speedUpTime: CFTimeInterval = 0.0
    
    var gameTime: Int = 0
    
    
    let shipCategory = 0x1 << 1
    let obstacleCategory = 0x1 << 2
    
    
    
    func removeAllSprite() {
        removeChildren(in: superDuck)
        for (_, obj) in helpMan {
            obj.removeFromParent()
        }
    }
    
    func getPosition(_ _cnt:Int) -> CGFloat {
        return (self.moveSize * CGFloat(_cnt)) + (self.moveSize/2)
    }
    
    
    
    
    func showSuperDuck() {
    
        
        let flyDuck = sprite.createDuck(CGPoint(x: self.getPosition(1), y: self.getPosition(1)), _duration: self.duration / 2)
        self.addChild(flyDuck)
        self.superDuck.append(flyDuck)
        
        self.superDuckPostion["x"]!.append(flyDuck.position.x)
        self.superDuckPostion["y"]!.append(flyDuck.position.y)
    
    }
    
    
    func appendSafeMan(_ name:String) {
        
        let man = self.helpMan.index(forKey: name)
        var positionXY = CGPoint(x: 0, y: 0)

        
        if man != nil {
            positionXY = CGPoint(x: helpMan[name]!.position.x, y: helpMan[name]!.position.y)
            self.helpMan[name]!.removeFromParent()
            self.helpMan.removeValue(forKey: name)
        }
        
        let flyMan = sprite.createMan(positionXY, _duration: self.duration / 2, _name: "", _physics: false)
        self.addChild(flyMan)
        self.superDuck.append(flyMan)
        
        self.superDuckPostion["x"]!.append(flyMan.position.x)
        self.superDuckPostion["y"]!.append(flyMan.position.y)
        
    }

    
    
    func showHelpMan(_ currentTime: CFTimeInterval) {
        
        let randomX = Int(arc4random()) % 8 + 1
        let randomY = Int(arc4random()) % 13 + 1
        
        for cnt in 0 ..< superDuckPostion["x"]!.count {
            if Int(superDuckPostion["x"]![cnt]) == randomX && Int(superDuckPostion["y"]![cnt]) == randomY {
                print("position sam")
                return
            }
        }
        
        let name = "man_" + String(currentTime)
        let pst = CGPoint(x: CGFloat((Int(self.moveSize) * randomX) + Int(self.moveSize/2)), y: CGFloat((Int(self.moveSize) * randomY) + Int(self.moveSize/2)))
        let man = sprite.createMan(pst, _duration: self.duration / 2, _name: name, _physics: true)
        
        self.addChild(man)
        self.helpMan[name] = man
        
    }
    

    
    
    func gameStart() {

        
        gameStatus = "start"
        moveStatus = "UP"
        self.speed = 1
        self.gameTime = 0
        
        
        self.superDuck = [SKSpriteNode]()
        self.superDuckPostion = [String : [CGFloat]]()
        self.superDuckPostion["x"] = [CGFloat]()
        self.superDuckPostion["y"] = [CGFloat]()
        
        self.showSuperDuck()
        self.appendSafeMan("man1")

        let direction = SKAction.run({
            
            let duckCount = self.superDuck.count;
            
            if duckCount > 1 {
                for cnt in (duckCount - 1)...1 {
                    self.superDuck[cnt].isHidden = self.superDuck[cnt - 1].isHidden
                    self.superDuckPostion["x"]![cnt] = self.superDuckPostion["x"]![cnt - 1]
                    self.superDuckPostion["y"]![cnt] = self.superDuckPostion["y"]![cnt - 1]
                }
            }

            
            let firstX = self.superDuckPostion["x"]![0]
            let firstY = self.superDuckPostion["y"]![0]
            
            if self.moveStatus == "UP" {
                self.superDuckPostion["y"]![0] = firstY + self.moveSize
                
                if self.superDuckPostion["y"]![0] >= self.getPosition(self.topBoxCount! + 1) {
                    self.superDuckPostion["y"]![0] = self.getPosition(-1)
                    
                }
            } else if self.moveStatus == "RIGHT" {
                self.superDuckPostion["x"]![0] = firstX + self.moveSize
                
                if self.superDuckPostion["x"]![0] >= self.getPosition(self.leftBoxCount + 1) {
                    self.superDuckPostion["x"]![0] = self.getPosition(-1)
                }
            } else if self.moveStatus == "DOWN" {
                self.superDuckPostion["y"]![0] = firstY - self.moveSize
                
                if self.superDuckPostion["y"]![0] <= self.getPosition(-1) {
                    self.superDuckPostion["y"]![0] = self.getPosition(self.topBoxCount! + 1)
                }
            } else if self.moveStatus == "LEFT" {
                self.superDuckPostion["x"]![0] = firstX - self.moveSize
                
                if self.superDuckPostion["x"]![0] <= self.getPosition(-1) {
                    self.superDuckPostion["x"]![0] = self.getPosition(self.leftBoxCount + 1)
                }
            }
        })
        
        let moveAll = SKAction.run({
       
            for cnt in 0 ..< self.superDuck.count {
                let item = self.superDuck[cnt]
                let pnt = CGPoint(x: self.superDuckPostion["x"]![cnt], y: self.superDuckPostion["y"]![cnt])

                if (pnt.y == self.getPosition(-1)) || (pnt.y == self.getPosition(self.topBoxCount! + 1)) || (pnt.x == self.getPosition(-1)) || (pnt.x == self.getPosition(self.leftBoxCount + 1)) {
                    item.isHidden = true
                    item.run(SKAction.move(to: pnt, duration:0.1), completion : {

                    })
                }else {
                    item.isHidden = false
                    item.run(SKAction.move(to: pnt, duration: self.duration), completion : {
                        if item.name == "" {
                            item.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1.0, height: 1.0))
                            item.physicsBody?.categoryBitMask = UInt32(self.obstacleCategory)
                            item.physicsBody?.isDynamic = true
                            item.physicsBody?.contactTestBitMask = UInt32(self.shipCategory)
                            item.physicsBody?.collisionBitMask = 0
                            item.name = "safe_man"
                        }
                        
                    })
                }
            }
            
        })
        
        let infoUpdate = SKAction.run({
            let deckSize = self.superDuck.count
            self.score.updateScore(deckSize - 1)
        })

        self.moveDuck(SKAction.sequence([infoUpdate, direction, moveAll, SKAction.wait(forDuration: self.duration)]))
    }
    
    func moveDuck(_ _sequence: SKAction) {
        self.run(SKAction.repeatForever(_sequence), withKey: "move")
    }
    func stopDuck() {
        self.removeAction(forKey: "move")
    }
    
    
    func gameOver() {
        if gameStatus == "end" {
            return
        }
        gameStatus = "end"
        self.stopDuck()
        removeAllSprite()
        gameStart()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        //print("firstBody.categoryBitMask",firstBody.categoryBitMask)
        //print("UInt32(shipCategory)", UInt32(shipCategory))
        //print("secondBody",secondBody.categoryBitMask)
        //print("UInt32(obstacleCategory)", UInt32(obstacleCategory))
        //print("firstBody.categoryBitMask & UInt32(shipCategory))", (firstBody.categoryBitMask & UInt32(shipCategory)))
        
        if (firstBody.categoryBitMask & UInt32(shipCategory)) != 0 && (secondBody.categoryBitMask & UInt32(obstacleCategory)) != 0 {
            let first_name = firstBody.node!.name!
            let second_name = secondBody.node!.name!
            
            print("boom duck!", first_name, second_name)
            
            if second_name != "duck" && second_name != "safe_man" {
                // print("safe man!", second_name)
                self.appendSafeMan(second_name)
            }else {
                
                print("game over")
                // self.gameOver()
            }
            

        }
        
    }
    
    
    
    init(size: CGSize, score_field: UILabel) {
        score.setScoreFild(score_field)
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        print("screen size :", self.view?.frame.size.width, self.view?.frame.size.height)
        
        self.backgroundColor = SKColor.white
        self.scaleMode = .resizeFill

        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        let bg = Background.init(left_box_count: self.leftBoxCount, frame_size: CGSize(width: self.view!.frame.size.width, height: self.view!.frame.size.height))
        self.addChild(bg.createGrid())

        self.moveSize = bg.getBlackSize()
        self.topBoxCount = bg.getTopBoxCount()
        
        
        self.gameStart()
        
    
        let rectLayer = CAShapeLayer()
        rectLayer.path = UIBezierPath(rect: CGRect(x: 0, y: self.view!.frame.size.height - bg.getTopHeight(), width: self.view!.frame.size.width, height: bg.getTopHeight())).cgPath
        rectLayer.fillColor = SKColor.white.cgColor
        self.view?.layer.mask = rectLayer



    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !self.superDuck[0].isHidden {
            for touch: AnyObject in touches {
                let location = touch.location(in: self)
                
                if self.moveStatus == "LEFT" || self.moveStatus == "RIGHT" {
                    
                    if location.y > superDuck[0].position.y {
                        if superDuck[0].position.y < 600 {
                            self.moveStatus = "UP"
                        }
                    } else if location.y < superDuck[0].position.y {
                        if superDuck[0].position.y > 12 {
                            self.moveStatus = "DOWN"
                        }
                    }
                }else if self.moveStatus == "UP" || self.moveStatus == "DOWN" {
                    if location.x > superDuck[0].position.x {
                        if superDuck[0].position.x < 360 {
                            self.moveStatus = "RIGHT"
                            
                        }
                    } else if location.x < superDuck[0].position.x {
                        if superDuck[0].position.x > 12 {
                            self.moveStatus = "LEFT"
                        }
                    }
                }
            }
        }
    }

    
    override func update(_ currentTime: TimeInterval) {
        
        if currentTime - self.addHelpManTime > 1 {
            self.addHelpManTime = currentTime + 1
            // self.showHelpMan(currentTime)

            self.gameTime = self.gameTime + 1
            // print(self.gameTime)

        }
        
        if currentTime - self.speedUpTime > 4 {
            self.speedUpTime = currentTime + 4
           //  self.speed = CGFloat(self.speed) + 0.2
            // print("speed UP ", self.speed)
        }
        
    }

    
}

