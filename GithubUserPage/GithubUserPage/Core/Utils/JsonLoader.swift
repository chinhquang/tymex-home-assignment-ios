//
//  JsonLoader.swift
//  GithubUserPage
//
//  Created by chinh on 1/11/25.
//

import Foundation

struct JSONLoader {
    static func loadJSON(from fileName: String, in bundle: Bundle = .main) -> Data {
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            fatalError("Could not find \(fileName).json in bundle.")
        }
        do {
            return try Data(contentsOf: url)
        } catch {
            fatalError("Could not load data from \(fileName).json: \(error)")
        }
    }
}
