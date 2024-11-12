//
//  AddClientView.swift
//  Relayance
//
//  Created by Amandine Cousin on 10/07/2024.
//

import SwiftUI

struct AddClientView: View {
    @EnvironmentObject private var viewModel: ClientViewModel
    @Binding var dismissModal: Bool
    @State var name: String = ""
    @State var email: String = ""
    
    var body: some View {
        VStack {
            Text("Ajouter un nouveau client")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
            Spacer()
            TextField("Nom", text: $name)
                .font(.title2)
            TextField("Email", text: $email)
                .font(.title2)
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Button("Ajouter") {
                if viewModel.addClient(name: name, email: email) {
                    dismissModal.toggle()
                }
                
            }
            .padding(.horizontal, 50)
            .padding(.vertical)
            .font(.title2)
            .bold()
            .background(RoundedRectangle(cornerRadius: 10).fill(.orange))
            .foregroundStyle(.white)
            .padding(.top, 50)
            .disabled(!viewModel.isFormValid(name: name, email: email))
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    AddClientView(dismissModal: .constant(false))
}
