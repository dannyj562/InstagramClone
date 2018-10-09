//
//  LoginViewController.swift
//  InstagramClone
//
//  Created by Danny on 10/2/18.
//  Copyright © 2018 Danny Rivera. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        loginUser()
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        registerUser()
    }
    
    private func registerUser() {
        let newUser = PFUser()
        newUser.username = usernameTextField.text
        newUser.password = passwordTextField.text
        
        DispatchQueue.global(qos: .userInteractive).async {
            newUser.signUpInBackground { (success: Bool, error: Error?) -> Void in
                if success {
                    print("Created a user")
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                } else {
                    print(error!.localizedDescription)
                }
            }
            DispatchQueue.main.async {
                
            }
        }
        
    }
    
    private func loginUser() {
        DispatchQueue.main.async {
            PFUser.logInWithUsername(inBackground: self.usernameTextField.text!, password: self.passwordTextField.text!) {
                (user: PFUser?, error: Error?) -> Void in
                if user != nil {
                    print("You are logged in")
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                } else {
                    print("User logged in failed: \(error!.localizedDescription)")
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
