//
//  Model.swift
//  Relayance
//
//  Created by Amandine Cousin on 10/07/2024.
//

import Foundation

struct Client: Codable, Hashable {
    var nom: String
    var email: String
    private var dateCreationString: String
    var dateCreation: Date {
        Date.dateFromString(dateCreationString) ?? Date.now
    }
    
    enum CodingKeys: String, CodingKey {
        case nom
        case email
        case dateCreationString = "date_creation"
    }

    // for tests
    func creationDateString() -> String {
        return dateCreationString
    }

    init(name: String, email: String, dateCreationString: String) {
        self.nom = name
        self.email = email
        self.dateCreationString = dateCreationString
    }
    
    static func createClient(name: String, email: String) -> Client {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        return Client(name: name, email: email, dateCreationString: dateFormatter.string(from: Date.now))
    }
    
    func isNew() -> Bool {
        let aujourdhui = Date.now
        let dateCreation = self.dateCreation
        
        if aujourdhui.getYear() != dateCreation.getYear() ||
            aujourdhui.getMonth() != dateCreation.getMonth() ||
            aujourdhui.getDay() != dateCreation.getDay() {
            return false
        }
        return true
    }
    
    func clientExists(in clients: [Client]) -> Bool {
        return clients.contains { $0.email.lowercased() == self.email.lowercased() }
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(email.lowercased())
    }
    
    func formatDateToString(isoDateDFormatter: String = "dd-MM-yyyy") -> String {
        return Date.stringFromDate(self.dateCreation, isoDateDFormatter: isoDateDFormatter) ?? self.dateCreationString
    }
}
