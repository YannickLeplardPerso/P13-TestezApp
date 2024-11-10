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
        // On tente d'ajouter un client avec le même email mais potentiellement un nom différent
        let resultat = viewModel.addClient(nom: "Nouveau Nom",
                                           email: clientExistant.email)
        
        // Then
        XCTAssertFalse(resultat, "L'ajout aurait dû échouer car l'email existe déjà")
        XCTAssertEqual(viewModel.clients.count, nombreClientsInitial,
                       "Le nombre de clients ne devrait pas changer")
        XCTAssertEqual(viewModel.errorMessage, "Ce client existe déjà",
                       "Le message d'erreur devrait indiquer que le client existe")
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
    
    func test_suppressionDernierClient_DevaitReussirEtListeVide() {
        // Given
        // Supprime tous les clients sauf un
        while viewModel.clients.count > 1 {
            _ = viewModel.deleteClient(viewModel.clients[0])
        }
        let dernierClient = viewModel.clients[0]
        
        // When
        let resultat = viewModel.deleteClient(dernierClient)
        
        // Then
        XCTAssertTrue(resultat)
        XCTAssertTrue(viewModel.clients.isEmpty)
        XCTAssertNil(viewModel.errorMessage)
    }
        
    func test_validationFormulaire_DevaitValiderEmailCorrect() {
        // Given
        let nom = "Test User"
        let email = "test.user@example.com"
        
        // When
        let estValide = viewModel.isFormValid(nom: nom, email: email)
        
        // Then
        XCTAssertTrue(estValide)
    }
    
    func test_validationFormulaire_DevaitRejeterEmailIncorrect() {
        // Given
        let nom = "Test User"
        let emailsInvalides = [
            "test@",
            "@example.com",
            "test@example",
            "test.example.com",
            ""
        ]
        
        // When & Then
        emailsInvalides.forEach { email in
            XCTAssertFalse(viewModel.isFormValid(nom: nom, email: email), "Email '\(email)' devrait être invalide")
        }
    }
    
    
    
    
    // YA
    func test_deleteClient_AvecClientInexistant_DevaitEchouer() {
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
    
    func test_getFormattedDate_DevaitRetournerDateFormatee() {
        // Given
        let client = viewModel.clients[0]
        
        // When
        let dateFormatee = client.formatDateVersString()
        
        // Then
        // Vérifie que la date est au format "dd-MM-yyyy"
        let dateComponents = dateFormatee.split(separator: "-")
        XCTAssertEqual(dateComponents.count, 3)
        XCTAssertTrue(dateComponents[0].count == 2) // jour
        XCTAssertTrue(dateComponents[1].count == 2) // mois
        XCTAssertTrue(dateComponents[2].count == 4) // année
    }
    
    func test_getFormattedDate_AvecTousLesClients_DevaitRetournerDatesValides() {
        // Given
        let clients = viewModel.clients
        
        // When & Then
        for client in clients {
            let dateFormatee = client.formatDateVersString()
            let dateComponents = dateFormatee.split(separator: "-")
            
            XCTAssertEqual(dateComponents.count, 3,
                           "La date \(dateFormatee) n'est pas au bon format pour le client \(client.nom)")
            XCTAssertTrue(dateComponents[0].count == 2,
                          "Le jour n'est pas sur 2 chiffres pour \(client.nom)")
            XCTAssertTrue(dateComponents[1].count == 2,
                          "Le mois n'est pas sur 2 chiffres pour \(client.nom)")
            XCTAssertTrue(dateComponents[2].count == 4,
                          "L'année n'est pas sur 4 chiffres pour \(client.nom)")
        }
    }
    
//    func test_formatDateVersString_AvecFormattageDeDateEchoue_DevaitRetournerDateString() {
//        // Given
//        // On crée un spy de Date pour forcer l'échec du formatage
//        class DateFormatterSpy: DateFormatter {
//            override func string(from date: Date) -> String {
//                return ""  // Force un échec de formatage
//            }
//        }
//        
//        let originalFormatter = Date.stringFromDate
//        
//        // Remplace temporairement le formatter par notre spy
//        Date.stringFromDate = { _ in return nil }
//        
//        let client = Client(nom: "Test",
//                           email: "test@example.com",
//                           dateCreationString: "2024-01-01T00:00:00Z")
//        
//        // When
//        let resultat = client.formatDateVersString()
//        
//        // Then
//        XCTAssertEqual(resultat, client.getDateCreationString())
//        
//        // Restore original formatter
//        Date.stringFromDate = originalFormatter
//    }
}
