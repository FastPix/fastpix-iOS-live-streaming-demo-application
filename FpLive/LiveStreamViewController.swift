//
//  LiveStreamViewController.swift
//  FpLive
//
//  Created by Neha Dereddy on 19/09/25.

import UIKit
import HaishinKit
import AVFoundation
import VideoToolbox
import UserNotifications
import Network

class UltraModernNotificationView: UIView {
    
    private let title: String
    private let message: String?
    private let style: ModernNotificationManager.NotificationStyle
    private let duration: TimeInterval
    
    init(title: String, message: String? = nil, style: ModernNotificationManager.NotificationStyle, duration: TimeInterval = 4.0) {
        self.title = title
        self.message = message
        self.style = style
        self.duration = duration
        super.init(frame: .zero)
        setupUltraModernView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUltraModernView() {
        backgroundColor = .clear
        layer.cornerRadius = 20
        layer.cornerCurve = .continuous
        clipsToBounds = true
        
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        let containerView = UIView()
        containerView.backgroundColor = style.backgroundColor.withAlphaComponent(0.15)
        containerView.layer.cornerRadius = 20
        containerView.layer.cornerCurve = .continuous
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 8)
        layer.shadowRadius = 25
        layer.shadowOpacity = 0.15
        
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
        
        let appIconView = UIView()
        appIconView.backgroundColor = style.backgroundColor
        appIconView.layer.cornerRadius = 8
        appIconView.layer.cornerCurve = .continuous
        appIconView.translatesAutoresizingMaskIntoConstraints = false
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: style.icon)
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let appNameLabel = UILabel()
        appNameLabel.text = "FastPix Live"
        appNameLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        appNameLabel.textColor = .white.withAlphaComponent(0.9)
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let timeLabel = UILabel()
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        timeLabel.text = formatter.string(from: Date())
        timeLabel.font = .systemFont(ofSize: 13, weight: .regular)
        timeLabel.textColor = .white.withAlphaComponent(0.7)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        var messageLabel: UILabel?
        if let message = message {
            messageLabel = UILabel()
            messageLabel?.text = message
            messageLabel?.font = .systemFont(ofSize: 14, weight: .regular)
            messageLabel?.textColor = .white.withAlphaComponent(0.8)
            messageLabel?.numberOfLines = 3
            messageLabel?.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let accentLine = UIView()
        accentLine.backgroundColor = style.backgroundColor
        accentLine.layer.cornerRadius = 1
        accentLine.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(blurView)
        addSubview(containerView)
        containerView.addSubview(appIconView)
        appIconView.addSubview(iconImageView)
        containerView.addSubview(appNameLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(accentLine)
        
        if let messageLabel = messageLabel {
            containerView.addSubview(messageLabel)
        }
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            appIconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            appIconView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 14),
            appIconView.widthAnchor.constraint(equalToConstant: 28),
            appIconView.heightAnchor.constraint(equalToConstant: 28),
            
            iconImageView.centerXAnchor.constraint(equalTo: appIconView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: appIconView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 16),
            iconImageView.heightAnchor.constraint(equalToConstant: 16),
            
            appNameLabel.leadingAnchor.constraint(equalTo: appIconView.trailingAnchor, constant: 10),
            appNameLabel.centerYAnchor.constraint(equalTo: appIconView.centerYAnchor),
            
            timeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            timeLabel.centerYAnchor.constraint(equalTo: appIconView.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: appIconView.bottomAnchor, constant: 12),
            
            accentLine.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            accentLine.widthAnchor.constraint(equalToConstant: 4),
            accentLine.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            accentLine.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])
        
        if let messageLabel = messageLabel {
            NSLayoutConstraint.activate([
                messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
                messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
                messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
                messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
            ])
        } else {
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16).isActive = true
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissWithAnimation))
        addGestureRecognizer(tapGesture)
    }
    
    func show(in viewController: UIViewController) {
        guard let parentView = viewController.view else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(self)
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 8),
            trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -8),
            topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor, constant: 8)
        ])
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        alpha = 0
        transform = CGAffineTransform(translationX: 0, y: -120).scaledBy(x: 0.95, y: 0.95)
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: [.curveEaseOut, .allowUserInteraction]) {
            self.alpha = 1
            self.transform = .identity
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.dismissWithAnimation()
        }
    }
    
    @objc private func dismissWithAnimation() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .soft)
        impactFeedback.impactOccurred()
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(translationX: 0, y: -80).scaledBy(x: 0.9, y: 0.9)
        }) { _ in
            self.removeFromSuperview()
        }
    }
}

// MARK: - Notification Manager
class ModernNotificationManager {
    static let shared = ModernNotificationManager()
    
    private init() {}
    
    enum NotificationStyle {
        case success
        case error
        case warning
        case info
        
        var backgroundColor: UIColor {
            switch self {
            case .success: return .systemGreen
            case .error: return .systemRed
            case .warning: return .systemOrange
            case .info: return .systemBlue
            }
        }
        
        var icon: String {
            switch self {
            case .success: return "checkmark.circle.fill"
            case .error: return "xmark.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .info: return "info.circle.fill"
            }
        }
    }
    
    func showNotification(title: String, message: String? = nil, style: NotificationStyle, in viewController: UIViewController) {
        let notification = UltraModernNotificationView(title: title, message: message, style: style)
        notification.show(in: viewController)
    }
}

// MARK: - LiveStreamViewController
class LiveStreamViewController: UIViewController {
    
    // MARK: - UI Components
    var previewView: MTHKView!
    var topControlsContainer: UIView!
    var bottomControlsContainer: UIView!
    var cameraSelector: UISegmentedControl!
    var startStopButton: UIButton!
    var fpsLabel: UILabel!
    var bitrateLabel: UILabel!
    var closeButton: UIButton!
    var recordingIndicator: UIView!
    var streamStatusLabel: UILabel!
    
