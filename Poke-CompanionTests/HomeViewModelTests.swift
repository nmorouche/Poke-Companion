//
//  HomeViewModelTests.swift
//  Poke-CompanionTests
//
//  Created by Nassim Morouche on 18/07/2023.
//

import XCTest
import Injector
@testable import Poke_Companion

final class HomeViewModelTests: XCTestCase {

    var sut: HomeViewModel!
    var mockPokemonService: MockPokemonService!

    override func setUp() async throws {
        try await super.setUp()
        mockPokemonService = MockPokemonService()

        // Register mock service with Injector
        Locator.register(PokemonServiceProtocol.self, mode: .newInstance) {
            self.mockPokemonService
        }

        // Initialize after registering the mock
        sut = HomeViewModel()

        // Wait a bit for init Task to complete
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
    }

    override func tearDown() {
        sut = nil
        mockPokemonService = nil
        super.tearDown()
    }

    // MARK: - Initialization Tests

    func testInit_FetchesPokemonsOnInitialization() async throws {
        // Given
        let expectedPokemons = [Pokemon.mockedPokemon, Pokemon.mockedPokemon2]
        mockPokemonService.fetchPokemonsResult = .success((200, expectedPokemons))

        // When
        let viewModel = HomeViewModel()
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds

        // Then
        await MainActor.run {
            XCTAssertEqual(viewModel.pokemons.count, 2)
            XCTAssertEqual(viewModel.offset, 100)
            XCTAssertEqual(viewModel.maximumPokemonsCount, 200)
        }
    }

    // MARK: - Fetch Pokemons Tests

    func testFetchPokemons_Success_UpdatesPokemonsAndOffset() async {
        // Given
        let expectedPokemons = [Pokemon.mockedPokemon, Pokemon.mockedPokemon2]
        mockPokemonService.fetchPokemonsResult = .success((200, expectedPokemons))

        await MainActor.run {
            sut._pokemons = []
            sut.offset = 0
            sut.maximumPokemonsCount = -1
        }

        // When
        await sut.fetchPokemons()

        // Then
        await MainActor.run {
            XCTAssertEqual(sut.pokemons.count, 2)
            XCTAssertEqual(sut.offset, 100)
            XCTAssertEqual(sut.maximumPokemonsCount, 200)
            XCTAssertFalse(sut.isLoading)
            XCTAssertFalse(sut.isError)
        }
    }

    func testFetchPokemons_Success_AppendsToExistingPokemons() async {
        // Given
        let initialPokemons = [Pokemon.mockedPokemon]
        let newPokemons = [Pokemon.mockedPokemon2]

        await MainActor.run {
            sut._pokemons = initialPokemons
            sut.offset = 100
            sut.maximumPokemonsCount = 200
        }

        mockPokemonService.fetchPokemonsResult = .success((200, newPokemons))

        // When
        await sut.fetchPokemons()

        // Then
        await MainActor.run {
            XCTAssertEqual(sut.pokemons.count, 2)
            XCTAssertEqual(sut.pokemons[0].id, 1)
            XCTAssertEqual(sut.pokemons[1].id, 2)
            XCTAssertEqual(sut.offset, 200)
        }
    }

    func testFetchPokemons_Failure_SetsError() async {
        // Given
        mockPokemonService.fetchPokemonsResult = .failure(.generic)

        await MainActor.run {
            sut._pokemons = []
            sut.offset = 0
            sut.maximumPokemonsCount = -1
        }

        // When
        await sut.fetchPokemons()

        // Then
        await MainActor.run {
            XCTAssertTrue(sut.isError)
            XCTAssertEqual(sut.pokemons.count, 0)
            XCTAssertFalse(sut.isLoading)
        }
    }

    func testFetchPokemons_WhenAlreadyLoading_DoesNotFetch() async {
        // Given
        mockPokemonService.fetchPokemonsResult = .success((200, [Pokemon.mockedPokemon]))

        await MainActor.run {
            sut.isLoading = true
            sut.offset = 0
        }

        let initialCallCount = mockPokemonService.fetchPokemonsCallCount

        // When
        await sut.fetchPokemons()

        // Then
        XCTAssertEqual(mockPokemonService.fetchPokemonsCallCount, initialCallCount)
    }

    func testFetchPokemons_WhenOffsetEqualsMaximum_DoesNotFetch() async {
        // Given
        mockPokemonService.fetchPokemonsResult = .success((200, [Pokemon.mockedPokemon]))

        await MainActor.run {
            sut.offset = 200
            sut.maximumPokemonsCount = 200
        }

        let initialCallCount = mockPokemonService.fetchPokemonsCallCount

        // When
        await sut.fetchPokemons()

        // Then
        XCTAssertEqual(mockPokemonService.fetchPokemonsCallCount, initialCallCount)
    }

    func testFetchPokemons_SetsLoadingStateCorrectly() async {
        // Given
        mockPokemonService.fetchPokemonsResult = .success((200, [Pokemon.mockedPokemon]))
        mockPokemonService.fetchDelay = 0.1

        await MainActor.run {
            sut._pokemons = []
            sut.offset = 0
            sut.maximumPokemonsCount = -1
        }

        // When
        let fetchTask = Task {
            await sut.fetchPokemons()
        }

        try? await Task.sleep(nanoseconds: 50_000_000) // 0.05 seconds

        // Then - Loading should be true during fetch
        await MainActor.run {
            XCTAssertTrue(sut.isLoading)
        }

        await fetchTask.value

        // Then - Loading should be false after fetch
        await MainActor.run {
            XCTAssertFalse(sut.isLoading)
        }
    }

