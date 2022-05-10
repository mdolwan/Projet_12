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
    func requestOut(url: URL,method:HTTPMethod,parameters: Parameters, callback: @escaping (AFDataResponse<SignUp>) -> Void)
}

final class MesAmiesSession: AlamofireSession {

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
}
