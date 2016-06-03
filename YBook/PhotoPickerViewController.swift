//
//  PhotoPickerViewController.swift
//  YBook
//
//  Created by linyi on 16/5/19.
//  Copyright © 2016年 linyi. All rights reserved.
//

import UIKit

@objc protocol PhotoPickerDelegate {
    func getImageFromPicker(image: UIImage)
}

class PhotoPickerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var alert: UIAlertController?
    var picker: UIImagePickerController!
    weak var delegate: PhotoPickerDelegate!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .OverFullScreen
        self.view.backgroundColor = UIColor.clearColor()
        
        self.picker = UIImagePickerController()
        self.picker.delegate = self
        self.picker.allowsEditing = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        if (self.alert == nil) {
            self.alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            
            self.alert?.addAction(UIAlertAction(title: "从相册选择", style: .Default, handler: { (action) -> Void in
                self.localPhoto()
            }))
            self.alert?.addAction(UIAlertAction(title: "打开相机", style: .Default, handler: { (action) -> Void in
                self.takePhoto()
            }))
            self.alert?.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: { (action) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            self.presentViewController(self.alert!, animated: true, completion: nil)
        }
    }
    
    /**
     拍照获取图片
     */
    func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            self.picker.sourceType = .Camera
            self.presentViewController(self.picker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "该设备没有相机", message: nil, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "关闭", style: .Cancel, handler: { (action) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    /**
     本地图库获取图片
     */
    func localPhoto() {
        self.picker.sourceType = .PhotoLibrary
        self.presentViewController(self.picker, animated: true, completion: nil)
    }
    
    /**
    *  UIImagePickerController Delegate
    */
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.picker.dismissViewControllerAnimated(true) { () -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.picker.dismissViewControllerAnimated(true) { () -> Void in
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                self.delegate.getImageFromPicker(image)
            })
        }
    }
}




