    // MARK: - Streaming Properties
    var rtmpConnection = RTMPConnection()
    var rtmpStream: RTMPStream!
    var defaultCamera: AVCaptureDevice.Position = .back
    var liveDesired = false
    
    // MARK: - Public Properties (for backward compatibility)
    var streamKey: String!
    var preset: Preset!
    
    // MARK: - Enhanced Connection State Management
    private enum StreamState {
        case idle, connecting, connected, publishing, reconnecting, stopping, waitingForNetwork
        
        var buttonTitle: String {
            switch self {
            case .idle: return "Go Live!"
            case .connecting: return "Connecting..."
            case .waitingForNetwork: return "Waiting for Network..."
            case .connected: return "Starting Stream..."
            case .publishing: return "🛑 Stop Streaming!"
            case .reconnecting: return "Reconnecting..."
            case .stopping: return "Stopping..."
            }
        }
        
        var buttonColor: UIColor {
            switch self {
            case .idle: return .systemGreen
            case .connecting, .connected: return .systemOrange
            case .waitingForNetwork: return .systemBlue
            case .publishing: return .systemRed
            case .reconnecting: return .systemBlue
            case .stopping: return .systemGray
            }
        }
        
        var allowsUserInteraction: Bool {
            switch self {
            case .idle, .publishing: return true
            case .connecting, .reconnecting, .waitingForNetwork: return true  // Allow cancel/options
            case .connected, .stopping: return false
            }
        }
        
        var shouldShowCancelOption: Bool {
            switch self {
            case .connecting, .reconnecting, .waitingForNetwork: return true
            default: return false
            }
        }
        
        var shouldShowProgress: Bool {
            switch self {
            case .connecting, .reconnecting, .waitingForNetwork: return true
            default: return false
            }
        }
    }
    
    private var currentStreamState: StreamState = .idle {
        didSet { updateUIForState(currentStreamState) }
    }
    
    // MARK: - Network Monitoring
    private var networkMonitor: NWPathMonitor!
    private var networkQueue: DispatchQueue!
    private var isNetworkAvailable = true
    
    // MARK: - Task 10928 Fix: Screen Wake Lock Properties
    private var originalIdleTimerDisabled: Bool = false
    private var shouldKeepScreenAwake: Bool = false
    
    // MARK: - Enhanced Orientation Persistence Properties
    private var savedInterfaceOrientation: UIInterfaceOrientation?
    private var shouldRestoreOrientation = false
    private var lastKnownDeviceOrientation: UIDeviceOrientation = .portrait
    private var hasInitialOrientationBeenSet = false
    
    // MARK: - Connection Management
    private var connectionTimer: Timer?
    private let connectionTimeout: TimeInterval = 15.0
    private var reconnectAttempt = 0
    
    enum Preset {
        case hd_1080p_30fps_5mbps
        case hd_720p_30fps_3mbps
        case sd_540p_30fps_2mbps
        case sd_360p_30fps_1mbps
    }
    
    private class Profile {
        public var width : Int = 0
        public var height : Int = 0
        public var frameRate : Int = 0
        public var bitrate : Int = 0
        
