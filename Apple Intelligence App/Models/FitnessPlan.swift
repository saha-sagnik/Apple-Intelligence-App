//
//  Plan.swift
//  Apple Intelligence App
//
//  Created by Sagnik Saha on 03/10/25.
//

import Foundation
import FoundationModels

// MARK: - Core Models

@Generable
struct FitnessPlan {
    @Guide(description: "A motivational name for the plan.")
    let title: String
    
    let description: String
    
    @Guide(description: "Summary of how the plan addresses the user's fitness goals.")
    let rationale: String
    
    @Guide(.count(7))
    let days: [DayRoutine]
}

@Generable
struct DayRoutine {
    @Guide(description: "A catchy and unique title for the day.")
    let title: String
    let subtitle: String
    
    let workout: Workout
    let mealPlan: MealPlan
    let wellnessTip: WellnessTip
}

@Generable
struct Workout {
    let focusArea: FocusArea
    let exercises: [Exercise]
}

@Generable
struct Exercise {
    let name: String
    let sets: Sets
    let reps: Reps
    let description: String?
}

@Generable
struct MealPlan {
    let meals: [Meal]
}

@Generable
struct Meal {
    let name: String
    let description: String
    let calories: Int?
}

@Generable
struct WellnessTip {
    let tip: String
}

// MARK: - Typealiases & Enums

typealias Sets = Int
typealias Reps = Int

@Generable
enum FocusArea: String, Codable, CaseIterable {
    case arms
    case core
    case fullBody
    case legs
    case chest
    case back
    case cardio
    case recovery
}

// MARK: - Example

extension FitnessPlan {
    static let example = FitnessPlan(
        title: "7-Day Arms & Belly Fat Blast",
        description: "Gym-based program focused on trimming belly fat and building lean arm muscle, paired with an Indian non-veg meal plan for steady energy and recovery.",
        rationale: "Combines resistance training and HIIT for fat reduction, focuses on arms/core, and pairs workouts with high protein, fiber-rich meals. Wellness tips reinforce hydration, sleep and consistency.",
        days: [
            DayRoutine(
                title: "Strength Starter",
                subtitle: "Full-body muscle activation",
                workout: Workout(
                    focusArea: .fullBody,
                    exercises: [
                        .init(name: "Squat", sets: 3, reps: 12, description: "Barbell or bodyweight, good form."),
                        .init(name: "Push-ups", sets: 3, reps: 10, description: "Controlled descent."),
                        .init(name: "Dumbbell Row", sets: 3, reps: 12, description: "Each arm, moderate weight."),
                        .init(name: "Plank", sets: 3, reps: 1, description: "Hold 30s each."),
                        .init(name: "Lunges", sets: 3, reps: 12, description: "Each leg, add weights optional.")
                    ]
                ),
                mealPlan: MealPlan(
                    meals: [
                        .init(name: "Breakfast", description: "Curd with papaya and basil seeds.", calories: 250),
                        .init(name: "Lunch", description: "Grilled tandoori chicken salad with avocado.", calories: 350),
                        .init(name: "Dinner", description: "Steamed rohu fish, sautéed lauki, bajra khichdi.", calories: 400)
                    ]
                ),
                wellnessTip: WellnessTip(tip: "Hydrate early. Drink water before breakfast to boost metabolism.")
            ),
            // ...other days (same structure, shortened here for brevity)
        ]
    )
}
