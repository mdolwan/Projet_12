//
//  RequestServiceTests.swift
//  MesAmiesTests
//
//  Created by Mohammad Olwan on 07/06/2022.
//

import UIKit
import XCTest
@testable import MesAmies

class NewSchoolTests: XCTestCase {
    var requestService = RequestService()
    let parameters  = [ "userId" : "1",
                         "level": "Lyceum",
                         "schoolId": "1" as Any
    ]
    var api1 = URL(string:"https://www.apple.com")
    func testGetData_WhenNoDataIsPassed_ThenShouldReturnFailedCallback_Add_New_School() {
        let session = FakeMesAmiesSession(fakeResponse: FakeResponse(response: nil, data: nil))
        let requestService = RequestService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.addNewSchool(url: api1!, method: .post, parameters: parameters) { response in
            guard case .failure(let error) = response else {
                XCTFail("Test getData method with no data failed.")
                return
            }
            print(error)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetData_WhenIncorrectResponseIsPassed_ThenShouldReturnFailedCallback_Add_New_School() {
        let session = FakeMesAmiesSession(fakeResponse: FakeResponse(response: FakeResponseData.responseKO, data: FakeResponseData.correctData))
        let requestService = RequestService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.addNewSchool(url: api1!, method: .post, parameters: parameters){ result in
            guard case .failure(let error) = result else {
                XCTFail("Test getData method with incorrect response failed.")
                return
            }
            print(error)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetData_WhenUndecodableDataIsPassed_ThenShouldReturnFailedCallback_Add_New_School() {
        let session = FakeMesAmiesSession(fakeResponse: FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.incorrectData))
        let requestService = RequestService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.addNewSchool(url: api1!, method: .post, parameters: parameters) { result in
            guard case .failure(let error) = result else {
                XCTFail("Test getData method with undecodable data failed.")
                return
            }
            print(error)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetData_WhenCorrectDataIsPassed_ThenShouldReturnSuccededCallback_Add_New_School() {
        let session = FakeMesAmiesSession(fakeResponse: FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.newSchoolcorrectData))
        let requestService = RequestService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.addNewSchool(url: api1!, method: .post , parameters: parameters) { dataResponse in

            guard case .success(let data) = dataResponse else {
                print(dataResponse)
                XCTFail("Test getData method with correct data failed.")
                return
            }
            
            print(data.message, "9")
            XCTAssertTrue(data.message == "New school created successfully" )
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
}
