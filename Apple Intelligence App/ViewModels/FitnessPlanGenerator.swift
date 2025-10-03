//
//  FitnessPlanGenerator.swift
//  Apple Intelligence App
//
//  Created by Sagnik Saha on 03/10/25.
//

import Foundation
import FoundationModels

@Observable
@MainActor
final class FitnessPlanGenerator {
    
    // MARK: - Published Properties
    var isLoading: Bool = false
    var error: Error?
    var plan: FitnessPlan?
    var rawResponse: String?   // keep full text if needed
    
    // MARK: - Private
    private let session: LanguageModelSession
    
    // MARK: - Init
    init(instructions: String? = nil) {
        let baseInstructions = instructions ?? """
        Your job is to create a personalized 7-day fitness plan for the user.
        Each day should include a workout routine, a recommended meal plan, and one wellness tip.
        Always include a title, a short motivational introduction, and a day-by-day structured guide.
        """
        
        self.session = LanguageModelSession(instructions: baseInstructions)
    }
    
    // MARK: - Generate Plan
    func generatePlan(for userInput: String) async {
        isLoading = true
        error = nil
        plan = nil
        rawResponse = nil
        defer { isLoading = false }

        do {
            let prompt = """
            Generate a comprehensive 7-day fitness plan based on the following user information:

            \(userInput)
            """

            let response = try await session.respond(to: prompt)
            self.rawResponse = response.content

            // Try to generate structured plan using @Generable
            let structuredResponse = try await session.respond(to: prompt, generating: FitnessPlan.self)
            self.plan = structuredResponse.content

        } catch {
            self.error = error
            // Keep raw response for fallback display
        }
    }
}
