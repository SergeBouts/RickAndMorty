import Combine
import Foundation
import SwiftUI
import os.log

final class CharacterListViewModel: ObservableObject, TrackLoadingTrait {

    // MARK: - Properties

    let rickAndMortyRemoteRepository: RickAndMortyRemoteRepository

    let cellViewForCharacter: (CharacterModel) -> CharacterCellView
    let detailViewForCharacter: (CharacterModel) -> CharacterDetailView

    @Published @MainActor var characters: [CharacterModel] = []

    @Published @MainActor var isLoading = false

    private var currentPage = 1
    private var canLoadMorePages = true

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

        guard await !isLoading && canLoadMorePages else {
            return
        }

        os_log(.info, log: OSLog.default, "Loading page #\(self.currentPage)")

        do {
            try await trackLoading {

                let result = try await rickAndMortyRemoteRepository.characters(
                    by: !searchFilter.isEmpty ? CharacterFilter(name: searchFilter) : nil,
                    page: currentPage)
                await MainActor.run {
                    var newCharacters: [CharacterModel] = []
                    if let result = result {
                        self.canLoadMorePages = currentPage < result.info.pages
                        self.currentPage += 1
                        newCharacters = result.results
                    }
                    if Const.CharacterListView.isAnimated {
                        withAnimation {
                            self.characters += newCharacters
                        }
                    } else {
                        self.characters += newCharacters
                    }
                }
            }
        } catch {

            await MainActor.run {
                self.error = error
            }
        }
    }

    func loadMoreCharactersIfNeeded(currentCharacter character: CharacterModel) async {

        let thresholdIndex = await characters.index(characters.endIndex, offsetBy: -5)
        if await characters.firstIndex(where: { $0.id == character.id }) == thresholdIndex {
            await load()
        }
    }
}
