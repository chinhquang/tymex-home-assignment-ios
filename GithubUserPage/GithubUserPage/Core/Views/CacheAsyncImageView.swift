//
//  CacheAsyncImageView.swift
//  GithubUserPage
//
//  Created by chinh on 1/9/25.
//

import SwiftUI


struct CachedAsyncImage<Placeholder: View>: View {
    
    @StateObject private var imageLoader: ImageDownloader
    private let transition: AnyTransition
    private let placeholder: Placeholder
    init(url: URL,
         uuid: String = UUID().uuidString,
         transition: AnyTransition = .opacity,
         placeholder: Placeholder) {
        self.placeholder = placeholder
        self.transition = transition
        _imageLoader = StateObject(wrappedValue: ImageDownloader(url: url, uuid: uuid))
    }
    
    var body: some View {
        ZStack {
            Group{
                if let image = imageLoader.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .transition(transition)
                } else if imageLoader.isLoading {
                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                } else {
                    placeholder
                }
            }.task {
                await imageLoader.loadImage()
            }
        }
        .animation(.easeInOut, value: imageLoader.image != nil)
    }
}
