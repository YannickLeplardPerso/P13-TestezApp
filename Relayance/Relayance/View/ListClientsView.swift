//
//  ListClientsView.swift
//  Relayance
//
//  Created by Amandine Cousin on 10/07/2024.
//

import SwiftUI

struct ListClientsView: View {
    @EnvironmentObject private var viewModel: ClientViewModel
    @State private var showModal: Bool = false
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.clients.isEmpty {
                    Text("Aucun client")
                        .font(.title2)
                        .foregroundColor(.gray)
                } else {
                    List(viewModel.clients, id: \.self) { client in
                        NavigationLink {
                            DetailClientView(client: client)
                        } label: {
                            Text(client.nom)
                                .font(.title3)
                        }
                    }
                }
            }
            .navigationTitle("Liste des clients")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Ajouter un client") {
                        showModal.toggle()
                    }
                    .foregroundStyle(.orange)
                    .bold()
                }
            }
            .sheet(isPresented: $showModal, content: {
                AddClientView(dismissModal: $showModal)
            })
        }
    }

}

#Preview {
    ListClientsView()
}
