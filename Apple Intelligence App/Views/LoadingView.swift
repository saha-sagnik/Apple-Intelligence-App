//
//  LoadingView.swift
//  Apple Intelligence App
//
//  Created by Sagnik Saha on 03/10/25.
//

import SwiftUI

struct LoadingView: View {
    let message: String

    init(message: String = "Creating your personalized plan...") {
        self.message = message
    }

    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
                .tint(.blue)

            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(24)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    VStack(spacing: 20) {
        LoadingView()
        LoadingView(message: "Generating workout plan...")
        LoadingView(message: "Processing your nutrition requirements...")
    }
    .padding()
}