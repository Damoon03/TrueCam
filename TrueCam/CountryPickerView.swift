//
//  SelectCountryView.swift
//  TrueCam
//
//  Created by Damoon saber on 3/6/1405 AP.
//
import SwiftUI

struct CountryPickerView<Store: CountriesStoreProtocol>: View {
    @ObservedObject var store: Store
    let onSelect: (Country) -> Void

    @State private var searchText = ""
    @Environment(\.dismiss) private var dismiss

    private var filtered: [Country] {
        guard !searchText.isEmpty else { return store.countries }
        let q = searchText.lowercased()
        return store.countries.filter {
            $0.displayName.lowercased().contains(q) ||
            $0.phoneCode.contains(q) ||
            $0.isoCode.lowercased().contains(q)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                

                Group {
                    if store.isLoading {
                        ProgressView("Loading countries…")
                            .tint(.white)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)

                    } else if filtered.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 40))
                                .foregroundStyle(.white.opacity(0.2))
                            Text("No results for \"\(searchText)\"")
                                .foregroundStyle(.white.opacity(0.4))
                                .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                    } else {
                        List(filtered) { country in
                            CountryRowView(country: country)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    onSelect(country)
                                    dismiss()
                                }
                                .listRowBackground(Color.clear)
                                .listRowSeparatorTint(.white.opacity(0.08))
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .navigationTitle("Select Country")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.backward")
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                            
                    }
                }
                .sharedBackgroundVisibility(.hidden)
            }
        }
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search by name or code"
        )
        .preferredColorScheme(.dark)
    }
}

// MARK: - Row
private struct CountryRowView: View {
    let country: Country

    var body: some View {
        HStack(spacing: 14) {
            Text(country.flag)
                .font(.title2)
                .frame(width: 40, height: 40)
                .background(.white.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 3) {
                Text(country.displayName)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                Text(country.displayDialCode)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.4))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.2))
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Previews
#Preview("With mock data") {
    CountryPickerView(store: MockCountriesStore()) { country in
        print("Selected: \(country.displayName)")
    }
}
