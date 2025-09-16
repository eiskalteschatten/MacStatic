//
//  ContentView.swift
//  MacStaticGUI
//
//  Created by Alex Seifert on 16.09.25.
//

import MacStaticCore
import Foundation
import SwiftUI

struct ContentView: View {
    @StateObject private var core = MacStaticCore()
    @State private var commandText = ""
    @State private var argumentsText = ""
    @State private var currentResult = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Input section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Command Input")
                        .font(.headline)
                    
                    TextField("Enter command", text: $commandText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Arguments (space-separated)", text: $argumentsText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                // Action button
                Button(action: executeCommand) {
                    HStack {
                        if core.isProcessing {
                            ProgressView()
                                .scaleEffect(0.8)
                        }
                        Text(core.isProcessing ? "Processing..." : "Execute")
                    }
                }
                .disabled(core.isProcessing || commandText.isEmpty)
                .buttonStyle(.borderedProminent)
                
                // Results section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Output")
                        .font(.headline)
                    
                    ScrollView {
                        Text(currentResult)
                            .font(.system(.body, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    .frame(minHeight: 200)
                }
                
                // History
                if !core.results.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Recent Results")
                            .font(.headline)
                        
                        List(core.results.reversed(), id: \.self) { result in
                            Text(result)
                                .font(.system(.caption, design: .monospaced))
                        }
                        .frame(maxHeight: 150)
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Your App")
        }
        #if os(macOS)
        .frame(minWidth: 600, minHeight: 500)
        #endif
    }
    
    private mutating func executeCommand() {
        let arguments = argumentsText.split(separator: " ").map(String.init)
        
        Task {
            do {
                let result = try await core.processCommand(commandText, arguments: arguments)
                await MainActor.run {
                    currentResult = result
                }
            } catch {
                await MainActor.run {
                    currentResult = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
