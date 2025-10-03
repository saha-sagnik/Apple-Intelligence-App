//
//  WorkoutDetailView.swift
//  Apple Intelligence App
//
//  Created by Sagnik Saha on 03/10/25.
//

import SwiftUI

struct WorkoutDetailView: View {
    let workout: Workout

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            focusAreaBadge

            LazyVStack(spacing: 12) {
                ForEach(Array(workout.exercises.enumerated()), id: \.offset) { index, exercise in
                    ExerciseRowView(exercise: exercise, index: index + 1)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private var focusAreaBadge: some View {
        HStack {
            Image(systemName: focusAreaIcon(for: workout.focusArea))
                .foregroundColor(.blue)

            Text("Focus: \(workout.focusArea.rawValue.capitalized)")
                .font(.subheadline)
                .fontWeight(.medium)

            Spacer()

            Text("\(workout.exercises.count) exercises")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(8)
    }

    private func focusAreaIcon(for focusArea: FocusArea) -> String {
        switch focusArea {
        case .arms:
            return "figure.arms.open"
        case .core:
            return "figure.core.training"
        case .fullBody:
            return "figure.strengthtraining.traditional"
        case .legs:
            return "figure.walk"
        case .chest:
            return "figure.boxing"
        case .back:
            return "figure.rowing"
        case .cardio:
            return "figure.run"
        case .recovery:
            return "figure.yoga"
        }
    }
}

struct ExerciseRowView: View {
    let exercise: Exercise
    let index: Int
    @State private var isCompleted = false

    var body: some View {
        HStack(spacing: 16) {
            exerciseNumber

            VStack(alignment: .leading, spacing: 6) {
                Text(exercise.name)
                    .font(.headline)
                    .foregroundColor(isCompleted ? .secondary : .primary)

                HStack(spacing: 12) {
                    Label("\(exercise.sets) sets", systemImage: "repeat")
                        .font(.caption)
                        .foregroundColor(.blue)

                    Label("\(exercise.reps) reps", systemImage: "number")
                        .font(.caption)
                        .foregroundColor(.green)
                }

                if let description = exercise.description, !description.isEmpty {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .italic()
                }
            }

            Spacer()

            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isCompleted.toggle()
                }
            }) {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isCompleted ? .green : .gray)
                    .font(.title3)
            }
        }
        .padding()
        .background(isCompleted ? Color.green.opacity(0.1) : Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isCompleted ? Color.green.opacity(0.3) : Color.clear, lineWidth: 2)
        )
        .scaleEffect(isCompleted ? 0.98 : 1.0)
    }

    private var exerciseNumber: some View {
        Text("\(index)")
            .font(.caption)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(width: 24, height: 24)
            .background(isCompleted ? Color.green : Color.blue)
            .clipShape(Circle())
    }
}

#Preview {
    ScrollView {
        WorkoutDetailView(workout: FitnessPlan.example.days[0].workout)
            .padding()
    }
}