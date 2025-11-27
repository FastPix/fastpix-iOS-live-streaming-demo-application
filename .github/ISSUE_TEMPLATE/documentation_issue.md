---
name: Documentation Issue
about: Report issues with the FastPix Live iOS Streaming App documentation
title: '[DOCS]'
labels: ['documentation', 'needs-triage']
assignees: ''
---

# Documentation Issue

Thank you for helping improve the **FastPix Live – iOS Streaming App** documentation!  
Please provide the following details to help us resolve the issue effectively.

---

## Issue Type  
Select the type of documentation problem:

- [ ] Missing documentation
- [ ] Incorrect or misleading information
- [ ] Unclear explanation
- [ ] Broken or outdated links
- [ ] Outdated content (deprecated APIs, old workflow, etc.)
- [ ] Missing code samples
- [ ] Other: _______________

---

## Description  
**Describe the documentation issue clearly:**  

<!-- Example: The stream setup process is missing steps for reconnect logic. -->

---

## Current Documentation  
**Paste the exact content that needs correction:**  

<!-- Example: Copy the snippet or lines from README.md or docs that are incorrect. -->

---

## Expected Documentation  
**Provide the corrected or expected content:**  

```swift
// Example: Correct FastPix Live stream setup

import HaishinKit
import AVFoundation

let rtmpConnection = RTMPConnection()
let rtmpStream = RTMPStream(connection: rtmpConnection)

// Configure streaming preset
configureStream(preset: .hd_720p_30fps_3mbps)

// Attach camera + audio
rtmpStream.attachCamera(cameraDevice)
rtmpStream.attachAudio(audioDevice)

// Connect & publish
rtmpConnection.connect("rtmps://live.fastpix.app:443/live/<STREAM_KEY>")
rtmpStream.publish("<STREAM_NAME>")
```

## Location
**Where is this issue located?**

- [ ] README.md
- [ ] docs/ directory
- [ ] USAGE.md
- [ ] CONTRIBUTING.md
- [ ] API documentation
- [ ] Code examples
- [ ] Other: _______________

**Specific file or section:**  
<!-- Example: README.md → "Quick Start" → Step 3 -->

## Impact
**How does this issue affect users?**

- [ ] Blocks new users from getting started
- [ ] Causes confusion for existing users
- [ ] Leads to incorrect implementation
- [ ] Creates support requests
- [ ] Other: _______________

## Proposed Fix
**Suggested correction or updated example:**  

<!-- Example: Add missing reconnect logic sample in the "Connection Management" section. -->

## Additional Context
Add any other context about the issue here.  

## Screenshots
<!-- If applicable, include screenshots of the documentation issue -->

### Related Issues
- GitHub Issues: [Link related issues]  
- User Feedback: [Link to complaints or confusion]

### Testing
**How did you discover this issue?**

- [ ] While following the documentation
- [ ] User reported confusion
- [ ] Code didn't work as documented
- [ ] Other: _______________

## Priority
- [ ] Critical (Blocks users from using the SDK)
- [ ] High (Causes significant confusion)
- [ ] Medium (Minor clarity issue)
- [ ] Low (Cosmetic improvement)

## Checklist
- [ ] Identified the specific documentation issue
- [ ] Provided current and expected content
- [ ] Explained the impact on users
- [ ] Proposed a clear fix
- [ ] Checked if already reported
- [ ] Provided sufficient context

---

**Thank you for helping us improve the FastPix Live – iOS Streaming App documentation!**
