//
//  EnterAgeView.swift
//  TrueCam
//
//  Created by Damoon saber on 3/4/1405 AP.
//
import SwiftUI

struct EnterAgeView: View {
    
    @State private var selectedDay = 1
    @State private var selectedMonth = 1
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    
    @State private var showAgeError = false
    
    @Binding var age: String
    let onConfirm: () -> Void

    
    let days = Array(1...31)
    let months = Array(1...12)
    let years = Array(1950...Calendar.current.component(.year, from: Date()))
    
    var isOldEnough: Bool {
        let calendar = Calendar.current
        let comps = DateComponents(year: selectedYear, month: selectedMonth, day: selectedDay)
        guard let birthDate = calendar.date(from: comps) else { return false }
        
        let age = calendar.dateComponents([.year], from: birthDate, to: Date()).year ?? 0
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
                
                VStack {
                    Text("When is your birthday?")
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                    
                    Text("Only to make sure you're old enough to use TrueCam")
                        .foregroundStyle(.gray)
                        .lineLimit(1)
                        .font(.caption)
                        .padding(.top)
                }
                .padding(.top, 50)
                
                HStack(spacing: 15) {
                    
                    Picker(selection: $selectedDay) {
                        ForEach(days, id: \.self) { day in
                            Text(String(format: "%02d", day))
                                .foregroundStyle(.white)
                                .font(.system(size: 20, weight: .medium))
                        }
                    } label: { Text("") }
                        .frame(width: 80, height: 120)
                        .clipped()
                        .pickerStyle(.wheel)
                        .background(.white.opacity(0.05))
                        .cornerRadius(10)
                    
                    Picker(selection: $selectedMonth) {
                        ForEach(months, id: \.self) { month in
                            Text(monthName(month))
                                .foregroundStyle(.white)
                                .font(.system(size: 20, weight: .medium))
                        }
                    } label: { Text("") }
                        .frame(width: 80, height: 120)
                        .clipped()
                        .pickerStyle(.wheel)
                        .background(.white.opacity(0.05))
                        .cornerRadius(10)
                    
                    Picker(selection: $selectedYear) {
                        ForEach(years, id: \.self) { year in
                            Text(year, format: .number.grouping(.never))
                                .foregroundStyle(.white)
                                .font(.system(size: 20, weight: .medium))
                        }
                    } label: { Text("") }
                        .frame(width: 80, height: 120)
                        .clipped()
                        .pickerStyle(.wheel)
                        .background(.white.opacity(0.05))
                        .cornerRadius(10)
                }
                .padding(.top, -4)

                // Hide the warning when the date changes
                .onChange(of: selectedDay) {
                    showAgeError = false
                }
                .onChange(of: selectedMonth) {
                    showAgeError = false
                }
                .onChange(of: selectedYear) {
                    showAgeError = false
                }
                
                VStack(spacing: 8) {
                    Button(action: {
                        if isOldEnough {
                            print("Access granted: \(selectedDay)-\(selectedMonth)-\(selectedYear)")
                            showAgeError = false
                            onConfirm()
                        } else {
                            withAnimation(.easeInOut) {
                                showAgeError = true
                            }
                        }
                        
                    }) {
                        Text("CONFIRM")
                            .font(.caption.bold())
                            .kerning(2)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 30)
                            .background(isOldEnough ? Color.white : Color.gray.opacity(0.3))
                            .foregroundStyle(isOldEnough ? .black : .gray)
                            .cornerRadius(5)
                    }
                    .animation(.easeInOut, value: isOldEnough)
                    
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
        }
    }
    
    // Converts month number to short English name
    func monthName(_ m: Int) -> String {
        let formatter = DateFormatter()
        return formatter.shortMonthSymbols[m - 1]
    }
}


#Preview {
    EnterAgeView(age: .constant(""), onConfirm: {})
}
