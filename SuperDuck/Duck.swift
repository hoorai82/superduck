// ---------------------------------------
// Sprite definitions for 'Duck'
// Generated with TexturePacker 4.1.0
//
// http://www.codeandweb.com/texturepacker
// ---------------------------------------

import SpriteKit


class Duck {

    // sprite names
    let STEP1 = "step1"
    let STEP2 = "step2"
    let STEP3 = "step3"


    // load texture atlas
    let textureAtlas = SKTextureAtlas(named: "Duck")


    // individual texture objects
    func step1() -> SKTexture { return textureAtlas.textureNamed(STEP1) }
    func step2() -> SKTexture { return textureAtlas.textureNamed(STEP2) }
    func step3() -> SKTexture { return textureAtlas.textureNamed(STEP3) }


    // texture arrays for animations
    func step() -> [SKTexture] {
        return [
            step1(),
            step2(),
            step3()
        ]
    }


}