    // MARK: - Filtering Tests

    func testPokemons_WithNoFilter_ReturnsAllPokemons() async {
        // Given
        let pokemon1 = Pokemon(id: 1, name: "Bulbasaur", order: 1,
                              typesValue: [TypesResult(slot: 1, type: PokemonTypes(name: .grass, url: ""))],
                              abilities: [], baseHeight: 7, baseWeight: 69, stats: [])
        let pokemon2 = Pokemon(id: 4, name: "Charmander", order: 4,
                              typesValue: [TypesResult(slot: 1, type: PokemonTypes(name: .fire, url: ""))],
                              abilities: [], baseHeight: 6, baseWeight: 85, stats: [])

        await MainActor.run {
            sut._pokemons = [pokemon1, pokemon2]
            sut.selectedFilter = nil
        }

        // When/Then
        await MainActor.run {
            XCTAssertEqual(sut.pokemons.count, 2)
        }
    }

    func testPokemons_WithFilter_ReturnsFilteredPokemons() async {
        // Given
        let pokemon1 = Pokemon(id: 1, name: "Bulbasaur", order: 1,
                              typesValue: [TypesResult(slot: 1, type: PokemonTypes(name: .grass, url: ""))],
                              abilities: [], baseHeight: 7, baseWeight: 69, stats: [])
        let pokemon2 = Pokemon(id: 4, name: "Charmander", order: 4,
                              typesValue: [TypesResult(slot: 1, type: PokemonTypes(name: .fire, url: ""))],
                              abilities: [], baseHeight: 6, baseWeight: 85, stats: [])

        await MainActor.run {
            sut._pokemons = [pokemon1, pokemon2]
            sut.selectedFilter = .fire
        }

        // When/Then
        await MainActor.run {
            let filteredPokemons = sut.pokemons
            XCTAssertEqual(filteredPokemons.count, 1)
            XCTAssertEqual(filteredPokemons[0].name, "Charmander")
        }
    }

    func testPokemons_WithFilterNoMatches_ReturnsEmptyArray() async {
        // Given
        let pokemon1 = Pokemon(id: 1, name: "Bulbasaur", order: 1,
                              typesValue: [TypesResult(slot: 1, type: PokemonTypes(name: .grass, url: ""))],
                              abilities: [], baseHeight: 7, baseWeight: 69, stats: [])

        await MainActor.run {
            sut._pokemons = [pokemon1]
            sut.selectedFilter = .water
        }

        // When/Then
        await MainActor.run {
            XCTAssertEqual(sut.pokemons.count, 0)
        }
    }

    func testPokemons_WithDualTypeFilter_ReturnsMatchingPokemons() async {
        // Given
        let pokemon1 = Pokemon(id: 6, name: "Charizard", order: 6,
                              typesValue: [
                                TypesResult(slot: 1, type: PokemonTypes(name: .fire, url: "")),
                                TypesResult(slot: 2, type: PokemonTypes(name: .flying, url: ""))
                              ],
                              abilities: [], baseHeight: 17, baseWeight: 905, stats: [])
        let pokemon2 = Pokemon(id: 4, name: "Charmander", order: 4,
                              typesValue: [TypesResult(slot: 1, type: PokemonTypes(name: .fire, url: ""))],
                              abilities: [], baseHeight: 6, baseWeight: 85, stats: [])

        await MainActor.run {
            sut._pokemons = [pokemon1, pokemon2]
            sut.selectedFilter = .fire
        }

        // When/Then
        await MainActor.run {
            let filteredPokemons = sut.pokemons
            XCTAssertEqual(filteredPokemons.count, 2)
        }
    }

    // MARK: - hasMorePokemons Tests

    func testHasMorePokemons_WhenMaximumIsNegative_ReturnsTrue() {
        // Given
        sut.maximumPokemonsCount = -1
        sut.offset = 0

        // When/Then
        XCTAssertTrue(sut.hasMorePokemons())
    }

    func testHasMorePokemons_WhenOffsetLessThanMaximum_ReturnsTrue() {
        // Given
        sut.maximumPokemonsCount = 200
        sut.offset = 100

        // When/Then
        XCTAssertTrue(sut.hasMorePokemons())
    }

    func testHasMorePokemons_WhenOffsetEqualsMaximum_ReturnsFalse() {
        // Given
        sut.maximumPokemonsCount = 200
        sut.offset = 200

        // When/Then
        XCTAssertFalse(sut.hasMorePokemons())
    }

    func testHasMorePokemons_WhenOffsetGreaterThanMaximum_ReturnsFalse() {
        // Given
        sut.maximumPokemonsCount = 200
        sut.offset = 300

        // When/Then
        XCTAssertFalse(sut.hasMorePokemons())
    }

    // MARK: - Search Text Tests

    func testSearchText_CanBeUpdated() async {
        // Given
        let expectedText = "Pikachu"

        // When
        await MainActor.run {
            sut.searchText = expectedText
        }

        // Then
        await MainActor.run {
            XCTAssertEqual(sut.searchText, expectedText)
        }
    }

    // MARK: - Published Properties Tests

    func testPublishedProperties_AreUpdatedCorrectly() async {
        // Given
        let newFilter = PokemonType.water

        // When
        await MainActor.run {
            sut.selectedFilter = newFilter
            sut.searchText = "test"
            sut.offset = 200
        }

        // Then
        await MainActor.run {
            XCTAssertEqual(sut.selectedFilter, newFilter)
            XCTAssertEqual(sut.searchText, "test")
            XCTAssertEqual(sut.offset, 200)
        }
    }
}
