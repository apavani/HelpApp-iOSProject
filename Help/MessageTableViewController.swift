//
//  MessageTableViewController.swift
//  Help
//
//  Created by LiQihui on 10/13/14.
//  Copyright (c) 2014 Adarshkumar Pavani. All rights reserved.
//

import UIKit
import Foundation

class MessageTableViewController: UITableViewController, UITableViewDataSource, CLLocationManagerDelegate {
    
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
    var userList: [String] = []
    
    
    // *** STEP 1: STORE FIREBASE REFERENCES
    var messagesRef: Firebase!
    var senderRef: Firebase!
    var usersRef: Firebase!
    var firstSender : String!
    var firstMessage : String!
    @IBOutlet weak var messageField: UITextField!

    @IBAction func SendButton(sender: AnyObject) {
        if(self.messageField.text=="")
        {
            self.showNullAlert()
            return
        }
        
        let date = NSDate()
        var formatter = NSDateFormatter();
        formatter.dateFormat = "HH:mm";
        let defaultTimeZoneStr = formatter.stringFromDate(date);
        
        var userMessage = ["username": PFUser.currentUser().username, "message": self.messageField.text, "time":defaultTimeZoneStr ]
        
        self.messagesRef.setValue(userMessage)

    }
    
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

        
        
        // *** STEP 4: RECEIVE MESSAGES FROM FIREBASE
        messagesRef.observeEventType(.Value, withBlock: { (snapshot) in
            let sender: String! = snapshot.value.objectForKey("username") as? String
            let message: String! = snapshot.value.objectForKey("message") as? String
            let timeStamp: String! = snapshot.value.objectForKey("time") as? String
            
            println(self.userList.count)
            if(contains(self.userList, sender))
            {
                var newUser = UserInfo(name: sender, message: message, timeStamp: timeStamp)
                self.users.append(newUser)
                self.tableView.reloadData()
            }
            
        })
        
        /*
        senderRef.observeEventType(.Value, withBlock: { (snapshot) in
            self.message = snapshot.value as? String
        })
        
        usersRef.observeEventType(.Value, withBlock: { (snapshot) in
            self.message = snapshot.value as? String
        })
        */
        
    }

    func startUpdatingLocation()
    {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(animated: Bool) {
        startUpdatingLocation()
        locationTimer = NSTimer.scheduledTimerWithTimeInterval(300, target: self, selector: Selector("startUpdatingLocation"), userInfo: nil, repeats: true)
        
        //messageTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("loadData"), userInfo: nil, repeats: true)
        
       

    }
    
    override func viewDidDisappear(animated: Bool) {
        //self.timer.invalidate()
        self.locationTimer.invalidate()
        //self.messageTimer.invalidate()
    }
    
    func loadNewUserData()
    {
        if self.userList.isEmpty
        {
        self.userList.removeAll(keepCapacity: false)
        }
        var query =  PFUser.query()
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error:NSError!) -> Void in
            if error == nil{
                println("Size of users is \(objects.count)")
                for object in objects{
                    let distanceCalc = DistanceCalculator(lat1: self.myLatitudeFloat, lat2: object.objectForKey("Latitude") as Float, lon1: self.myLongitudeFloat , lon2: object.objectForKey("Longitude") as Float)
                    var distance : Float = distanceCalc.calculateDistance()
                    
                    if(distance < 100)
                    {
                        
                        var user =  object.objectForKey("username") as String
                        self.userList.append(user)
                    }
                }
                println("Finished saving nearby users")

            }
        }
        
        //Set up firebase only once you have all the user data
        setupFirebase()
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
        cell.timeStamp.text = user.timeStamp
        cell.messageText.text = user.messageText
        return cell
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        println("Saving Location")
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
        self.myLatitudeFloat = (self.myLatitude.description as NSString).floatValue
        self.myLongitudeFloat = (self.myLongitude.description as NSString).floatValue
        println("My Latitude: \(self.myLatitudeFloat)")
        println("My Longitude: \(self.myLongitudeFloat)")
        currUser.saveInBackgroundWithBlock { (success:Bool!, error:NSError!) -> Void in
            if (success==true && (error == nil))
            {
                //Done saving
                //After saving get the new list of users
                self.loadNewUserData()
            }
            return
        }
    }
    
    func showNullAlert(){
        var alert = UIAlertController(title: "Message Field Is Left Blank", message: "Please enter a message first, and then press the Send button", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
