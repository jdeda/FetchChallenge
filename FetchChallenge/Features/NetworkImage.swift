//
//  NetworkImage.swift
//  FetchChallenge
//
//  Created by Jesse Deda on 5/16/25.
//

import Foundation
import SwiftUI

struct NetworkImage<Content: View>: View {
    @State var phase: NetworkImagePhase = .loading
    @ViewBuilder var content: (NetworkImagePhase) -> Content
    
    var loader: ImageLoader
    
    let url: URL?
    
    init(url: URL?, loader: ImageLoader, content: @escaping (NetworkImagePhase) -> Content) {
        self.content = content
        self.url = url
        self.loader = loader
    }
    
    var body: some View {
        content(phase)
            .task { await load() }
    }
    
    
    func load() async {
        let phase: NetworkImagePhase = await {
            guard let url
            else { return .noURL }
            
            do {
                let image = try await loader.loadImage(url: url)
                return .success(Image(uiImage: image))
            } catch {
                print("An error occured while loading image from \(url): \(error)")
                return .failure
            }
        }()
        
        await MainActor.run {
            self.phase = phase
        }
    }
    
    enum LoadError: Error {
        case uiImageFailure
        
        var description: String {
            switch self {
            case .uiImageFailure: "Failed to init UIImage from data"
            }
        }
    }
}

enum NetworkImagePhase {
    case noURL
    case loading
    case failure
    case success(Image)
}

#Preview {
    NetworkImage(url: .temporaryDirectory, loader: MockImageLoader.default()) { phase in
        VStack {
            switch phase {
            case .noURL, .failure:
                Image(systemName: "photo.stack.fill")
                    .resizable()
                    .scaledToFit()
            case .loading:
                ProgressView()
            case let .success(image):
                image
                    .resizable()
                    .scaledToFit()
            }
        }
        .frame(width: 75, height: 75)
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}
