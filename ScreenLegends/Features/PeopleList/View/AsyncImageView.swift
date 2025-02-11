//
//  AsyncImageView.swift
//  ScreenLegends
//
//  Created by Pranjal Bhumij on 10/02/25.
//

import SwiftUI

struct AsyncImageView: View {
    @StateObject private var loader: ImageLoader
    private let url: URL?

    init(url: URL?) {
        self.url = url
        _loader = StateObject(wrappedValue: ImageLoader(url: nil))
    }

    var body: some View {
        ZStack {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
            } else if loader.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Image(systemName: "photo")
                    .resizable()
            }
        }
        .onAppear { loader.setURL(url) }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false
    private var url: URL?

    init(url: URL?) {
        self.url = url
    }

    func setURL(_ url: URL?) {
        self.url = url
        load()
    }

    func load() {
        guard let url = url else { return }
        isLoading = true
        URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                self.isLoading = false
                if let data = data, let uiImage = UIImage(data: data) {
                    self.image = uiImage
                }
            }
        }.resume()
    }
}



