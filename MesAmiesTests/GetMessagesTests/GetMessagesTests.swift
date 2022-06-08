//
//  RequestServiceGetMessagesTests.swift
//  MesAmiesTests
//
//  Created by Mohammad Olwan on 08/06/2022.
//
import UIKit
import XCTest
@testable import MesAmies
class GetMessagesTests: XCTestCase {
    var requestService = RequestService()
    let parameters = [
        "FromId":1 as Any,
        "ToId": 2
    ]
     let api = URL(string:"http://localhost/mesamies/addMessage.php")
    func testGetData_WhenNoDataIsPassed_ThenShouldReturnFailedCallback_Get_Messages() {
        let session = FakeMesAmiesSession(fakeResponse: FakeResponse(response: nil, data: nil))
        let requestService = RequestService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getMessageBetweenTowStudents(url: api!, method: .post, parameters: parameters) { response in
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
    func testGetData_WhenIncorrectResponseIsPassed_ThenShouldReturnFailedCallback_Get_Messages() {
        let session = FakeMesAmiesSession(fakeResponse: FakeResponse(response: FakeResponseData.responseKO, data: FakeResponseData.correctData))
        let requestService = RequestService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getMessageBetweenTowStudents(url: api!, method: .post, parameters: parameters){ result in
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
    
    func testGetData_WhenUndecodableDataIsPassed_ThenShouldReturnFailedCallback_Get_Messages() {
        let session = FakeMesAmiesSession(fakeResponse: FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.incorrectData))
        let requestService = RequestService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getMessageBetweenTowStudents(url: api!, method: .post, parameters: parameters) { result in
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
    
    func testGetData_WhenCorrectDataIsPassed_ThenShouldReturnSuccededCallback_Get_Messages() {
        let session = FakeMesAmiesSession(fakeResponse: FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.getMessagecorrectData))
        let requestService = RequestService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getMessageBetweenTowStudents(url: api!, method: .post, parameters: parameters) { dataResponse in
            
            guard case .success(let data) = dataResponse else {
                XCTFail("Test getData method with correct data failed.")
                return
            }
            print(data[0].message)
            XCTAssertTrue(data[0].message == "80")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
