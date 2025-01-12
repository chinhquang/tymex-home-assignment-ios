//
//  UserDetailServiceTest.swift
//  GithubUserPage
//
//  Created by chinh on 1/11/25.
//

import XCTest
@testable import GithubUserPage

final class UserDetailServiceTest: XCTestCase {
    
    
    var apiClient: APIClient!
    var userService: UserDetailServiceProtocol!

    override func setUp() {
        super.setUp()
        apiClient = APIClient(session: MockURLSession.mockResponse(with: nil, error: nil))
        userService = UserDetailService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        userService = nil
        super.tearDown()
    }

    func testFetchUserListSuccess() async throws {
        // Arrange
        let mockData = try JSONLoader.loadJSON(from: "mock_users_detail_data_success", in: Bundle(for: type(of: self)))
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (mockData, response, nil)
            
        }
        // Act
        do {
            let result: UserDetailResponse = try await userService.fetchUserDetail(loginName: "test")
            XCTAssertNotNil(result.id, "Expected success but no data returns")
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
            let result: UserDetailResponse = try await userService.fetchUserDetail(loginName: "mockName" )
            XCTFail("Expected Fail, but received success.")
        } catch {
            XCTAssertNotNil(error)
            XCTAssertTrue(error is APIError)
        }
        
    }
}
