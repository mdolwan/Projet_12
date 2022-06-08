//
//  FakeMesAmiesSession.swift
//  MesAmiesTests
//
//  Created by Mohammad Olwan on 06/06/2022.
//

import Foundation
import Alamofire
@testable import MesAmies

struct FakeResponse {
    var response: HTTPURLResponse?
    var data: Data?
}
final class FakeMesAmiesSession: AlamofireSession {

    

    // MARK: - Properties

    private let fakeResponse: FakeResponse

    // MARK: - Initializer

    init(fakeResponse: FakeResponse) {
        self.fakeResponse = fakeResponse
    }
    var response = Reponse(error: false, userid: 1, message: "Log In successfully")
    var school = SchoolElement(id: "1", name: "Alma", city: "Cherbour", code: "50100")
    var level =  Level()
    var student = Student(username: "Olwan", level: "Primary", userid: "1", schoolname: "Alma")
    var messeg = Message(error: false, lastMessageID: 2, message: "New Message created successfully")
    var messegs = GetMessages()
    var newRecord = NewSchool(error: false, userid: 1, message: "New school created successfully")
    
    func requestIn(url: URL, method: HTTPMethod, parameters: Parameters, callback: @escaping (AFDataResponse<Reponse>) -> Void) {
        let dataResponse = AFDataResponse<Reponse>( request: nil, response: fakeResponse.response, data: fakeResponse.data, metrics: nil, serializationDuration: 0, result: .success(response))
        callback(dataResponse)
    }
    
    func requestUp(url: URL, method: HTTPMethod, parameters: Parameters, callback: @escaping (AFDataResponse<Reponse>) -> Void) {
        let dataResponse = AFDataResponse<Reponse>( request: nil, response: fakeResponse.response, data: fakeResponse.data, metrics: nil, serializationDuration: 0, result: .success(response))
        callback(dataResponse)
    }
    func requestAddNewSchool(url: URL, method: HTTPMethod, parameters: Parameters, callback: @escaping (AFDataResponse<NewSchool>) -> Void) {
        let dataResponse = AFDataResponse<NewSchool>( request: nil, response: fakeResponse.response, data: fakeResponse.data, metrics: nil, serializationDuration: 0, result: .success(newRecord))
        callback(dataResponse)
    }
    func requestSchool(url: URL, method: HTTPMethod, parameters: Parameters, callback: @escaping (AFDataResponse<SchoolElement>) -> Void) {
        let dataResponse = AFDataResponse<SchoolElement>( request: nil, response: fakeResponse.response, data: fakeResponse.data, metrics: nil, serializationDuration: 0, result: .success(school))
        callback(dataResponse)
    }
    
    func requestLevel(url: URL, method: HTTPMethod, parameters: Parameters, callback: @escaping (AFDataResponse<Level>) -> Void) {
        let dataResponse = AFDataResponse<Level>( request: nil, response: fakeResponse.response, data: fakeResponse.data, metrics: nil, serializationDuration: 0, result: .success(level))
       callback(dataResponse)
    }
    
    func requestStudents(url: URL, method: HTTPMethod, parameters: Parameters, callback: @escaping (AFDataResponse<Student>) -> Void) {
        let dataResponse = AFDataResponse<Student>( request: nil, response: fakeResponse.response, data: fakeResponse.data, metrics: nil, serializationDuration: 0, result: .success(student))
       callback(dataResponse)
    }
    
    func sendMessages(url: URL, method: HTTPMethod, parameters: Parameters, callback: @escaping (AFDataResponse<Message>) -> Void) {
        let dataResponse = AFDataResponse<Message>( request: nil, response: fakeResponse.response, data: fakeResponse.data, metrics: nil, serializationDuration: 0, result: .success(messeg))
       callback(dataResponse)
    }
    
    func getMessages(url: URL, method: HTTPMethod, parameters: Parameters, callback: @escaping (AFDataResponse<GetMessages>) -> Void) {
        let dataResponse = AFDataResponse<GetMessages>( request: nil, response: fakeResponse.response, data: fakeResponse.data, metrics: nil, serializationDuration: 0, result: .success(messegs))
       callback(dataResponse)
    }
}
