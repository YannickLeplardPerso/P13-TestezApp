//
//  ClientViewModel.swift
//  Relayance
//
//  Created by Yannick LEPLARD on 10/11/2024.
//

import Foundation
import SwiftUI



class ClientViewModel: ObservableObject {
    @Published private(set) var clients: [Client] = []
    @Published private(set) var errorMessage: String?
    
    init() {
        loadClients()
    }
    
    private func loadClients() {
        clients = ModelData.chargement("Source.json")
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func addClient(nom: String, email: String) -> Bool {
        // Validation des champs
        guard !nom.isEmpty && !email.isEmpty else {
            errorMessage = "Les champs nom et email sont requis"
            return false
        }
        
        // Validation du format email
        guard isValidEmail(email) else {
            errorMessage = "Format d'email invalide"
            return false
        }
        
        let newClient = Client.creerNouveauClient(nom: nom, email: email)
        
        // Vérification si le client existe déjà
        guard !newClient.clientExiste(clientsList: clients) else {
            errorMessage = "Ce client existe déjà"
            return false
        }
        
        // Ajout du client
        clients.append(newClient)
        errorMessage = nil
        return true
    }
    
//    func addClient(nom: String, email: String) {
//        let newClient = Client.creerNouveauClient(nom: nom, email: email)
//        if !newClient.clientExiste(clientsList: clients) {
//            clients.append(newClient)
//        }
//    }
    
    func isNewClient(_ client: Client) -> Bool {
        return client.estNouveauClient()
    }
    
    func getFormattedDate(for client: Client) -> String {
        return client.formatDateVersString()
    }
    
    func deleteClient(_ client: Client) -> Bool {
        guard let index = clients.firstIndex(of: client) else {
            errorMessage = "Client non trouvé"
            return false
        }
        
        clients.remove(at: index)
        errorMessage = nil
        return true
    }
//    func deleteClient(at indexSet: IndexSet) {
//        clients.remove(atOffsets: indexSet)
//    }
    
    func isFormValid(nom: String, email: String) -> Bool {
        return !nom.isEmpty && !email.isEmpty && isValidEmail(email)
    }
    
//    func moveClient(from source: IndexSet, to destination: Int) {
//        clients.move(fromOffsets: source, toOffset: destination)
//    }
}
