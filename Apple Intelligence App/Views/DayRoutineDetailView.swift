//
//  DayRoutineDetailView.swift
//  Apple Intelligence App
//
//  Created by Sagnik Saha on 03/10/25.
//

import SwiftUI

struct DayRoutineDetailView: View {
    let day: DayRoutine
    let dayNumber: Int

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                headerSection
                workoutSection
                mealPlanSection
                wellnessTipSection
            }
            .padding()
        }
        .navigationTitle("Day \(dayNumber)")
        .navigationBarTitleDisplayMode(.large)
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Day \(dayNumber)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(Color.blue)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    Text(day.title)
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(day.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private var workoutSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Workout", icon: "figure.strengthtraining.traditional", color: .blue)

            WorkoutDetailView(workout: day.workout)
        }
    }

    private var mealPlanSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Meal Plan", icon: "fork.knife", color: .green)

            MealPlanDetailView(mealPlan: day.mealPlan)
        }
    }

    private var wellnessTipSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "Wellness Tip", icon: "leaf.fill", color: .orange)

            HStack(spacing: 12) {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                    .font(.title3)

                Text(day.wellnessTip.tip)
                    .font(.subheadline)
                    .italic()
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.yellow.opacity(0.1))
            .cornerRadius(12)
        }
    }

    private func sectionHeader(title: String, icon: String, color: Color) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)

            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    NavigationStack {
        DayRoutineDetailView(day: FitnessPlan.example.days[0], dayNumber: 1)
    }
}