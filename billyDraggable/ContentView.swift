//
//  ContentView.swift
//  billyDraggable
//
//  Created by Bilal Aurangzeb (billy) on 03/09/2025.
//  Email: fbilal@proton.me
//  Made in Pakistan 🇵🇰
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
import SwiftUI

// MARK: - Main Content View
struct ContentView: View {
    // MARK: - State Properties
    @StateObject private var manager = SlideButtonManager()
    @State private var showWelcomeMessage = false
    
    // MARK: - Initialization
    init() {
        // Enable the slider by default for demo
        _manager = StateObject(wrappedValue: {
            let manager = SlideButtonManager()
            manager.setEnabled(true)
            return manager
        }())
    }
    
    // MARK: - Environment
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Title Section
            titleSection
            
            Spacer()
            
            // Slide Button with adaptive padding
            SlideToConfirmButton(
                configuration: .default,
                theme: .default,
                primaryText: "CTA Text Here",
                instructionText: "slide to confirm",
                isEnabled: manager.isEnabled,
                onComplete: handleSlideCompletion,
                onStateChange: manager.handleStateChange,
                delegate: manager,
                nudgeOffset: manager.nudgeOffset
            )
            .padding(.horizontal, horizontalPadding)
            
            Spacer()
            
            // Welcome message (appears after sliding)
            welcomeMessage
            
            Spacer()
        }
        .animation(.easeInOut(duration: 0.3), value: showWelcomeMessage)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Slide to confirm interface")
        .onTapGesture {
            handleScreenTap()
        }
        .slideButtonManager(manager)
    }
    
    // MARK: - Subviews
    private var titleSection: some View {
        VStack(spacing: 12) {
            Text("Slider Button Demo")
                .font(.largeTitle)
                .fontWeight(.bold)
                .accessibilityAddTraits(.isHeader)
            
            Text("Tap anywhere to nudge the slider")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    
    private var welcomeMessage: some View {
        Group {
            if showWelcomeMessage {
                Text("Action Completed Successfully!")
                    .font(.headline)
                    .foregroundColor(.green)
                    .transition(.scale.combined(with: .opacity))
                    .accessibilityLabel("Action completed successfully")
            }
        }
    }
    
    // MARK: - Methods
    private func handleSlideCompletion() {
        showWelcomeMessage = true
        
        // Reset after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            showWelcomeMessage = false
        }
    }
    
    private func handleScreenTap() {
        manager.nudge()
    }
    
    // MARK: - Computed Properties
    private var horizontalPadding: CGFloat {
        switch horizontalSizeClass {
        case .compact:
            return 24  // iPhone in portrait
        case .regular:
            return 48  // iPad
        default:
            return 24
        }
    }
}

// MARK: - App Entry Point
@main
struct SlideButtonApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light) // Optional: force light mode
                .onAppear {
                    // Performance optimization: Preload haptic feedback
                    let _ = UIImpactFeedbackGenerator(style: .medium)
                }
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // iPhone SE
            ContentView()
                .previewDevice("iPhone SE (3rd generation)")
                .previewDisplayName("iPhone SE")
                .previewLayout(.sizeThatFits)
            
            // iPhone 15
            ContentView()
                .previewDevice("iPhone 15")
                .previewDisplayName("iPhone 15")
                .previewLayout(.sizeThatFits)
            
            // iPhone 15 Pro Max
            ContentView()
                .previewDevice("iPhone 15 Pro Max")
                .previewDisplayName("iPhone 15 Pro Max")
                .previewLayout(.sizeThatFits)
            
            // iPad
            ContentView()
                .previewDevice("iPad (10th generation)")
                .previewDisplayName("iPad")
                .previewLayout(.sizeThatFits)
            
            // Dark mode preview
            ContentView()
                .previewDevice("iPhone 15")
                .previewDisplayName("Dark Mode")
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}

// MARK: - Performance Testing
#if DEBUG
struct PerformanceTestView: View {
    @State private var sliderCount = 1
    
    var body: some View {
        VStack {
            Text("Performance Test: \(sliderCount) sliders")
                .font(.headline)
            
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(0..<sliderCount, id: \.self) { index in
                        SlideToConfirmButton(onComplete: {
                            print("Slider \(index) completed")
                        })
                        .padding(.horizontal)
                    }
                }
            }
            
            HStack {
                Button("Add Slider") {
                    sliderCount += 1
                }
                
                Button("Remove Slider") {
                    if sliderCount > 1 {
                        sliderCount -= 1
                    }
                }
            }
        }
    }
}

struct PerformanceTestView_Previews: PreviewProvider {
    static var previews: some View {
        PerformanceTestView()
    }
}
#endif
