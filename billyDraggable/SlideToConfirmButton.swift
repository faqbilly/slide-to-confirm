//
//  SlideToConfirmButton.swift
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

// MARK: - Slide Button State
@frozen
public enum SlideButtonState: Equatable, CaseIterable {
    case disabledStart
    case enabledStart
    case enabledSliding
    case enabledEnd
    case disabledTriggered
    
    public var isInteractive: Bool {
        switch self {
        case .enabledStart, .enabledSliding, .enabledEnd:
            return true
        case .disabledStart, .disabledTriggered:
            return false
        }
    }
    
    public var isDragging: Bool {
        switch self {
        case .enabledSliding, .enabledEnd:
            return true
        case .disabledStart, .enabledStart, .disabledTriggered:
            return false
        }
    }
}

// MARK: - Slide Button Configuration
public struct SlideButtonConfiguration {
    // MARK: - Layout
    public let height: CGFloat
    public let horizontalPadding: CGFloat
    public let handleSize: CGFloat
    
    // MARK: - Interaction
    public let cancelAreaThreshold: CGFloat
    public let confirmAreaThreshold: CGFloat
    public let nudgeOffset: CGFloat
    
    // MARK: - Animation
    public let animationDuration: Double
    public let nudgeAnimationDuration: Double
    public let resetDelay: Double
    
    // MARK: - Visual
    public let cornerRadius: CGFloat
    public let shadowRadius: CGFloat
    public let shadowOffset: CGFloat
    
    // MARK: - Initialization
    public init(
        height: CGFloat = 56,
        horizontalPadding: CGFloat = 4,
        handleSize: CGFloat = 48,
        cancelAreaThreshold: CGFloat = 0.9,
        confirmAreaThreshold: CGFloat = 0.1,
        nudgeOffset: CGFloat = 8,
        animationDuration: Double = 0.3,
        nudgeAnimationDuration: Double = 0.15,
        resetDelay: Double = 2.0,
        cornerRadius: CGFloat = 28,
        shadowRadius: CGFloat = 4,
        shadowOffset: CGFloat = 2
    ) {
        self.height = height
        self.horizontalPadding = horizontalPadding
        self.handleSize = handleSize
        self.cancelAreaThreshold = cancelAreaThreshold
        self.confirmAreaThreshold = confirmAreaThreshold
        self.nudgeOffset = nudgeOffset
        self.animationDuration = animationDuration
        self.nudgeAnimationDuration = nudgeAnimationDuration
        self.resetDelay = resetDelay
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
    }
    
    // MARK: - Presets
    public static let `default` = SlideButtonConfiguration()
    
    public static let compact = SlideButtonConfiguration(
        height: 44,
        handleSize: 36,
        nudgeOffset: 6
    )
    
    public static let large = SlideButtonConfiguration(
        height: 64,
        handleSize: 56,
        nudgeOffset: 10
    )
}

// MARK: - Slide Button Theme
public struct SlideButtonTheme {
    // MARK: - Colors
    public let disabledStartBackground: Color
    public let enabledStartBackground: Color
    public let enabledSlidingBackground: Color
    public let enabledEndBackground: Color
    public let disabledTriggeredBackground: Color
    
    public let disabledStartBorder: Color
    public let enabledBorder: Color
    
    public let disabledStartShadow: Color
    public let enabledShadow: Color
    
    public let disabledStartText: Color
    public let enabledText: Color
    public let disabledStartSecondaryText: Color
    public let enabledSecondaryText: Color
    
    public let disabledStartHandleIcon: Color
    public let enabledHandleIcon: Color
    
    // MARK: - Typography
    public let primaryTextFont: Font
    public let secondaryTextFont: Font
    public let handleIconFont: Font
    
