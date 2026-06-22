//
//  Country.swift
//  TrueCam
//

import Foundation

struct Country: Codable, Identifiable, Hashable {
    var id: String { isoCode }

    let phoneCode: String
    let isoCode: String

    var displayName: String {
        Locale.current.localizedString(forRegionCode: isoCode) ?? isoCode
    }

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
