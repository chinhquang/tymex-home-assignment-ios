//
//  JsonLoader.swift
//  GithubUserPage
//
//  Created by chinh on 1/11/25.
//

import Foundation

struct JSONLoader {
    enum JSONLoaderError: Error {
        case fileNotFound(String)
        case dataLoadError(String, Error)
    }
    
    static func loadJSON(from fileName: String, in bundle: Bundle = .main) throws -> Data {
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            throw JSONLoaderError.fileNotFound("\(fileName).json not found in bundle.")
        }
        do {
            return try Data(contentsOf: url)
        } catch {
            throw JSONLoaderError.dataLoadError("Failed to load data from \(fileName).json", error)
        }
    }
}