    // MARK: - Initialization
    public init(
        disabledStartBackground: Color = Color(red: 0.98, green: 0.95, blue: 0.8),
        enabledStartBackground: Color = Color(red: 1.0, green: 0.9, blue: 0.0),
        enabledSlidingBackground: Color = Color(red: 1.0, green: 0.9, blue: 0.0),
        enabledEndBackground: Color = Color(red: 1.0, green: 0.6, blue: 0.0),
        disabledTriggeredBackground: Color = Color(red: 1.0, green: 0.9, blue: 0.0),
        disabledStartBorder: Color = Color(red: 0.9, green: 0.85, blue: 0.7),
        enabledBorder: Color = Color(red: 0.8, green: 0.7, blue: 0.0),
        disabledStartShadow: Color = Color.black.opacity(0.1),
        enabledShadow: Color = Color.black.opacity(0.2),
        disabledStartText: Color = .gray,
        enabledText: Color = .black,
        disabledStartSecondaryText: Color = .gray,
        enabledSecondaryText: Color = Color(red: 0.4, green: 0.4, blue: 0.4),
        disabledStartHandleIcon: Color = .gray,
        enabledHandleIcon: Color = Color(red: 1.0, green: 0.9, blue: 0.0),
        primaryTextFont: Font = .system(size: 16, weight: .medium, design: .default),
        secondaryTextFont: Font = .system(size: 12, weight: .regular, design: .default),
        handleIconFont: Font = .system(size: 20, weight: .semibold, design: .default)
    ) {
        self.disabledStartBackground = disabledStartBackground
        self.enabledStartBackground = enabledStartBackground
        self.enabledSlidingBackground = enabledSlidingBackground
        self.enabledEndBackground = enabledEndBackground
        self.disabledTriggeredBackground = disabledTriggeredBackground
        self.disabledStartBorder = disabledStartBorder
        self.enabledBorder = enabledBorder
        self.disabledStartShadow = disabledStartShadow
        self.enabledShadow = enabledShadow
        self.disabledStartText = disabledStartText
        self.enabledText = enabledText
        self.disabledStartSecondaryText = disabledStartSecondaryText
        self.enabledSecondaryText = enabledSecondaryText
        self.disabledStartHandleIcon = disabledStartHandleIcon
        self.enabledHandleIcon = enabledHandleIcon
        self.primaryTextFont = primaryTextFont
        self.secondaryTextFont = secondaryTextFont
        self.handleIconFont = handleIconFont
    }
    
    // MARK: - Presets
    public static let `default` = SlideButtonTheme()
    
    public static let dark = SlideButtonTheme(
        disabledStartBackground: Color(red: 0.2, green: 0.2, blue: 0.2),
        enabledStartBackground: Color(red: 0.3, green: 0.3, blue: 0.3),
        enabledSlidingBackground: Color(red: 0.3, green: 0.3, blue: 0.3),
        enabledEndBackground: Color(red: 0.4, green: 0.2, blue: 0.0),
        disabledTriggeredBackground: Color(red: 0.3, green: 0.3, blue: 0.3),
        disabledStartText: Color.gray,
        enabledText: Color.white,
        disabledStartSecondaryText: Color.gray,
        enabledSecondaryText: Color(red: 0.8, green: 0.8, blue: 0.8)
    )
}

// MARK: - Slide Button Delegate
public protocol SlideButtonDelegate: AnyObject {
    @MainActor
    func slideButtonDidComplete(_ slideButton: SlideToConfirmButton)
    @MainActor
    func slideButtonStateDidChange(_ slideButton: SlideToConfirmButton, state: SlideButtonState)
    @MainActor
    func slideButtonDidStartDragging(_ slideButton: SlideToConfirmButton)
    @MainActor
    func slideButtonDidEndDragging(_ slideButton: SlideToConfirmButton)
}

// MARK: - Slide Button
public struct SlideToConfirmButton: View {
    // MARK: - Properties
    @State private var offset: CGFloat = 0
    @State private var currentState: SlideButtonState = .disabledStart
    @State private var isEnabled: Bool = false
    let nudgeOffset: CGFloat
    
    // MARK: - Configuration
    private let config: SlideButtonConfiguration
    private let theme: SlideButtonTheme
    private let primaryText: String
    private let instructionText: String
    private let handleIcon: String
    private let checkmarkIcon: String
    
    // MARK: - Callbacks
    private let onComplete: (() -> Void)?
    private let onStateChange: ((SlideButtonState) -> Void)?
    private weak var delegate: SlideButtonDelegate?
    
    // MARK: - Initialization
    public init(
        configuration: SlideButtonConfiguration = .default,
        theme: SlideButtonTheme = .default,
        primaryText: String = "CTA Text Here",
        instructionText: String = "slide to confirm",
        handleIcon: String = "chevron.right.2",
        checkmarkIcon: String = "checkmark",
        isEnabled: Bool = false,
        onComplete: (() -> Void)? = nil,
        onStateChange: ((SlideButtonState) -> Void)? = nil,
        delegate: SlideButtonDelegate? = nil,
        nudgeOffset: CGFloat = 0
    ) {
        self.config = configuration
        self.theme = theme
        self.primaryText = primaryText
        self.instructionText = instructionText
        self.handleIcon = handleIcon
        self.checkmarkIcon = checkmarkIcon
        self.onComplete = onComplete
        self.onStateChange = onStateChange
        self.delegate = delegate
        self.nudgeOffset = nudgeOffset
        self._isEnabled = State(initialValue: isEnabled)
    }
    
