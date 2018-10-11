//
//  PhotoCell.swift
//  InstagramClone
//
//  Created by Danny on 10/2/18.
//  Copyright © 2018 Danny Rivera. All rights reserved.
//

import UIKit
import Parse
import AFNetworking

class PhotoCell: UITableViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    var post: PFObject! {
        didSet {
            if let urlString = post.media.url {
                self.photoImageView.setImageWith(URL(string: urlString)!)
            }
            //let x = self.post.value(forKey: "media") as? PFFile
            //print(x?.url)
            //self.captionLabel.text = self.post.value(forKey: "caption") as? String
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async {
            self.photoImageView.file = self.post.value(forKey: "media") as? PFFile
            self.photoImageView.file?.getDataInBackground {
                (data: Data?, error: Error?) -> Void in
                if data != nil {
                    print("Data is not null \(data)")
                    self.photoImageView.image = UIImage(data: data!)
                }
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
