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
            ScrollView {
                VStack(spacing: 20) {
                    headerSection
                    inputSection
                    generateButton

                    if generator.isStreaming {
                        // Chapter 4: Show streaming progress
                        VStack(spacing: 16) {
                            LoadingView()
                            if let partial = generator.partialPlan,
                               let title = partial.title,
                               let description = partial.description {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(title)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    Text(description)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    if let days = partial.days?.compactMap({ $0 }), !days.isEmpty {
                                        Text("Loading days: \(days.count)/7")
                                            .font(.caption)
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .opacity(0.8)
                            }
                        }
                    } else if generator.isLoading {
                        LoadingView(message: generator.progressMessage)
                    } else if let plan = generator.plan {
                        PlanPreviewView(plan: plan)
                    } else if let error = generator.error {
                        ErrorView(error: error) {
                            Task {
                                await generator.generatePlan(for: userInput)
                            }
                        }
                    } else if let rawResponse = generator.rawResponse {
                        RawResponseView(response: rawResponse)
                    }

                    // Add some bottom padding for better scrolling
                    Spacer(minLength: 50)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.large)
            .onTapGesture {
                // Dismiss keyboard when tapping outside
                hideKeyboard()
            }
            .task {
                // Skip prewarming to save memory - only prewarm when actually generating
                // await generator.prewarmModelForUser()
            }
            .onDisappear {
                // Clean up memory when view disappears
                generator.cleanup()
            }
        }
    }
    
    // Helper function to dismiss keyboard
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            hideKeyboard()
                        }
                    }
                }

            Text("Example: I want to lose belly fat and build arm muscle. I have access to a gym and prefer Indian non-vegetarian meals.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    private var generateButton: some View {
        VStack(spacing: 12) {
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
            
            Button(action: {
                Task {
                    await generator.generateDemoPlan()
                }
            }) {
                HStack {
                    Image(systemName: "play.circle")
                    Text("Demo Mode (Instant)")
                }
                .font(.subheadline)
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
            }
            .disabled(generator.isLoading)
        }
    }

}

#Preview {
    FitnessPlanView()
}