    // MARK: - Body
    public var body: some View {
        GeometryReader { geometry in
            let maxOffset = geometry.size.width - config.handleSize - (config.horizontalPadding * 2)
            
            ZStack(alignment: .leading) {
                // Background Track
                backgroundTrack
                
                // Text Layer
                textOverlay
                
                // Draggable Handle
                handle
                    .offset(x: config.horizontalPadding + offset + nudgeOffset)
                    .gesture(handleGesture(maxOffset: maxOffset))
            }
        }
        .frame(height: config.height)
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(accessibilityHint)
        .accessibilityAddTraits(accessibilityTraits)
        .onChange(of: isEnabled) { _, newValue in
            updateStateForEnabled(newValue)
        }
        .onChange(of: currentState) { _, newState in
            onStateChange?(newState)
            delegate?.slideButtonStateDidChange(self, state: newState)
        }
    }
    
    // MARK: - Subviews
    private var backgroundTrack: some View {
        RoundedRectangle(cornerRadius: config.cornerRadius)
            .fill(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: config.cornerRadius)
                    .stroke(borderColor, lineWidth: 1)
            )
            .shadow(
                color: shadowColor,
                radius: shadowRadius,
                x: 0,
                y: shadowOffset
            )
    }
    
    private var textOverlay: some View {
        HStack {
            Spacer()
            
            VStack(spacing: 2) {
                Text(primaryText)
                    .font(theme.primaryTextFont)
                    .foregroundColor(primaryTextColor)
                
                Text(currentInstructionText)
                    .font(theme.secondaryTextFont)
                    .foregroundColor(secondaryTextColor)
            }
            
            Spacer()
        }
    }
    
    private var handle: some View {
        ZStack {
            Circle()
                .fill(Color(.white))
                .shadow(
                    color: Color(.black).opacity(0.15),
                    radius: 4,
                    x: 0,
                    y: 2
                )
            
            Image(systemName: currentHandleIcon)
                .font(theme.handleIconFont)
                .foregroundColor(handleIconColor)
        }
        .frame(width: config.handleSize, height: config.handleSize)
        .accessibilityElement()
        .accessibilityLabel(handleAccessibilityLabel)
        .accessibilityAddTraits(.isButton)
    }
    
    // MARK: - Gestures
    private func handleGesture(maxOffset: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                handleDragChanged(value: value, maxOffset: maxOffset)
            }
            .onEnded { value in
                handleDragEnded(value: value, maxOffset: maxOffset)
            }
    }
    
    // MARK: - Drag Handling
    private func handleDragChanged(value: DragGesture.Value, maxOffset: CGFloat) {
        guard currentState.isInteractive else { return }
        
        let translation = value.translation.width
        let newOffset = min(max(0, translation), maxOffset)
        
        // Update offset directly without any animation
        offset = newOffset
        
        // Update state based on position
        let progress = newOffset / maxOffset
        if progress >= config.cancelAreaThreshold {
            if currentState != .enabledEnd {
                currentState = .enabledEnd
            }
        } else {
            if currentState != .enabledSliding {
                currentState = .enabledSliding
                delegate?.slideButtonDidStartDragging(self)
            }
        }
    }
    
    private func handleDragEnded(value: DragGesture.Value, maxOffset: CGFloat) {
        delegate?.slideButtonDidEndDragging(self)
        
        let progress = offset / maxOffset
        
        if progress >= config.cancelAreaThreshold {
            triggerAction(maxOffset: maxOffset)
        } else {
            springBack()
        }
    }
    
    // MARK: - Actions
    private func triggerAction(maxOffset: CGFloat) {
        currentState = .disabledTriggered
        
        withAnimation(.easeInOut(duration: 0.3)) {
            offset = maxOffset
        }
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // Call completion handler
        onComplete?()
        delegate?.slideButtonDidComplete(self)
        
        // Auto-reset after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + config.resetDelay) {
            reset()
        }
    }
    
    private func springBack() {
        currentState = .enabledStart
        
        withAnimation(.easeOut(duration: 0.25)) {
            offset = 0
        }
    }
    
    private func reset() {
        withAnimation(.easeOut(duration: 0.25)) {
            offset = 0
            currentState = isEnabled ? .enabledStart : .disabledStart
        }
    }
    
    private func updateStateForEnabled(_ enabled: Bool) {
        currentState = enabled ? .enabledStart : .disabledStart
    }
    
    // MARK: - Public Methods
    public func setEnabled(_ enabled: Bool) {
        isEnabled = enabled
    }
    
    public func resetSlider() {
        reset()
    }
    
    public func nudge() {
        guard isEnabled && currentState == .enabledStart else { return }
        
        // Haptic feedback for nudge
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        // Notify delegate to handle nudge
        delegate?.slideButtonDidStartDragging(self)
    }
    
    // MARK: - Computed Properties
    private var backgroundColor: Color {
        switch currentState {
        case .disabledStart:
            return theme.disabledStartBackground
        case .enabledStart, .enabledSliding:
            return theme.enabledStartBackground
        case .enabledEnd:
            return theme.enabledEndBackground
        case .disabledTriggered:
            return theme.disabledTriggeredBackground
        }
    }
    
    private var borderColor: Color {
        switch currentState {
        case .disabledStart:
            return theme.disabledStartBorder
        case .enabledStart, .enabledSliding, .enabledEnd, .disabledTriggered:
            return theme.enabledBorder
        }
    }
    
    private var shadowColor: Color {
        switch currentState {
        case .disabledStart:
            return theme.disabledStartShadow
        case .enabledStart, .enabledSliding, .enabledEnd, .disabledTriggered:
            return theme.enabledShadow
        }
    }
    
    private var shadowRadius: CGFloat {
        switch currentState {
        case .disabledStart:
            return config.shadowRadius * 0.5
        case .enabledStart, .enabledSliding, .enabledEnd, .disabledTriggered:
            return config.shadowRadius
        }
    }
    
    private var shadowOffset: CGFloat {
        switch currentState {
        case .disabledStart:
            return config.shadowOffset * 0.5
        case .enabledStart, .enabledSliding, .enabledEnd, .disabledTriggered:
            return config.shadowOffset
        }
    }
    
    private var primaryTextColor: Color {
        switch currentState {
        case .disabledStart:
            return theme.disabledStartText
        case .enabledStart, .enabledSliding, .enabledEnd, .disabledTriggered:
            return theme.enabledText
        }
    }
    
    private var secondaryTextColor: Color {
        switch currentState {
        case .disabledStart:
            return theme.disabledStartSecondaryText
        case .enabledStart, .enabledSliding:
            return theme.enabledSecondaryText
        case .enabledEnd:
            return theme.enabledSecondaryText
        case .disabledTriggered:
            return Color.clear
        }
    }
    
    private var currentInstructionText: String {
        switch currentState {
        case .disabledStart, .enabledStart, .enabledSliding:
            return instructionText
        case .enabledEnd:
            return "release to confirm"
        case .disabledTriggered:
            return ""
        }
    }
    
    private var currentHandleIcon: String {
        switch currentState {
        case .disabledStart, .enabledStart, .enabledSliding:
            return handleIcon
        case .enabledEnd, .disabledTriggered:
            return checkmarkIcon
        }
    }
    
    private var handleIconColor: Color {
        switch currentState {
        case .disabledStart:
            return theme.disabledStartHandleIcon
        case .enabledStart, .enabledSliding, .enabledEnd, .disabledTriggered:
            return theme.enabledHandleIcon
        }
    }
    
    private var accessibilityLabel: String {
        switch currentState {
        case .disabledStart:
            return "Slide button disabled"
        case .enabledStart:
            return "Slide to confirm"
        case .enabledSliding:
            return "Sliding to confirm"
        case .enabledEnd:
            return "Release to confirm"
        case .disabledTriggered:
            return "Action completed"
        }
    }
    
    private var accessibilityHint: String {
        switch currentState {
        case .disabledStart:
            return "Button is currently disabled"
        case .enabledStart:
            return "Drag the handle to the right to confirm your action"
        case .enabledSliding:
            return "Continue dragging to the right to confirm"
        case .enabledEnd:
            return "Release to confirm your action"
        case .disabledTriggered:
            return "Action has been completed successfully"
        }
    }
    
    private var accessibilityTraits: AccessibilityTraits {
        switch currentState {
        case .disabledStart:
            return []
        case .enabledStart, .enabledSliding, .enabledEnd:
            return .isButton
        case .disabledTriggered:
            return [.isButton, .isSelected]
        }
    }
    
    private var handleAccessibilityLabel: String {
        switch currentState {
        case .disabledStart:
            return "Disabled handle"
        case .enabledStart, .enabledSliding:
            return "Drag handle"
        case .enabledEnd:
            return "Release handle to confirm"
        case .disabledTriggered:
            return "Action completed"
        }
    }
}

// MARK: - Preview
struct SlideToConfirmButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            SlideToConfirmButton(
                configuration: .default,
                theme: .default,
                isEnabled: true
            )
            .padding()
            
            SlideToConfirmButton(
                configuration: .compact,
                theme: .dark,
                isEnabled: false
            )
            .padding()
        }
        .previewLayout(.sizeThatFits)
    }
}
