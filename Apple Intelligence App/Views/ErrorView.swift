//
//  ErrorView.swift
//  Apple Intelligence App
//
//  Created by Sagnik Saha on 03/10/25.
//

import SwiftUI

struct ErrorView: View {
    let error: Error
    let onRetry: (() -> Void)?

    init(error: Error, onRetry: (() -> Void)? = nil) {
        self.error = error
        self.onRetry = onRetry
    }

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
                .font(.system(size: 40))

            VStack(spacing: 8) {
                Text("Something went wrong")
                    .font(.headline)
                    .foregroundColor(.red)

                Text(error.localizedDescription)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            if let onRetry = onRetry {
                Button(action: onRetry) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Try Again")
                    }
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .cornerRadius(8)
                }
            }
        }
        .padding(24)
        .background(Color.red.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    VStack(spacing: 20) {
        ErrorView(error: NSError(domain: "Test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network connection failed"]))

        ErrorView(error: NSError(domain: "Test", code: 2, userInfo: [NSLocalizedDescriptionKey: "Unable to generate fitness plan"])) {
            print("Retry tapped")
        }
    }
    .padding()
}