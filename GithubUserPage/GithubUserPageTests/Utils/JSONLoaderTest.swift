//
//  JSONLoaderTest.swift
//  GithubUserPage
//
//  Created by chinh on 1/11/25.
//

import XCTest
@testable import GithubUserPage

final class JSONLoaderTests: XCTestCase {
    
    func testLoadJSONSuccess() {
        // Ensure the test bundle contains the sample JSON file
        let testBundle = Bundle(for: type(of: self))
        
        do {
            let data = try JSONLoader.loadJSON(from: "mock_api_client_data", in: testBundle)
            XCTAssertNotNil(data, "Data should not be nil for valid JSON file.")
        } catch {
            XCTFail("Failed to load JSON file: \(error)")
        }
    }
    
    func testLoadJSONFileNotFound() {
        let testBundle = Bundle(for: type(of: self))
        
        do {
            _ = try JSONLoader.loadJSON(from: "mock_api_client_data_non_existed", in: testBundle)
            XCTFail("Expected to throw an error for a missing file.")
        } catch JSONLoader.JSONLoaderError.fileNotFound(let message) {
            XCTAssertEqual(message, "mock_api_client_data_non_existed.json not found in bundle.", "Error message mismatch.")
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
