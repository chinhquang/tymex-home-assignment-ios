//
//  UserServiceTest.swift
//  GithubUserPage
//
//  Created by chinh on 1/11/25.
//

import XCTest
@testable import GithubUserPage

final class UserServiceTest: XCTestCase {
    
    
    var apiClient: APIClient!
    var userService: UserService!

    override func setUp() {
        super.setUp()
        apiClient = APIClient(session: MockURLSession.mockResponse(with: nil, error: nil))
        userService = UserService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        userService = nil
        super.tearDown()
    }

    func testFetchUserListSuccess() async throws {
        // Arrange
        let mockData = try JSONLoader.loadJSON(from: "mock_users_data_success", in: Bundle(for: type(of: self)))
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (mockData, response, nil)
            
        }
        // Act
        do {
            let result: [UserResponse] = try await userService.fetchUsers()
            XCTAssertFalse(result.isEmpty, "Expected success but no data returns")
        } catch {
            XCTFail("Expected success, but received failure.")
        }
        
    }
    
    func testFetchUserListEmptySuccess() async throws {
        // Arrange
        let mockData = try JSONLoader.loadJSON(from: "mock_users_data_success_empty_data", in: Bundle(for: type(of: self)))
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (mockData, response, nil)
            
        }
        // Act
        do {
            let result: [UserResponse] = try await userService.fetchUsers()
            XCTAssertTrue(result.isEmpty, "Expected success but no data returns")
        } catch {
            XCTFail("Expected success, but received failure.")
        }
        
    }
    
    func testFetchUserListFailure() async throws {
        // Arrange
        let mockData = try JSONLoader.loadJSON(from: "mock_users_data_success_empty_data", in: Bundle(for: type(of: self)))
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 501, httpVersion: nil, headerFields: nil)!
            return (mockData, response, APIError.noData)
            
        }
        // Act
        do {
            let result: [UserResponse] = try await userService.fetchUsers()
            XCTFail("Expected Fail, but received success.")
        } catch {
            XCTAssertNotNil(error)
            XCTAssertTrue(error is APIError)
        }
        
    }
}
