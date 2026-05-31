//
//  EnterAgeView.swift
//  TrueCam
//
//  Created by Damoon saber on 3/9/1405 AP.
//

import SwiftUI

struct EnterAgeView: View {
    @Binding var birthDate: Date?
    let onConfirm: () -> Void

    @State private var selectedDay: Int = 1
    @State private var selectedMonth: Int = 1
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())

    @State private var showAgeError = false

    private let months = Array(1...12)

    private var years: [Int] {
        Array(1950...Calendar.current.component(.year, from: Date())).reversed()
    }

    private var validDays: [Int] {
        var comps = DateComponents()
        comps.year = selectedYear
        comps.month = selectedMonth

        let calendar = Calendar.current
        let date = calendar.date(from: comps) ?? Date()

        let range = calendar.range(of: .day, in: .month, for: date) ?? 1..<32
        return Array(range)
    }

    private var selectedBirthDate: Date? {
        let calendar = Calendar.current
        let comps = DateComponents(
            year: selectedYear,
            month: selectedMonth,
            day: selectedDay
        )
        return calendar.date(from: comps)
    }

    private var isOldEnough: Bool {
        guard let selectedBirthDate else { return false }
        let age = Calendar.current.dateComponents([.year], from: selectedBirthDate, to: Date()).year ?? 0
        return age >= 18
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 40) {
                HStack {
                    Spacer()
                    Text("TrueCam.")
                        .foregroundStyle(.white)
                        .font(.system(size: 22))
                        .font(.caption.bold())
                        .kerning(2)
                    Spacer()
                }

                VStack(spacing: 12) {
                    Text("When is your birthday?")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)

                    Text("Only to make sure you're old enough to use TrueCam")
                        .foregroundStyle(.gray)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                .padding(.top, 50)

                HStack(spacing: 15) {
                    Picker("", selection: $selectedDay) {
                        ForEach(validDays, id: \.self) { day in
                            Text(String(format: "%02d", day))
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(width: 80, height: 120)
                    .clipped()
                    .pickerStyle(.wheel)
                    .background(.white.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                    Picker("", selection: $selectedMonth) {
                        ForEach(months, id: \.self) { month in
                            Text(monthName(month))
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(width: 90, height: 120)
                    .clipped()
                    .pickerStyle(.wheel)
                    .background(.white.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                    Picker("", selection: $selectedYear) {
                        ForEach(years, id: \.self) { year in
                            Text(String(year))
                                .monospacedDigit()
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(width: 90, height: 120)
                    .clipped()
                    .pickerStyle(.wheel)
                    .background(.white.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.top, -4)
                .onChange(of: selectedDay) {
                    showAgeError = false
                }
                .onChange(of: selectedMonth) {
                    showAgeError = false
                    adjustDayIfNeeded()
                }
                .onChange(of: selectedYear) {
                    showAgeError = false
                    adjustDayIfNeeded()
                }

                VStack(spacing: 8) {
                    Button {
                        if isOldEnough, let selectedBirthDate {
                            birthDate = selectedBirthDate
                            showAgeError = false
                            onConfirm()
                        } else {
                            withAnimation(.easeInOut) {
                                showAgeError = true
                            }
                        }
                    } label: {
                        Text("CONFIRM")
                            .font(.caption.bold())
                            .kerning(2)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 30)
                            .background(isOldEnough ? Color.white : Color.gray.opacity(0.3))
                            .foregroundStyle(isOldEnough ? .black : .gray)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }

                    if showAgeError {
                        Text("You must be 18+ to use TrueCam")
                            .font(.caption)
                            .foregroundStyle(.red.opacity(0.9))
                            .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .animation(.easeInOut, value: showAgeError)

                Spacer()
            }
            .foregroundStyle(.white)
            .padding()
        }
        .onAppear {
            loadExistingBirthDateIfNeeded()
        }
    }

    private func adjustDayIfNeeded() {
        if !validDays.contains(selectedDay) {
            selectedDay = validDays.last ?? 1
        }
    }

    private func loadExistingBirthDateIfNeeded() {
        guard let birthDate else { return }

        let calendar = Calendar.current
        selectedDay = calendar.component(.day, from: birthDate)
        selectedMonth = calendar.component(.month, from: birthDate)
        selectedYear = calendar.component(.year, from: birthDate)

        adjustDayIfNeeded()
    }

    private func monthName(_ month: Int) -> String {
        let formatter = DateFormatter()
        return formatter.shortMonthSymbols[month - 1]
    }
}

#Preview {
    EnterAgeView(birthDate: .constant(nil)) {

    }
}
