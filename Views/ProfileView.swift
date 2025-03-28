//
//  ProfileView.swift
//  APIEflectica
//
//  Created by Анна on 03.12.2024.
//

import SwiftUI

struct ProfileView: View {
    @State private var user: UserProfile = UserProfile(
        firstName: "Сева",
        lastName: "Сделал",
        email: "sevaantonov44@mail.ru",
        avatar: UIImage(named: "A_Avatar")
    )
    @State private var isEditing: Bool = false
    @State private var showSettings: Bool = false
    @State private var selectedImage: UIImage?
    
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                if let avatar = user.avatar {
                    Image(uiImage: avatar)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 10)
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 10)
                }
                
                Text("\(user.firstName) \(user.lastName)")
                    .font(.custom("BasisGrotesquePro-Regular", size: 24))
                
                Text("@seva_sdelal")
                    .font(.custom("BasisGrotesquePro-Regular", size: 16))
                    .foregroundColor(Color("ordinaryGrey"))
                
                Text("Почта")
                    .font(.custom("BasisGrotesquePro-Regular", size: 16))
                    .foregroundColor(.gray)
                
                Text(user.email)
                    .font(.custom("BasisGrotesquePro-Regular", size: 16))
                
                Spacer()
                
                Button(action: {
                    isEditing.toggle()
                }) {
                    Text("Редактировать профиль")
                        .font(.custom("BasisGrotesquePro-Regular", size: 16))
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $isEditing) {
                    EditProfileView(user: $user, selectedImage: $selectedImage)
                }
                
                Button(action: {
                    isLoggedIn = false
                }) {
                    Text("Выйти")
                        .font(.custom("BasisGrotesquePro-Regular", size: 16))
                        .foregroundColor(.blue)
                        .padding()
                        .cornerRadius(10)
                }
                .padding(.bottom)
            }
            .padding()
            .navigationBarTitle("Профиль", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                showSettings.toggle()
            }) {
                Image(systemName: "gear")
            })
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Settings")
            .font(.custom("BasisGrotesquePro-Regular", size: 24))
    }
}

struct EditProfileView: View {
    @Binding var user: UserProfile
    @Binding var selectedImage: UIImage?
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var showImagePicker: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Avatar")) {
                    Button(action: {
                        showImagePicker.toggle()
                    }) {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        }
                    }
                }
                
                Section(header: Text("Personal information")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                }
            }
            .navigationBarTitle("Редактирование профиля", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Отмена") {},
                trailing: Button("Сохранить") {
                    user.firstName = firstName
                    user.lastName = lastName
                    user.email = email
                    if let selectedImage = selectedImage {
                        user.avatar = selectedImage
                    }
                }
            )
            .onAppear {
                firstName = user.firstName
                lastName = user.lastName
                email = user.email
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage)
            }
        }
    }
}
