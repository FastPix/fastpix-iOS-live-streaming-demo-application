---
name: Bug Report
about: Report an issue related to the FastPix Live iOS Streaming App
title: '[BUG] '
labels: bug
assignees: ''
---

# Bug Description
Provide a clear, concise description of the issue encountered while using the FastPix Live iOS Streaming App.
Mention whether the bug affects streaming, UI, camera switching, notifications, reconnection, or performance.

---

# Steps to Reproduce

### **App Setupp**

Describe how you configured the FastPix Live application.

```swift
import HaishinKit
import AVFoundation

let rtmpConnection = RTMPConnection()
let rtmpStream = RTMPStream(connection: rtmpConnection)

// Configure the stream
configureStream(preset: .hd_720p_30fps_3mbps)

// Attach camera and audio
rtmpStream.attachCamera(cameraDevice)
rtmpStream.attachAudio(audioDevice)
```

### 2. **Example Code to Reproduce**

Provide a minimal reproducible code snippet that demonstrates the issue. Example:

```swift
// Attempt to start streaming
rtmpConnection.connect("rtmps://live.fastpix.app:443/live/<STREAM_KEY>")
rtmpStream.publish("<STREAM_NAME>")

// Example: Camera switching
toggleCamera()

// Example: Using modern notifications
ModernNotificationManager.shared.showNotification(
    style: .error,
    message: "Test Error Message"
)
```

Replace this snippet with the exact code where the bug occurs.

---

# Expected Behavior
```
<!-- Describe what you expected to happen -->
```

# Actual Behavior
```
<!-- Describe what actually happened -->
```

# Environment

- **App Version**: [e.g., 1.0.0]
- **iOS Version**: [e.g., iOS 17.5]
- **Device/Simulator**: [e.g., iPhone 14 Pro, Xcode Simulator]
- **Xcode Version**: [e.g., 15.3]

---

# Logs / Errors / Stack Trace
```
Paste console logs, crash logs, or SDK error responses here
```

---

# Additional Context
Add any additional information that might help us troubleshoot, such as:

---

# Screenshots / Screen Recording
If applicable, attach screenshots or a video demonstrating the issue.
