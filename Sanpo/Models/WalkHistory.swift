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
    var distance: Double = 0.0

    init(_ date: Date, _ checkpoints: [CheckPoint]) {
        self.date = date
        self.checkpoints = checkpoints.map {
            WalkCheckPoint($0.title, $0.subtitle, [$0.latitude, $0.longitude])
        }
        super.init()
        self.distance = self.getDistance(checkpoints: checkpoints)
    }

    required init?(coder: NSCoder) {
        date = (coder.decodeObject(forKey: "date") as? Date) ?? Date()
        checkpoints = (coder.decodeObject(forKey: "CheckPoints") as? [WalkCheckPoint]) ?? []
        distance = coder.decodeDouble(forKey: "distance")
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(date, forKey: "date")
        coder.encode(checkpoints, forKey: "CheckPoints")
        coder.encode(distance, forKey: "distance")
    }
    
    func getCheckPoints() -> [CheckPoint] {
        return self.checkpoints.map {
            CheckPoint(title: $0.title,
                       subtitle: $0.subtitle,
                       coordinate: CLLocationCoordinate2D(latitude: $0.coodinate[0], longitude: $0.coodinate[1])
            )
        }
    }
    
    // 距離計算
    private func getDistance(checkpoints: [CheckPoint]) -> Double {
        guard let first = checkpoints.first else { return 0.0 }
        guard let last = checkpoints.last else { return 0.0 }
        
        let firstLocation = CLLocation(latitude: first.latitude, longitude: first.longitude)
        let lastLocation = CLLocation(latitude: last.latitude, longitude: last.longitude)
        return firstLocation.distance(from: lastLocation)
    }
}

// UserDefaults保存用変換クラス
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
