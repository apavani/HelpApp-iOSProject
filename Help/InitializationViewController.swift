//
//  InitializationViewController.swift
//  Help
//
//  Created by demo on 10/12/14.
//  Copyright (c) 2014 Adarshkumar Pavani. All rights reserved.
//

import CoreLocation
import UIKit
import Foundation

class InitializationViewController: UIViewController,SignUpControllerDelegate{
    @IBOutlet var name: UITextField!
    @IBOutlet var initializationView: UIView!
 //   @IBOutlet var fbLoginView : FBLoginView!
    @IBOutlet var testingfirebase: UILabel!

    @IBOutlet var passwordTextField: UITextField!
    var tap: UITapGestureRecognizer!
    var myObject : PFObject!
    var myID : String!
    //var timer : NSTimer!
    
  // *** STEP 1: STORE FIREBASE REFERENCES
    var messagesRef: Firebase!
    func setupFirebase() {
        // *** STEP 2: SETUP FIREBASE
        messagesRef = Firebase(url: "https://helpapp.firebaseio.com/sender")
        messagesRef.setValue("Do you have data? You'll love Firebase.")
        // *** STEP 4: RECEIVE MESSAGES FROM FIREBASE
        messagesRef.observeEventType(.Value, withBlock: { (snapshot) in
            //let text = snapshot.value as? String
            let sender = snapshot.value as? String
            //print(text!+" "+sender!);
            self.testingfirebase.text = sender
            /*
            let message = Message(text: text, sender: sender)
            self.messages.append(message)
            self.finishReceivingMessage()
*/
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

   //     self.fbLoginView.delegate = self
    //    self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
        //Tap Gesture Recognizer
        self.tap=UITapGestureRecognizer()
        setup()
        setupFirebase() 
    }
    

    func myVCDidFinish(controller:SignUpViewController,Name:String,Password:String){
        name.text = Name
        passwordTextField.text = Password
        
        controller.navigationController?.popViewControllerAnimated(true)
    }
    // Facebook Delegate Methods
    /*
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
        println("User: \(user)")
        println("User ID: \(user.objectID)")
        println("User Name: \(user.name)")
        var userEmail = user.objectForKey("email") as String
        println("User Email: \(userEmail)")
        /* make the API call */
//        FBRequestConnection.startForMyFriendsWithCompletionHandler({ (connection, result, error: NSError!) -> Void in
//            if error == nil {
//                var friendObjects = result["data"] as [NSDictionary]
//                for friendObject in friendObjects {
//                    println(friendObject["id"] as NSString)
//                }
//                println("\(friendObjects.count)")
//            } else {
//                println("Error requesting friends list form facebook")
//                println("\(error)")
//            }
//        })
        // Get List Of Friends
//        var friendsRequest : FBRequest = FBRequest.requestForMyFriends()
//        friendsRequest.startWithCompletionHandler{(connection:FBRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
//            var resultdict = result as NSDictionary
//            println("Result Dict: \(resultdict)")
//            var data : NSArray = resultdict.objectForKey("data") as NSArray
//            
//            for i in 0..<data.count {
//                let valueDict : NSDictionary = data[i] as NSDictionary
//                let id = valueDict.objectForKey("id") as String
//                println("the id value is \(id)")
//            }
//            
//            var friends = resultdict.objectForKey("data") as NSArray
//            println("Found \(friends.count) friends")
//        }
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        println("User Logged Out")
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }
*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
                   //Stuff to do before you segue
        
            var text:String = segue.identifier as String!
            switch text {
            case "toIMController":
                if var nextViewController = segue.destinationViewController as? MessageTableViewController {
                    var nameString = self.name.text
                    var passwordString = self.passwordTextField.text
                    if(nameString=="" || passwordString=="")
                    {
                        self.showNullAlert()
                        return
                    }else{
                        PFUser.logInWithUsernameInBackground(nameString, password:passwordString) {
                            (user: PFUser!, error: NSError!) -> Void in
                            if user != nil {
                                // Do stuff after successful login.
                                self.myObject = PFObject(className: "PeopleLocation")
                                self.myObject["Name"]=user.username
                                self.myObject.saveInBackgroundWithBlock({ (success:Bool!, error:NSError!) -> Void in
                                    //Done
                                })

                                nextViewController.myID = self.myID
                            } else {
                                // The login failed. Check error to see why.
                               println("Error: \(error.localizedDescription)")
                            }
                        }
                    }

                }
            
            case "toSignUp":if var nextViewController = segue.destinationViewController as? SignUpViewController {
                 nextViewController.delegate = self
                }
            default:
                break
        }
    }
    
    func showNullAlert(){
    var alert = UIAlertController(title: "Name or Password Field Is Left Blank", message: "Please enter name and password first, and then press Sign In", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func setup()
    {
        self.initializationView.addGestureRecognizer(self.tap)
        self.tap.addTarget(self, action: "tapped:")
    }
    
    func tapped(sender: UIGestureRecognizer)
    {
    self.view.endEditing(true)
    }
}
    

