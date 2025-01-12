//
//  UserListViewModelTests.swift
//  GithubUserPage
//
//  Created by chinh on 1/11/25.
//

import XCTest
import Combine
@testable import GithubUserPage

final class UserListViewModelTests: XCTestCase {

    var viewModel: UserListViewModel!
    var mockService: UserServiceProtocol!
    var cancellables: Set<AnyCancellable> = []
    var apiClient: APIClient!
    override func setUp() {
        super.setUp()
        let mockSession = MockURLSession.mockResponse(with: nil, error: nil)
        apiClient = APIClient(session: mockSession)
        mockService = UserService(apiClient: apiClient)
        viewModel = UserListViewModel(service: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        apiClient = nil
        mockService = nil
        super.tearDown()
    }
    
    func testFetchUsers_Success() async throws {
        // Given
        let mockData = try JSONLoader.loadJSON(from: "mock_users_data_success", in: Bundle(for: type(of: self)))
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (mockData, response, nil)
        }
        // When
        await viewModel.fetchItems()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.users.count, 20) // JSon file contains 20 user records
        XCTAssertNotNil(viewModel.users.first?.id)
    }
    
    func testFetchUsersClientError_Failure() async throws {
        // Given
        let mockData = try JSONLoader.loadJSON(from: "mock_api_client_data", in: Bundle(for: type(of: self)))
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)!
            return (mockData, response, APIError.serverError(statusCode: 404))
        }
        // When
        await viewModel.fetchItems()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.users.count, 0)
    }
    
    func testFetchUsersServerError_Failure() async throws {
        // Given
        let mockData = try JSONLoader.loadJSON(from: "mock_api_client_data", in: Bundle(for: type(of: self)))
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 501, httpVersion: nil, headerFields: nil)!
            return (mockData, response, APIError.serverError(statusCode: 501))
        }
        // When
        await viewModel.fetchItems()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.users.count, 0)
    }

    func testFetchUsersUnknownError_Failure() async throws {
        // Given
        let mockData = try JSONLoader.loadJSON(from: "mock_api_client_data", in: Bundle(for: type(of: self)))
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (mockData, response, APIError.unknownError)
        }
        
        // When
        await viewModel.fetchItems()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.users.count, 0)
    }
    
    func testFetchUsers_LoadingState() async throws {
        // Given
        let mockData = try JSONLoader.loadJSON(from: "mock_api_client_data", in: Bundle(for: type(of: self)))
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
        await viewModel.fetchItems()
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
    }
}
