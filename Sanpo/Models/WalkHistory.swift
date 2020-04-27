//
//  WalkHistory.swift
//  Sanpo
//
//  Created by yas on 2020/04/24.
//  Copyright © 2020 yas. All rights reserved.
//
import MapKit

class WalkHistory: NSObject, Identifiable, NSCoding {

    var id = UUID()
    var date: Date
    var checkpoints: [WalkCheckPoint]

    init(_ date: Date, _ checkpoints: [CheckPoint]) {
        self.date = date
        self.checkpoints = checkpoints.map {
            WalkCheckPoint($0.title, $0.subtitle, [$0.latitude, $0.longitude])
        }
    }

    required init?(coder: NSCoder) {
        date = (coder.decodeObject(forKey: "date") as? Date) ?? Date()
        checkpoints = (coder.decodeObject(forKey: "CheckPoints") as? [WalkCheckPoint]) ?? []
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(date, forKey: "date")
        coder.encode(checkpoints, forKey: "CheckPoints")
    }
    
    func getCheckPoints() -> [CheckPoint] {
        return self.checkpoints.map {
            CheckPoint(title: $0.title,
                       subtitle: $0.subtitle,
                       coordinate: CLLocationCoordinate2D(latitude: $0.coodinate[0], longitude: $0.coodinate[1])
            )
        }
    }
}

class WalkCheckPoint: NSObject, Identifiable, NSCoding {
    var title: String?
    var subtitle: String?
    var coodinate: [Double]
    
    init(_ title: String?, _ subtitle: String?, _ coodinate: [Double]) {
        self.title = title
        self.subtitle = subtitle
        self.coodinate = coodinate
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(title, forKey: "title")
        coder.encode(subtitle, forKey: "subtitle")
        coder.encode(coodinate, forKey: "coodinate")
    }
    
    required init?(coder: NSCoder) {
        title = coder.decodeObject(forKey: "title") as? String
        subtitle = coder.decodeObject(forKey: "subtitle") as? String
        coodinate = (coder.decodeObject(forKey: "coodinate") as? [Double]) ?? [0.0]
    }
}
