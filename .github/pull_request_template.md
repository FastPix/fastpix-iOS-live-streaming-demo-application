# FastPix iOS Live App - Documentation PR

## Documentation Changes

### What Changed
- [ ] New documentation added
- [ ] Existing documentation updated
- [ ] Documentation errors fixed
- [ ] Code examples updated
- [ ] Links and references updated

### Files Modified
- [ ] README.md
- [ ] docs/ files
- [ ] USAGE.md
- [ ] CONTRIBUTING.md
- [ ] Other: _______________

### Summary
**Brief description of changes:**

<!-- Describe what documentation was added, updated, or fixed for the App -->

### Code Examples
```swift
```swift
import HaishinKit
import AVFoundation

// MARK: - Streaming Setup
let rtmpConnection = RTMPConnection()
let rtmpStream = RTMPStream(connection: rtmpConnection)

// MARK: - Configure Camera & Audio
configureStream(preset: .hd_720p_30fps_3mbps)
rtmpStream.attachCamera(cameraDevice)
rtmpStream.attachAudio(audioDevice)

// MARK: - Start Streaming
rtmpConnection.connect("rtmps://live.fastpix.app:443/live/<STREAM_KEY>")
rtmpStream.publish("<STREAM_NAME>")
```

### Testing
- [ ] All code examples tested on iOS
- [ ] Links verified
- [ ] Grammar checked
- [ ] Formatting consistent

### Review Checklist
- [ ] Content is accurate
- [ ] Code examples work as expected
- [ ] Links are working
- [ ] Grammar is correct
- [ ] Formatting is consistent

---

**Ready for review!**
