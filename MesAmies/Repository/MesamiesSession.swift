//
//  SignInOut.swift
//  MesAmies
//
//  Created by Mohammad Olwan on 09/05/2022.
//

import Foundation
import Alamofire


protocol AlamofireSession {
    func requestIn(url: URL,method:HTTPMethod,parameters: Parameters,callback: @escaping (AFDataResponse<Reponse>) -> Void)
    func requestOut(url: URL,method:HTTPMethod,parameters: Parameters, callback: @escaping (AFDataResponse<Reponse>) -> Void)
    func requestSchool(url:URL, method: HTTPMethod, parameters: Parameters, callback: @escaping (AFDataResponse<SchoolElement>) -> Void)
    func requestLevel(url:URL, method: HTTPMethod, parameters: Parameters, callback: @escaping (AFDataResponse<Level>) -> Void)
    func requestStudents(url: URL, method: HTTPMethod, parameters: Parameters, callback: @escaping(AFDataResponse<Student>)->Void)
    
    func sendMessages(url: URL, method: HTTPMethod, parameters: Parameters, callback: @escaping(AFDataResponse<Student>)->Void)
}

final class MesAmiesSession: AlamofireSession {

    func requestSchool<T: Decodable>(url: URL, method: HTTPMethod, parameters: Parameters, callback: @escaping (DataResponse<T, AFError>) -> Void) {
        AF.request(url, method: .post, parameters: parameters).responseDecodable { (response: DataResponse<T, AFError>) in
            
            callback(response)
        }
    }
    func requestIn<T: Decodable>(url: URL,method: HTTPMethod, parameters: Parameters, callback: @escaping (DataResponse<T, AFError>) -> Void) {
        AF.request(url, method: .post, parameters: parameters).responseDecodable { (response: DataResponse<T, AFError>) in
            callback(response)
        }
    }
    func requestOut<T: Decodable>(url: URL,method: HTTPMethod, parameters: Parameters , callback: @escaping (DataResponse<T, AFError>) -> Void) {
        AF.request(url, method: .post, parameters: parameters).responseDecodable { (response: DataResponse<T, AFError>) in
            callback(response)
        }
    }
    
    func requestLevel<T: Decodable>(url: URL, method: HTTPMethod, parameters: Parameters, callback: @escaping (DataResponse<T, AFError>) -> Void) {
        AF.request(url, method: .post, parameters: parameters).responseDecodable { (response: DataResponse<T, AFError>) in
            callback(response)
        }
    }
    
    func requestStudents<T: Decodable>(url: URL, method: HTTPMethod, parameters: Parameters, callback: @escaping (DataResponse<T, AFError>) -> Void) {
        AF.request(url, method: .post, parameters: parameters).responseDecodable { (response: DataResponse<T, AFError>) in
            callback(response)
        }
    }
    
    func sendMessages<T: Decodable>(url: URL, method: HTTPMethod, parameters: Parameters, callback: @escaping (DataResponse<T, AFError>) -> Void) {
        AF.request(url, method: .post, parameters: parameters).responseDecodable{ (response: DataResponse<T, AFError>) in
            callback(response)
        }
    }
}
