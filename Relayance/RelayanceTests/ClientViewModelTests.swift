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
    
    // MARK: - Tests d'ajout de client
    
    func test_ajoutClientValide_DevaitReussir() {
        // Given
        let nombreClientsInitial = viewModel.clients.count
        let nom = "Jean Dupont"
        let email = "jean.dupont@example.com"
        
        // When
        let resultat = viewModel.addClient(nom: nom, email: email)
        
        // Then
        XCTAssertTrue(resultat)
        XCTAssertEqual(viewModel.clients.count, nombreClientsInitial + 1)
        XCTAssertTrue(viewModel.clients.contains { $0.nom == nom && $0.email == email })
        XCTAssertNil(viewModel.errorMessage)
        if let nouveauClient = viewModel.clients.first(where: { $0.nom == nom }) {
            XCTAssertTrue(viewModel.isNewClient(nouveauClient))
        }
    }
    
    func test_ajoutClientExistant_DevaitEchouer() {
        // Given
        let clientExistant = viewModel.clients[0]
        let nombreClientsInitial = viewModel.clients.count
        
        // When
        let resultat = viewModel.addClient(nom: "Nouveau Nom", email: clientExistant.email)
        
        // Then
        XCTAssertFalse(resultat)
        XCTAssertEqual(viewModel.clients.count, nombreClientsInitial)
        XCTAssertEqual(viewModel.errorMessage, "Ce client existe déjà")
    }
    
    func test_ajoutClientEmailInvalide_DevaitEchouer() {
        // Given
        let nombreClientsInitial = viewModel.clients.count
        let nom = "Marie Martin"
        let email = "marie.martin"
        
        // When
        let resultat = viewModel.addClient(nom: nom, email: email)
        
        // Then
        XCTAssertFalse(resultat)
        XCTAssertEqual(viewModel.clients.count, nombreClientsInitial)
        XCTAssertEqual(viewModel.errorMessage, "Format d'email invalide")
    }
    
    func test_ajoutClientChampsVides_DevaitEchouer() {
        // Given
        let nombreClientsInitial = viewModel.clients.count
        
        // When
        let resultat = viewModel.addClient(nom: "", email: "")
        
        // Then
        XCTAssertFalse(resultat)
        XCTAssertEqual(viewModel.clients.count, nombreClientsInitial)
        XCTAssertEqual(viewModel.errorMessage, "Les champs nom et email sont requis")
    }
    
    // MARK: - Tests de suppression de client
    
    func test_suppressionClientExistant_DevaitReussir() {
        // Given
        let nombreClientsInitial = viewModel.clients.count
        let clientASupprimer = viewModel.clients[0]
        
        // When
        let resultat = viewModel.deleteClient(clientASupprimer)
        
        // Then
        XCTAssertTrue(resultat)
        XCTAssertEqual(viewModel.clients.count, nombreClientsInitial - 1)
        XCTAssertFalse(viewModel.clients.contains(clientASupprimer))
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func test_suppressionClientInexistant_DevaitEchouer() {
        // Given
        let nombreClientsInitial = viewModel.clients.count
        let clientInexistant = Client(nom: "Inexistant",
                                      email: "inexistant@test.com",
                                      dateCreationString: "2024-01-01T00:00:00Z")
        
        // When
        let resultat = viewModel.deleteClient(clientInexistant)
        
        // Then
        XCTAssertFalse(resultat)
        XCTAssertEqual(viewModel.clients.count, nombreClientsInitial)
        XCTAssertEqual(viewModel.errorMessage, "Client non trouvé")
    }
    
    // MARK: - Tests de formatage de date
    
    func test_getFormattedDate_DevaitRetournerDateFormatee() {
        // Given
        let dateString = "2024-01-15T08:30:00Z"
        let client = Client(nom: "Test", email: "test@example.com", dateCreationString: dateString)
        
        // When
        let dateFormatee = viewModel.getFormattedDate(for: client)
        
        // Then
        XCTAssertEqual(dateFormatee, "15-01-2024")
    }
    
    func test_getFormattedDate_AvecDateInvalide_DevaitRetournerDateActuelle() {
        // Given
        let client = Client(nom: "Test", email: "test@example.com", dateCreationString: "date invalide")
        
        // When
        let dateFormatee = viewModel.getFormattedDate(for: client)
        
        // Then
        let maintenant = Date.now
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let datePrevue = dateFormatter.string(from: maintenant)
        
        XCTAssertEqual(dateFormatee, datePrevue)
    }
    
    func test_isFormValid_AvecDonneesValides_DevaitRetournerTrue() {
        // Given
        let nom = "Test User"
        let email = "test@example.com"
        
        // When
        let estValide = viewModel.isFormValid(nom: nom, email: email)
        
        // Then
        XCTAssertTrue(estValide)
    }
    
    func test_isFormValid_AvecNomVide_DevaitRetournerFalse() {
        // Given
        let nom = ""
        let email = "test@example.com"
        
        // When
        let estValide = viewModel.isFormValid(nom: nom, email: email)
        
        // Then
        XCTAssertFalse(estValide)
    }
    
    func test_isFormValid_AvecEmailVide_DevaitRetournerFalse() {
        // Given
        let nom = "Test User"
        let email = ""
        
        // When
        let estValide = viewModel.isFormValid(nom: nom, email: email)
        
        // Then
        XCTAssertFalse(estValide)
    }
    
    func test_isFormValid_AvecEmailInvalide_DevaitRetournerFalse() {
        // Given
        let nom = "Test User"
        let emailsInvalides = [
            "test@",
            "@example.com",
            "test@example",
            "test.example.com",
            "test@.com",
            "test@com."
        ]
        
        // When & Then
        emailsInvalides.forEach { email in
            XCTAssertFalse(viewModel.isFormValid(nom: nom, email: email),
                           "Email '\(email)' devrait être invalide")
        }
    }
}
