//
//  MessageTableViewController.swift
//  Help
//
//  Created by LiQihui on 10/13/14.
//  Copyright (c) 2014 Adarshkumar Pavani. All rights reserved.
//

import UIKit
import Foundation

class MessageTableViewController: UITableViewController, UITableViewDataSource, AddMessageControllerDelegate, CLLocationManagerDelegate {
    
    var myLatitudeFloat : Float!
    var myLongitudeFloat : Float!
    var locationTimer : NSTimer!
    var messageTimer : NSTimer!
    
    var locationManager : CLLocationManager!
    var myLatitude : CLLocationDegrees!
    var myLongitude : CLLocationDegrees!
    
    
    var users : [UserInfo] = []
    var timeformatter = NSDateFormatter()
    var usersWithinRange : [UserInfo] = []
    var firstTime : Bool = true
    var myID: String!
    var addMessage : PFObject!
    var userList: [String] = [PFUser.currentUser().description]
    
    
    // *** STEP 1: STORE FIREBASE REFERENCES
    var messagesRef: Firebase!
    var senderRef: Firebase!
    var sender: String!
    var message: String!
    var firstSender : String!
    var firstMessage : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager = CLLocationManager()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.timeformatter.dateFormat = "hh:mm"
    }

    func setupFirebase() {
        // *** STEP 2: SETUP FIREBASE
        messagesRef = Firebase(url: "https://helpapp.firebaseio.com/message")
        senderRef = Firebase(url: "https://helpapp.firebaseio.com/sender")
        
        
        
        // *** STEP 4: RECEIVE MESSAGES FROM FIREBASE
        messagesRef.observeEventType(.Value, withBlock: { (snapshot) in
            self.sender = snapshot.value as? String
        })
        
        
        messagesRef.observeEventType(.Value, withBlock: { (snapshot) in
            self.message = snapshot.value as? String
        })
        
        if(self.firstTime)
        {
        self.firstTime = false
        self.firstSender = self.sender
        self.firstMessage = self.message
        }
        
    }

    func startUpdatingLocation()
    {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(animated: Bool) {
        setupFirebase()
        locationTimer = NSTimer.scheduledTimerWithTimeInterval(300, target: self, selector: Selector("startUpdatingLocation"), userInfo: nil, repeats: true)
        
        //messageTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("loadData"), userInfo: nil, repeats: true)
        
        var newUser = UserInfo(name: "1", message: "1")
        for (var i = 0; i<15; i++)
        {
        self.users.append(newUser)
        }
        self.tableView.reloadData()

    }
    
    override func viewDidDisappear(animated: Bool) {
        //self.timer.invalidate()
        self.locationTimer.invalidate()
        //self.messageTimer.invalidate()
    }
    
    func loadNewData()
    {
        self.userList.removeAll(keepCapacity: false)
        var query = PFQuery(className: "User")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error:NSError!) -> Void in
            if error == nil{
                
                for object in objects{
                    let distanceCalc = DistanceCalculator(lat1: self.myLatitudeFloat, lat2: object.objectForKey("Latitude") as Float, lon1: self.myLongitudeFloat , lon2: object.objectForKey("Longitude") as Float)
                    var distance : Float = distanceCalc.calculateDistance()
                    
                    if(distance < 100)
                    {
                        
                        var user =  object.objectForKey("Name") as String
                        self.userList.append(user)
    
                    }
                }
                //var newUser = UserInfo(name: user, message: self.message)
                //self.users.append(newUser)
                //self.tableView.reloadData()

            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.users.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("chatMessage") as? TableViewCell ?? TableViewCell()
        var user = self.users[indexPath.row]
        
        cell.nameField.text = user.name
        //cell.timeStamp.text = user.timeStamp
        cell.messageText.text = user.messageText
        return cell
    }
    
    //help message returned from AddMessageViewController
    func myVCDidFinish(controller:AddMessageViewController,message:String){
        
        var currUser = PFUser.currentUser()
        
        senderRef.setValue(currUser.username)
        messagesRef.setValue(message)
        controller.navigationController?.popViewControllerAnimated(true)
        
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var text:String = segue.identifier as String!
        switch text {
        case "toAddMessage":
            if var secondViewController = segue.destinationViewController as? AddMessageViewController {
                secondViewController.delegate = self
            }
                    
        default:
            break
        }
    }
    
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        print("Saving Location")
        // Most recent updates are appended to end of array,
        // so find the most recent update in last index.
        var loc : CLLocation = locations?[locations.count - 1] as CLLocation
        
        // The location stored as a coordinate.
        var coord : CLLocationCoordinate2D = loc.coordinate
        
        // Set the coordinates of location.
        self.myLatitude = coord.latitude
        self.myLongitude = coord.longitude
        
        // Tell location manager to stop collecting and updating location.
        self.locationManager.stopUpdatingLocation()
        
        //Setting other variables in the PFObject
        
       saveUserPosition() //Change: Removed the line: deviceID: self.myID from parameters
        
    }
    
    
    
    func saveUserPosition() -> Void{
        
        //Saving latitude and longitude for the current user
        var currUser = PFUser.currentUser()
        var addLocation : PFObject = PFObject(className: "PeopleLocation")
        currUser["Latitude"]=(self.myLatitude.description as NSString).floatValue
        currUser["Longitude"]=(self.myLongitude.description as NSString).floatValue
        currUser.saveInBackgroundWithBlock { (success:Bool!, error:NSError!) -> Void in
            if (success==true && (error == nil))
            {
                //Done saving
                //After saving get the new list of users
                self.loadNewData()
            }
            return
        }
    }
    
}
