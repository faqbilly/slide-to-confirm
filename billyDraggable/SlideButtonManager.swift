//
//  SlideButtonManager.swift
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
import Combine

// MARK: - Slide Button Manager
@MainActor
public final class SlideButtonManager: ObservableObject {
    // MARK: - Published Properties
    @Published public var isEnabled: Bool = false
    @Published public var currentState: SlideButtonState = .disabledStart
    @Published public var isHolding: Bool = false
    @Published public var nudgeOffset: CGFloat = 0
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private let hapticFeedback = UIImpactFeedbackGenerator(style: .medium)
    private let lightHapticFeedback = UIImpactFeedbackGenerator(style: .light)
    
    // MARK: - Callbacks
    public var onComplete: (() -> Void)?
    public var onStateChange: ((SlideButtonState) -> Void)?
    public var onStartDragging: (() -> Void)?
    public var onEndDragging: (() -> Void)?
    
    // MARK: - Initialization
    public init() {
        setupBindings()
    }
    
    // MARK: - Public Methods
    public func setEnabled(_ enabled: Bool) {
        isEnabled = enabled
    }
    
    public func reset() {
        currentState = isEnabled ? .enabledStart : .disabledStart
        isHolding = false
        nudgeOffset = 0
    }
    
    public func nudge() {
        guard isEnabled && currentState == .enabledStart else { return }
        
        lightHapticFeedback.impactOccurred()
        
        // Simple nudge animation without complex timing
        withAnimation(.easeOut(duration: 0.1)) {
            nudgeOffset = 8
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeOut(duration: 0.1)) {
                self.nudgeOffset = 0
            }
        }
    }
    
    public func handleStateChange(_ newState: SlideButtonState) {
        currentState = newState
        isHolding = newState.isDragging
        
        switch newState {
        case .enabledSliding:
            onStartDragging?()
        case .disabledStart, .enabledStart, .disabledTriggered:
            onEndDragging?()
        case .enabledEnd:
            break
        }
    }
    
    public func handleCompletion() {
        onComplete?()
        hapticFeedback.impactOccurred()
    }
    
    // MARK: - Private Methods
    private func setupBindings() {
        $currentState
            .sink { [weak self] newState in
                self?.onStateChange?(newState)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Slide Button Manager Delegate
extension SlideButtonManager: SlideButtonDelegate {
    @MainActor
    public func slideButtonDidComplete(_ slideButton: SlideToConfirmButton) {
        handleCompletion()
    }
    
    @MainActor
    public func slideButtonStateDidChange(_ slideButton: SlideToConfirmButton, state: SlideButtonState) {
        handleStateChange(state)
    }
    
    @MainActor
    public func slideButtonDidStartDragging(_ slideButton: SlideToConfirmButton) {
        onStartDragging?()
    }
    
    @MainActor
    public func slideButtonDidEndDragging(_ slideButton: SlideToConfirmButton) {
        onEndDragging?()
    }
}

// MARK: - Slide Button Wrapper
public struct SlideButtonWrapper: View {
    @StateObject private var manager = SlideButtonManager()
    
    private let configuration: SlideButtonConfiguration
    private let theme: SlideButtonTheme
    private let primaryText: String
    private let instructionText: String
    private let handleIcon: String
    private let checkmarkIcon: String
    
    public init(
        configuration: SlideButtonConfiguration = .default,
        theme: SlideButtonTheme = .default,
        primaryText: String = "CTA Text Here",
        instructionText: String = "slide to confirm",
        handleIcon: String = "chevron.right.2",
        checkmarkIcon: String = "checkmark"
    ) {
        self.configuration = configuration
        self.theme = theme
        self.primaryText = primaryText
        self.instructionText = instructionText
        self.handleIcon = handleIcon
        self.checkmarkIcon = checkmarkIcon
    }
    
    public var body: some View {
        SlideToConfirmButton(
            configuration: configuration,
            theme: theme,
            primaryText: primaryText,
            instructionText: instructionText,
            handleIcon: handleIcon,
            checkmarkIcon: checkmarkIcon,
            isEnabled: manager.isEnabled,
            onComplete: manager.handleCompletion,
            onStateChange: manager.handleStateChange,
            delegate: manager
        )
        .offset(x: manager.nudgeOffset)
        .environmentObject(manager)
    }
}

// MARK: - Environment Key
private struct SlideButtonManagerKey: EnvironmentKey {
    static let defaultValue: SlideButtonManager? = nil
}

extension EnvironmentValues {
    public var slideButtonManager: SlideButtonManager? {
        get { self[SlideButtonManagerKey.self] }
        set { self[SlideButtonManagerKey.self] = newValue }
    }
}

// MARK: - View Extensions
public extension View {
    func slideButtonManager(_ manager: SlideButtonManager) -> some View {
        environment(\.slideButtonManager, manager)
    }
    
    func onSlideButtonTap(perform action: @escaping () -> Void) -> some View {
        onTapGesture {
            if let manager = Environment(\.slideButtonManager).wrappedValue {
                manager.nudge()
            }
            action()
        }
    }
}
