//
//  ViewController.swift
//  FBSDK4.1
//
//  Created by Mohsin on 18/07/2015.
//  Copyright (c) 2015 Mohsin. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit

var loginUser = MyUser()

class ViewController: UIViewController,FBSDKLoginButtonDelegate, FBSDKAppInviteDialogDelegate {

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
            
            self.fbLoginView.readPermissions = ["public_profile","email","user_friends"]
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
                if let id = result["id"] as? NSString{
                    loginUser.fbID = String(id)
                }
            }
        })
    }
    
    
    func getFriends(){
        if FBSDKAccessToken.currentAccessToken().hasGranted("user_friends"){
            println("user_friends access")
            self.friendList()
        }
        else{
            
            println("user_friends not access")
            var loginManager = FBSDKLoginManager()
            loginManager.logInWithReadPermissions(["user_friends"], handler: { (result, error) -> Void in
                
                println(result)
                
                if result.declinedPermissions != nil &&  result.grantedPermissions.contains("user_friends"){
                    println("user_friends permission granted")
                    self.friendList()
                }
                else{
                    println("user_friends permission not granted")
                }
            })
        }
        
        
    }
    
    // helper func
    func friendList(){
        var request = FBSDKGraphRequest(graphPath:  "/\(loginUser.fbID)/invitable_friends", parameters: nil, HTTPMethod: "GET")

        
        request.startWithCompletionHandler { (req, data, error) -> Void in
            
            println("req: \(req)")
            println("data: \(data)")
            println("error: \(error)")
            
            
        }
        
    }
    
    
    
    
    
    // FBSDKAppInviteDialogDelegate
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [NSObject : AnyObject]!){
      println("complete")
    }
    

    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: NSError!){
        println("failer")
 
    }
    
    
    
    
    
    
    @IBAction func getFriends(sender: UIButton) {
        
      //  self.getFriends()
        
//        let MyUrl = NSURL(string: "https://fb.me/1482571955390929")
//        
//       UIApplication.sharedApplication().openURL(MyUrl!)
        
        var inviteContent = FBSDKAppInviteContent()
        inviteContent.appLinkURL = NSURL(string: "https://fb.me/1482571955390929")
        inviteContent.appInvitePreviewImageURL = NSURL(string: "http://a2.mzstatic.com/us/r30/Purple3/v4/fd/89/0c/fd890c6d-518c-9650-4adb-af4a4b74571f/screen322x572.jpeg")
        
        FBSDKAppInviteDialog.showWithContent(inviteContent, delegate: self)
        
    }
    
    
}



class MyUser{
    var fbID = ""
    
}