        init(width: Int, height: Int, frameRate: Int, bitrate: Int) {
            self.width = width
            self.height = height
            self.frameRate = frameRate
            self.bitrate = bitrate
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalIdleTimerDisabled = UIApplication.shared.isIdleTimerDisabled
        
        setupNetworkMonitoring()
        
        setupAppLifecycleObservers()
        
        storeInitialOrientation()
        
        if let savedOrientation = loadSavedOrientation() {
            savedInterfaceOrientation = savedOrientation
            shouldRestoreOrientation = true
        }
        
        setupUI()
        
        setupOrientationMonitoring()
        
        requestCameraPermission { [weak self] granted in
            if granted {
                self?.setupStreamingEngine()
            } else {
                DispatchQueue.main.async {
                    self?.showPermissionAlert()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if shouldRestoreOrientation, let targetOrientation = savedInterfaceOrientation {
            restoreOrientation(targetOrientation)
            shouldRestoreOrientation = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let rtmpStream = self.rtmpStream {
                self.previewView?.attachStream(rtmpStream)
                self.updateCameraOrientationForCurrentState()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateGradients()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveCurrentOrientation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cancelConnectionTimer()
    }
    
    // MARK: - App Lifecycle Observers
    private func setupAppLifecycleObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillResignActive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
    }
    
    @objc private func appWillEnterForeground() {
        storeCurrentDeviceOrientation()
    }
    
    @objc private func appDidBecomeActive() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.updateCameraOrientationForCurrentState()
            self.updateVideoOrientationFromDevice()
        }
    }
    
    @objc private func appWillResignActive() {
        saveCurrentOrientation()
        storeCurrentDeviceOrientation()
    }
    
    // MARK: - Enhanced Orientation Management
    private func storeInitialOrientation() {
        lastKnownDeviceOrientation = UIDevice.current.orientation
        hasInitialOrientationBeenSet = true
    }
    
    private func storeCurrentDeviceOrientation() {
        let currentOrientation = UIDevice.current.orientation
        
        if currentOrientation != .unknown &&
            currentOrientation != .faceUp &&
            currentOrientation != .faceDown {
            lastKnownDeviceOrientation = currentOrientation
            
            UserDefaults.standard.set(currentOrientation.rawValue, forKey: "LastDeviceOrientation")
            UserDefaults.standard.synchronize()
            
        }
    }
    
    private func loadStoredDeviceOrientation() -> UIDeviceOrientation? {
        let rawValue = UserDefaults.standard.integer(forKey: "LastDeviceOrientation")
        guard rawValue != 0 else { return nil }
        
        return UIDeviceOrientation(rawValue: rawValue)
    }
    
    private func updateCameraOrientationForCurrentState() {
        guard let rtmpStream = rtmpStream else { return }
        
        let currentDeviceOrientation = UIDevice.current.orientation
        
        let orientationToUse: UIDeviceOrientation
        if currentDeviceOrientation == .unknown ||
            currentDeviceOrientation == .faceUp ||
            currentDeviceOrientation == .faceDown {
            
            if let storedOrientation = loadStoredDeviceOrientation() {
                orientationToUse = storedOrientation
            } else {
                orientationToUse = lastKnownDeviceOrientation
            }
        } else {
            orientationToUse = currentDeviceOrientation
            storeCurrentDeviceOrientation()
        }
        
        let videoOrientation = deviceOrientationToVideoOrientation(orientationToUse)
        
        rtmpStream.videoOrientation = videoOrientation
        
        updateVideoSizeForOrientation(videoOrientation)
        
    }
    
    private func deviceOrientationToVideoOrientation(_ deviceOrientation: UIDeviceOrientation) -> AVCaptureVideoOrientation {
        switch deviceOrientation {
        case .portrait:
            return .portrait
        case .portraitUpsideDown:
            return .portraitUpsideDown
        case .landscapeLeft:
            return .landscapeRight
        case .landscapeRight:
            return .landscapeLeft
        default:
            return .portrait
        }
    }
    
    private func updateVideoSizeForOrientation(_ videoOrientation: AVCaptureVideoOrientation) {
        guard let rtmpStream = rtmpStream else { return }
        
        let profile = presetToProfile(preset: preset)
        let isPortrait = (videoOrientation == .portrait || videoOrientation == .portraitUpsideDown)
        
        if isPortrait {
            rtmpStream.videoSettings.videoSize.width = CGFloat(profile.height)
            rtmpStream.videoSettings.videoSize.height = CGFloat(profile.width)
        } else {
            rtmpStream.videoSettings.videoSize.width = CGFloat(profile.width)
            rtmpStream.videoSettings.videoSize.height = CGFloat(profile.height)
        }
    }
    
    private func setupNetworkMonitoring() {
        networkMonitor = NWPathMonitor()
        networkQueue = DispatchQueue(label: "NetworkMonitor")
        
        networkMonitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.handleNetworkChange(isAvailable: path.status == .satisfied)
            }
        }
        networkMonitor.start(queue: networkQueue)
    }
    
    private func handleNetworkChange(isAvailable: Bool) {
        let wasAvailable = isNetworkAvailable
        isNetworkAvailable = isAvailable
        
        if !wasAvailable && isAvailable {
            if currentStreamState == .waitingForNetwork && liveDesired {
                currentStreamState = .connecting
                connectRTMP()
            }
        } else if wasAvailable && !isAvailable {
            if currentStreamState == .connecting || currentStreamState == .reconnecting {
                currentStreamState = .waitingForNetwork
            }
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return savedInterfaceOrientation ?? .portrait
    }
    
    private func enableScreenWakeLock() {
        UIApplication.shared.isIdleTimerDisabled = true
        shouldKeepScreenAwake = true
        
        ModernNotificationManager.shared.showNotification(
            title: "Screen Lock Disabled",
            message: "Screen will stay awake during live streaming",
            style: .info,
            in: self
        )
    }
    
    private func disableScreenWakeLock() {
        UIApplication.shared.isIdleTimerDisabled = originalIdleTimerDisabled
        shouldKeepScreenAwake = false
        
        ModernNotificationManager.shared.showNotification(
            title: "Screen Lock Restored",
            message: "Normal screen timeout behavior restored",
            style: .info,
            in: self
        )
    }
    
    private func saveCurrentOrientation() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let currentOrientation = windowScene.interfaceOrientation
            UserDefaults.standard.set(currentOrientation.rawValue, forKey: "LiveStreamLastOrientation")
            UserDefaults.standard.synchronize()
        }
    }
    
    private func loadSavedOrientation() -> UIInterfaceOrientation? {
        let rawValue = UserDefaults.standard.integer(forKey: "LiveStreamLastOrientation")
        guard rawValue != 0 else { return nil }
        
        let savedOrientation = UIInterfaceOrientation(rawValue: rawValue)
        
        return savedOrientation
    }
    
    private func orientationName(_ orientation: UIInterfaceOrientation?) -> String {
        guard let orientation = orientation else { return "Unknown" }
        
        switch orientation {
        case .portrait: return "Portrait"
        case .portraitUpsideDown: return "Portrait Upside Down"
        case .landscapeLeft: return "Landscape Left"
        case .landscapeRight: return "Landscape Right"
        default: return "Unknown"
        }
    }
    
