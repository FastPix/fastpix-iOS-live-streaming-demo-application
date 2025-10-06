
# FastPix Live - iOS Streaming App

A robust iOS live streaming application built with [HaishinKit RTMP library](https://github.com/shogo4405/HaishinKit.swift) that provides professional-grade broadcasting capabilities with advanced features like crash protection, network resilience, and modern iOS 18-style notifications.

## Demo App

![FastPix Live Demo](FpLive/Assets.xcassets/demo.gif)

# Key Features
### Core Streaming Capabilities
* **RTMPS Broadcasting** - Secure streaming to FastPix Live platform
* **Real-time Camera Switching** - Seamless front/back camera toggle during live streams
* **Network Resilience** - Automatic reconnection on network dropouts or changes (WiFi ↔ 4G)
* **Adaptive Bitrate** - Dynamic quality adjustment based on network conditions
* **Multi-Resolution Support** - Supporting four broadcasting profiles

### Advanced Features
* **Screen Wake Lock** - Prevents device from sleeping during broadcasts
* **Modern UI/UX** - iOS 18-style notifications with haptic feedback
* **Connection Management** - Intelligent retry logic with exponential backoff
* **Real-time Stats** - Live FPS and bitrate monitoring
* **Crash Protection** - Enhanced error handling for camera switching and status interactions

### User Experience
* **Ultra-modern Notifications** - Glass morphism design with blur effects
* **Progressive Web-style UI** - Gradient buttons and smooth animations  
* **Intuitive Controls** - One-tap streaming with clear status indicators
* **Error Recovery** - Graceful handling of network and hardware issues

# Known Limitations
* Streaming resolution 1080p may result in occasional frame drops, lowering the frame rate to around 20fps on older devices
* Camera switching is disabled during connection states to prevent crashes
* Rotation changes during reconnection may cause connection failures

# Quick Start
## Prerequisites

To use this application, you'll need:
1. **FastPix Account** - Sign up at [FastPix Dashboard](https://dashboard.fastpix.io/signup)
2. **RTMP Stream Key** - Create a live stream and obtain your unique stream key
3. **iOS Device** - iOS 13.0+ required (streaming not supported on simulator)

## Installation

1. **Clone the repository**
```bash
git clone https://github.com/example-fastpix-live-ios.git

cd fastpix-live-ios
```

2. **Install dependencies**
```bash
pod install
```

3. **Open and run**
```bash
open FpLive.xcworkspace
```

4. **Device Testing**
   - Connect your iOS device (simulator won't work for camera/streaming)
   - Build and run the project
   - Enter your FastPix stream key when prompted

# System Requirements

* **iOS Version**: 13.0 or higher
* **Device**: iPhone/iPad (physical device required for camera access)
* **Network**: WiFi or cellular data connection
* **Permissions**: Camera and microphone access

# Architecture Overview

## Core Components

### `LiveStreamViewController.swift`
The main streaming interface containing:
- **Camera Management**: Safe switching between front/back cameras
- **Stream Control**: Start/stop broadcasting with state management  
- **Network Handling**: Connection monitoring and automatic retry logic
- **UI Management**: Modern controls with real-time feedback

### Key Classes

**`UltraModernNotificationView`**
- iOS 18-style notifications with blur effects
- Haptic feedback integration
- Auto-dismiss with smooth animations

**`ModernNotificationManager`** 
- Centralized notification system
- Multiple styles (success, error, warning, info)
- Thread-safe presentation

**`StreamState` Enum**
- Comprehensive state management (idle, connecting, publishing, etc.)
- UI behavior mapping for each state
- Progress indication and user interaction control

### Streaming Profiles
```Swift
enum Preset {
  case hd_1080p_30fps_5mbps // Premium quality
  case hd_720p_30fps_3mbps // High quality
  case sd_540p_30fps_2mbps // Standard quality
  case sd_360p_30fps_1mbps // Data-saver quality
}
```

# Technical Implementation

## Stream Setup Process

1. **Permission Handling**
```Swift
requestCameraPermission { [weak self] granted in
    if granted {
        self?.setupStreamingEngine()
    } else {
        DispatchQueue.main.async {
            self?.showPermissionAlert()
        }
    }
}
```

2. **RTMP Configuration**
```Swift
rtmpStream = RTMPStream(connection: rtmpConnection)
configureStream(preset: self.preset)
rtmpStream.attachCamera(cameraDevice)
rtmpStream.attachAudio(audioDevice)
```

3. **Connection Management**
```Swift
rtmpConnection.addEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self)
rtmpConnection.connect("rtmps://live.fastpix.app:443/live")
```

## Crash Protection Features

### Camera Switching Protection
```Swift
private var isCameraSwitching = false
private var cameraAttachmentInProgress = false

private func attachCamera() {
guard !isCameraSwitching && !cameraAttachmentInProgress else { return }

// Safe camera switching logic

}
```

### Status Interaction Safety
```Swift
private func handleConnectingStateInteraction() {
guard isViewLoaded, view.window != nil, presentedViewController == nil else { return }

// Safe UI interaction during connection states

}
```

## Error Handling & Recovery

### Network Resilience
- **Network Change Detection**: Seamless transition between WiFi and cellular
- **Connection Timeout**: 15-second timeout with user options
- **Poor Network Handling**: Quality reduction and user notifications

### UI Protection
- **Thread Safety**: All UI updates on main thread with proper guards
- **State Validation**: Operations only allowed in appropriate states  
- **Debouncing**: Prevention of rapid button taps and concurrent operations
- **Graceful Degradation**: Fallback behaviors for edge cases

## Monitoring & Analytics

### Real-time Metrics
- **FPS Monitoring**: Live frame rate display
- **Bitrate Tracking**: Current upload speed in kbps
- **Connection Status**: Visual indicators for stream health
- **Quality Adaptation**: Automatic bitrate adjustment notifications

## UI Features

### Modern Design Elements
- **Blur Effects**: Ultra-thin material backgrounds
- **Glass Morphism**: Translucent containers with subtle borders
- **Haptic Feedback**: Tactile responses for user actions
- **Smooth Animations**: Spring-based transitions and transforms

### Accessibility
- **Clear Visual Hierarchy**: Distinct UI sections and controls
- **Status Indicators**: Color-coded connection states
- **Error Messages**: User-friendly notification system
- **Touch Targets**: Properly sized interactive elements

## State Management

The app uses a comprehensive state machine to handle streaming lifecycle:
```Swift
enum StreamState {
  case idle // Ready to start streaming
  case connecting // Attempting RTMP connection
  case connected // Connected, starting stream
  case publishing // Live streaming active
  case reconnecting // Recovering from connection loss
  case stopping // Ending stream gracefully
  case waitingForNetwork // Poor network, waiting for improvement
}
```

# Platform Integration

## iOS System Features
- **Background Handling**: Proper app lifecycle management
- **Orientation Support**: All orientations with persistence
- **Screen Wake Lock**: Prevents sleep during streaming
- **Audio Session**: Proper audio handling for streaming
- **Network Monitoring**: Real-time connectivity status

## Testing Considerations
- **Physical Device Required**: Camera and streaming features need real hardware
- **Network Conditions**: Test various connection scenarios
- **Battery Impact**: Monitor power consumption during long streams
- **Memory Usage**: Profile for memory leaks in streaming components

# Performance Optimizations

## Memory Management
- **Weak References**: Proper memory handling in async callbacks
- **Resource Cleanup**: Complete stream teardown and reset
- **Buffer Management**: Efficient video/audio buffer handling

## Network Optimization
- **Adaptive Bitrate**: Dynamic quality adjustment
- **Connection Pooling**: Efficient RTMP connection reuse
- **Bandwidth Detection**: Network quality assessment

# Support & Troubleshooting

## Common Issues

1. **Black Screen During Streaming**
   - Check camera permissions
   - Verify stream key validity
   - Restart the app

2. **Connection Failures**
   - Check network connectivity
   - Verify RTMP endpoint accessibility
   - Try different network (WiFi/4G)

3. **Camera Switching Crashes** 
   - Fixed in latest version with crash protection
   - Avoid rapid camera switching during connection

