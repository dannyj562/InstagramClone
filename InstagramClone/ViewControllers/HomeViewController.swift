//
//  HomeViewController.swift
//  InstagramClone
//
//  Created by Danny on 10/2/18.
//  Copyright © 2018 Danny Rivera. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController {
    @IBOutlet weak var photoTableView: UITableView!
    
    var instagramPosts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoTableView.dataSource = self
        self.photoTableView.delegate = self
        self.photoTableView.rowHeight = UITableViewAutomaticDimension
        self.photoTableView.estimatedRowHeight = 200
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.fetchNetworkRequest()
            DispatchQueue.main.async {
                print("Main UI Thread")
                self.photoTableView.reloadData()
                let refreshControl: UIRefreshControl = UIRefreshControl()
                self.createPullToRefreshControl(refreshControl: refreshControl)
                refreshControl.endRefreshing()
            }
        }
    }
    
    func createPullToRefreshControl(refreshControl: UIRefreshControl) {
        refreshControl.tintColor = UIColor.red
        refreshControl.addTarget(self, action: #selector(HomeViewController.didPullToRefresh(_ :)), for: .valueChanged)
        self.photoTableView.insertSubview(refreshControl, at: 0)
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        DispatchQueue.global(qos: .userInteractive).async {
            self.fetchNetworkRequest()
            DispatchQueue.main.async {
                self.photoTableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchNetworkRequest() {
        let query = PFQuery(className: "Post")
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.limit = 2
        
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            if let objects = objects {
                print("successful fetching object")
                for totalObjects in objects {
                    print(totalObjects)
                    self.instagramPosts.append(totalObjects)
                }
                self.photoTableView.reloadData()
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    @IBAction func onPhotoTaken(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
        self.present(vc, animated: true, completion: nil)
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

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instagramPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        for post in instagramPosts {
            print("Instagram Post \(post)")
            cell.post = post
            self.photoTableView.reloadData()
        }
        return cell
    }
}

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        //let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigation = storyboard.instantiateViewController(withIdentifier: "PostPhotoViewController")
        let newPostViewController = navigation as! PostPhotoViewController
        newPostViewController.photo = editedImage
        //newPostViewController.editedPhoto = editedImage
        
        present(navigation, animated: false, completion: nil)
    }
}
