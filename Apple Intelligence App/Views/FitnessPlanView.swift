//
//  FitnessPlanView.swift
//  Apple Intelligence App
//
//  Created by Sagnik Saha on 03/10/25.
//

import SwiftUI

struct FitnessPlanView: View {
    @State private var generator = FitnessPlanGenerator()
    @State private var userInput = ""
    @State private var showingPlanDetail = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                headerSection
                inputSection
                generateButton

                if generator.isLoading {
                    loadingView
                } else if let plan = generator.plan {
                    planPreview(plan)
                } else if let error = generator.error {
                    errorView(error)
                } else if let rawResponse = generator.rawResponse {
                    rawResponseView(rawResponse)
                }

                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var headerSection: some View {
        VStack(spacing: 8) {
            
            Text("Fitness Planner")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Image(systemName: "figure.run.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)

            Text("AI Fitness Coach")
                .font(.title2)
                .fontWeight(.bold)

            Text("Get your personalized 7-day fitness plan")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private var inputSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Tell us about your fitness goals:")
                .font(.headline)

            TextEditor(text: $userInput)
                .frame(minHeight: 100)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )

            Text("Example: I want to lose belly fat and build arm muscle. I have access to a gym and prefer Indian non-vegetarian meals.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    private var generateButton: some View {
        Button(action: {
            Task {
                await generator.generatePlan(for: userInput)
            }
        }) {
            HStack {
                Image(systemName: "wand.and.stars")
                Text("Generate My Plan")
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(userInput.isEmpty ? Color.gray : Color.blue)
            .cornerRadius(10)
        }
        .disabled(userInput.isEmpty || generator.isLoading)
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            Text("Creating your personalized plan...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }

    private func planPreview(_ plan: FitnessPlan) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                Text("Plan Generated!")
                    .font(.headline)
                    .foregroundColor(.green)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(plan.title)
                    .font(.title3)
                    .fontWeight(.semibold)

                Text(plan.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            NavigationLink(destination: FitnessPlanDetailView(plan: plan)) {
                HStack {
                    Text("View Full Plan")
                    Spacer()
                    Image(systemName: "arrow.right")
                }
                .font(.headline)
                .foregroundColor(.blue)
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }

    private func errorView(_ error: Error) -> some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
                .font(.title2)

            Text("Error generating plan")
                .font(.headline)
                .foregroundColor(.red)

            Text(error.localizedDescription)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color.red.opacity(0.1))
        .cornerRadius(10)
    }

    private func rawResponseView(_ response: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Generated Plan:")
                .font(.headline)

            ScrollView {
                Text(response)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxHeight: 200)
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
    }
}

#Preview {
    FitnessPlanView()
}
