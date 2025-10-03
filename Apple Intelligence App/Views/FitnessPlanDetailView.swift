//
//  FitnessPlanDetailView.swift
//  Apple Intelligence App
//
//  Created by Sagnik Saha on 03/10/25.
//

import SwiftUI

struct FitnessPlanDetailView: View {
    let plan: FitnessPlan

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                rationaleSection
                daysSection
            }
            .padding()
        }
        .navigationTitle("Your Plan")
        .navigationBarTitleDisplayMode(.large)
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.title2)

                Text(plan.title)
                    .font(.title2)
                    .fontWeight(.bold)
            }

            Text(plan.description)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private var rationaleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.orange)
                Text("Why This Plan?")
                    .font(.headline)
            }

            Text(plan.rationale)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
    }

    private var daysSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("7-Day Schedule")
                .font(.title3)
                .fontWeight(.semibold)

            LazyVStack(spacing: 12) {
                ForEach(Array(plan.days.enumerated()), id: \.offset) { index, day in
                    DayRowView(day: day, dayNumber: index + 1)
                }
            }
        }
    }
}

struct DayRowView: View {
    let day: DayRoutine
    let dayNumber: Int

    var body: some View {
        NavigationLink(destination: DayRoutineDetailView(day: day, dayNumber: dayNumber)) {
            HStack(spacing: 16) {
                dayNumberBadge

                VStack(alignment: .leading, spacing: 4) {
                    Text(day.title)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(day.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    HStack(spacing: 16) {
                        Label(day.workout.focusArea.rawValue.capitalized, systemImage: "figure.strengthtraining.traditional")
                            .font(.caption)
                            .foregroundColor(.blue)

                        Label("\(day.mealPlan.meals.count) meals", systemImage: "fork.knife")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var dayNumberBadge: some View {
        Text("Day \(dayNumber)")
            .font(.caption)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(width: 50, height: 50)
            .background(Color.blue)
            .clipShape(Circle())
    }
}

#Preview {
    NavigationStack {
        FitnessPlanDetailView(plan: .example)
    }
}