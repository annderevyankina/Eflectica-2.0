//
//  ContentView.swift
//  Eflectica 2.0
//
//  Created by Анна on 24.02.2025.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.gotjwt {
                    Label("Logged in", systemImage: "person.circle")
                    
                    Button("Get all users") {
                        viewModel.getUsers()
                    }
                    
                    Button("Log Out") {
                        viewModel.logOut()
                    }
                    .foregroundColor(.red)
                } else {
                    TextField("Your email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)

                    SecureField("Your password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button("Sign in") {
                        viewModel.signIn(email: email, password: password)
                    }

                    NavigationLink("Sign Up", destination: SignUpView(viewModel: viewModel))
                        .padding(.top, 10)
                }
            }
            .padding()
            .navigationTitle("Welcome")
        }
    }
}

struct SignUpView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack {
            Text("Sign Up")
                .font(.largeTitle)
                .bold()

            TextField("Your email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)

            SecureField("Your password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Register") {
                viewModel.signUp(email: email, password: password)
            }
            .padding(.top, 10)
        }
        .padding()
        .navigationTitle("Create Account")
    }
}

#Preview {
    ContentView(viewModel: ViewModel())
}
