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
    static var  gettenlevel = [String]()
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
    func signOutRequest(url:URL, method: HTTPMethod, parameters: Parameters ,callback: @escaping (Result<Reponse, RequestError>) -> Void){
        session.requestOut(url: url,method: HTTPMethod.post, parameters: parameters) {  dataResponse in
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
    
    func addNewSchool(url:URL, method: HTTPMethod, parameters: Parameters ,callback: @escaping (Result<Reponse, RequestError>) -> Void){
        session.requestOut(url: url,method: HTTPMethod.post, parameters: parameters) {  dataResponse in
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
}

