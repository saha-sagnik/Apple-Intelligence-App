//
//  FitnessPlanGenerator.swift
//  Apple Intelligence App
//
//  Created by Sagnik Saha on 03/10/25.
//

import FoundationModels
import SwiftUI

// MARK: - Chapter 5: Tools for extended capabilities
// Note: Tools are simplified for now to focus on basic functionality

@Observable
@MainActor
final class FitnessPlanGenerator {
    
    // MARK: - Published Properties
    var isLoading: Bool = false
    var error: Error?
    var plan: FitnessPlan?
    var rawResponse: String?   // keep full text if needed

    // Chapter 4: Streaming support
    var isStreaming: Bool = false
    var streamedContent: String = ""
    var partialPlan: FitnessPlan.PartiallyGenerated?
    var progressMessage: String = "Initializing..."
    
    // MARK: - Private
    private var session: LanguageModelSession?
    private let instructions: String
    
    // MARK: - Init
    init(instructions: String? = nil) {
        self.instructions = instructions ?? """
        You are a fitness expert creating personalized 7-day plans.
        Each day needs: workout, meal plan, wellness tip.
        Keep responses concise and actionable.
        """
        
        // Don't initialize session or prewarm automatically to save memory
    }
    
    // MARK: - Lazy Session Initialization
    private func getSession() -> LanguageModelSession {
        if session == nil {
            session = LanguageModelSession(instructions: instructions)
        }
        return session!
    }

    // MARK: - Performance Optimization
    private func prewarmModel() async {
        do {
            // More effective prewarming with a simple request
            let session = getSession()
            _ = try await session.respond(to: "Quick tip")
        } catch {
            // Silent prewarm - don't show errors to user
        }
    }
    
    // Public method to prewarm when view appears
    func prewarmModelForUser() async {
        await prewarmModel()
    }
    
    // MARK: - Memory Management
    func cleanup() {
        // Clear large objects to free memory
        plan = nil
        partialPlan = nil
        rawResponse = nil
        streamedContent = ""
        error = nil
        
        // Optionally clear session to free more memory
        // session = nil
    }
    
    // MARK: - Demo Mode for Testing
    func generateDemoPlan() async {
        isLoading = true
        isStreaming = true
        error = nil
        plan = nil
        partialPlan = nil
        rawResponse = nil
        streamedContent = ""
        
        // Simulate streaming with demo data
        self.progressMessage = "Generating demo plan..."
        
        // Create a demo plan instantly
        let demoPlan = FitnessPlan(
            title: "7-Day Weight Loss Plan",
            description: "A simple, effective plan to help you lose weight and build healthy habits.",
            rationale: "This plan focuses on sustainable weight loss through balanced exercise and nutrition.",
            days: [
                DayRoutine(
                    title: "Day 1: Cardio Start",
                    subtitle: "Begin your fitness journey",
                    workout: Workout(
                        focusArea: .cardio,
                        exercises: [
                            Exercise(name: "Walking", sets: 1, reps: 20, description: "Moderate pace for 20 minutes"),
                            Exercise(name: "Stretching", sets: 1, reps: 10, description: "Full body stretching")
                        ]
                    ),
                    mealPlan: MealPlan(
                        meals: [
                            Meal(name: "Breakfast", description: "Oatmeal with berries", calories: 300),
                            Meal(name: "Lunch", description: "Grilled chicken salad", calories: 400),
                            Meal(name: "Dinner", description: "Baked fish with vegetables", calories: 500)
                        ]
                    ),
                    wellnessTip: WellnessTip(tip: "Stay hydrated! Drink at least 8 glasses of water today.")
                ),
                DayRoutine(
                    title: "Day 2: Strength Building",
                    subtitle: "Build lean muscle",
                    workout: Workout(
                        focusArea: .fullBody,
                        exercises: [
                            Exercise(name: "Push-ups", sets: 3, reps: 10, description: "8-12 reps per set"),
                            Exercise(name: "Squats", sets: 3, reps: 12, description: "10-15 reps per set"),
                            Exercise(name: "Plank", sets: 3, reps: 1, description: "Hold for 30 seconds")
                        ]
                    ),
                    mealPlan: MealPlan(
                        meals: [
                            Meal(name: "Breakfast", description: "Greek yogurt with nuts", calories: 350),
                            Meal(name: "Lunch", description: "Turkey wrap with vegetables", calories: 450),
                            Meal(name: "Dinner", description: "Lean beef with sweet potato", calories: 550)
                        ]
                    ),
                    wellnessTip: WellnessTip(tip: "Get 7-8 hours of sleep for muscle recovery.")
                )
            ]
        )
        
        // Simulate streaming delay
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        self.progressMessage = "Generated 2/7 days..."
        
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        self.progressMessage = "Generated 7/7 days..."
        
        // Set the final plan
        self.plan = demoPlan
        self.isLoading = false
        self.isStreaming = false
        
        // Clean up temporary data to save memory
        self.partialPlan = nil
        self.streamedContent = ""
    }
    
