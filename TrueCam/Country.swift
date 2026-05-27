//
//  Country.swift
//  TrueCam
//
//  Created by Damoon saber on 3/6/1405 AP.
//


import Foundation

struct Country: Codable, Identifiable, Hashable {
    // For List identity. isoCode is unique enough here.
    var id: String { isoCode }

    let phoneCode: String
    let isoCode: String

    /// Localized country name (based on device language)
    var displayName: String {
        Locale.current.localizedString(forRegionCode: isoCode) ?? isoCode
    }

    /// Flag emoji from ISO country code
    var flag: String {
        let base: UInt32 = 127397
        return isoCode
            .uppercased()
            .unicodeScalars
            .compactMap { UnicodeScalar(base + $0.value) }
            .map { String($0) }
            .joined()
    }

    var displayDialCode: String { "+\(phoneCode)" }
}
