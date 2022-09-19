import UIKit

actor ImageCache {

    enum ImageLoaderError: Error {
        case download(Error)
        case resize
    }

    // MARK: - Types

    enum DownloadState {

        case inProgress(Task<(UIImage, UIImage), Error>)
        case completed(UIImage, UIImage)
        case failed(Error)
    }

    // MARK: - Properties

    private(set) var cache: [String: DownloadState] = [:]

    private let downloader: (URL) async throws -> UIImage

    // MARK: - Initialization

    init(downloader: @escaping (URL) async throws -> UIImage) {
        self.downloader = downloader
    }

    func get(at url: URL) async throws -> (image: UIImage, thumb: UIImage) {

        if let cached = cache[url.absoluteString] {

            switch cached {
            case .completed(let image, let thumb):
                return (image: image, thumb: thumb)
            case .inProgress(let task):
                return try await task.value
            case .failed(let error): throw ImageLoaderError.download(error)
            }

        } else {

            let downloadTask: Task<(UIImage, UIImage), Error> = Task.detached {
                let image = try await self.downloader(url)
                guard let thumb = image.resizedImage(scale: 0.3) else { throw ImageLoaderError.resize }
                return (image, thumb)
            }

            cache[url.absoluteString] = .inProgress(downloadTask)

            do {
                let (image, thumb) = try await downloadTask.value
                cache[url.absoluteString] = .completed(image, thumb)
                return (image: image, thumb: thumb)
            } catch {
                cache[url.absoluteString] = .failed(error)
                throw ImageLoaderError.download(error)
            }
        }
    }

    func clearCache() {

        cache.removeAll()
    }
}
