//
//  ProfileData.swift
//  Eflectica
//
//  Created by Анна on 01.12.2024.
//

import Foundation
import SwiftUI
 
struct UserProfile: Identifiable {
 var id = UUID()
 var firstName: String
 var lastName: String
 var email: String
 var avatar: UIImage?
} 
