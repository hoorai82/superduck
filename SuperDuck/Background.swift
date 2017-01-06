//
//  Background.swift
//  SuperDuck
//
//  Created by byuli on 2016. 3. 6..
//  Copyright © 2016년 byuli. All rights reserved.
//
import SpriteKit

class Background {
    
    fileprivate var blockSize: CGFloat = 25
    fileprivate var letfBoxCount: Int = 9
    fileprivate var frameSize: CGSize?
    fileprivate var topBoxCount: Int?
    fileprivate var topHeight: CGFloat?

    fileprivate func createLine(_ pnt_start:CGPoint, pnt_end:CGPoint) -> SKShapeNode {
        
        let path = UIBezierPath()
        path.move(to: pnt_start)
        path.addLine(to: pnt_end)
        
        let dashed = CGPath (__byDashing: path.cgPath, transform: nil, phase: 0, lengths: [2,2], count: 2);
        let line = SKShapeNode(path: dashed!)
        line.strokeColor = UIColor.gray
        line.alpha = 0.5
        
        return line
    }
    
    
    internal init(left_box_count:Int, frame_size:CGSize) {
        self.letfBoxCount = left_box_count;
        self.frameSize = frame_size
        self.blockSize = frame_size.width / CGFloat(left_box_count)
        self.topBoxCount = Int((self.frameSize!.height / self.blockSize) - 1)
        self.topHeight = self.blockSize * CGFloat(self.topBoxCount! - 1) + 2
    }
    
    internal func createGrid() -> SKNode {
        
        let grid = SKNode()
        let boxSize:CGFloat = self.blockSize
        let topBoxCount:Int = self.topBoxCount!
        let resizeHeight:CGFloat = boxSize * CGFloat(topBoxCount - 1)
        
        for row:Int in 1 ..< Int(self.letfBoxCount) {
            let lineX:CGFloat = boxSize * CGFloat(row)
            grid.addChild(self.createLine(CGPoint(x: lineX, y: 0), pnt_end: CGPoint(x: lineX, y: resizeHeight)))
        }

        for row in 1 ..< topBoxCount {
            let lineY:CGFloat = boxSize * CGFloat(row)
            grid.addChild(self.createLine(CGPoint(x: 0, y: lineY), pnt_end: CGPoint(x: self.frameSize!.width, y: lineY)))

        }

        grid.position = CGPoint(x: 0, y: 0)
        return grid
    }
    
    internal func getBlackSize() -> CGFloat {
        return self.blockSize
    }
    
    internal func getTopBoxCount() -> Int {
        return self.topBoxCount! - 1
    }
    
    internal func getTopHeight() -> CGFloat {
        return self.topHeight!
    }
}