    private func setupOrientationMonitoring() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deviceOrientationDidChange),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }
    
    @objc private func deviceOrientationDidChange() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.saveCurrentOrientation()
            self.storeCurrentDeviceOrientation()
            self.updateVideoOrientationFromDevice()
        }
    }
    
    private func updateVideoOrientationFromDevice() {
        guard let rtmpStream = rtmpStream else { return }
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let interfaceOrientation = windowScene.interfaceOrientation
            
            let videoOrientation: AVCaptureVideoOrientation
            switch interfaceOrientation {
            case .portrait:
                videoOrientation = .portrait
            case .portraitUpsideDown:
                videoOrientation = .portraitUpsideDown
            case .landscapeLeft:
                videoOrientation = .landscapeLeft
            case .landscapeRight:
                videoOrientation = .landscapeRight
            default:
                videoOrientation = .portrait
            }
            
            rtmpStream.videoOrientation = videoOrientation
            updateVideoSizeForOrientation(videoOrientation)
            
        }
    }
    
    private func restoreOrientation(_ targetOrientation: UIInterfaceOrientation) {
        let deviceOrientation: UIDeviceOrientation
        
        switch targetOrientation {
        case .portrait:
            deviceOrientation = .portrait
        case .portraitUpsideDown:
            deviceOrientation = .portraitUpsideDown
        case .landscapeLeft:
            deviceOrientation = .landscapeRight
        case .landscapeRight:
            deviceOrientation = .landscapeLeft
        default:
            deviceOrientation = .portrait
        }
        
        UIDevice.current.setValue(deviceOrientation.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        createCameraPreview()
        createTopControls()
        createBottomControls()
        createStatusIndicators()
        setupConstraints()
        setupGestures()
    }
    
    private func createCameraPreview() {
        previewView = MTHKView(frame: view.bounds)
        previewView.backgroundColor = .black
        previewView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(previewView)
        
        NSLayoutConstraint.activate([
            previewView.topAnchor.constraint(equalTo: view.topAnchor),
            previewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previewView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            previewView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func createTopControls() {
        topControlsContainer = UIView()
        topControlsContainer.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        topControlsContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.alpha = 0.8
        topControlsContainer.insertSubview(blurView, at: 0)
        view.addSubview(topControlsContainer)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topControlsContainer.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: topControlsContainer.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: topControlsContainer.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: topControlsContainer.bottomAnchor)
        ])
        
        createCameraSelector()
        createCloseButton()
    }
    
    private func createCameraSelector() {
        let titles = ["Back", "Front"]
        cameraSelector = UISegmentedControl(items: titles)
        cameraSelector.selectedSegmentIndex = 0
        cameraSelector.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        cameraSelector.selectedSegmentTintColor = .systemGreen
        cameraSelector.layer.cornerRadius = 20
        cameraSelector.translatesAutoresizingMaskIntoConstraints = false
        cameraSelector.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.8),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold)
        ], for: .normal)
        cameraSelector.addTarget(self, action: #selector(changeCameraToggle(_:)), for: .valueChanged)
        topControlsContainer.addSubview(cameraSelector)
    }
    
    private func createCloseButton() {
        closeButton = UIButton(type: .system)
        closeButton.setTitle("✕", for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.backgroundColor = UIColor.systemRed.withAlphaComponent(0.8)
        closeButton.layer.cornerRadius = 25
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        closeButton.layer.shadowColor = UIColor.black.cgColor
        closeButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        closeButton.layer.shadowRadius = 8
        closeButton.layer.shadowOpacity = 0.3
        closeButton.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
        topControlsContainer.addSubview(closeButton)
    }
    
    private func createBottomControls() {
        bottomControlsContainer = UIView()
        bottomControlsContainer.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        bottomControlsContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.alpha = 0.9
        bottomControlsContainer.insertSubview(blurView, at: 0)
        view.addSubview(bottomControlsContainer)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: bottomControlsContainer.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: bottomControlsContainer.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: bottomControlsContainer.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomControlsContainer.bottomAnchor)
        ])
        
        createStatsLabels()
        createStreamButton()
    }
    
    private func createStatsLabels() {
        let statsContainer = UIView()
        statsContainer.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        statsContainer.layer.cornerRadius = 16
        statsContainer.translatesAutoresizingMaskIntoConstraints = false
        
        fpsLabel = UILabel()
        fpsLabel.text = "0 fps"
        fpsLabel.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .semibold)
        fpsLabel.textColor = .systemGreen
        fpsLabel.textAlignment = .center
        fpsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        bitrateLabel = UILabel()
        bitrateLabel.text = "0 kbps"
        bitrateLabel.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .semibold)
        bitrateLabel.textColor = .systemBlue
        bitrateLabel.textAlignment = .center
        bitrateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let divider = UIView()
        divider.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        statsContainer.addSubview(fpsLabel)
        statsContainer.addSubview(divider)
        statsContainer.addSubview(bitrateLabel)
        bottomControlsContainer.addSubview(statsContainer)
        
        NSLayoutConstraint.activate([
            statsContainer.leadingAnchor.constraint(equalTo: bottomControlsContainer.leadingAnchor, constant: 20),
            statsContainer.centerYAnchor.constraint(equalTo: bottomControlsContainer.centerYAnchor),
            statsContainer.widthAnchor.constraint(equalToConstant: 120),
            statsContainer.heightAnchor.constraint(equalToConstant: 60),
            
            fpsLabel.topAnchor.constraint(equalTo: statsContainer.topAnchor, constant: 8),
            fpsLabel.leadingAnchor.constraint(equalTo: statsContainer.leadingAnchor, constant: 8),
            fpsLabel.trailingAnchor.constraint(equalTo: statsContainer.trailingAnchor, constant: -8),
            
            divider.topAnchor.constraint(equalTo: fpsLabel.bottomAnchor, constant: 4),
            divider.leadingAnchor.constraint(equalTo: statsContainer.leadingAnchor, constant: 16),
            divider.trailingAnchor.constraint(equalTo: statsContainer.trailingAnchor, constant: -16),
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            bitrateLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 4),
            bitrateLabel.leadingAnchor.constraint(equalTo: statsContainer.leadingAnchor, constant: 8),
            bitrateLabel.trailingAnchor.constraint(equalTo: statsContainer.trailingAnchor, constant: -8),
            bitrateLabel.bottomAnchor.constraint(equalTo: statsContainer.bottomAnchor, constant: -8)
        ])
    }
    
    private func createStreamButton() {
        startStopButton = UIButton(type: .system)
        startStopButton.setTitle("Go Live!", for: .normal)
        startStopButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        startStopButton.setTitleColor(.white, for: .normal)
        startStopButton.backgroundColor = .systemGreen
        startStopButton.layer.cornerRadius = 25
        startStopButton.translatesAutoresizingMaskIntoConstraints = false
        startStopButton.addTarget(self, action: #selector(buttonStartLive(_:)), for: .touchUpInside)
        bottomControlsContainer.addSubview(startStopButton)
    }
    
    private func createStatusIndicators() {
        recordingIndicator = UIView()
        recordingIndicator.backgroundColor = .systemRed
        recordingIndicator.layer.cornerRadius = 6
        recordingIndicator.translatesAutoresizingMaskIntoConstraints = false
        recordingIndicator.alpha = 0
        
        streamStatusLabel = UILabel()
        streamStatusLabel.text = "LIVE"
        streamStatusLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        streamStatusLabel.textColor = .systemRed
        streamStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        streamStatusLabel.alpha = 0
        
        view.addSubview(recordingIndicator)
        view.addSubview(streamStatusLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            topControlsContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topControlsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topControlsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topControlsContainer.heightAnchor.constraint(equalToConstant: 80),
            
            closeButton.leadingAnchor.constraint(equalTo: topControlsContainer.leadingAnchor, constant: 20),
            closeButton.centerYAnchor.constraint(equalTo: topControlsContainer.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 50),
            closeButton.heightAnchor.constraint(equalToConstant: 50),
            
            cameraSelector.centerXAnchor.constraint(equalTo: topControlsContainer.centerXAnchor),
            cameraSelector.centerYAnchor.constraint(equalTo: topControlsContainer.centerYAnchor),
            cameraSelector.widthAnchor.constraint(equalToConstant: 200),
            cameraSelector.heightAnchor.constraint(equalToConstant: 40),
            
            bottomControlsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomControlsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomControlsContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomControlsContainer.heightAnchor.constraint(equalToConstant: 100),
            
            startStopButton.trailingAnchor.constraint(equalTo: bottomControlsContainer.trailingAnchor, constant: -20),
            startStopButton.centerYAnchor.constraint(equalTo: bottomControlsContainer.centerYAnchor),
            startStopButton.widthAnchor.constraint(equalToConstant: 200),
            startStopButton.heightAnchor.constraint(equalToConstant: 50),
            
            recordingIndicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            recordingIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            recordingIndicator.widthAnchor.constraint(equalToConstant: 12),
            recordingIndicator.heightAnchor.constraint(equalToConstant: 12),
            
            streamStatusLabel.leadingAnchor.constraint(equalTo: recordingIndicator.trailingAnchor, constant: 8),
            streamStatusLabel.centerYAnchor.constraint(equalTo: recordingIndicator.centerYAnchor)
        ])
    }
    
    private func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        previewView.addGestureRecognizer(tap)
        previewView.isUserInteractionEnabled = true
    }
    
    private func updateGradients() {
        DispatchQueue.main.async {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.startStopButton.bounds
            gradientLayer.colors = [
                UIColor.systemGreen.cgColor,
                UIColor.systemBlue.cgColor
            ]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            gradientLayer.cornerRadius = 25
            self.startStopButton.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
            self.startStopButton.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    private func updateUIForState(_ state: StreamState) {
        DispatchQueue.main.async {
            self.startStopButton.setTitle(state.buttonTitle, for: .normal)
            self.startStopButton.backgroundColor = state.buttonColor
            self.startStopButton.isUserInteractionEnabled = state.allowsUserInteraction
            self.startStopButton.alpha = state.allowsUserInteraction ? 1.0 : 0.7
            
            if state.shouldShowProgress {
                self.showProgressIndicator()
            } else {
                self.hideProgressIndicator()
            }
            
            self.cameraSelector.isUserInteractionEnabled = (state == .idle || state == .publishing)
            
            switch state {
            case .publishing:
                self.recordingIndicator.alpha = 1
                self.streamStatusLabel.alpha = 1
                self.animateLiveIndicator()
            default:
                self.recordingIndicator.layer.removeAllAnimations()
                self.recordingIndicator.alpha = 0
                self.streamStatusLabel.alpha = 0
            }
        }
    }
    
    private func showProgressIndicator() {
        if startStopButton.subviews.first(where: { $0 is UIActivityIndicatorView }) == nil {
            let indicator = UIActivityIndicatorView(style: .medium)
            indicator.color = UIColor.white
            indicator.translatesAutoresizingMaskIntoConstraints = false
            startStopButton.addSubview(indicator)
            
            NSLayoutConstraint.activate([
                indicator.trailingAnchor.constraint(equalTo: startStopButton.trailingAnchor, constant: -16),
                indicator.centerYAnchor.constraint(equalTo: startStopButton.centerYAnchor)
            ])
            
            indicator.startAnimating()
        }
    }
    
    private func hideProgressIndicator() {
        startStopButton.subviews.first(where: { $0 is UIActivityIndicatorView })?.removeFromSuperview()
    }
    
    private func startConnectionTimer() {
        cancelConnectionTimer()
        let timeout = isNetworkAvailable ? connectionTimeout : (connectionTimeout * 2)
        
        connectionTimer = Timer.scheduledTimer(withTimeInterval: timeout, repeats: false) { [weak self] _ in
            self?.handleConnectionTimeout()
        }
    }
    
    private func cancelConnectionTimer() {
        connectionTimer?.invalidate()
        connectionTimer = nil
    }
    
    private func handleConnectionTimeout() {
        if currentStreamState == .connecting || currentStreamState == .reconnecting {
            if !isNetworkAvailable {
                currentStreamState = .waitingForNetwork
                ModernNotificationManager.shared.showNotification(
                    title: "Poor Network Connection",
                    message: "Waiting for better network connection...",
                    style: .warning,
                    in: self
                )
            } else {
                handleConnectionFailure()
            }
        }
    }
    
    private func handleConnectionFailure() {
        cancelConnectionTimer()
        
        if liveDesired && reconnectAttempt < 5 {
            reconnectAttempt += 1
            
            let delay = calculateBackoffDelay()
            currentStreamState = .reconnecting
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                if self.liveDesired {
                    if self.isNetworkAvailable {
                        self.startConnectionTimer()
                        self.connectRTMP()
                    } else {
                        self.currentStreamState = .waitingForNetwork
                    }
                }
            }
        } else {
            liveDesired = false
            reconnectAttempt = 0
            currentStreamState = .idle
            disableScreenWakeLock()
            
            ModernNotificationManager.shared.showNotification(
                title: "Connection Failed",
                message: "Unable to establish connection after multiple attempts",
                style: .error,
                in: self
            )
        }
    }
    
    private func calculateBackoffDelay() -> TimeInterval {
        return min(pow(2.0, Double(reconnectAttempt)), 30.0)
    }
    
    private func animateLiveIndicator() {
        UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse, .allowUserInteraction]) {
            self.recordingIndicator.alpha = 0.3
        }
    }
    
    private func requestCameraPermission(completion: @escaping (Bool) -> Void) {
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        let microphoneStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        
        switch cameraStatus {
        case .authorized:
            if microphoneStatus == .authorized {
                completion(true)
            } else {
                AVCaptureDevice.requestAccess(for: .audio) { granted in
                    completion(granted)
                }
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    AVCaptureDevice.requestAccess(for: .audio) { audioGranted in
                        completion(audioGranted)
                    }
                } else {
                    completion(false)
                }
            }
        case .denied, .restricted:
            completion(false)
        @unknown default:
            completion(false)
        }
    }
    
    private func showPermissionAlert() {
        let alert = UIAlertController(
            title: "Camera Access Required",
            message: "Please enable camera and microphone access in Settings to use live streaming.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true)
        })
        
        present(alert, animated: true)
    }
    
    private func setupStreamingEngine() {
        rtmpStream = RTMPStream(connection: rtmpConnection)
        
        configureStream(preset: self.preset)
        
        setInitialCameraOrientation()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(on(_:)),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
        
        if let audioDevice = AVCaptureDevice.default(for: .audio) {
            rtmpStream.attachAudio(audioDevice) { error in
                if error != nil {
                    print("Audio attachment error: \(String(describing: error))")
                } else {
                    print("Audio attached successfully")
                }
            }
        }
        
        attachCamera()
        
        DispatchQueue.main.async {
            self.previewView?.attachStream(self.rtmpStream)
        }
        
        rtmpConnection.addEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self)
        rtmpConnection.addEventListener(.ioError, selector: #selector(rtmpErrorHandler), observer: self)
        rtmpConnection.delegate = self
    }
    
    private func setInitialCameraOrientation() {
        guard let rtmpStream = rtmpStream else { return }
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let interfaceOrientation = windowScene.interfaceOrientation
            
            if let videoOrientation = DeviceUtil.videoOrientation(by: interfaceOrientation) {
                rtmpStream.videoOrientation = videoOrientation
                updateVideoSizeForOrientation(videoOrientation)
                return
            }
        }
        
        let orientationToUse = loadStoredDeviceOrientation() ?? lastKnownDeviceOrientation
        let videoOrientation = deviceOrientationToVideoOrientation(orientationToUse)
        
        rtmpStream.videoOrientation = videoOrientation
        updateVideoSizeForOrientation(videoOrientation)
    }
    
    private func attachCamera() {
        let position: AVCaptureDevice.Position = (cameraSelector.selectedSegmentIndex == 0) ? .back : .front
        
        guard let cameraDevice = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: position
        ) else {
            return
        }
        
        rtmpStream.attachCamera(cameraDevice) { error in
            // Fix: Check if error is nil directly, don't use optional binding
            if error != nil {
                print("Camera attachment error: \(error)")
            } else {
                print("Camera attached successfully: \(position)")
            }
        }
    }
    
    private func presetToProfile(preset: Preset) -> Profile {
        switch preset {
        case .hd_1080p_30fps_5mbps:
            return Profile(width: 1920, height: 1080, frameRate: 30, bitrate: 5000000)
        case .hd_720p_30fps_3mbps:
            return Profile(width: 1280, height: 720, frameRate: 30, bitrate: 3000000)
        case .sd_540p_30fps_2mbps:
            return Profile(width: 960, height: 540, frameRate: 30, bitrate: 2000000)
        case .sd_360p_30fps_1mbps:
            return Profile(width: 640, height: 360, frameRate: 30, bitrate: 1000000)
        }
    }
    
    private func configureStream(preset: Preset) {
        let profile = presetToProfile(preset: preset)
        
        rtmpStream.sessionPreset = AVCaptureSession.Preset.hd1920x1080
        rtmpStream.frameRate = Float64(profile.frameRate)
        
        if let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation {
            if let videoOrientation = DeviceUtil.videoOrientation(by: orientation) {
                rtmpStream.videoOrientation = videoOrientation
            }
        }
        
        rtmpStream.videoSettings.videoSize.width = CGFloat(profile.width)
        rtmpStream.videoSettings.videoSize.height = CGFloat(profile.height)
        rtmpStream.videoSettings.bitRate = profile.bitrate
        rtmpStream.videoSettings.profileLevel = kVTProfileLevel_H264_Main_AutoLevel as String
        rtmpStream.videoSettings.maxKeyFrameIntervalDuration = 2
        
        rtmpStream.audioSettings.bitRate = 128000
    }
    
    private func publishStream() {
        rtmpStream.publish(streamKey)
        currentStreamState = .connected
    }
    
    private func connectRTMP() {
        rtmpConnection.connect("rtmps://live.fastpix.app:443/live")
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.ended {
            let point = sender.location(in: previewView)
            let pointOfInterest = CGPoint(x: point.x / previewView.bounds.size.width, y: point.y / previewView.bounds.size.height)
            
            guard let device = rtmpStream.videoCapture(for: 0)?.device, device.isFocusPointOfInterestSupported else {
                return
            }
            
            do {
                try device.lockForConfiguration()
                device.focusPointOfInterest = pointOfInterest
                device.focusMode = .continuousAutoFocus
                device.unlockForConfiguration()
            } catch let error as NSError {
            }
        }
    }
    
    @objc func changeCameraToggle(_ sender: UISegmentedControl) {
        attachCamera()
    }
    
    @objc func buttonStartLive(_ sender: UIButton) {
        switch currentStreamState {
        case .idle:
            if !isNetworkAvailable {
                showNetworkUnavailableAlert()
            } else {
                startStreamingProcess()
            }
            
        case .connecting, .reconnecting, .waitingForNetwork:
            showConnectionOptionsAlert()
            
        case .publishing:
            stopStreamingProcess()
            
        case .stopping:
            return
            
        default:
            break
        }
    }
    
    private func showNetworkUnavailableAlert() {
        let alert = UIAlertController(
            title: "No Network Connection",
            message: "Please check your internet connection and try again.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showConnectionOptionsAlert() {
        let alertTitle = currentStreamState == .waitingForNetwork ?
        "Waiting for Better Connection" : "Still Connecting..."
        
        let alertMessage = currentStreamState == .waitingForNetwork ?
        "Network connection is poor. The app will automatically continue when connection improves." :
        "Still trying to connect to the streaming server. What would you like to do?"
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel Stream", style: .destructive) { _ in
            self.cancelConnectionProcess()
        })
        
        if isNetworkAvailable && currentStreamState != .waitingForNetwork {
            alert.addAction(UIAlertAction(title: "Retry Now", style: .default) { _ in
                self.retryConnection()
            })
        }
        
        present(alert, animated: true)
    }
    
    private func retryConnection() {
        cancelConnectionTimer()
        currentStreamState = .connecting
        startConnectionTimer()
        connectRTMP()
        
        ModernNotificationManager.shared.showNotification(
            title: "Retrying Connection",
            message: "Attempting to reconnect to streaming server...",
            style: .info,
            in: self
        )
    }
    
    // ENHANCED: Start Streaming with Validation
    private func startStreamingProcess() {
        guard currentStreamState == .idle else {
            return
        }
        
        if rtmpConnection.connected {
            performCompleteStreamCleanup()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.executeStreamStart()
            }
            return
        }
        
        executeStreamStart()
    }
    
    private func executeStreamStart() {
        currentStreamState = .connecting
        liveDesired = true
        
        enableScreenWakeLock()
        startConnectionTimer()
        connectRTMP()
        
        ModernNotificationManager.shared.showNotification(
            title: "Starting Stream",
            message: "Connecting to server...",
            style: .info,
            in: self
        )
    }
    
    // ENHANCED: Stop Streaming with Complete Cleanup
    private func stopStreamingProcess() {
        
        currentStreamState = .stopping
        liveDesired = false
        
        disableScreenWakeLock()
        cancelConnectionTimer()
        
        performCompleteStreamCleanup()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.currentStreamState = .idle
            self.reconnectAttempt = 0
            self.resetUIForNextStream()
        }
        
        ModernNotificationManager.shared.showNotification(
            title: "Stream Ended",
            message: "Ready to start new stream",
            style: .info,
            in: self
        )
    }
    
    // MARK: - Complete Stream Cleanup and Reset for Restart
    private func performCompleteStreamCleanup() {
        rtmpStream?.close()
        
        if rtmpConnection.connected {
            rtmpConnection.close()
        }
        
        resetStreamObject()
        cancelConnectionTimer()
        
    }
    
    private func resetStreamObject() {
        previewView?.attachStream(nil)
        
        rtmpConnection.removeEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self)
        rtmpConnection.removeEventListener(.ioError, selector: #selector(rtmpErrorHandler), observer: self)
        
        rtmpConnection = RTMPConnection()
        rtmpStream = RTMPStream(connection: rtmpConnection)
        
        configureStream(preset: preset)
        setupStreamComponents()
        
        rtmpConnection.addEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self)
        rtmpConnection.addEventListener(.ioError, selector: #selector(rtmpErrorHandler), observer: self)
        rtmpConnection.delegate = self
        
    }
    
    private func setupStreamComponents() {
        if let audioDevice = AVCaptureDevice.default(for: .audio) {
            rtmpStream.attachAudio(audioDevice) { error in
                if error != nil {
                    print("Audio re-attachment error: \(String(describing: error))")
                } else {
                    print("Audio re-attached successfully")
                }
            }
        }
        
        attachCamera()
        
        DispatchQueue.main.async {
            self.previewView?.attachStream(self.rtmpStream)
        }
    }
    
    private func resetUIForNextStream() {
        DispatchQueue.main.async {
            self.fpsLabel.text = "0 fps"
            self.bitrateLabel.text = "0 kbps"
            
            self.startStopButton.setTitle("Go Live!", for: .normal)
            self.startStopButton.backgroundColor = .systemGreen
            self.startStopButton.isUserInteractionEnabled = true
            self.startStopButton.alpha = 1.0
            
            self.cameraSelector.isUserInteractionEnabled = true
            
        }
    }
    
    private func cancelConnectionProcess() {
        
        cancelConnectionTimer()
        rtmpStream?.close()
        rtmpConnection.close()
        
        liveDesired = false
        reconnectAttempt = 0
        currentStreamState = .idle
        
        disableScreenWakeLock()
        
        resetUIForNextStream()
        
        ModernNotificationManager.shared.showNotification(
            title: "Connection Cancelled",
            message: "Stream connection attempt has been cancelled",
            style: .warning,
            in: self
        )
    }
    
    @objc func closeButtonTapped(_ sender: Any) {
        if currentStreamState == .publishing || currentStreamState == .connecting || currentStreamState == .reconnecting {
            let alert = UIAlertController(
                title: "End Live Stream?",
                message: "Are you sure you want to end your live stream and close?",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "End Stream", style: .destructive) { _ in
                self.forceCloseStream()
            })
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default))
            
            present(alert, animated: true)
        } else {
            forceCloseStream()
        }
    }
    
    private func forceCloseStream() {
        disableScreenWakeLock()
        performCompleteStreamCleanup()
        liveDesired = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Enhanced RTMP Status Handler
    @objc private func rtmpStatusHandler(_ notification: Notification) {
        
        let e = Event.from(notification)
        guard let data: ASObject = e.data as? ASObject, let code: String = data["code"] as? String else {
            return
        }
        
        switch code {
        case RTMPConnection.Code.connectSuccess.rawValue:
            handleConnectionSuccess()
            
        case RTMPStream.Code.publishStart.rawValue:
            handlePublishStart()
            
        case RTMPStream.Code.unpublishSuccess.rawValue:
            handleUnpublishSuccess()
            
        case RTMPConnection.Code.connectFailed.rawValue:
            handleConnectionFailure()
            
        case RTMPConnection.Code.connectClosed.rawValue:
            handleConnectionLoss()
            
        default:
            break
        }
    }
    
    private func handleConnectionSuccess() {
        cancelConnectionTimer()
        currentStreamState = .connected
        reconnectAttempt = 0
        
        if liveDesired {
            publishStream()
        }
        
        DispatchQueue.main.async {
            ModernNotificationManager.shared.showNotification(
                title: "Connected Successfully",
                message: "Ready to start streaming",
                style: .success,
                in: self
            )
        }
    }
    
    private func handlePublishStart() {
        currentStreamState = .publishing
        reconnectAttempt = 0
        
        if !shouldKeepScreenAwake {
            enableScreenWakeLock()
        }
        
        DispatchQueue.main.async {
            ModernNotificationManager.shared.showNotification(
                title: "🔴 Live Streaming Started",
                message: "Stream is now live!",
                style: .success,
                in: self
            )
        }
    }
    
    private func handleUnpublishSuccess() {
        
        if currentStreamState != .stopping {
            currentStreamState = .idle
        }
        
        disableScreenWakeLock()
        
        DispatchQueue.main.async {
            ModernNotificationManager.shared.showNotification(
                title: "Stream Ended Successfully",
                message: "Ready for next stream",
                style: .info,
                in: self
            )
        }
    }
    
    private func handleConnectionLoss() {
        if liveDesired && currentStreamState == .publishing {
            currentStreamState = .reconnecting
            handleConnectionFailure()
        }
    }
    
    @objc private func rtmpErrorHandler(_ notification: Notification) {
        
        DispatchQueue.main.async {
            ModernNotificationManager.shared.showNotification(
                title: "Streaming Error",
                message: "An error occurred while streaming",
                style: .error,
                in: self
            )
        }
    }
    
    @objc private func on(_ notification: Notification) {
        if let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation {
            let videoOrientation = DeviceUtil.videoOrientation(by: orientation)
            if liveDesired == false {
                let profile = presetToProfile(preset: preset)
                rtmpStream.videoSettings.videoSize.width = CGFloat((orientation.isPortrait) ? profile.height : profile.width)
                rtmpStream.videoSettings.videoSize.height = CGFloat((orientation.isPortrait) ? profile.width : profile.height)
            }
        }
    }
    
    func rtmpStreamDidClear(_ stream: RTMPStream) {
    }
    
    deinit {
        UIApplication.shared.isIdleTimerDisabled = originalIdleTimerDisabled
        
        // Clean up app lifecycle observers
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
        NotificationCenter.default.removeObserver(self)
        
        previewView?.attachStream(nil)
        rtmpStream?.close()
        rtmpConnection.close()
        cancelConnectionTimer()
        networkMonitor?.cancel()
        
    }
}

// MARK: - RTMPConnection Delegate
extension LiveStreamViewController: RTMPConnectionDelegate {
    
    func connection(_ connection: RTMPConnection, publishInsufficientBWOccured stream: RTMPStream) {
        // Handle insufficient bandwidth
    }
    
    func connection(_ connection: RTMPConnection, publishSufficientBWOccured stream: RTMPStream) {
        print("ABR: Bandwidth adjustment")
    }
    
    func connection(_ connection: RTMPConnection, updateStats stream: RTMPStream) {
        DispatchQueue.main.async {
            self.fpsLabel.text = String(stream.currentFPS) + " fps"
            self.bitrateLabel.text = String((connection.currentBytesOutPerSecond / 125)) + " kbps"
        }
    }
}

// MARK: - DeviceUtil Extension
extension DeviceUtil {
    static func videoOrientation(by interfaceOrientation: UIInterfaceOrientation) -> AVCaptureVideoOrientation? {
        switch interfaceOrientation {
        case .portrait:
            return .portrait
        case .portraitUpsideDown:
            return .portraitUpsideDown
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        default:
            return nil
        }
    }
}
