//
//  ViewController.swift
//  StampCamera
//
//  Created by Owner on 2020/06/11.
//  Copyright © 2020 asOne. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var mainImageView :UIImageView!
    @IBOutlet var canvasView :UIView!
    
    var pickerController = UIImagePickerController()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("test1",appDelegate.isNewStampAdded)
        if appDelegate.isNewStampAdded == true {
            let stamp = appDelegate.stampArray.last!
            stamp.frame = CGRectMake(0, 0, 100, 100)
            stamp.center = mainImageView.center
            stamp.isUserInteractionEnabled = true
            canvasView.addSubview(stamp)
            appDelegate.isNewStampAdded = false
        }
    }
    
    

    @IBAction func cameraTapped() {
        let actionSheet :UIAlertController = UIAlertController(title: "写真を取得", message: "写真の取得先を選択してください", preferredStyle: UIAlertController.Style.actionSheet)
        
        let cancelAction :UIAlertAction = UIAlertAction(title: "Cancel",style: UIAlertAction.Style.cancel, handler: {(action :UIAlertAction!) -> Void in
            print("Cancel")})
        
        let cameraAction :UIAlertAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default, handler: {(action :UIAlertAction!) -> Void in
            print("Camera")
            self.pickerController.sourceType = UIImagePickerController.SourceType.camera
            self.present(self.pickerController, animated: true, completion: nil)
        })
        
        let libraryAction :UIAlertAction = UIAlertAction(title: "Library", style: UIAlertAction.Style.default, handler: {(action :UIAlertAction!) -> Void in
            print("Library")
            self.pickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(self.pickerController, animated: true, completion: nil)
        })
        
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(libraryAction)
        present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickerImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            mainImageView.image = pickerImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func stampTapped() {
        self.performSegue(withIdentifier: "ToStampList", sender: self)
    }
    
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    
    
    @IBAction func deleteTapped() {
        if canvasView.subviews.count > 1 {
            let lastStamp = canvasView.subviews.last! as! Stamp
            lastStamp.removeFromSuperview()
            
            if let index = appDelegate.stampArray.index(of: lastStamp) {
                appDelegate.stampArray.remove(at: index)
            }
        }
    }
    
    
    
    @IBAction func saveTapped() {
        UIGraphicsBeginImageContextWithOptions(canvasView.bounds.size, canvasView.isOpaque, 0.0)
        canvasView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(showResultOfSaveImage(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    @objc func showResultOfSaveImage(_ image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer) {
        var title = "保存完了"
        var message = "カメラロールに保存しました"
        
        if error != nil {
            title = "エラー"
            message = "保存に失敗しました"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

}
