# SlideToConfirmButton

[![Swift](https://img.shields.io/badge/Swift-5.0+-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-14.0+-blue.svg)](https://developer.apple.com/ios/)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-2.0+-green.svg)](https://developer.apple.com/xcode/swiftui/)
[![License](https://img.shields.io/badge/License-Apache%202.0-yellow.svg)](https://opensource.org/licenses/Apache-2.0)
[![Made in Pakistan](https://img.shields.io/badge/Made%20in-Pakistan-green.svg)](https://github.com/billy)

A highly customizable, production-ready slide-to-confirm button component for iOS apps built with SwiftUI. This component provides a smooth, accessible, and performant user experience for critical actions that require user confirmation.

## ✨ Features

- 🎯 **Five Distinct States**: Disabled Start, Enabled Start, Enabled Sliding, Enabled End, Disabled Triggered
- 🎨 **Highly Customizable**: Themes, configurations, and styling options
- ♿ **Accessibility First**: Full VoiceOver support and accessibility features
- 🚀 **Performance Optimized**: Efficient state management and smooth animations
- 🔧 **Easy Integration**: Simple API with manager pattern for complex scenarios
- 📱 **Responsive Design**: Adapts to different screen sizes and orientations
- 🎭 **Haptic Feedback**: Tactile feedback for better user experience
- 🔄 **Bidirectional Dragging**: Smooth forward and backward movement
- 👆 **Global Nudge Effect**: Screen-wide tap detection for user guidance

## Contributors

- **Bilal Aurangzeb** (billy) - Developer
- **Email**: fbilal@proton.me
- **Produly, Made in Pakistan** 🇵🇰

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.


## Installation

Simply copy the following files to your project:
- `SlideToConfirmButton.swift`
- `SlideButtonManager.swift`
- `SlideButtonExamples.swift` (optional, for examples)

## Quick Start

### Basic Usage

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        SlideToConfirmButton(
            isEnabled: true,
            onComplete: {
                print("Action completed!")
            }
        )
        .padding()
    }
}
```

### Advanced Usage with Manager

```swift
import SwiftUI

struct ContentView: View {
    @StateObject private var manager = SlideButtonManager()
    
    var body: some View {
        VStack {
            SlideToConfirmButton(
                configuration: .large,
                theme: .dark,
                primaryText: "Delete Account",
                instructionText: "slide to delete",
                isEnabled: manager.isEnabled,
                onComplete: {
                    // Handle deletion
                }
            )
            .padding()
            
            Button("Toggle") {
                manager.setEnabled(!manager.isEnabled)
            }
        }
        .slideButtonManager(manager)
    }
}
```

## Configuration

### SlideButtonConfiguration

```swift
let config = SlideButtonConfiguration(
    height: 56,                    // Button height
    horizontalPadding: 4,          // Internal padding
    handleSize: 48,                // Handle (ball) size
    cancelAreaThreshold: 0.9,      // 90% cancel area
    confirmAreaThreshold: 0.1,     // 10% confirm area
    nudgeOffset: 8,                // Nudge animation offset
    animationDuration: 0.3,        // Animation duration
    nudgeAnimationDuration: 0.15,  // Nudge animation duration
    resetDelay: 2.0,               // Auto-reset delay
    cornerRadius: 28,              // Corner radius
    shadowRadius: 4,               // Shadow radius
    shadowOffset: 2                // Shadow offset
)

// Presets available
let compactConfig = SlideButtonConfiguration.compact
let largeConfig = SlideButtonConfiguration.large
```

### SlideButtonTheme

```swift
let theme = SlideButtonTheme(
    disabledStartBackground: Color(red: 0.98, green: 0.95, blue: 0.8),
    enabledStartBackground: Color(red: 1.0, green: 0.9, blue: 0.0),
    enabledEndBackground: Color(red: 1.0, green: 0.6, blue: 0.0),
    // ... more customization options
)

// Presets available
let defaultTheme = SlideButtonTheme.default
let darkTheme = SlideButtonTheme.dark
```

## API Reference

### SlideToConfirmButton

#### Initialization

```swift
SlideToConfirmButton(
    configuration: SlideButtonConfiguration = .default,
    theme: SlideButtonTheme = .default,
    primaryText: String = "CTA Text Here",
    instructionText: String = "slide to confirm",
    handleIcon: String = "chevron.right.2",
    checkmarkIcon: String = "checkmark",
    isEnabled: Bool = false,
    onComplete: (() -> Void)? = nil,
    onStateChange: ((SlideButtonState) -> Void)? = nil,
    delegate: SlideButtonDelegate? = nil
)
```

#### Public Methods

```swift
// Enable/disable the button
func setEnabled(_ enabled: Bool)

// Reset the button to initial state
func resetSlider()

// Trigger nudge animation
func nudge()
```

### SlideButtonManager

#### Properties

```swift
@Published var isEnabled: Bool
@Published var currentState: SlideButtonState
@Published var isHolding: Bool
@Published var nudgeOffset: CGFloat
```

#### Methods

```swift
// Enable/disable the button
func setEnabled(_ enabled: Bool)

// Reset to initial state
func reset()

// Trigger nudge animation
func nudge()

// Handle state changes
func handleStateChange(_ newState: SlideButtonState)

// Handle completion
func handleCompletion()
```

#### Callbacks

```swift
var onComplete: (() -> Void)?
var onStateChange: ((SlideButtonState) -> Void)?
var onStartDragging: (() -> Void)?
var onEndDragging: (() -> Void)?
```

## States

### SlideButtonState

- **`.disabledStart`**: Button is disabled, light appearance
- **`.enabledStart`**: Button is enabled, ready for interaction
- **`.enabledSliding`**: User is dragging the handle
- **`.enabledEnd`**: Handle is in confirm area, ready to release
- **`.disabledTriggered`**: Action completed, showing success state

## Integration Patterns

### 1. Simple Integration

```swift
struct SimpleView: View {
    var body: some View {
        SlideToConfirmButton(
            primaryText: "Submit",
            instructionText: "slide to submit",
            isEnabled: true,
            onComplete: {
                // Handle completion
            }
        )
    }
}
```

### 2. Form Integration

```swift
struct FormView: View {
    @StateObject private var manager = SlideButtonManager()
    @State private var formData = ""
    
    var body: some View {
        VStack {
            TextField("Enter data", text: $formData)
                .disabled(manager.isHolding)
                .opacity(manager.isHolding ? 0.5 : 1.0)
            
            SlideToConfirmButton(
                isEnabled: !formData.isEmpty,
                onComplete: {
                    // Submit form
                }
            )
        }
        .slideButtonManager(manager)
    }
}
```

### 3. Payment Flow

```swift
struct PaymentView: View {
    @StateObject private var manager = SlideButtonManager()
    
    var body: some View {
        VStack {
            Text("Amount: $99.99")
                .font(.title)
            
            SlideToConfirmButton(
                configuration: .large,
                primaryText: "Pay $99.99",
                instructionText: "slide to pay",
                isEnabled: true,
                onComplete: {
                    // Process payment
                }
            )
        }
        .slideButtonManager(manager)
    }
}
```

### 4. Settings with Confirmation

```swift
struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Danger Zone")
                .font(.headline)
                .foregroundColor(.red)
            
            SlideToConfirmButton(
                theme: SlideButtonTheme(
                    enabledStartBackground: .red,
                    enabledEndBackground: .red
                ),
                primaryText: "Reset All Data",
                instructionText: "slide to reset",
                isEnabled: true,
                onComplete: {
                    // Reset data
                }
            )
        }
    }
}
```

## Accessibility

The component provides comprehensive accessibility support:

- **VoiceOver**: Full screen reader support with descriptive labels
- **Dynamic Type**: Respects user's text size preferences
- **Accessibility Traits**: Proper button and selected states
- **Accessibility Hints**: Contextual instructions for each state
- **Accessibility Labels**: Clear descriptions of current state

## Performance Considerations

- **Efficient State Management**: Uses `@State` and `@StateObject` for optimal performance
- **Minimal View Updates**: Only updates when necessary
- **Memory Management**: Proper cleanup and no retain cycles
- **Animation Optimization**: Uses efficient spring animations
- **Gesture Handling**: Optimized drag gesture recognition

## Customization Examples

### Custom Theme

```swift
let customTheme = SlideButtonTheme(
    disabledStartBackground: .gray,
    enabledStartBackground: .blue,
    enabledEndBackground: .green,
    disabledStartText: .white,
    enabledText: .white,
    enabledSecondaryText: .white.opacity(0.8)
)
```

### Custom Configuration

```swift
let customConfig = SlideButtonConfiguration(
    height: 64,
    handleSize: 56,
    cancelAreaThreshold: 0.8,  // 80% cancel area
    confirmAreaThreshold: 0.2,  // 20% confirm area
    nudgeOffset: 12
)
```

## Troubleshooting

### Common Issues

1. **Button not responding**: Ensure `isEnabled` is set to `true`
2. **Nudge not working**: Check if button is in `.enabledStart` state
3. **State not updating**: Verify callback functions are properly set
4. **Accessibility issues**: Ensure proper labels and hints are provided

### Debug Tips

```swift
// Add state change logging
SlideToConfirmButton(
    onStateChange: { state in
        print("State changed to: \(state)")
    }
)

// Use manager for complex state management
@StateObject private var manager = SlideButtonManager()

// Add completion logging
manager.onComplete = {
    print("Action completed!")
}
```

## Requirements

- iOS 14.0+
- Swift 5.0+
- SwiftUI

## License

This component is provided as-is for use in your projects. Feel free to modify and adapt as needed.

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## Support

For questions or support, please refer to the examples in `SlideButtonExamples.swift` or create an issue in the project repository.
