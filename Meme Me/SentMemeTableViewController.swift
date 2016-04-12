//
//  SentMemeTableViewController.swift
//  Meme Me
//
//  Created by Daniel Brand on 11.04.16.
//  Copyright © 2016 Daniel Brand. All rights reserved.
//

import Foundation
import UIKit

class SentMemeTableViewController: UITableViewController {
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
      
        if memes.count == 0 {
            let memeEditorcontroller = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
            presentViewController(memeEditorcontroller, animated: true, completion: nil)
        }
        
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let memeCell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! SentMemeTableViewCell
        let meme = memes[indexPath.row]
        
        
            memeCell.bottomText.text = meme.bottomMemeText
            memeCell.topText.text = meme.topMemeText
            memeCell.memeImageView.image = meme.memedImage

        
        return memeCell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let memeDetailController = storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        presentViewController(memeDetailController, animated: true, completion: nil)
    }
    
    
    @IBAction func openMemeEditor(sender: UIBarButtonItem) {
        showMemeEditor()
    }
    
    func showMemeEditor() {
        let memeEditorcontroller = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        presentViewController(memeEditorcontroller, animated: true, completion: nil)
    }
    
}
