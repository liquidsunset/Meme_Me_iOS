//
//  MemeManager.swift
//  Meme Me
//
//  Created by Daniel Brand on 13.04.16.
//  Copyright © 2016 Daniel Brand. All rights reserved.
//

import Foundation
import UIKit

class MemeManager {
    
    private var memes = [Meme]()
    
    static let sharedInstance = MemeManager()
    private init(){}
    
    func addMeme(meme: Meme) {
        memes.append(meme)
    }
    
    func addMemeWithFields(topMemeText: String!, bottomMemeText: String!, memedImage: UIImage, originalImage: UIImage!) {
        memes.append(Meme(topMemeText: topMemeText, bottomMemeText: bottomMemeText, memedImage: memedImage, originalImage: originalImage))
    }
    
    func removeMemeAtIndex(index: Int) {
        memes.removeAtIndex(index)
    }
    
    func getSize() -> Int {
        return memes.count
    }
    
    func getMemes() -> [Meme] {
        return memes
    }
    
    func getMemeAtIndex(index: Int) -> Meme {
        return memes[index]
    }
    
    struct Meme {
        let topMemeText: String!
        let bottomMemeText: String!
        let memedImage: UIImage
        let originalImage: UIImage!
    }
}
