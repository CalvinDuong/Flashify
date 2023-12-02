//
//  Item.swift
//  Flashify
//
//  Created by Jason Huynh on 12/2/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
