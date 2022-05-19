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
    func signInRequest(url: URL, method: HTTPMethod, parameters: Parameters ,callback: @escaping (Result<Reponse, RequestError>) -> Void){
        session.requestIn(url: url,method: HTTPMethod.post, parameters: parameters) {  dataResponse in
            guard let data = dataResponse.data else {
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
    
    
    //
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
    
    //
}
/*
 
 var array1 = ["maternelle", "college", "lycee"]
 var array2 = ["maternelle"]
 if array2.count>0{
 for i in 0...array2.count-1{
   if (  array1.contains(array2[i])){
       array1.remove(at:array1.firstIndex(of: array2[i])! )
   }
 }}
 print(array1)
 */
