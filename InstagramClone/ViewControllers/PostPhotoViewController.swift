//
//  PhotoMapViewController.swift
//  InstagramClone
//
//  Created by Danny on 10/2/18.
//  Copyright © 2018 Danny Rivera. All rights reserved.
//

import UIKit

class PostPhotoViewController: UIViewController {
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    
    var photo: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postImageView.image = photo
        postImageView.image = resize(image: postImageView.image!, newSize: CGSize(width: 75, height: 75))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x:0, y:0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    @IBAction func onPost(_ sender: Any) {
        DispatchQueue.main.async {
            Post.postUserImage(image: self.postImageView.image, withCaption: self.captionTextField.text!) {
                (success: Bool, error: Error?) -> Void in
                if success {
                    print("Photo successfully posted")
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("Photo failed to post")
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
