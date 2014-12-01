//
//  AddMessageViewController.swift
//  Help
//
//  Created by demo on 10/13/14.
//  Copyright (c) 2014 Adarshkumar Pavani. All rights reserved.
//

import UIKit

protocol AddMessageControllerDelegate{
    func myVCDidFinish(controller:AddMessageViewController,message:String)
}

class AddMessageViewController: UIViewController {

    @IBOutlet var sendMessageView: UIView!
    var tap: UITapGestureRecognizer!

    @IBOutlet var messageText: UITextField!


    @IBAction func sendMessageButton(sender: UIButton) {
        
        if(self.messageText.text=="")
        {
            self.showNullAlert()
            return
        }
        
        if(delegate != nil){
            var message = self.messageText.text
            delegate!.myVCDidFinish(self, message:message)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        //Tap Gesture Recognizer
        self.tap=UITapGestureRecognizer()
        setup()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup()
    {
        self.sendMessageView.addGestureRecognizer(self.tap)
        self.tap.addTarget(self, action: "tapped:")
    }
    
    func tapped(sender: UIGestureRecognizer)
    {
        self.view.endEditing(true)
    }
    
 var delegate: AddMessageControllerDelegate? = nil
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func showNullAlert(){
        var alert = UIAlertController(title: "Message Field Is Left Blank", message: "Please enter a message first, and then press the Send button", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}
