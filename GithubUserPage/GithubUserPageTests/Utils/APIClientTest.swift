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
        do {
            let result: [String: String] = try await apiClient.sendRequest(
                to: "https://mockurl.com",
                responseType: [String: String].self
            )
            XCTAssertEqual(result["key"], "value")
        } catch {
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
            let result: [String: String] = try await apiClient.sendRequest(
                to: "https://mockurl.com",
                responseType: [String: String].self
            )
            // Assert
            XCTFail("Expected failure, but received success.")
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
            let result: [String: String] = try await apiClient.sendRequest(
                to: "https://mockurl.com",
                responseType: [String: String].self
            )
            // Assert
            XCTFail("Expected failure, but received success.")
        } catch let error {
            XCTAssert(error is APIError)
        }
    }
}
