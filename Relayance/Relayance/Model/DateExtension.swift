//
//  DateExtension.swift
//  Relayance
//
//  Created by Amandine Cousin on 10/07/2024.
//

import Foundation

extension Date {
    // pour tests
    static var customFormatter: DateFormatter?
    
    static func dateFromString(_ isoString: String) -> Date? {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withFullDate]
        
        return isoDateFormatter.date(from: isoString)
    }
    
    static func stringFromDate(_ date: Date) -> String? {
        // pour tests
        if let customFormatter = customFormatter {
            let result = customFormatter.string(from: date)
            return result.isEmpty ? nil : result
        }
        
        let isoDateFormatter = DateFormatter()
        isoDateFormatter.dateFormat = "dd-MM-yyyy"
        
        return isoDateFormatter.string(from: date)
    }
    
    func getDay() -> Int {
        return Calendar.current.component(.day, from: self)
    }
    
    func getMonth() -> Int {
        return Calendar.current.component(.month, from: self)
    }
    
    func getYear() -> Int {
        return Calendar.current.component(.year, from: self)
    }
    
}
