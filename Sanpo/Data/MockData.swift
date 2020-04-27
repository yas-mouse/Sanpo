//
//  MockData.swift
//  Sanpo
//
//  Created by yas on 2020/04/27.
//  Copyright © 2020 yas. All rights reserved.
//

import MapKit

class MockData {
    // 名古屋駅
    static let latitude = 35.1715
    static let longitude = 136.8820
    static let location = CLLocation(latitude: latitude, longitude: longitude)
    static let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    static let checkpoints = [
        CheckPoint(title: "1", coordinate: .init(latitude: 35.1715, longitude: 136.8828)),
        CheckPoint(title: "2", coordinate: .init(latitude: 35.1719, longitude: 136.8835)),
        CheckPoint(title: "3", coordinate: .init(latitude: 35.1727, longitude: 136.8831)),
        CheckPoint(title: "4", coordinate: .init(latitude: 35.1735, longitude: 136.8827))
    ]
    static var history: [WalkHistory] = [
        WalkHistory(Date(), MockData.checkpoints),
        WalkHistory(Date(timeIntervalSinceNow: 60 * 60 * 24), MockData.checkpoints)
    ]
}

class MockLocationManager: LocationManager {

    override init() {
        super.init()
    }
    
    override var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: MockData.latitude, longitude: MockData.longitude)
    }
}
