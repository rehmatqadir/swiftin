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

class ViewController: UIViewController, CLLocationManagerDelegate{

    let arrowView:UIImageView
    let locationLabel:UILabel
    let locationManager:CLLocationManager
    var currentLocation:CLLocation
    var destinationLocation:CLLocation
    var currentHeading:CLHeading
    var collectedVenues:NSMutableArray
    
    required init(coder aDecoder: NSCoder) {
        arrowView = UIImageView()
        locationLabel = UILabel()
        locationManager = CLLocationManager()
        currentLocation = CLLocation()
        destinationLocation = CLLocation()
        currentHeading = CLHeading()
        collectedVenues = NSMutableArray()
        super.init(coder: aDecoder)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        arrowView.frame = CGRectMake(0, self.view.frame.size.height/2-150, 400, 300)
        arrowView.image = UIImage (named: "Love-heart-arrow.png")
        self.view.addSubview(arrowView)
        locationLabel.frame = CGRectMake(100, arrowView.frame.origin.y + arrowView.frame.size.height + 50, self.view.frame.size.width - 200, 30)
        locationLabel.font = UIFont (name: "Arial", size: 12)
        locationLabel.textAlignment = NSTextAlignment.Center
        locationLabel.text = "location goes here"
        self.view.addSubview(locationLabel)
        let location = CLLocationCoordinate2D(latitude: 37, longitude: -122)
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        self.startLocationListener()

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func startLocationListener(){
        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
    }
    
    
   func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    
    if !locations.isEmpty && (CLLocationManager.locationServicesEnabled()) {
        currentLocation = locations[locations.count-1] as CLLocation
        var locationAsString = "\(currentLocation.coordinate.latitude)" + " " + "\(currentLocation.coordinate.longitude)"
        locationLabel.text = locationAsString
        
    }
    
    }
    
    
    func updateCurrentDistanceRemaining(){
        
        var currentLatitudeRadians = DegreesToRadians(currentLocation.coordinate.latitude)
        var currentLongitudeRadians = DegreesToRadians(currentLocation.coordinate.longitude)
        
        var destinationLatitudeRadians = DegreesToRadians(destinationLocation.coordinate.latitude)
        var destinationLongitudeRadians = DegreesToRadians(destinationLocation.coordinate.longitude)
        
        var latitudeDelta = Float (destinationLatitudeRadians - currentLatitudeRadians)
        
        var longitudeDelta = Float (destinationLongitudeRadians - currentLongitudeRadians)
        
        var a =  sinf(latitudeDelta/2) * sinf(latitudeDelta/2) + sinf(longitudeDelta/2) * sinf(longitudeDelta/2)
        
        var c = 2 * (atan2f((sqrt(a)), sqrtf(1-a)))
        
        var remainingDistanceMeters = c * 6371 * 1000
        var remainingDistanceFeet = remainingDistanceMeters * 3.281
        
//        ourPhoneFloatLat = startLocation.coordinate.latitude;
//        ourPhoneFloatLong = startLocation.coordinate.longitude;
//        self.strLatitude = [NSString stringWithFormat: @"%f", startLocation.coordinate.latitude];
//        self.strLongitude = [NSString stringWithFormat: @"%f", startLocation.coordinate.longitude];
//        
//        
//        // thisDistVenueLat = [appDelegate.closestVenue.venueLatitude floatValue];
//        // thisDistVenueLong = [appDelegate.closestVenue.venueLongitude floatValue];
//        
//        self.currentVenue = appDelegate.fullySortedArray[appDelegate.shakeIndex];
//        
//        thisDistVenueLat = [self.currentVenue.venueLatitude floatValue];
//        thisDistVenueLong = [self.currentVenue.venueLongitude floatValue];
//        
//        //  give latitude2,lang of destination   and latitude,longitude of first place.
//        
//        //this function returns distance in kilometer, the spherical law of cosines.
//        
//        float DistRadCurrentLat = degreesToRadians(startLocation.coordinate.latitude);
//        float DistRadCurrentLong = degreesToRadians(startLocation.coordinate.longitude);
//        float DistRadthisVenueLat = degreesToRadians(thisDistVenueLat);
//        float DistRadthisVenueLong = degreesToRadians(thisDistVenueLong);
//        //float deltLat = (radthisVenueLat - radcurrentLat);
//        float deltDistLat = (DistRadthisVenueLat - DistRadCurrentLat);
//        float deltDistLong = (DistRadthisVenueLong - DistRadCurrentLong);
//        
//        float a = (sinf(deltDistLat/2) * sinf(deltDistLat/2)) + ((sinf(deltDistLong/2) * sinf(deltDistLong/2)) * cosf(DistRadCurrentLat) * cosf(DistRadthisVenueLat));
//        float srootA = sqrtf(a);
//        float srootoneMinusA = sqrtf((1-a));
//        
//        float c = (2 * atan2f(srootA, srootoneMinusA));
//        
//        float distBetweenStartandVenueMeters = (c * 6371*1000); //radius of earth
//        
//        float distBetweenStartandVenueFeet = (distBetweenStartandVenueMeters*3.281);
//        
//        self.theDistance = [[NSString alloc] init];
        

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

