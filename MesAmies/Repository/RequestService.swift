//
//  RequestService.swift
//  MesAmies
//
//  Created by Mohammad Olwan on 09/05/2022.
//

import Foundation
import Alamofire

final class RequestService {
    
    // MARK: - Properties
    
    private let session: AlamofireSession
    // MARK: - Initializer
    var url: URL!
    static var  gettenCity = [String]()
    static var  gettenSchool = [String]()
    static var  gettenSchoolId = [Int]()
    static var  gettenLevel = [String]()
    static var  gettenStudent = [String]()
    static var  gettenStudentId = [Int]()
    static var  chatId = [Int]()  // For MessengerViewController
    static var  userMessangerId = [String]()  // For MessengerViewController
    static var  userMessage = [String]()  // For MessengerViewController
    static var  messageDate = [String]()  // For MessengerViewController
    static var  messageTime = [String]()  // For MessengerViewController
    var isPagination: Bool = false  // For Paginiation in MessengerViewController
    var parameters = Parameters()
    init(session: AlamofireSession = MesAmiesSession() ) {
        self.session = session
    }
    
    // MARK: - Management
    func signInRequest(url: URL, method: HTTPMethod, parameters: Parameters ,callback: @escaping (Result<ReponseSignIn, RequestError>) -> Void){
        session.requestIn(url: url,method: HTTPMethod.post, parameters: parameters) {  dataResponse in
            guard let data = dataResponse.data else {
                callback(.failure(.noData))
                return
            }
            guard dataResponse.response?.statusCode == 200 else {
                callback(.failure(.invalidResponse))
                return
            }
            guard let dataDecoded = try? JSONDecoder().decode(ReponseSignIn.self, from: data) else {
                callback(.failure(.undecodableData))
                return
            }
            callback(.success(dataDecoded))
        }
    }
    
    // MARK: - Management
    func signUpRequest(url:URL, method: HTTPMethod, parameters: Parameters ,callback: @escaping (Result<Reponse, RequestError>) -> Void){
        session.requestUp(url: url,method: HTTPMethod.post, parameters: parameters) {  dataResponse in
            guard let data = dataResponse.data else{
                callback(.failure(.noData))
                return
            }
            guard dataResponse.response?.statusCode == 200 else {
                callback(.failure(.invalidResponse))
                return
            }
            guard let dataDecoded = try? JSONDecoder().decode(Reponse.self, from: data) else {
                callback(.failure(.undecodableData))
                return
            }
            callback(.success(dataDecoded))
        }
    }
    
    func schoolSelect(url:URL, method: HTTPMethod, parameters: Parameters, callback: @escaping(Result<School,RequestError>) -> Void){
        
        session.requestSchool(url: url, method: HTTPMethod.post, parameters: parameters) { dataResponse in
            guard let data = dataResponse.data else{
                callback(.failure(.noData))
                return
            }
            guard dataResponse.response?.statusCode == 200 else {
                callback(.failure(.invalidResponse))
                return
            }
            guard let dataDecoded = try? JSONDecoder().decode(School.self, from: data) else {
                callback(.failure(.undecodableData))
                return
            }
           callback(.success(dataDecoded))
        }
    }

    func countLevel(url:URL, method: HTTPMethod, parameters: Parameters, callback: @escaping(Result<Level,RequestError>) -> Void){
        
        session.requestLevel(url: url, method: HTTPMethod.post, parameters: parameters) { dataResponse in
            guard let data = dataResponse.data else{
                callback(.failure(.noData))
                return
            }
            guard dataResponse.response?.statusCode == 200 else {
                callback(.failure(.invalidResponse))
                return
            }
            guard let dataDecoded = try? JSONDecoder().decode(Level.self, from: data) else {
                callback(.failure(.undecodableData))
                return
            }
           callback(.success(dataDecoded))
        }
    }
    
    func addNewSchool(url:URL, method: HTTPMethod, parameters: Parameters ,callback: @escaping (Result<NewSchool, RequestError>) -> Void){
        session.requestAddNewSchool(url: url,method: HTTPMethod.post, parameters: parameters) {  dataResponse in
            guard let data = dataResponse.data else{
                callback(.failure(.noData))
                return
            }
            guard dataResponse.response?.statusCode == 200 else {
                callback(.failure(.invalidResponse))
                return
            }
            guard let dataDecoded = try? JSONDecoder().decode(NewSchool.self, from: data) else {
                callback(.failure(.undecodableData))
                return
            }
            callback(.success(dataDecoded))
            
        }
    }
    
    func getStudent(url: URL, method: HTTPMethod, parameters: Parameters, callback: @escaping(Result<[Student],RequestError>)-> Void){
        session.requestStudents(url: url, method: HTTPMethod.post, parameters: parameters){ dataResponse in
            guard let data = dataResponse.data else {
                callback(.failure(.noData))
                return
            }
            guard  dataResponse.response?.statusCode == 200 else {
                callback(.failure(.invalidResponse))
                return
            }
            guard let dataDecoded = try? JSONDecoder().decode([Student].self, from: data) else {
                callback(.failure(.undecodableData))
                return
            }
            callback(.success(dataDecoded))
        }
   }
    
    func sendCurrentMessage(url: URL, method: HTTPMethod, parameters: Parameters, callback: @escaping(Result<Message,RequestError>)-> Void){
        session.sendMessages(url: url, method: HTTPMethod.post, parameters: parameters){ dataResponse in
            guard let data = dataResponse.data else {
                callback(.failure(.noData))
                return
            }
            guard  dataResponse.response?.statusCode == 200 else {
                callback(.failure(.invalidResponse))
                return
            }
            guard let dataDecoded = try? JSONDecoder().decode(Message.self, from: data) else {
                callback(.failure(.undecodableData))
                return
            }
            callback(.success(dataDecoded))
        }
    }
    
    func getMessageBetweenTowStudents(url: URL, method: HTTPMethod, parameters: Parameters, callback: @escaping(Result<GetMessages,RequestError>)-> Void){
        
        session.getMessages(url: url, method: HTTPMethod.post, parameters: parameters){ dataResponse in
           
            guard let data = dataResponse.data else {
                callback(.failure(.noData))
                return
            }
            guard  dataResponse.response?.statusCode == 200 else {
                callback(.failure(.invalidResponse))
                return
            }
            guard let dataDecoded = try? JSONDecoder().decode(GetMessages.self, from: data) else {
                callback(.failure(.undecodableData))
                return
            }
            callback(.success(dataDecoded))
        }
        }
    }

