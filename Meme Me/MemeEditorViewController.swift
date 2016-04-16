//
//  ViewController.swift
//  Meme Me
//
//  Created by Daniel Brand on 31.03.16.
//  Copyright © 2016 Daniel Brand. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var topNavBar: UINavigationBar!
    @IBOutlet weak var topMemeText: UITextField!
    @IBOutlet weak var bottomMemeText: UITextField!
    
    let memeManger = MemeManager.sharedInstance
    var meme: MemeManager.Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        cancelButton.enabled = false
        shareButton.enabled = false
        initTextField("TOP", textField: topMemeText)
        initTextField("BOTTOM", textField: bottomMemeText)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loadImageFromAlbum(sender: UIBarButtonItem) {
        getImageFromSource(.PhotoLibrary)
    }
    
    @IBAction func takeImageFromCamera(sender: UIBarButtonItem) {
        getImageFromSource(.Camera)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = pickedImage
            
            shareButton.enabled = true
            cancelButton.enabled = true
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func hideToolBars(visible: Bool) {
        topNavBar.hidden = visible
        bottomToolBar.hidden = visible
    }
    
    func getImageFromSource(sourceTpye: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceTpye
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func initTextField(text: String!, textField: UITextField) {
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "Impact", size: 35)!,
            NSStrokeWidthAttributeName : -1.0
        ]
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = text
        textField.delegate = self
        textField.textAlignment = .Center
        textField.minimumFontSize = 12
        textField.adjustsFontSizeToFitWidth = true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField.text == "TOP" || textField.text == "BOTTOM") {
            textField.text = ""
        }
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:))    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:))    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomMemeText.isFirstResponder() {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomMemeText.isFirstResponder() {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    //Dismiss Keyboard, when user touches outside a textfield
    //http://samwize.com/2014/03/27/dismiss-keyboard-when-tap-outside-a-uitextfield-slash-uitextview/
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    func generateMemedImage() -> UIImage
    {
        hideToolBars(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        hideToolBars(false)
        
        return memedImage
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        if memeManger.getSize() == 0 {
            shareButton.enabled = false
            imageView.image = nil
            initTextField("TOP", textField: topMemeText)
            initTextField("BOTTOM", textField: bottomMemeText)
            cancelButton.enabled = false
        } else {
            dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    func saveMeme(memedImage: UIImage) {
        memeManger.addMemeWithFields(topMemeText.text, bottomMemeText: bottomMemeText.text, memedImage: memedImage, originalImage: imageView.image!)
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        let sharedMeme = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [sharedMeme], applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[AnyObject]?, error: NSError?) in
            if completed {
                self.saveMeme(sharedMeme)
                activityVC.dismissViewControllerAnimated(true, completion: nil)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        presentViewController(activityVC, animated: true, completion: nil)
    }
    
    func setMeme(meme: MemeManager.Meme) {
        topMemeText.text = meme.topMemeText
        bottomMemeText.text = meme.bottomMemeText
        imageView.image = meme.originalImage
        
        shareButton.enabled = true
        cancelButton.enabled = true
    }
}

