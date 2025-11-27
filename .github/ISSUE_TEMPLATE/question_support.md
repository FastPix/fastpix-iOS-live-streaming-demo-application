---
name: Question/Support
about: Ask questions or get help with the FastPix iOS live Streaming App
title: '[QUESTION] '
labels: ['question', 'needs-triage']
assignees: ''
---

# Question/Support

Thank you for reaching out! We're here to help you with the FastPix iOS live Streaming App. To get faster and more accurate help, please provide the following information:

## Question Type
- [ ] How to use a specific feature
- [ ] Integration help
- [ ] Configuration question
- [ ] Performance question
- [ ] Troubleshooting help
- [ ] Other: _______________

## Question
**What would you like to know?**

<!-- Provide a clear and specific question about the FastPix iOS live Streaming App -->

## What You've Tried
**What have you already attempted to solve this?**

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

// Your attempted code here
```

## Current Setup
**Describe your current setup:**
- iOS project version, Swift version, player used (AVPlayer, custom player, etc.)

# Environment

- **App Version**: [e.g., 1.0.0]
- **iOS Version**: [e.g., iOS 17.5]
- **Device/Simulator**: [e.g., iPhone 14 Pro, Xcode Simulator]
- **Xcode Version**: [e.g., 15.3]

## Configuration
**Current App configuration:**

```swift
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

## Expected Outcome
**What are you trying to achieve?**

<!-- Example: Add missing reconnect logic sample in the "Connection Management" section. -->

## Error Messages (if any)
```
<!-- Paste any error messages or unexpected behavior -->
```

## Additional Context

### Use Case
**What are you building?**
- [ ] Mobile app
- [ ] Video streaming service
- [ ] Video streaming service
- [ ] Other: _______________

### Timeline
**When do you need this resolved?**
- [ ] ASAP (blocking development)
- [ ] This week
- [ ] This month
- [ ] No rush

### Resources Checked
**What resources have you already checked?**
- [ ] README.md
- [ ] SDK documentation
- [ ] Examples
- [ ] Stack Overflow
- [ ] GitHub Issues
- [ ] Other: _______________

## Priority
Please indicate the urgency:
- [ ] Critical (Blocking production deployment)
- [ ] High (Blocking development)
- [ ] Medium (Would like to know soon)
- [ ] Low (Just curious)

## Checklist
Before submitting, please ensure:
- [ ] I have provided a clear question
- [ ] I have described what I've tried
- [ ] I have included my current setup and environment
- [ ] I have checked existing documentation
- [ ] I have provided sufficient context

---

**We'll do our best to help you get unstuck!**

**Helpful Resources:**
- [FastPix iOS Live App Documentation](https://docs.fastpix.io/docs/using-mobile)
