# MultitouchArt - Interactive Multitouch iOS App

A beautiful and interactive iOS app that responds to multitouch input with vibrant colors, smooth animations, and pleasing sounds.

## Features

- **Multitouch Support**: Touch the screen with multiple fingers simultaneously
- **Dynamic Colors**: Each touch creates a colorful particle with gradient effects (11 vibrant colors)
- **Sound Effects**: Procedurally generated harmonic tones for each touch with frequency variations
- **Visual Trails**: Smooth particle trails that follow your finger movements
- **Haptic Feedback**: Tactile response on each touch
- **Smooth Animations**: Particles fade out gracefully with expanding effects
- **Full-Screen Experience**: Status bar hidden for immersive interaction
- **Universal Support**: Works on iPhone and iPad in all orientations

## Technical Details

### Components

1. **MultitouchArtApp.swift**: Main app entry point
2. **ContentView.swift**: SwiftUI wrapper with reset functionality
3. **MultitouchView.swift**: UIKit-based multitouch canvas with gesture handling
4. **TouchParticle.swift**: Particle rendering with gradients and trails
5. **SoundManager.swift**: AVAudioEngine-based procedural sound synthesis

### Audio System

- Uses AVAudioEngine for real-time audio synthesis
- Generates sine waves with harmonics for pleasing tones
- Frequency range: 300-800 Hz with random variations
- Multiple concurrent audio nodes for simultaneous touches

### Visual System

- Radial gradients with core glow effects
- Alpha-blended particle trails
- Smooth fade-out animations
- Color palette includes system colors for native iOS feel

## Building and Deployment

### Requirements

- Xcode 15.0 or later
- iOS 15.0 or later
- Apple Developer Account (for TestFlight)

### Steps to Deploy to TestFlight

1. **Open the Project**
   ```bash
   open MultitouchArt/MultitouchArt.xcodeproj
   ```

2. **Configure Code Signing**
   - Select the MultitouchArt target in Xcode
   - Go to "Signing & Capabilities"
   - Select your development team
   - Change bundle identifier if needed (currently: `com.multitouchart.app`)

3. **Build for Release**
   - Select "Any iOS Device (arm64)" as the destination
   - Product > Archive
   - Wait for the archive to complete

4. **Upload to App Store Connect**
   - In the Organizer window, select your archive
   - Click "Distribute App"
   - Select "App Store Connect"
   - Follow the wizard to upload

5. **Configure TestFlight**
   - Go to [App Store Connect](https://appstoreconnect.apple.com)
   - Select your app
   - Go to the TestFlight tab
   - Add internal or external testers
   - Submit the build for testing

6. **Share with Testers**
   - Testers will receive an invitation email
   - They need the TestFlight app installed
   - Click the invitation link to install the app

## Usage

Simply touch the screen with one or multiple fingers to create colorful, interactive particles with sound effects. Each touch generates a unique color and sound frequency. Move your fingers to see the trailing effects.

Tap the refresh button (↻) in the bottom-right corner to clear all particles.

## Customization

You can easily customize:
- Colors in `MultitouchView.swift` (colors array)
- Sound frequency range in `SoundManager.swift` (frequency parameter)
- Particle size and fade duration in `TouchParticle.swift` (radius and alpha)
- Trail length in `TouchParticle.swift` (maxTrailLength)

## License

This project structure is provided as-is for your use.
