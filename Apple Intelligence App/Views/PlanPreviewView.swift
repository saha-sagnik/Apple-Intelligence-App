//
//  PlanPreviewView.swift
//  Apple Intelligence App
//
//  Created by Sagnik Saha on 03/10/25.
//

import SwiftUI

struct PlanPreviewView: View {
    let plan: FitnessPlan

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            successHeader
            planSummary
            navigationButton
        }
        .padding(20)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private var successHeader: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.title2)

            VStack(alignment: .leading, spacing: 2) {
                Text("Plan Generated!")
                    .font(.headline)
                    .foregroundColor(.green)

                Text("Your personalized fitness journey awaits")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
    }

    private var planSummary: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(plan.title)
                .font(.title3)
                .fontWeight(.semibold)
                .lineLimit(2)

            Text(plan.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(3)

            HStack(spacing: 16) {
                Label("7 Days", systemImage: "calendar")
                    .font(.caption)
                    .foregroundColor(.blue)

                Label("\(totalExercises) Exercises", systemImage: "figure.strengthtraining.traditional")
                    .font(.caption)
                    .foregroundColor(.orange)

                Label("\(totalMeals) Meals", systemImage: "fork.knife")
                    .font(.caption)
                    .foregroundColor(.green)
            }
        }
    }

    private var navigationButton: some View {
        NavigationLink(destination: FitnessPlanDetailView(plan: plan)) {
            HStack {
                Text("View Full Plan")
                    .fontWeight(.medium)

                Spacer()

                Image(systemName: "arrow.right.circle.fill")
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
        }
    }

    private var totalExercises: Int {
        plan.days.reduce(0) { total, day in
            total + day.workout.exercises.count
        }
    }

    private var totalMeals: Int {
        plan.days.reduce(0) { total, day in
            total + day.mealPlan.meals.count
        }
    }
}

#Preview {
    NavigationStack {
        ScrollView {
            VStack(spacing: 20) {
                PlanPreviewView(plan: .example)
                PlanPreviewView(plan: .example)
            }
            .padding()
        }
    }
}