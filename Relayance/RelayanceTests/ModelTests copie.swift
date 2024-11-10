//
//  ModelTests.swift
//  RelayanceTests
//
//  Created by Yannick LEPLARD on 08/11/2024.
//

import XCTest
@testable import Relayance



final class ModelTests: XCTestCase {
    
    func testInit() {
        // Given
        let nom = "Jean Dupont"
        let email = "jean.dupont@example.com"
        let dateCreationString = "2023-02-20T09:15:00Z"
        
        // When
        let client = Client(nom: nom, email: email, dateCreationString: dateCreationString)
        
        // Then
        XCTAssertEqual(client.nom, nom, "Le nom du client ne correspond pas")
        XCTAssertEqual(client.email, email, "L'email du client ne correspond pas")
        XCTAssertEqual(client.getDateCreationString(), dateCreationString, "La date de création sous forme de chaîne ne correspond pas")
        
        if let expectedDate = Date.dateFromString(dateCreationString) {
            XCTAssertEqual(client.dateCreation, expectedDate, "La date de création convertie ne correspond pas")
        } else {
            XCTFail("La conversion de dateCreationString en Date a échoué")
        }
    }
    
    func testCreerNouveauClient() {
        // Given
        let nom = "Jane Doe"
        let email = "jane.doe@example.com"
        
        // When
        let client = Client.creerNouveauClient(nom: nom, email: email)
        
        // Then
        XCTAssertEqual(client.nom, nom, "Le nom du client ne correspond pas")
        XCTAssertEqual(client.email, email, "L'email du client ne correspond pas")
        
        if let dateCreation = Date.dateFromString(client.getDateCreationString()) {
            XCTAssertEqual(client.dateCreation, dateCreation, "La date de création ne correspond pas")
        } else {
            XCTFail("La conversion de dateCreationString en Date a échoué")
        }
    }
     
    func testEstNouveauClient() {
        // Given
        let nouveauClient = Client.creerNouveauClient(nom: "NouveauClient", email: "NouveauClient@example.com")
        let clientExistant = Client(nom: "ClientExistant", email: "ClientExistant@example.com", dateCreationString: "1990-02-20T09:15:00Z")
        
        // When
        let isNew = nouveauClient.estNouveauClient()
        
        // Then
        XCTAssertTrue(isNew, "Le client devrait être considéré comme nouveau")
        XCTAssertFalse(clientExistant.estNouveauClient(), "Le client existe depuis longtemps. Il ne devrait pas être considéré comme nouveau.")
    }
    
    func testClientExiste() {
        // Given
        let client1 = Client(nom: "Bob", email: "bob@example.com", dateCreationString: "2023-04-01T10:00:00Z")
        let client2 = Client(nom: "Charlie", email: "charlie@example.com", dateCreationString: "2023-05-15T15:30:00Z")
        let clientsList = [client1, client2]
        
        // When
        let clientExists = client1.clientExiste(clientsList: clientsList)
        let clientDoesNotExist = Client(nom: "David", email: "david@example.com", dateCreationString: "2023-06-30T20:45:00Z").clientExiste(clientsList: clientsList)
        
        // Then
        XCTAssertTrue(clientExists, "Le client1 devrait exister dans la liste")
        XCTAssertFalse(clientDoesNotExist, "Le client David ne devrait pas exister dans la liste")
    }
    
//    func testFormatDateVersString() {
//        // Given
//        let client = Client(nom: "Eve", email: "eve@example.com", dateCreationString: "2023-07-10T12:00:00Z")
//        
//        // When
//        let formattedDate = client.formatDateVersString()
//        
//        // Then
//        XCTAssertEqual(formattedDate, "10-07-2023", "La date formatée ne correspond pas")
//    }
    
    func testFormatDateVersString() {
        // !!! le test avec une date invalide ne peut pas fonctionner car la fonction formatDateVersString
        // !!! utilise des fonctions qui renvoient toujours une String, et donc ne peut jamais renvoyer la chaîne originale
        
        // Given
        let validDateString = "2023-07-10T12:00:00Z"
//        let invalidDateString = "date_invalide"
        let clientWithValidDate = Client(nom: "Eve", email: "eve@example.com", dateCreationString: validDateString)
//        let clientWithInvalidDate = Client(nom: "EveNotValid", email: "eveNotValid@example.com", dateCreationString: invalidDateString)
        
        // When
        let formattedValidDate = clientWithValidDate.formatDateVersString()
//        let formattedInvalidDate = clientWithInvalidDate.formatDateVersString()
        
        // Then
        XCTAssertEqual(formattedValidDate, "10-07-2023", "La date formatée ne correspond pas")
//        XCTAssertEqual(formattedInvalidDate, invalidDateString, "En cas d'échec de conversion, la chaîne originale devrait être retournée")
    }
    
    
    // YA
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
        
        XCTAssertEqual(dateFormatee, datePrevue,
                       "Pour une date invalide, devrait retourner la date actuelle formatée")
    }
}
