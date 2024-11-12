//
//  ClientViewModelTests.swift
//  RelayanceTests
//
//  Created by Yannick LEPLARD on 10/11/2024.
//

import XCTest
@testable import Relayance



final class ClientViewModelTests: XCTestCase {
    var viewModel: ClientViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = ClientViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
        
    func test_ajoutClientValide_DevaitReussir() {
        // Given
        let initialNumberOfClients: Int = viewModel.clients.count
        let name = "Jean Dupont"
        let email = "jean.dupont@example.com"
        
        // When
        let result = viewModel.addClient(name: name, email: email)
        
        // Then
        XCTAssertTrue(result)
        XCTAssertEqual(viewModel.clients.count, initialNumberOfClients + 1)
        XCTAssertTrue(viewModel.clients.contains { $0.nom == name && $0.email == email })
        XCTAssertNil(viewModel.errorMessage)
        if let newClient = viewModel.clients.first(where: { $0.nom == name }) {
            XCTAssertTrue(viewModel.isNewClient(newClient))
        }
    }
    
    func test_ajoutClientExistant_DevaitEchouer() {
        // Given
        let existingClient = viewModel.clients[0]
        let initialNumberOfClients = viewModel.clients.count
        
        // When
        let result = viewModel.addClient(name: "Nouveau Nom", email: existingClient.email)
        
        // Then
        XCTAssertFalse(result)
        XCTAssertEqual(viewModel.clients.count, initialNumberOfClients)
        XCTAssertEqual(viewModel.errorMessage, "Ce client existe déjà")
    }
    
    func test_ajoutClientEmailInvalide_DevaitEchouer() {
        // Given
        let initialNumberOfClients = viewModel.clients.count
        let name = "Marie Martin"
        let email = "marie.martin"
        
        // When
        let result = viewModel.addClient(name: name, email: email)
        
        // Then
        XCTAssertFalse(result)
        XCTAssertEqual(viewModel.clients.count, initialNumberOfClients)
        XCTAssertEqual(viewModel.errorMessage, "Format d'email invalide")
    }
    
    func test_ajoutClientChampsVides_DevaitEchouer() {
        // Given
        let initialNumberOfClients = viewModel.clients.count
        
        // When
        let result = viewModel.addClient(name: "", email: "")
        
        // Then
        XCTAssertFalse(result)
        XCTAssertEqual(viewModel.clients.count, initialNumberOfClients)
        XCTAssertEqual(viewModel.errorMessage, "Les champs nom et email sont requis")
    }
        
    func test_suppressionClientExistant_DevaitReussir() {
        // Given
        let initialNumberOfClients = viewModel.clients.count
        let clientToDelete = viewModel.clients[0]
        
        // When
        let result = viewModel.deleteClient(clientToDelete)
        
        // Then
        XCTAssertTrue(result)
        XCTAssertEqual(viewModel.clients.count, initialNumberOfClients - 1)
        XCTAssertFalse(viewModel.clients.contains(clientToDelete))
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func test_suppressionClientInexistant_DevaitEchouer() {
        // Given
        let initialNumberOfClients = viewModel.clients.count
        let nonExistentClient = Client(name: "Inexistant",
                                      email: "inexistant@test.com",
                                      dateCreationString: "2024-01-01T00:00:00Z")
        
        // When
        let result = viewModel.deleteClient(nonExistentClient)
        
        // Then
        XCTAssertFalse(result)
        XCTAssertEqual(viewModel.clients.count, initialNumberOfClients)
        XCTAssertEqual(viewModel.errorMessage, "Client non trouvé")
    }
        
    func test_getFormattedDate_DevaitRetournerDateFormatee() {
        // Given
        let dateString = "2024-01-15T08:30:00Z"
        let client = Client(name: "Test", email: "test@example.com", dateCreationString: dateString)
        
        // When
        let formattedDate = viewModel.getFormattedDate(for: client)
        
        // Then
        XCTAssertEqual(formattedDate, "15-01-2024")
    }
    
    func test_getFormattedDate_AvecDateInvalide_DevaitRetournerDateActuelle() {
        // Given
        let client = Client(name: "Test", email: "test@example.com", dateCreationString: "date invalide")
        
        // When
        let formattedDate = viewModel.getFormattedDate(for: client)
        
        // Then
        let now = Date.now
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let expectedDate = dateFormatter.string(from: now)
        
        XCTAssertEqual(formattedDate, expectedDate)
    }
    
    func test_isFormValid_AvecDonneesValides_DevaitRetournerTrue() {
        // Given
        let name = "Test User"
        let email = "test@example.com"
        
        // When
        let isValid = viewModel.isFormValid(name: name, email: email)
        
        // Then
        XCTAssertTrue(isValid)
    }
    
    func test_isFormValid_AvecNomVide_DevaitRetournerFalse() {
        // Given
        let name = ""
        let email = "test@example.com"
        
        // When
        let isValid = viewModel.isFormValid(name: name, email: email)
        
        // Then
        XCTAssertFalse(isValid)
    }
    
    func test_isFormValid_AvecEmailVide_DevaitRetournerFalse() {
        // Given
        let name = "Test User"
        let email = ""
        
        // When
        let isValid = viewModel.isFormValid(name: name, email: email)
        
        // Then
        XCTAssertFalse(isValid)
    }
    
    func test_isFormValid_AvecEmailInvalide_DevaitRetournerFalse() {
        // Given
        let name = "Test User"
        let invalidEmails = [
            "test@",
            "@example.com",
            "test@example",
            "test.example.com",
            "test@.com",
            "test@com."
        ]
        
        // When & Then
        invalidEmails.forEach { email in
            XCTAssertFalse(viewModel.isFormValid(name: name, email: email),
                           "Email '\(email)' devrait être invalide")
        }
    }
}
