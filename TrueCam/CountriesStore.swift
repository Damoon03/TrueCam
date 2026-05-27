//
//  CountriesStore.swift
//  TrueCam
//
//  Created by Damoon saber on 3/6/1405 AP.
//

import Foundation
import Combine

// MARK: - Protocol (enables mock injection)
protocol CountriesStoreProtocol: ObservableObject {
    var countries: [Country] { get }
    var isLoading: Bool { get }
}

// MARK: - Live Store
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


// MARK: - Mock Store (previews & tests)
final class MockCountriesStore: CountriesStoreProtocol, ObservableObject {
    @Published private(set) var countries: [Country]
    @Published private(set) var isLoading: Bool = false

    init() {
        // Loads from the same countries.json in the bundle,
        // but falls back to empty so the Preview never crashes.
        let loaded = Self.loadFromBundle()
        self.countries = loaded.sorted { $0.displayName < $1.displayName }
    }

    private static func loadFromBundle() -> [Country] {
        // Works in both app target and Preview/test target
        // because we search all bundles in the current process.
        let bundles = [Bundle.main] + Bundle.allBundles + Bundle.allFrameworks

        for bundle in bundles {
            guard
                let url = bundle.url(forResource: "countries", withExtension: "json"),
                let data = try? Data(contentsOf: url),
                let decoded = try? JSONDecoder().decode([Country].self, from: data)
            else { continue }
            return decoded
        }

        // Last-resort in-memory fallback so the Preview canvas
        // still renders something even if the file isn't found.
        return [
            Country(phoneCode: "1",  isoCode: "US"),
            Country(phoneCode: "44", isoCode: "GB"),
            Country(phoneCode: "49", isoCode: "DE"),
        ]
    }
}

// Remove the Country.mockList extension entirely — no more hardcoded list needed.
