//
//  PersonRecord.swift
//  WillNest
//
//  Created by Harshit ‎ on 3/30/25.
//

import Foundation

struct Prescription {
    let drugName: String
    let dosage: String
    let days: Int

    init(drugName: String, dosage: String, days: Int) {
        self.drugName = drugName
        self.dosage = dosage
        self.days = days
    }

    init(value: [String: Any]) {
        self.drugName = value["drugName"] as? String ?? ""
        self.dosage = value["dosage"] as? String ?? ""
        self.days = value["days"] as? Int ?? 0
    }
}
