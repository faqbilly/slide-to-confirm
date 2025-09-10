//
//  SlideButtonExamples.swift
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

// MARK: - Usage Examples
struct SlideButtonExamples: View {
    @StateObject private var manager = SlideButtonManager()
    @State private var showSuccessMessage = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // Basic Usage
                    basicUsageExample
                    
                    // Customized Usage
                    customizedUsageExample
                    
                    // Manager Usage
                    managerUsageExample
                    
                    // Multiple Buttons
                    multipleButtonsExample
                    
                    // RTL Examples
                    rtlExamples
                }
                .padding()
            }
            .navigationTitle("Slide Button Examples")
        }
        .slideButtonManager(manager)
        .onSlideButtonTap {
            // Global nudge effect
        }
    }
    
    // MARK: - Basic Usage Example
    private var basicUsageExample: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Basic Usage")
                .font(.headline)
            
            SlideToConfirmButton(
                isEnabled: true,
                onComplete: {
                    showSuccessMessage = true
                }
            )
            .padding(.horizontal)
        }
    }
    
    // MARK: - Customized Usage Example
    private var customizedUsageExample: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Customized Usage")
                .font(.headline)
            
            SlideToConfirmButton(
                configuration: .compact,
                theme: .dark,
                primaryText: "Delete Account",
                instructionText: "slide to delete",
                handleIcon: "trash",
                checkmarkIcon: "checkmark",
                isEnabled: true,
                onComplete: {
                    // Handle deletion
                }
            )
            .padding(.horizontal)
        }
    }
    
    // MARK: - Manager Usage Example
    private var managerUsageExample: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Manager Usage")
                .font(.headline)
            
            SlideButtonWrapper(
                configuration: .large,
                primaryText: "Purchase Item",
                instructionText: "slide to buy"
            )
            .padding(.horizontal)
            
            HStack {
                Button("Enable") {
                    manager.setEnabled(true)
                }
                .disabled(manager.isEnabled)
                
                Button("Disable") {
                    manager.setEnabled(false)
                }
                .disabled(!manager.isEnabled)
                
                Button("Reset") {
                    manager.reset()
                }
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Multiple Buttons Example
    private var multipleButtonsExample: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Multiple Buttons")
                .font(.headline)
            
            VStack(spacing: 16) {
                SlideToConfirmButton(
                    configuration: .compact,
                    primaryText: "Action 1",
                    isEnabled: true
                )
                
                SlideToConfirmButton(
                    configuration: .compact,
                    primaryText: "Action 2",
                    isEnabled: true
                )
                
                SlideToConfirmButton(
                    configuration: .compact,
                    primaryText: "Action 3",
                    isEnabled: false
                )
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - RTL Examples
    private var rtlExamples: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("RTL (Arabic) Examples")
                .font(.headline)
            
            VStack(spacing: 16) {
                SlideToConfirmButton(
                    configuration: .rtl,
                    theme: .rtl,
                    primaryText: "انقر للتأكيد",
                    instructionText: "اسحب للتأكيد",
                    isEnabled: true
                )
                
                SlideToConfirmButton(
                    configuration: .rtlCompact,
                    theme: .rtlDark,
                    primaryText: "حذف الحساب",
                    instructionText: "اسحب للحذف",
                    isEnabled: true
                )
                
                SlideToConfirmButton(
                    configuration: .rtlLarge,
                    theme: .rtl,
                    primaryText: "شراء المنتج",
                    instructionText: "اسحب للشراء",
                    isEnabled: false
                )
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Integration Examples
struct IntegrationExamples: View {
    @StateObject private var manager = SlideButtonManager()
    @State private var isProcessing = false
    @State private var showAlert = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Form with slide button
            formExample
            
            // Payment flow
            paymentFlowExample
            
            // Settings with confirmation
            settingsExample
        }
        .slideButtonManager(manager)
        .alert("Action Completed", isPresented: $showAlert) {
            Button("OK") { }
        }
    }
    
    private var formExample: some View {
        VStack(spacing: 16) {
            TextField("Enter amount", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disabled(manager.isHolding)
                .opacity(manager.isHolding ? 0.5 : 1.0)
            
            SlideToConfirmButton(
                primaryText: "Submit Form",
                instructionText: "slide to submit",
                isEnabled: !isProcessing,
                onComplete: {
                    isProcessing = true
                    // Process form
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isProcessing = false
                        showAlert = true
                    }
                }
            )
        }
        .padding()
    }
    
    private var paymentFlowExample: some View {
        VStack(spacing: 16) {
            Text("Payment Amount: $99.99")
                .font(.title2)
                .fontWeight(.bold)
            
            SlideToConfirmButton(
                configuration: .large,
                theme: .default,
                primaryText: "Pay $99.99",
                instructionText: "slide to pay",
                isEnabled: true,
                onComplete: {
                    // Process payment
                }
            )
        }
        .padding()
    }
    
    private var settingsExample: some View {
        VStack(spacing: 16) {
            Text("Danger Zone")
                .font(.headline)
                .foregroundColor(.red)
            
            SlideToConfirmButton(
                configuration: .default,
                theme: SlideButtonTheme(
                    enabledStartBackground: .red,
                    enabledEndBackground: .red,
                    enabledBorder: .red
                ),
                primaryText: "Reset All Data",
                instructionText: "slide to reset",
                isEnabled: true,
                onComplete: {
                    // Reset data
                }
            )
        }
        .padding()
    }
}

// MARK: - Preview
struct SlideButtonExamples_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SlideButtonExamples()
                .previewDisplayName("Examples")
            
            IntegrationExamples()
                .previewDisplayName("Integration")
        }
    }
}
