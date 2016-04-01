//
//  Meme.swift
//  Meme Me
//
//  Created by Daniel Brand on 01.04.16.
//  Copyright © 2016 Daniel Brand. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    let topMemeText: String!
    let bottomMemeText: String!
    let memedImage: UIImage
    let originalImage: UIImage
    
    init(topMemeText: String!, bottomMemeText: String, memedImage: UIImage, originalImage: UIImage) {
        self.topMemeText = topMemeText
        self.bottomMemeText = bottomMemeText
        self.memedImage = memedImage
        self.originalImage = originalImage
    }
}
