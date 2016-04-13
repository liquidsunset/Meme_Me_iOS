//
//  MemeCollectionViewController.swift
//  Meme Me
//
//  Created by Daniel Brand on 11.04.16.
//  Copyright © 2016 Daniel Brand. All rights reserved.
//

import Foundation
import UIKit

class SentMemeCollectionViewController : UICollectionViewController, UIGestureRecognizerDelegate {
    
    var memeManager = MemeManager.sharedInstance
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let space: CGFloat = 5.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
        
        //http://stackoverflow.com/questions/29241691/how-do-i-use-uilongpressgesturerecognizer-with-a-uicollectionviewcell-in-swift
        //http://flexmonkey.blogspot.co.at/2014/11/improved-interaction-design-for.html
        let longPressGR = UILongPressGestureRecognizer(target: self, action: Selector("handleLongPress"))
        longPressGR.minimumPressDuration = 1.0
        longPressGR.delaysTouchesBegan = true
        longPressGR.delegate = self
        collectionView?.addGestureRecognizer(longPressGR)
    }
    
    func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        
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