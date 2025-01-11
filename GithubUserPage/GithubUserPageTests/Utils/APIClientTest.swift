//
//  APIClientTest.swift
//  GithubUserPageTests
//
//  Created by chinh on 1/11/25.
//

import XCTest
@testable import GithubUserPage

final class APIClientTest: XCTestCase {
    
    var apiClient: APIClient!
    
    override func setUp() {
        super.setUp()
        let mockSession = MockURLSession.mockResponse(with: nil, error: nil)
        apiClient = APIClient(testingSession: mockSession)
    }

    override func tearDown() {
        apiClient = nil
        super.tearDown()
    }

    func testSendRequestSuccess() async throws {
        // Arrange
        let mockData = try JSONLoader.loadJSON(from: "mock_api_client_data", in: Bundle(for: type(of: self)))
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (mockData, response, nil)
            
        }
        // Act
        let result: Result<[String: String], any Error> = try await apiClient.sendRequest(
            to: "https://mockurl.com",
            responseType: [String: String].self
        )
        switch result {
        case .success(let response):
            XCTAssertEqual(response["key"], "value")
        case .failure:
            XCTFail("Expected success, but received failure.")
        }
    }

    func testSendRequestDecodingFailure() async throws {
        // Arrange
        let mockData = try JSONLoader.loadJSON(from: "mock_api_client_data", in: Bundle(for: type(of: self)))
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (mockData, response, APIError.decodingError)
            
        }
        // Act
        do {
            let result: Result<[String: String], any Error> = try await apiClient.sendRequest(
                to: "https://mockurl.com",
                responseType: [String: String].self
            )
            // Assert
            switch result {
            case .success:
                XCTFail("Expected failure, but received success.")
            case .failure(let error):
                XCTAssert(error is APIError)
            }
        } catch let error {
            XCTAssert(error is APIError)
        }
    }
    
    func testSendRequestServerFailure() async throws {
        // Arrange
        let mockData = try JSONLoader.loadJSON(from: "mock_api_client_data", in: Bundle(for: type(of: self)))
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 501, httpVersion: nil, headerFields: nil)!
            return (mockData, response, APIError.serverError(statusCode: 501))
            
        }
        // Act
        do {
            let result: Result<[String: String], any Error> = try await apiClient.sendRequest(
                to: "https://mockurl.com",
                responseType: [String: String].self
            )
            // Assert
            switch result {
            case .success:
                XCTFail("Expected failure, but received success.")
            case .failure(let error):
                XCTAssert(error is APIError)
            }
        } catch let error {
            XCTAssert(error is APIError)
        }
    }
}
