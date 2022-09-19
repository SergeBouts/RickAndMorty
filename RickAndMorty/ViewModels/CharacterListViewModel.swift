import Combine
import Foundation
import SwiftUI

final class CharacterListViewModel: ObservableObject {

    // MARK: - Properties

    let rickAndMortyRemoteRepository: RickAndMortyRemoteRepository

    let cellViewForCharacter: (CharacterModel) -> CharacterCellView
    let detailViewForCharacter: (CharacterModel) -> CharacterDetailView

    @Published @MainActor var characters: [CharacterModel] = []

    @Published @MainActor var isLoading = false

    @Published @MainActor var searchFilter: String = ""

    @Published @MainActor var error: Error?

    private var subscriptions: Set<AnyCancellable> = []

    // MARK: - Initialization

    init(
        rickAndMortyRemoteRepository: RickAndMortyRemoteRepository,
        cellViewForCharacter: @escaping (CharacterModel) -> CharacterCellView,
        detailViewForCharacter: @escaping (CharacterModel) -> CharacterDetailView
    ) {

        self.rickAndMortyRemoteRepository = rickAndMortyRemoteRepository
        self.cellViewForCharacter = cellViewForCharacter
        self.detailViewForCharacter = detailViewForCharacter

        $searchFilter
            .dropFirst() // we don't need the current value, which is published on subscription
            .removeDuplicates()
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink(receiveValue: { _ in
                Task.detached {
                    await self.load()
                }
            })
            .store(in: &subscriptions)
    }

    // MARK: - API

    func load() async {

        do {
            try await isLodingWrapper {

                let characters = try await rickAndMortyRemoteRepository.characters(by: !searchFilter.isEmpty ? CharacterFilter(name: searchFilter) : nil)
                await MainActor.run {
                    if Const.CharacterListView.isAnimated {
                        withAnimation {
                            self.characters = characters
                        }
                    } else {
                        self.characters = characters
                    }
                }
            }
        } catch {

            await MainActor.run {
                self.error = error
            }
        }
    }

    func isLodingWrapper<T>(exec: () async throws -> T) async throws -> T {

        await MainActor.run { withAnimation(.linear(duration: 0.1)) { self.isLoading = true } }

        let result: Result<T, Error>
        do {
            result = .success(try await exec())
        } catch {
            result = .failure(error)
        }

        await MainActor.run { withAnimation(.linear(duration: 0.1)) { self.isLoading = false } }

        switch result {
        case .success(let v):
            return v
        case .failure(let e):
            throw e
        }
    }
}
