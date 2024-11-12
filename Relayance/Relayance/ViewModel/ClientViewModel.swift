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
    // For future use
    @Published private(set) var errorMessage: String?
    
    init() {
        loadClients()
    }
    
    private func loadClients() {
        clients = ModelData.load("Source.json")
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func addClient(name: String, email: String) -> Bool {
        guard !name.isEmpty && !email.isEmpty else {
            errorMessage = "Les champs nom et email sont requis"
            return false
        }
        
        guard isValidEmail(email) else {
            errorMessage = "Format d'email invalide"
            return false
        }
        
        let newClient = Client.createClient(name: name, email: email)
        
        guard !newClient.clientExists(in: clients) else {
            errorMessage = "Ce client existe déjà"
            return false
        }
        
        clients.append(newClient)
        errorMessage = nil
        return true
    }
    
    func isNewClient(_ client: Client) -> Bool {
        return client.isNew()
    }
    
    func getFormattedDate(for client: Client) -> String {
        return client.formatDateToString()
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
    
    func isFormValid(name: String, email: String) -> Bool {
        return !name.isEmpty && !email.isEmpty && isValidEmail(email)
    }
}
