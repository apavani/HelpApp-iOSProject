//
//  SignUpViewController.swift
//  Help
//
//  Created by LiQihui on 11/27/14.
//  Copyright (c) 2014 Adarshkumar Pavani. All rights reserved.
//

import UIKit
import Foundation

protocol SignUpControllerDelegate{
    func myVCDidFinish(controller:SignUpViewController,Name:String,Password:String)
}

class SignUpViewController:
   
    UIViewController {
    @IBOutlet var PasswordTextField: UITextField!

    @IBOutlet var NameTextField: UITextField!
    
    @IBOutlet var EmailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    
    @IBAction func SignUp(sender: UIButton) {
        
        if(self.NameTextField.text=="" || self.PasswordTextField.text=="" || self.EmailTextField.text=="")
        {
            self.showNullAlert()
            return
        }
        
        if(delegate != nil){
            var user = PFUser()
            var username = NameTextField.text
            var password = PasswordTextField.text
            var email = EmailTextField.text
            user.username = username
            user.password = password
            user.email = email
            // other fields can be set just like with PFObject
            user["phone"] = "415-392-0202"
            
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool!, error: NSError!) -> Void in
                if error == nil {
                    // Hooray! Let them use the app now.
                } else {
                    //let errorString = error. as NSString
                    println("Error: \(error.localizedDescription)")
                    // Show the errorString somewhere and let the user try again.
                }
            }

            delegate!.myVCDidFinish(self, Name: username, Password: password)
        }

    }
    func setup()
    {
        }

    var delegate: SignUpControllerDelegate? = nil
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    func showNullAlert(){
        var alert = UIAlertController(title: "Required Field Is Left Blank", message: "Please enter the required field first, and then press the Sign Up button", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
