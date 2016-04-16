//
//  MemeViewDetailController.swift
//  Meme Me
//
//  Created by Daniel Brand on 12.04.16.
//  Copyright © 2016 Daniel Brand. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: MemeManager.Meme!
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: #selector(MemeDetailViewController.showMemeEditor(_:)))
        memeImageView.image = meme.memedImage
        tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.hidden = false
    }
    
    @IBAction func showMemeEditor(sender: UIBarButtonItem) {
        let memeEditorViewController = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        
        presentViewController(memeEditorViewController, animated: true, completion: {
            memeEditorViewController.setMeme(self.meme)
        })

    }
    
}
