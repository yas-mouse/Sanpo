//
//  Date+extension.swift
//  Sanpo
//
//  Created by yas on 2020/04/27.
//  Copyright © 2020 yas. All rights reserved.
//

import Foundation

extension Date {
    func formattedDate() -> String {
        let f = DateFormatter()
        f.timeStyle = .medium
        f.dateStyle = .medium
        f.locale = Locale(identifier: "ja_JP")
        return f.string(from: self)
    }
}

