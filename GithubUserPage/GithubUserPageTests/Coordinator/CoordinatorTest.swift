//
//  CoordinatorTest.swift
//  GithubUserPage
//
//  Created by chinh on 1/11/25.
//

import XCTest
import SwiftUI
@testable import GithubUserPage

final class CoordinatorTests: XCTestCase {
    
    var coordinator: Coordinator!
    
    override func setUp() {
        super.setUp()
        coordinator = Coordinator()
    }
    
    override func tearDown() {
        coordinator = nil
        super.tearDown()
    }
    
    func testPushPage() {
        // Initial path should be empty
        XCTAssertTrue(coordinator.path.isEmpty, "Initial path is not empty.")
        
        // Push a page
        coordinator.push(page: .userList)
        
        // Verify path contains the pushed page
        XCTAssertEqual(coordinator.path.count, 1, "Path count is incorrect after push.")
    }
    
    func testPopPage() {
        // Push multiple pages
        coordinator.push(page: .userList)
        coordinator.push(page: .userDetail(loginName: "testUser"))
        
        // Verify initial path count
        XCTAssertEqual(coordinator.path.count, 2, "Path count is incorrect after multiple pushes.")
        
        // Pop a page
        coordinator.pop()
        
        // Verify path count and last page
        XCTAssertEqual(coordinator.path.count, 1, "Path count is incorrect after pop.")
    }
    
    func testPopToRoot() {
        // Push multiple pages
        coordinator.push(page: .userList)
        coordinator.push(page: .userDetail(loginName: "testUser"))
        
        // Verify initial path count
        XCTAssertEqual(coordinator.path.count, 2, "Path count is incorrect after multiple pushes.")
        
        // Pop to root
        coordinator.popToRoot()
        
        // Verify path is empty
        XCTAssertTrue(coordinator.path.isEmpty, "Path is not empty after popToRoot.")
    }
    
    func testBuildUserListView() {
        // Build the user list view
        let view = coordinator.build(page: .userList)
        
        // Verify the view type (you can use `XCTAssertNotNil` or `XCTAssertTrue` with type checks)
        let hostingController = UIHostingController(rootView: view)
            
        XCTAssertNotNil(hostingController.view, "UserListView is not created properly.")
    }
    
    func testBuildUserDetailView() {
        // Build the user detail view
        let view = coordinator.build(page: .userDetail(loginName: "testUser"))
        
        let hostingController = UIHostingController(rootView: view)
            
        XCTAssertNotNil(hostingController.view, "UserDetailView is not created properly.")
        
    }
}
