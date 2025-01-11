//
//  GithubUserPageTests.swift
//  GithubUserPageTests
//
//  Created by chinh on 1/9/25.
//

import XCTest
import SwiftUI
@testable import GithubUserPage


final class ImageDownloaderTests: XCTestCase {

    var mockCache: MockImageCacheManager!

    override func setUp() {
        super.setUp()
        mockCache = MockImageCacheManager()
        
    }

    func testImageDownloaderUsesCache() async {
        // Arrange
        let testURL = URL(string: "https://example.com/image.png")!
        let uuid = "test-uuid"
        let testImage = UIImage(systemName: "star")!
        let mockSession = MockURLSession.mockResponse(with: nil, error: nil) // Load from cache
        // Preload the cache
        await mockCache.setImage(testImage, forKey: uuid)
        
        let downloader = ImageDownloader(url: testURL,
                                         uuid: uuid,
                                         cacheManager: mockCache,
                                         urlSession: mockSession)
        await downloader.loadImage()
        XCTAssertNotNil(downloader.image)
        XCTAssertFalse(downloader.isLoading)
        XCTAssertEqual(downloader.image, Image(uiImage: testImage))
    }

    func testImageDownloaderFetchesFromNetwork() async {
        let testURL = URL(string: "https://example.com/image.png")!
        let uuid = UUID().uuidString
        let mockImageData = UIImage(systemName: "star")?.pngData()
        let mockSession = MockURLSession.mockResponse(with: mockImageData, error: nil)
        let expectation = self.expectation(description: "Image download should complete")

        let downloader = ImageDownloader(url: testURL,
                                         uuid: uuid,
                                         cacheManager: mockCache,
                                         urlSession: mockSession)
        await downloader.loadImage()
        
        try? await Task.sleep(for: .seconds(1))
        XCTAssertNotNil(downloader.image)
        XCTAssertFalse(downloader.isLoading)
        let image = await self.mockCache.getImage(forKey: uuid)
        XCTAssertTrue(image != nil)
        expectation.fulfill()
    
        await fulfillment(of: [expectation], timeout: 2.0)
    }

    func testImageDownloaderImageDataCannotBeingParsed() async {
        let testURL = URL(string: "https://example.com/image.png")!
        let uuid = UUID().uuidString
        let mockImageData = Data() // Dummy data
        let mockSession = MockURLSession.mockResponse(with: mockImageData, error: nil)
        let expectation = self.expectation(description: "Image download should complete")

        let downloader = ImageDownloader(url: testURL,
                                         uuid: uuid,
                                         cacheManager: mockCache,
                                         urlSession: mockSession)
        await downloader.loadImage()
        try? await Task.sleep(for: .seconds(1))
        XCTAssertNil(downloader.image)
        XCTAssertFalse(downloader.isLoading)
        let image = await self.mockCache.getImage(forKey: uuid)
        XCTAssertNil(image)
        expectation.fulfill()
        
        await fulfillment(of: [expectation], timeout: 2.0)
    }

    func testImageDownloaderHandlesErrorGracefully() async {
        let testURL = URL(string: "https://example.com/image.png")!
        let uuid = "test-uuid"
        let mockSession = MockURLSession.mockResponse(with: nil, error: URLError(.badURL))

        let downloader = ImageDownloader(url: testURL,
                                         uuid: uuid,
                                         cacheManager: mockCache,
                                         urlSession: mockSession)
        await downloader.loadImage()
        let expectation = self.expectation(description: "Image download should handle error")
        try? await Task.sleep(for: .seconds(1))
        XCTAssertNil(downloader.image)
        XCTAssertFalse(downloader.isLoading)
        let image = await self.mockCache.getImage(forKey: uuid)
        XCTAssertNil(image)
        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 2.0)
    }
    
    
}