    // MARK: - Generate Plan with Streaming
    func generatePlan(for userInput: String) async {
        isLoading = true
        isStreaming = true
        error = nil
        plan = nil
        partialPlan = nil
        rawResponse = nil
        streamedContent = ""
        
        // Add timeout for long responses
        let timeoutTask = Task {
            try await Task.sleep(nanoseconds: 15_000_000_000) // 15 seconds - much more aggressive
            if isLoading {
                self.error = NSError(domain: "TimeoutError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Generation is taking longer than expected. Please try again."])
                isLoading = false
                isStreaming = false
            }
        }
        
        defer {
            timeoutTask.cancel()
            isLoading = false
            isStreaming = false
        }

        do {
            // Ultra-optimized prompt for faster generation
            let prompt = """
            Create a 7-day fitness plan for: \(userInput)
            
            Format: 3 exercises/day, simple meals, brief tips. Focus on main goals.
            """

            // Chapter 4: Stream the response with optimization
            self.progressMessage = "Generating your plan..."
            let session = getSession()
            let stream = session.streamResponse(to: prompt, 
                                                generating: FitnessPlan.self,
                                                includeSchemaInPrompt: false)

            var dayCount = 0
            for try await partialResponse in stream {
                self.partialPlan = partialResponse.content
                
                // Update progress message based on what we've received
                let partial = partialResponse.content
                if let days = partial.days?.compactMap({ $0 }), !days.isEmpty {
                    dayCount = days.count
                    self.progressMessage = "Generated \(dayCount)/7 days..."
                } else if partial.title != nil {
                    self.progressMessage = "Creating daily routines..."
                }
            }

            // Set the final plan - convert from PartiallyGenerated to complete FitnessPlan
            if let partial = partialPlan,
               let title = partial.title,
               let description = partial.description,
               let rationale = partial.rationale,
               let days = partial.days?.compactMap({ $0 }) {
                
                let completeDays = days.compactMap { dayPartial -> DayRoutine? in
                    guard let title = dayPartial.title,
                          let subtitle = dayPartial.subtitle,
                          let workoutPartial = dayPartial.workout,
                          let mealPlanPartial = dayPartial.mealPlan,
                          let wellnessTipPartial = dayPartial.wellnessTip else {
                        return nil
                    }
                    
                    // Convert partial types to complete types
                    let workout = Workout(
                        focusArea: workoutPartial.focusArea ?? .fullBody,
                        exercises: workoutPartial.exercises?.compactMap { exercisePartial in
                            guard let name = exercisePartial.name,
                                  let sets = exercisePartial.sets,
                                  let reps = exercisePartial.reps else {
                                return nil
                            }
                            return Exercise(
                                name: name,
                                sets: sets,
                                reps: reps,
                                description: exercisePartial.description
                            )
                        } ?? []
                    )
                    
                    let mealPlan = MealPlan(
                        meals: mealPlanPartial.meals?.compactMap { mealPartial in
                            guard let name = mealPartial.name,
                                  let description = mealPartial.description else {
                                return nil
                            }
                            return Meal(
                                name: name,
                                description: description,
                                calories: mealPartial.calories
                            )
                        } ?? []
                    )
                    
                    let wellnessTip = WellnessTip(
                        tip: wellnessTipPartial.tip ?? ""
                    )
                    
                    return DayRoutine(
                        title: title,
                        subtitle: subtitle,
                        workout: workout,
                        mealPlan: mealPlan,
                        wellnessTip: wellnessTip
                    )
                }
                
                // Only create the complete plan if we have all days
                if completeDays.count == 7 {
                    self.plan = FitnessPlan(
                        title: title,
                        description: description,
                        rationale: rationale,
                        days: completeDays
                    )
                }
            }

        } catch {
            self.error = error
            // Keep partial response for fallback display
        }
        
        // Clean up temporary data to save memory
        self.partialPlan = nil
        self.streamedContent = ""
    }
}
