//
//  ModelTests.swift
//  RelayanceTests
//
//  Created by Yannick LEPLARD on 08/11/2024.
//

import XCTest
@testable import Relayance



final class ModelTests: XCTestCase {
    
    func test_dateCreation_DevaitRetournerDateValide() {
        // Given
        let dateString = "2024-01-15T08:30:00Z"
        let client = Client(name: "Test", email: "test@example.com", dateCreationString: dateString)
        
        // When
        let date = client.dateCreation
        
        // Then
        XCTAssertNotNil(date)
        XCTAssertEqual(date.getYear(), 2024)
        XCTAssertEqual(date.getMonth(), 1)
        XCTAssertEqual(date.getDay(), 15)
    }
    
    func test_dateCreation_AvecDateInvalide_DevaitRetournerDateActuelle() {
        // Given
        let invalidDate = "date invalide"
        let client = Client(name: "Test", email: "test@example.com", dateCreationString: invalidDate)
        
        // When
        let date = client.dateCreation
        
        // Then
        let now = Date.now
        XCTAssertEqual(date.getYear(), now.getYear())
        XCTAssertEqual(date.getMonth(), now.getMonth())
        XCTAssertEqual(date.getDay(), now.getDay())
    }
        
    func test_formatDateVersString_DevaitRetournerFormatCorrect() {
        // Given
        let dateString = "2024-01-15T08:30:00Z"
        let client = Client(name: "Test", email: "test@example.com", dateCreationString: dateString)
        
        // When
        let formattedDate = client.formatDateToString()
        
        // Then
        XCTAssertEqual(formattedDate, "15-01-2024")
    }
    
    func test_formatDateVersString_AvecDateInvalide_DevaitRetournerDateActuelle() {
        // Given
        let invalidDate = "date invalide"
        let client = Client(name: "Test", email: "test@example.com", dateCreationString: invalidDate)
        
        // When
        let formattedDate = client.formatDateToString()
        
        // Then
        let now = Date.now
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let expectedDate = dateFormatter.string(from: now)
        
        XCTAssertEqual(formattedDate, expectedDate)
    }
    
    func test_formatDateVersString_AvecFormattageDeDateEchoue_DevaitRetournerDateString() {
        // Given
        let dateString = "2024-01-15T08:30:00Z"
        let client = Client(name: "Test", email: "test@example.com", dateCreationString: dateString)
        
        // When
        let result = client.formatDateToString(isoDateDFormatter: "")
        
        // Then
        XCTAssertEqual(result, client.creationDateString())
    }
    
    func test_estNouveauClient_AvecClientCreeAujourdhui_DevaitRetournerTrue() {
        // Given
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let dateString = formatter.string(from: Date.now)
        let client = Client(name: "Test", email: "test@example.com", dateCreationString: dateString)
        
        // When
        let isNew = client.isNew()
        
        // Then
        XCTAssertTrue(isNew)
    }
    
    func test_estNouveauClient_AvecClientCreeHier_DevaitRetournerFalse() {
        // Given
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let dateString = formatter.string(from: yesterday)
        let client = Client(name: "Test", email: "test@example.com", dateCreationString: dateString)
        
        // When
        let isNew = client.isNew()
        
        // Then
        XCTAssertFalse(isNew)
    }
    
    func test_estNouveauClient_AvecDateInvalide_DevaitRetournerTrue() {
        // Given
        let client = Client(name: "Test", email: "test@example.com", dateCreationString: "date invalide")
        
        // When
        let isNew = client.isNew()
        
        // Then
        XCTAssertTrue(isNew) // Car une date invalide renvoie Date.now
    }
}
