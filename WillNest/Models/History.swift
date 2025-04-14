//
//  History.swift
//  WillNest
//
//  Created by Harshit ‎ on 4/9/25.
//

import Foundation


struct History {
    let disease: String
    let date: String
    
    init(disease: String, date: String) {
        self.disease = disease
        self.date = date
    }

    init(value: [String: Any]) {
        self.disease = value["disease"] as? String ?? ""
        self.date = value["date"] as? String ?? ""
    }
}
