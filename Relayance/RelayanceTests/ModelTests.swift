//
//  ModelTests.swift
//  RelayanceTests
//
//  Created by Yannick LEPLARD on 08/11/2024.
//

import XCTest
@testable import Relayance



final class ModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Date.customFormatter = nil
    }
    
    override func tearDown() {
        Date.customFormatter = nil
        super.tearDown()
    }
    
    func test_dateCreation_DevaitRetournerDateValide() {
        // Given
        let dateString = "2024-01-15T08:30:00Z"
        let client = Client(nom: "Test", email: "test@example.com", dateCreationString: dateString)
        
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
        let dateInvalide = "date invalide"
        let client = Client(nom: "Test", email: "test@example.com", dateCreationString: dateInvalide)
        
        // When
        let date = client.dateCreation
        
        // Then
        let maintenant = Date.now
        XCTAssertEqual(date.getYear(), maintenant.getYear())
        XCTAssertEqual(date.getMonth(), maintenant.getMonth())
        XCTAssertEqual(date.getDay(), maintenant.getDay())
    }
        
    func test_formatDateVersString_DevaitRetournerFormatCorrect() {
        // Given
        let dateString = "2024-01-15T08:30:00Z"
        let client = Client(nom: "Test", email: "test@example.com", dateCreationString: dateString)
        
        // When
        let dateFormatee = client.formatDateVersString()
        
        // Then
        XCTAssertEqual(dateFormatee, "15-01-2024")
    }
    
    func test_formatDateVersString_AvecDateInvalide_DevaitRetournerDateActuelle() {
        // Given
        let dateInvalide = "date invalide"
        let client = Client(nom: "Test", email: "test@example.com", dateCreationString: dateInvalide)
        
        // When
        let dateFormatee = client.formatDateVersString()
        
        // Then
        let maintenant = Date.now
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let datePrevue = dateFormatter.string(from: maintenant)
        
        XCTAssertEqual(dateFormatee, datePrevue)
    }
    
    func test_formatDateVersString_AvecFormattageDeDateEchoue_DevaitRetournerDateString() {
        // Given
        let dateString = "2024-01-15T08:30:00Z"
        let client = Client(nom: "Test", email: "test@example.com", dateCreationString: dateString)
        
        // Force l'échec du formatage en utilisant un formatter qui retournera nil
        let failingFormatter = DateFormatter()
        failingFormatter.dateFormat = "" // Format invalide qui forcera l'échec
        Date.customFormatter = failingFormatter
        
        // When
        let resultat = client.formatDateVersString()
        
        // Then
        XCTAssertEqual(resultat, client.getDateCreationString())
    }
    
    func test_estNouveauClient_AvecClientCreeAujourdhui_DevaitRetournerTrue() {
        // Given
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let dateString = formatter.string(from: Date.now)
        let client = Client(nom: "Test", email: "test@example.com", dateCreationString: dateString)
        
        // When
        let estNouveau = client.estNouveauClient()
        
        // Then
        XCTAssertTrue(estNouveau)
    }
    
    func test_estNouveauClient_AvecClientCreeHier_DevaitRetournerFalse() {
        // Given
        let hier = Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let dateString = formatter.string(from: hier)
        let client = Client(nom: "Test", email: "test@example.com", dateCreationString: dateString)
        
        // When
        let estNouveau = client.estNouveauClient()
        
        // Then
        XCTAssertFalse(estNouveau)
    }
    
    func test_estNouveauClient_AvecDateInvalide_DevaitRetournerTrue() {
        // Given
        let client = Client(nom: "Test", email: "test@example.com", dateCreationString: "date invalide")
        
        // When
        let estNouveau = client.estNouveauClient()
        
        // Then
        XCTAssertTrue(estNouveau) // Car une date invalide renvoie Date.now
    }
}
