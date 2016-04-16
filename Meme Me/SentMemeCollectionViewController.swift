//
//  MemeCollectionViewController.swift
//  Meme Me
//
//  Created by Daniel Brand on 11.04.16.
//  Copyright © 2016 Daniel Brand. All rights reserved.
//

import Foundation
import UIKit

class SentMemeCollectionViewController : UICollectionViewController {
    
    var memeManager = MemeManager.sharedInstance
    var longPressTarget: (cell: UICollectionViewCell, indexPath: NSIndexPath)?
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let space: CGFloat = 5.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if memeManager.getSize() == 0 {
            let memeEditorViewController = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
            presentViewController(memeEditorViewController, animated: true, completion: nil)
        }
        
        collectionView?.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memeManager.getSize()
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let memeCell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCell", forIndexPath: indexPath) as! SentMemeCollectionViewCell
        let meme = memeManager.getMemeAtIndex(indexPath.row)
        memeCell.memeImageView.image = meme.memedImage
        
        return memeCell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let memeDetailViewController = storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        memeDetailViewController.meme = memeManager.getMemeAtIndex(indexPath.row)
        navigationController?.pushViewController(memeDetailViewController, animated: true)
    }
    
    @IBAction func openMemeEditor(sender: UIBarButtonItem) {
        let memeEditorcontroller = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        presentViewController(memeEditorcontroller, animated: true, completion: nil)
    }

}