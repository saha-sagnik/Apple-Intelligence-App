//
//  RawResponseView.swift
//  Apple Intelligence App
//
//  Created by Sagnik Saha on 03/10/25.
//

import SwiftUI

struct RawResponseView: View {
    let response: String
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            header
            responseContent
        }
        .padding(20)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private var header: some View {
        HStack(spacing: 12) {
            Image(systemName: "doc.text.fill")
                .foregroundColor(.blue)
                .font(.title3)

            VStack(alignment: .leading, spacing: 2) {
                Text("Generated Plan")
                    .font(.headline)

                Text("Tap to expand full response")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                Image(systemName: isExpanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                    .foregroundColor(.blue)
                    .font(.title3)
            }
        }
    }

    private var responseContent: some View {
        ScrollView {
            Text(response)
                .font(.subheadline)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .textSelection(.enabled)
        }
        .frame(maxHeight: isExpanded ? .infinity : 120)
        .background(Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
        .animation(.easeInOut(duration: 0.3), value: isExpanded)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 20) {
            RawResponseView(response: """
            # 7-Day Arms & Belly Fat Blast

            ## Day 1: Strength Starter
            **Focus**: Full-body muscle activation

            **Workout**:
            - Squats: 3 sets x 12 reps
            - Push-ups: 3 sets x 10 reps
            - Dumbbell Row: 3 sets x 12 reps each arm

            **Meals**:
            - Breakfast: Curd with papaya and basil seeds (250 cal)
            - Lunch: Grilled tandoori chicken salad with avocado (350 cal)
            - Dinner: Steamed rohu fish, sautéed lauki, bajra khichdi (400 cal)

            **Wellness Tip**: Hydrate early. Drink water before breakfast to boost metabolism.
            """)

            RawResponseView(response: "Short response example for testing the UI layout.")
        }
        .padding()
    }
}