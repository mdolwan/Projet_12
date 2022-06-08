//
//  FakeResponseData.swift
//  MesAmiesTests
//
//  Created by Mohammad Olwan on 06/06/2022.
//

import Foundation


final class FakeResponseData {
    static let responseOK = HTTPURLResponse(url: URL(string: "https://www.apple.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    static let responseKO = HTTPURLResponse(url: URL(string: "https://www.apple.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
    
    class NetworkError: Error {}
    static let networkError = NetworkError()
    
    static var newSchoolcorrectData: Data {
           let bundle = Bundle(for: FakeResponseData.self)
           let url = bundle.url(forResource: "NewSchool", withExtension: "json")
           let data = try! Data(contentsOf: url!)
           return data
       }
    
    static var correctData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "MesAmies", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static var getMessagecorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "GetMessages", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
   
    static var ResponseSignIncorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "ResponseSignIn", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static var ResponseSignUpcorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "SignUp", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static var SelectSchoolcorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "School", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static var CountLevelcorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "CountLevel", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static var SendMessagecorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Message", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    static let incorrectData = "erreur".data(using: .utf8)!
}
