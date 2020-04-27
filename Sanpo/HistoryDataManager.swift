//
//  HistoryData.swift
//  Sanpo
//
//  Created by yas on 2020/04/25.
//  Copyright © 2020 yas. All rights reserved.
//

import Foundation

class HistoryDataManager {
    static let key = "WalkHistoryList"
    
    static func set(walkHistory: WalkHistory) {
        var walkHistoryList = self.load()
        walkHistoryList.append(walkHistory)
        UserDefaults.standard.set(walkHistoryList, forKey: key)
    }

    static func setAll(walkHistoryList: [WalkHistory]) {
        if walkHistoryList.isEmpty {
            return
        }
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: walkHistoryList, requiringSecureCoding: false) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    static func load() -> [WalkHistory] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        guard let walkHistoryList = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [WalkHistory] else { return [] }
        return walkHistoryList
    }
}
