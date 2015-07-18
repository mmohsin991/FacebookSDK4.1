//
//  ViewController.swift
//  FBSDK4.1
//
//  Created by Mohsin on 18/07/2015.
//  Copyright (c) 2015 Mohsin. All rights reserved.
//

import UIKit
import FBSDKLoginKit


class ViewController: UIViewController,FBSDKLoginButtonDelegate {

    @IBOutlet weak var fbLoginView: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            println("already login")
            self.returnUserData()

        }
        else
        {
            println("not login")

            
            self.fbLoginView.delegate = self
            
            
            //self.fbLoginView.readPermissions = ["public_profile","email","user_friends","publish_stream", "user_videos","read_stream"]
            
            self.fbLoginView.readPermissions = ["public_profile","email"]
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!){
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
                println("now u can proceed")
                self.returnUserData()
            }
        }
    }
    
    /*!
    @abstract Sent to the delegate when the button was used to logout.
    @param loginButton The button that was clicked.
    */
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!){
        println("User Logged Out")

    }

    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else
            {
                let iddsa = result.name

                
                println(result)
                
//                println("fetched user: \(result)")
//                let userName : NSString = result.valueForKey("name") as! NSString
//                println("User Name is: \(userName)")
//                let userEmail : NSString = result.valueForKey("email") as! NSString
//                println("User Email is: \(userEmail)")
                let id = result["id"] as? NSString
                println(result.identifier)
                println(id)
//                println(result)
//                println(result)
            }
        })
    }
    
    
}

