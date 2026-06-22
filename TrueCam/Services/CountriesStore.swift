//
//  CountriesStore.swift
//  TrueCam
//

import Foundation
import Combine

protocol CountriesStoreProtocol: ObservableObject {
    var countries: [Country] { get }
    var isLoading: Bool { get }
}

final class CountriesStore: CountriesStoreProtocol, ObservableObject {
    @Published private(set) var countries: [Country] = []
    @Published private(set) var isLoading: Bool = false

    init() { load() }

    private func load() {
        isLoading = true
        guard
            let url = Bundle.main.url(forResource: "Countries", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let decoded = try? JSONDecoder().decode([Country].self, from: data)
        else {
            isLoading = false
            return
        }
        countries = decoded.sorted { $0.displayName < $1.displayName }
        isLoading = false
    }
}

final class MockCountriesStore: CountriesStoreProtocol, ObservableObject {
    @Published private(set) var countries: [Country]
    @Published private(set) var isLoading: Bool = false

    init() {
        let loaded = Self.loadFromBundle()
        self.countries = loaded.sorted { $0.displayName < $1.displayName }
    }

    private static func loadFromBundle() -> [Country] {
        let bundles = [Bundle.main] + Bundle.allBundles + Bundle.allFrameworks
        for bundle in bundles {
            guard
                let url = bundle.url(forResource: "countries", withExtension: "json"),
                let data = try? Data(contentsOf: url),
                let decoded = try? JSONDecoder().decode([Country].self, from: data)
            else { continue }
            return decoded
        }
        return [
            Country(phoneCode: "1",  isoCode: "US"),
            Country(phoneCode: "44", isoCode: "GB"),
            Country(phoneCode: "49", isoCode: "DE"),
        ]
    }
}
