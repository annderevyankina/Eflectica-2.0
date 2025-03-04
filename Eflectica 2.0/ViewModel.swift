//
//  ViewModel.swift
//  Eflectica 2.0
//
//  Created by Анна on 24.02.2025.
//

import Foundation

enum Signup {
    struct Request: Encodable {
        let user: UserData
    }

    struct Response: Decodable {
        let jwt: String
    }
}

enum Signin {
    struct Request: Encodable {
        let user: UserData
    }

    struct Response: Decodable {
        let jwt: String
    }
}

struct UserData: Encodable {
    var email: String
    var password: String
}

final class ViewModel: ObservableObject {
    enum Const {
        static let jwtKey = "jwt"
    }

    @Published var email: String = ""
    @Published var gotjwt: Bool = KeychainService().getString(forKey: Const.jwtKey)?.isEmpty == false

    private var worker = AuthWorker()
    private var keychain = KeychainService()

    func signUp(email: String, password: String) {
        let endpoint = AuthEndpoint.signup
        let requestData = ["user": ["email": email, "password": password]]

        guard let body = try? JSONEncoder().encode(requestData) else {
            print("Ошибка кодирования данных для регистрации")
            return
        }

        let request = Request(endpoint: endpoint, method: .post, body: body)

        worker.load(request: request) { [weak self] result in
            switch result {
            case .failure(let error):
                print("Ошибка регистрации: \(error)")

            case .success(let data):
                if let data,
                   let response = try? JSONDecoder().decode(Signup.Response.self, from: data) {
                    let jwt = response.jwt
                    self?.keychain.setString(jwt, forKey: Const.jwtKey)
                    DispatchQueue.main.async {
                        self?.gotjwt = true
                    }
                    print(">>> JWT успешно сохранен")
                } else {
                    print(">>> Ошибка: не удалось декодировать JWT")
                }
            }
        }
    }

    func signIn(email: String, password: String) {
        let endpoint = AuthEndpoint.signin
        let requestData = ["user": ["email": email, "password": password]]

        guard let body = try? JSONEncoder().encode(requestData) else {
            print("Ошибка кодирования данных для входа")
            return
        }

        let request = Request(endpoint: endpoint, method: .post, body: body)

        worker.load(request: request) { [weak self] result in
            switch result {
            case .failure(let error):
                print(">>> Ошибка запроса: \(error)")

            case .success(let data):
                if let data,
                   let response = try? JSONDecoder().decode(Signin.Response.self, from: data) {
                    let jwt = response.jwt
                    self?.keychain.setString(jwt, forKey: Const.jwtKey)
                    DispatchQueue.main.async {
                        self?.gotjwt = true
                    }
                    print(">>> JWT успешно сохранен")
                } else {
                    print(">>> Ошибка: не удалось декодировать JWT")
                }
            }
        }
    }

    func getUsers() {
        let jwt = keychain.getString(forKey: Const.jwtKey) ?? ""
        let request = Request(endpoint: AuthEndpoint.users(jwt: jwt))
        worker.load(request: request) { result in
            switch result {
            case .failure(let error):
                print("Ошибка получения пользователей: \(error)")
            case .success(let data):
                guard let data else {
                    print("Ошибка: пустой ответ")
                    return
                }
                print(String(data: data, encoding: .utf8) ?? "Ошибка декодирования данных")
            }
        }
    }

    func logOut() {
        keychain.setString("", forKey: Const.jwtKey) 
        DispatchQueue.main.async {
            self.gotjwt = false
        }
    }
}

enum AuthEndpoint: Endpoint {
    case signup
    case signin
    case users(jwt: String)

    var rawValue: String {
        switch self {
        case .signup:
            return "sign_up"
        case .signin:
            return "sign_in"
        case .users:
            return "users"
        }
    }

    var compositePath: String {
        return "/api/v1/\(self.rawValue)"
    }

    var headers: [String: String] {
        switch self {
        case .users(let jwt): ["Authorization": "Bearer \(jwt)"]
        default: ["Content-Type": "application/json"]
        }
    }
}

final class AuthWorker {
    let worker = BaseURLWorker(baseUrl: "http://localhost:3000")

    func load(request: Request, completion: @escaping (Result<Data?, Error>) -> Void) {
        print("=== ОТПРАВКА ЗАПРОСА ===")
        print("URL: \(request.endpoint.compositePath)")
        print("Метод: \(request.method.rawValue)")
        print("Заголовки: \(request.endpoint.headers)")
        if let body = request.body {
            print("Тело запроса: \(String(data: body, encoding: .utf8) ?? "nil")")
        }

        worker.executeRequest(with: request) { response in
            switch response {
            case .failure(let error):
                print("Ошибка сети: \(error)")
                completion(.failure(error))
            case .success(let result):
                if let httpResponse = result.response as? HTTPURLResponse {
                    print("Код ответа сервера: \(httpResponse.statusCode)")
                }
                if let data = result.data {
                    print("Ответ сервера: \(String(data: data, encoding: .utf8) ?? "nil")")
                }
                completion(.success(result.data))
            }
        }
    }
}
