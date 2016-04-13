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
    
    let memeManager = MemeManager.sharedInstance
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if memeManager.getSize() == 0 {
            let memeEditorcontroller = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
            presentViewController(memeEditorcontroller, animated: true, completion: nil)
        }
        
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memeManager.getSize()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let memeCell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! SentMemeTableViewCell
        let meme = memeManager.getMemeAtIndex(indexPath.row)
        
        memeCell.bottomText.text = meme.bottomMemeText
        memeCell.topText.text = meme.topMemeText
        memeCell.memeImageView.image = meme.memedImage

        return memeCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let memeDetailViewController = storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        memeDetailViewController.meme = memeManager.getMemeAtIndex(indexPath.row)
        navigationController?.pushViewController(memeDetailViewController, animated: true)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            memeManager.removeMemeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            if memeManager.getSize() == 0 {
                showMemeEditor()
            }
        }
    }
    
    @IBAction func openMemeEditor(sender: UIBarButtonItem) {
        showMemeEditor()
    }
    
    func showMemeEditor() {
        let memeEditorcontroller = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        presentViewController(memeEditorcontroller, animated: true, completion: nil)
    }
    
}
