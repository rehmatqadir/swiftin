//
//  ViewController.swift
//  swiftin
//
//  Created by Applico on 3/31/15.
//  Copyright (c) 2015 masterryux. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Darwin

//Client ID
// CBI40DM3EQLVBDGDIXTAXCY44DIB1VRD1T1A5HHXNSFTCVIC
// Client Secret
// L1GT3YIVMPEIIIXP5NALNSSZQJZWOFAYYZ0YOEMDFYT35COT

class ViewController: UIViewController, CLLocationManagerDelegate{

    let arrowView:UIImageView
    let locationLabel:UILabel
    let destinationNameLabel:UILabel
    let locationManager:CLLocationManager
    var currentLocation:CLLocation
    var destinationLocation:CLLocationCoordinate2D?
    var currentLocationAsString:String
    var currentHeading:CLHeading
    var destinationVenue:DestinationVenue
    var collectedVenues:NSMutableArray
    
    required init(coder aDecoder: NSCoder) {
        arrowView = UIImageView()
        locationLabel = UILabel()
        destinationNameLabel = UILabel()
        locationManager = CLLocationManager()
        currentLocation = CLLocation()
        currentLocationAsString = String()
        currentHeading = CLHeading()
        destinationVenue = DestinationVenue()
        collectedVenues = NSMutableArray()
        super.init(coder: aDecoder)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        arrowView.frame = CGRectMake(20, 50, 390, 455)
        arrowView.contentMode = UIViewContentMode(rawValue: 2)!
        arrowView.image = UIImage (named: "rotated-heart-arrow.png")
        view.addSubview(arrowView)
        destinationNameLabel.frame = CGRectMake(100, arrowView.frame.origin.y + arrowView.frame.size.height, self.view.frame.size.width - 200, 30)
        self.view.addSubview(destinationNameLabel)
        locationLabel.font = UIFont (name: "Avenir-Heavy", size: 26)
        locationLabel.frame = CGRectMake(100, arrowView.frame.origin.y + arrowView.frame.size.height + 50, self.view.frame.size.width - 150, 30)
        locationLabel.font = UIFont (name: "Avenir-Heavy", size: 20)
        locationLabel.textAlignment = NSTextAlignment.Center
        locationLabel.text = "location goes here"
        self.view.addSubview(locationLabel)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        self.startLocationListener()
    }
    
    
    
