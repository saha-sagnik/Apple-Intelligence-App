//
//  MealPlanDetailView.swift
//  Apple Intelligence App
//
//  Created by Sagnik Saha on 03/10/25.
//

import SwiftUI

struct MealPlanDetailView: View {
    let mealPlan: MealPlan

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            mealSummary

            LazyVStack(spacing: 12) {
                ForEach(Array(mealPlan.meals.enumerated()), id: \.offset) { index, meal in
                    MealRowView(meal: meal, mealType: mealType(for: index))
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private var mealSummary: some View {
        HStack {
            Image(systemName: "fork.knife.circle.fill")
                .foregroundColor(.green)

            Text("Daily Nutrition")
                .font(.subheadline)
                .fontWeight(.medium)

            Spacer()

            if let totalCalories = totalCalories {
                Text("\(totalCalories) cal")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green)
                    .cornerRadius(8)
            }

            Text("\(mealPlan.meals.count) meals")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.green.opacity(0.1))
        .cornerRadius(8)
    }

    private var totalCalories: Int? {
        let calories = mealPlan.meals.compactMap { $0.calories }
        return calories.isEmpty ? nil : calories.reduce(0, +)
    }

    private func mealType(for index: Int) -> String {
        switch index {
        case 0: return "Breakfast"
        case 1: return "Lunch"
        case 2: return "Dinner"
        case 3: return "Snack"
        default: return "Meal \(index + 1)"
        }
    }
}

struct MealRowView: View {
    let meal: Meal
    let mealType: String
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                mealIcon

                VStack(alignment: .leading, spacing: 4) {
                    Text(meal.name.isEmpty ? mealType : meal.name)
                        .font(.headline)
                        .foregroundColor(.primary)

                    if !meal.name.isEmpty && meal.name != mealType {
                        Text(mealType)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                if let calories = meal.calories {
                    Text("\(calories) cal")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.orange)
                        .cornerRadius(6)
                }

                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }

            if isExpanded && !meal.description.isEmpty {
                Text(meal.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.leading, 32)
                    .transition(.opacity.combined(with: .slide))
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }

    private var mealIcon: some View {
        Image(systemName: mealIconName)
            .foregroundColor(mealIconColor)
            .font(.title3)
            .frame(width: 24, height: 24)
    }

    private var mealIconName: String {
        switch mealType.lowercased() {
        case "breakfast":
            return "sunrise.fill"
        case "lunch":
            return "sun.max.fill"
        case "dinner":
            return "moon.fill"
        case "snack":
            return "leaf.fill"
        default:
            return "fork.knife"
        }
    }

    private var mealIconColor: Color {
        switch mealType.lowercased() {
        case "breakfast":
            return .orange
        case "lunch":
            return .yellow
        case "dinner":
            return .blue
        case "snack":
            return .green
        default:
            return .gray
        }
    }
}

#Preview {
    ScrollView {
        MealPlanDetailView(mealPlan: FitnessPlan.example.days[0].mealPlan)
            .padding()
    }
}