//
//  PersonRecord.swift
//  WillNest
//
//  Created by Harshit ‎ on 3/30/25.
//

import Foundation
import RealmSwift

class Prescription: Object {
    @objc dynamic var drugName: String = ""
    @objc dynamic var dosage: String = ""
    @objc dynamic var days: Int = 0
}
