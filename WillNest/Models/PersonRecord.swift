//
//  PersonRecord.swift
//  WillNest
//
//  Created by Harshit ‎ on 3/30/25.
//

import Foundation
import RealmSwift
import CoreLocation

class PersonRecord: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 1
    @objc dynamic var gender: String = "Select"
    @objc dynamic var weight: Int = 5
    @objc dynamic var location: String = "Unavailable"
}
