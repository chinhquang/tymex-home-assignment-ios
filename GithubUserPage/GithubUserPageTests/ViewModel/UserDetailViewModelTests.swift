//
//  UserDetailViewModelTests.swift
//  GithubUserPage
//
//  Created by chinh on 1/11/25.
//

import XCTest
import Combine
@testable import GithubUserPage

final class UserDetailViewModelTests: XCTestCase {

    var viewModel: UserDetailViewModel!
    var mockService: UserDetailServiceProtocol!
    var cancellables: Set<AnyCancellable> = []
    var apiClient: APIClient!
    override func setUp() {
        super.setUp()
        let mockSession = MockURLSession.mockResponse(with: nil, error: nil)
        apiClient = APIClient(testingSession: mockSession)
        mockService = UserDetailService(apiClient: apiClient)
        viewModel = UserDetailViewModel(service: mockService, loginName: "mock_name")
    }
    
    override func tearDown() {
        viewModel = nil
        apiClient = nil
        mockService = nil
        super.tearDown()
    }
    
    func testFetchUsers_Success() async {
        // Given
        let mockData = try? JSONLoader.loadJSON(from: "mock_users_detail_data_success", in: Bundle(for: type(of: self)))
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (mockData, response, nil)
        }
        // When
        await viewModel.fetchUserInfo()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.username.isEmpty, "Expect user name not empty")
    }
    
    func testFetchPhotosClientError_Failure() async {
        // Given
        let mockData = try? JSONLoader.loadJSON(from: "mock_api_client_data", in: Bundle(for: type(of: self)))
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)!
            return (mockData, response, APIError.serverError(statusCode: 404))
        }
        // When
        await viewModel.fetchUserInfo()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.username.isEmpty)
    }
    
    func testFetchPhotosServerError_Failure() async {
        // Given
        let mockData = try? JSONLoader.loadJSON(from: "mock_api_client_data", in: Bundle(for: type(of: self)))
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 501, httpVersion: nil, headerFields: nil)!
            return (mockData, response, APIError.serverError(statusCode: 501))
        }
        // When
        await viewModel.fetchUserInfo()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.username.isEmpty)
    }

    func testFetchPhotosUnknownError_Failure() async {
        // Given
        let mockData = try? JSONLoader.loadJSON(from: "mock_api_client_data", in: Bundle(for: type(of: self)))
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (mockData, response, APIError.unknownError)
        }
        
        // When
        await viewModel.fetchUserInfo()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.username.isEmpty)
    }
    
    func testFetchUserDetail_LoadingState() async {
        // Given
        let mockData = try? JSONLoader.loadJSON(from: "mock_users_detail_data_success", in: Bundle(for: type(of: self)))
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (mockData, response, nil)
        }
        
        let expectation = XCTestExpectation(description: "isLoading changes state correctly")
        
        viewModel.$isLoading
            .dropFirst()
            .sink { isLoading in
                if !isLoading {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables) // Store the subscription in `cancellables`
        
        // When
        await viewModel.fetchUserInfo()
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
    }
}
