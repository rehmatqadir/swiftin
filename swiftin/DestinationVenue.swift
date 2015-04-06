//
//  DestinationVenue.swift
//  swiftin
//
//  Created by Flatiron Student on 4/5/15.
//  Copyright (c) 2015 masterryux. All rights reserved.
//

import UIKit
import CoreLocation

class DestinationVenue: NSObject {
    
    var destinationName: String?
    var coordinates: CLLocation
    var latitudeString: String
    var longitudeString: String
    var streetAddress: String?
   
    
    override init(){
    
        destinationName = String()
        coordinates = CLLocation()
        latitudeString = String()
        longitudeString = String()
        streetAddress = String()
        super.init()
    }
}