    func startLocationListener(){
        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
    }
    
    
   func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    
    if !locations.isEmpty && (CLLocationManager.locationServicesEnabled()) {
        currentLocation = locations[locations.count-1] as CLLocation
        var locationAsString = "\(currentLocation.coordinate.latitude),"+"\(currentLocation.coordinate.longitude)"
        locationLabel.text = locationAsString
        currentLocationAsString = locationAsString
        
        if (collectedVenues.count == 0) {
            self.queryForVenues(currentLocation)
            return;
        }
        
        else {
             self.updateCurrentDistanceRemaining()
        }
       
    }
    
    }
    
    
    func queryForVenues(CLLocation){
        
        let todaysDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        let dateString = String(dateFormatter.stringFromDate(todaysDate))
        
        var urlString = String("https://api.foursquare.com/v2/venues/search?ll="+"\(currentLocationAsString)&client_id=CBI40DM3EQLVBDGDIXTAXCY44DIB1VRD1T1A5HHXNSFTCVIC&client_secret=L1GT3YIVMPEIIIXP5NALNSSZQJZWOFAYYZ0YOEMDFYT35COT"+"&query=sushi&v="+"\(dateString)")
        
        let url = NSURL(string: urlString)?
        
        var urlRequest:NSURLRequest! = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(urlRequest!, queue: NSOperationQueue.currentQueue()) { (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
            
            
            let outerDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as [String: AnyObject]
            var responseDictionary = outerDictionary["response"] as [String: AnyObject]
            var venuesArray = responseDictionary["venues"] as [AnyObject]
            println("\(venuesArray)")
            
            
            for  dest:AnyObject in venuesArray{
                var destinationVenue = DestinationVenue()
                if  (dest["name"]? != nil){
                    destinationVenue.destinationName = dest["name"] as? String
                }
                
                if  (dest["location"]? != nil) {
                    destinationVenue.latitudeString = ((dest["location"] as [String: AnyObject]!)["lat"] as Double!).description
                    destinationVenue.longitudeString = ((dest["location"] as [String: AnyObject]!)["lng"] as Double!).description
                    println("\(destinationVenue.longitudeString)")
                    destinationVenue.streetAddress = (dest["location"] as [String: AnyObject]!)["address"] as String!
                }
                
                self.collectedVenues.addObject(destinationVenue)
                
            }
            
             self.updateCurrentDistanceRemaining()
            
        }
    }
    
    
    func updateCurrentDistanceRemaining(){
        
        destinationVenue = self.collectedVenues.objectAtIndex(0) as DestinationVenue
        destinationLocation = CLLocationCoordinate2DMake((strtod(destinationVenue.latitudeString, nil)), (strtod(destinationVenue.longitudeString, nil)))
        destinationNameLabel.text = destinationVenue.destinationName as String!
        
        var currentLatitudeRadians = DegreesToRadians(currentLocation.coordinate.latitude)
        var currentLongitudeRadians = DegreesToRadians(currentLocation.coordinate.longitude)
        
        var destinationLatitudeRadians = DegreesToRadians(destinationLocation!.latitude)
        var destinationLongitudeRadians = DegreesToRadians(destinationLocation!.longitude)
        
        var latitudeDelta = Float (destinationLatitudeRadians - currentLatitudeRadians)
        
        var longitudeDelta = Float (destinationLongitudeRadians - currentLongitudeRadians)
        
        var a =  sinf(latitudeDelta/2) * sinf(latitudeDelta/2) + sinf(longitudeDelta/2) * sinf(longitudeDelta/2)
        
        var c = 2 * (atan2f((sqrt(a)), sqrtf(1-a)))
        
        var remainingDistanceMeters = c * 6371 * 1000
        var remainingDistanceFeet = remainingDistanceMeters * 3.281
        
        locationLabel.text = "\(remainingDistanceFeet.description) feet remaining"
        
//        
//        self.theDistance = [[NSString alloc] init];
        

    }
    
    
    func  locationManager(manager: CLLocationManager!, didUpdateHeading newHeading: CLHeading!) {
        
        if (collectedVenues.count > 0) {
        
        var currentLatitudeRadians = DegreesToRadians(currentLocation.coordinate.latitude)
        var currentLongitudeRadians = DegreesToRadians(currentLocation.coordinate.longitude)
        var destinationLatitudeRadians = DegreesToRadians(destinationLocation!.latitude)
        var destinationLongitudeRadians = DegreesToRadians(destinationLocation!.longitude)
        
        var latitudeDelta = Float (destinationLatitudeRadians - currentLatitudeRadians)
        
        var longitudeDelta = Float (destinationLongitudeRadians - currentLongitudeRadians)
        
        var y = sinf(Float (longitudeDelta)) * cosf(Float (destinationLatitudeRadians))
        var x = cosf(Float (currentLatitudeRadians)) * sinf(Float (destinationLatitudeRadians)) - (sinf(Float (currentLatitudeRadians)) * cosf(Float (destinationLatitudeRadians))  * cosf(Float (longitudeDelta)))
        var rotationAngleRadians = Double (atan2f(y, x))
        var initialBearingToDestination = rotationAngleRadians
        var initialBearingDegrees = RadiansToDegrees(initialBearingToDestination)
        
        if  initialBearingDegrees < 0 {
            initialBearingDegrees = initialBearingDegrees + 360
        }
        
        var angleToRotate = Double()
        
        if newHeading.trueHeading > initialBearingDegrees {
            
            angleToRotate = -(newHeading.trueHeading - initialBearingDegrees)
        }
        
        else {
            angleToRotate = initialBearingDegrees - newHeading.trueHeading
        }
        
        var angleToRotateRadians = angleToRotate * M_PI / 180.0
        
        UIView.animateWithDuration(0.8, animations: {
            self.arrowView.transform = CGAffineTransformMakeRotation(CGFloat (angleToRotateRadians))
        })
        
        }
    }
    
    func DegreesToRadians (value:Double) -> Double {
        return value * M_PI / 180.0
    }
    
    func RadiansToDegrees (value:Double) -> Double {
        return value * 180.0 / M_PI
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

