//
//  CheckPoint.swift
//  Sanpo
//
//  Created by yas on 2020/04/24.
//  Copyright © 2020 yas. All rights reserved.
//

import MapKit

class CheckPoint: NSObject, NSCoding, MKAnnotation {
    
    let title: String?
    var subtitle: String? = nil
    let coordinate: CLLocationCoordinate2D
    
    var latitude: Double { return self.coordinate.latitude }
    var longitude: Double { return self.coordinate.longitude }

    init(title: String?, subtitle: String? = nil, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
    required init?(coder: NSCoder) {
        title = (coder.decodeObject(forKey: "title") as? String) ?? ""
        subtitle = (coder.decodeObject(forKey: "subtitle") as? String)
        coordinate = (coder.decodeObject(forKey: "coordinate") as? CLLocationCoordinate2D) ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }

    func encode(with coder: NSCoder) {
        coder.encode(title, forKey: "title")
        coder.encode(subtitle, forKey: "subtitle")
        coder.encode(coordinate, forKey: "coordinate")
    }
}

