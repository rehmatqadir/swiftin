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
        locationLabel.font = UIFont (name: "Arial", size: 18)
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
        locationLabel.text = "(currentLocation)"
    }
    

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

