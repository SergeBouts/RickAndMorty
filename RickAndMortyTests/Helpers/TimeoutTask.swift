import Foundation

actor TimeoutTask<Output> {

    // MARK: - Properties

    let nanoseconds: UInt64
    let exec: @Sendable () async throws -> Output

    private var continuation: CheckedContinuation<Output, Error>?

    // MARK: - Initialization

    init(
        seconds: TimeInterval,
        exec: @escaping @Sendable () async throws -> Output
    ) {
        self.nanoseconds = UInt64(seconds * 1_000_000_000)
        self.exec = exec
    }

    // MARK: - API

    var result: Output {

        get async throws {

            try await withCheckedThrowingContinuation { continuation in

                self.continuation = continuation

                Task {
                    try await Task.sleep(nanoseconds: nanoseconds)
                    self.continuation?.resume(throwing: TimeoutError())
                    self.continuation = nil
                }

                Task {
                    do {
                        let output = try await exec()
                        self.continuation?.resume(returning: output)
                        self.continuation = nil
                    } catch {
                        self.continuation?.resume(throwing: error)
                        self.continuation = nil
                    }
                }
            }
        }
    }

    func cancel() {

        continuation?.resume(throwing: CancellationError())
        continuation = nil
    }
}

extension TimeoutTask {

    struct TimeoutError: LocalizedError {

        var errorDescription: String? { "Timeout." }
    }
}
