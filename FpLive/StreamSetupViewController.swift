//
//  StreamSetupViewController.swift
//  FpLive
//
//  Created by Neha Dereddy on 19/09/25.
//

import Foundation
import UIKit
import Loaf

class StreamSetupViewController: UIViewController, UITextFieldDelegate {
    
    private var titleLabel: UILabel!
    private var subtitleLabel: UILabel!
    private var qualityLabel: UILabel!
    private var streamKeyLabel: UILabel!
    private var logoImageView: UIImageView!
    private var topSection: UIView!
    private var middleSection: UIView!
    private var bottomSection: UIView!
    private var streamKeyTextBox: UITextField!
    private var presetSelector: UISegmentedControl!
    private var startCameraButton: UIButton!
    private var portraitConstraints: [NSLayoutConstraint] = []
    private var landscapeConstraints: [NSLayoutConstraint] = []
    
    let defaultStreamKey = ""
    var streamKey = ""
    
    var segmentedPresets = [LiveStreamViewController.Preset.hd_1080p_30fps_5mbps,
                            LiveStreamViewController.Preset.hd_720p_30fps_3mbps,
                            LiveStreamViewController.Preset.sd_540p_30fps_2mbps,
                            LiveStreamViewController.Preset.sd_360p_30fps_1mbps]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFullScreenBackground()
        setupFullScreenUI()
        setupConstraints()
        setupDelegates()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orientationDidChange),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateButtonGradient()
        updateBackgroundGradient()
    }
    
    @objc private func orientationDidChange() {
        DispatchQueue.main.async {
            self.updateConstraintsForCurrentOrientation()
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - Orientation-Adaptive Background
    private func setupFullScreenBackground() {
        updateBackgroundGradient()
        addPatternOverlay()
    }
    
    private func updateBackgroundGradient() {
        view.layer.sublayers?.removeAll { $0 is CAGradientLayer }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1.0).cgColor,
            UIColor(red: 0.2, green: 0.1, blue: 0.3, alpha: 1.0).cgColor,
            UIColor(red: 0.1, green: 0.2, blue: 0.4, alpha: 1.0).cgColor
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        
        if UIDevice.current.orientation.isLandscape {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        }
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func addPatternOverlay() {
        view.subviews.filter { $0.backgroundColor == UIColor.white.withAlphaComponent(0.05) }.forEach { $0.removeFromSuperview() }
        let particleCount = UIDevice.current.orientation.isLandscape ? 15 : 20
        
        for i in 0..<particleCount {
            let particle = UIView()
            particle.backgroundColor = UIColor.white.withAlphaComponent(0.05)
            let size = CGFloat.random(in: 15...60)
            particle.layer.cornerRadius = size / 2
            particle.frame = CGRect(
                x: CGFloat.random(in: -50...view.frame.width + 50),
                y: CGFloat.random(in: -50...view.frame.height + 50),
                width: size,
                height: size
            )
            
            view.addSubview(particle)
            animateParticle(particle, delay: Double(i) * 0.2)
        }
    }
    
    private func animateParticle(_ particle: UIView, delay: Double) {
        UIView.animate(withDuration: Double.random(in: 12...20), delay: delay, options: [.repeat, .autoreverse, .curveEaseInOut]) {
            let moveX = UIDevice.current.orientation.isLandscape ? CGFloat.random(in: -150...150) : CGFloat.random(in: -100...100)
            let moveY = UIDevice.current.orientation.isLandscape ? CGFloat.random(in: -100...100) : CGFloat.random(in: -200...200)
            particle.transform = CGAffineTransform(translationX: moveX, y: moveY)
            particle.alpha = CGFloat.random(in: 0.02...0.06)
        }
    }
    
    private func setupFullScreenUI() {
        createSectionViews()
        createTopSection()
        createMiddleSection()
        createBottomSection()
    }
    
    private func createSectionViews() {
        topSection = UIView()
        topSection.backgroundColor = UIColor.clear
        topSection.translatesAutoresizingMaskIntoConstraints = false
        middleSection = UIView()
        middleSection.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        middleSection.layer.cornerRadius = 0
        addBlurEffect(to: middleSection)
        middleSection.translatesAutoresizingMaskIntoConstraints = false
        
        bottomSection = UIView()
        bottomSection.backgroundColor = UIColor.clear
        bottomSection.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(topSection)
        view.addSubview(middleSection)
        view.addSubview(bottomSection)
    }
    
    private func addBlurEffect(to view: UIView) {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.alpha = 0.8
        
        view.addSubview(blurView)
        view.sendSubviewToBack(blurView)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func createTopSection() {
        let logoBackground = UIView()
        logoBackground.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.15)
        logoBackground.layer.cornerRadius = 25
        logoBackground.translatesAutoresizingMaskIntoConstraints = false
        
        logoImageView = UIImageView()
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let config = UIImage.SymbolConfiguration(pointSize: 35, weight: .medium)
        logoImageView.image = UIImage(systemName: "video.fill", withConfiguration: config)?
            .withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        
        // Responsive title
        titleLabel = UILabel()
        titleLabel.text = "FastPix Studio"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.6
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        subtitleLabel = UILabel()
        subtitleLabel.text = "Professional Live Streaming Platform"
        subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.minimumScaleFactor = 0.7
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        logoBackground.addSubview(logoImageView)
        topSection.addSubview(logoBackground)
        topSection.addSubview(titleLabel)
        topSection.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            logoBackground.centerXAnchor.constraint(equalTo: topSection.centerXAnchor),
            logoBackground.topAnchor.constraint(equalTo: topSection.topAnchor, constant: 15),
            logoBackground.widthAnchor.constraint(equalToConstant: 80),
            logoBackground.heightAnchor.constraint(equalToConstant: 80),
            
            logoImageView.centerXAnchor.constraint(equalTo: logoBackground.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: logoBackground.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 40),
            logoImageView.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.topAnchor.constraint(equalTo: logoBackground.bottomAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: topSection.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: topSection.trailingAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            subtitleLabel.leadingAnchor.constraint(equalTo: topSection.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: topSection.trailingAnchor, constant: -20)
        ])
    }
    
    private func createMiddleSection() {
        streamKeyLabel = UILabel()
        streamKeyLabel.text = "🔑 STREAM CONFIGURATION"
        streamKeyLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        streamKeyLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        streamKeyLabel.textAlignment = .center
        streamKeyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        streamKeyTextBox = UITextField()
        streamKeyTextBox.placeholder = "Enter your stream key here"
        streamKeyTextBox.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        streamKeyTextBox.textColor = .white
        streamKeyTextBox.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        streamKeyTextBox.layer.cornerRadius = 15
        streamKeyTextBox.layer.borderWidth = 2
        streamKeyTextBox.layer.borderColor = UIColor.systemGreen.withAlphaComponent(0.6).cgColor  // Green border for emphasis
        streamKeyTextBox.borderStyle = .none
        streamKeyTextBox.textAlignment = .center
        streamKeyTextBox.translatesAutoresizingMaskIntoConstraints = false
        
        streamKeyTextBox.attributedPlaceholder = NSAttributedString(
            string: "Enter your stream key here",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.6),
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)
            ]
        )
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 50))
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 50))
        streamKeyTextBox.leftView = leftPaddingView
        streamKeyTextBox.leftViewMode = .always
        streamKeyTextBox.rightView = rightPaddingView
        streamKeyTextBox.rightViewMode = .always
        
        qualityLabel = UILabel()
        qualityLabel.text = "📺 VIDEO QUALITY SETTINGS"
        qualityLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        qualityLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        qualityLabel.textAlignment = .center
        qualityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let titles = ["1080p", "720p", "540p", "360p"]
        presetSelector = UISegmentedControl(items: titles)
        presetSelector.selectedSegmentIndex = 1
        presetSelector.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        presetSelector.selectedSegmentTintColor = .systemGreen
        presetSelector.layer.cornerRadius = 12
        presetSelector.layer.borderWidth = 1
        presetSelector.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        presetSelector.translatesAutoresizingMaskIntoConstraints = false
        
        presetSelector.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.7),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold)
        ], for: .normal)
        
        presetSelector.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold)
        ], for: .selected)
        
        middleSection.addSubview(streamKeyLabel)
        middleSection.addSubview(streamKeyTextBox)
        middleSection.addSubview(qualityLabel)
        middleSection.addSubview(presetSelector)
        
        NSLayoutConstraint.activate([
            streamKeyLabel.topAnchor.constraint(equalTo: middleSection.topAnchor, constant: 20),
            streamKeyLabel.leadingAnchor.constraint(equalTo: middleSection.leadingAnchor, constant: 20),
            streamKeyLabel.trailingAnchor.constraint(equalTo: middleSection.trailingAnchor, constant: -20),
            
            streamKeyTextBox.topAnchor.constraint(equalTo: streamKeyLabel.bottomAnchor, constant: 15),
            streamKeyTextBox.leadingAnchor.constraint(equalTo: middleSection.leadingAnchor, constant: 20),
            streamKeyTextBox.trailingAnchor.constraint(equalTo: middleSection.trailingAnchor, constant: -20),
            streamKeyTextBox.heightAnchor.constraint(equalToConstant: 55),
            
            qualityLabel.topAnchor.constraint(equalTo: streamKeyTextBox.bottomAnchor, constant: 25),
            qualityLabel.leadingAnchor.constraint(equalTo: middleSection.leadingAnchor, constant: 20),
            qualityLabel.trailingAnchor.constraint(equalTo: middleSection.trailingAnchor, constant: -20),
            
            presetSelector.topAnchor.constraint(equalTo: qualityLabel.bottomAnchor, constant: 15),
            presetSelector.leadingAnchor.constraint(equalTo: middleSection.leadingAnchor, constant: 20),
            presetSelector.trailingAnchor.constraint(equalTo: middleSection.trailingAnchor, constant: -20),
            presetSelector.heightAnchor.constraint(equalToConstant: 44),
            presetSelector.bottomAnchor.constraint(equalTo: middleSection.bottomAnchor, constant: -20)
        ])
    }
    
    private func createBottomSection() {
        startCameraButton = UIButton(type: .system)
        startCameraButton.setTitle("START", for: .normal)
        startCameraButton.titleLabel?.numberOfLines = 0
        startCameraButton.setTitleColor(.white, for: .normal)
        startCameraButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        startCameraButton.backgroundColor = .systemGreen
        startCameraButton.layer.cornerRadius = 22
        startCameraButton.translatesAutoresizingMaskIntoConstraints = false
        
        startCameraButton.layer.shadowColor = UIColor.systemGreen.cgColor
        startCameraButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        startCameraButton.layer.shadowRadius = 15
        startCameraButton.layer.shadowOpacity = 0.5
        
        startCameraButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        startCameraButton.addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        startCameraButton.addTarget(self, action: #selector(startCamera(_:)), for: .touchUpInside)
        
        bottomSection.addSubview(startCameraButton)
        
        NSLayoutConstraint.activate([
            startCameraButton.centerXAnchor.constraint(equalTo: bottomSection.centerXAnchor),
            startCameraButton.centerYAnchor.constraint(equalTo: bottomSection.centerYAnchor),
            startCameraButton.leadingAnchor.constraint(equalTo: bottomSection.leadingAnchor, constant: 30),
            startCameraButton.trailingAnchor.constraint(equalTo: bottomSection.trailingAnchor, constant: -30),
            startCameraButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func updateButtonGradient() {
        DispatchQueue.main.async {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.startCameraButton.bounds
            gradientLayer.colors = [
                UIColor.systemGreen.cgColor,
                UIColor.systemBlue.cgColor,
                UIColor.systemPurple.cgColor
            ]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            gradientLayer.cornerRadius = 22
            
            self.startCameraButton.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
            self.startCameraButton.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    // MARK: - BOTH Portrait AND Landscape Constraints with CENTERED POSITIONING
    private func setupConstraints() {
        portraitConstraints = [
            topSection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            topSection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topSection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topSection.heightAnchor.constraint(equalToConstant: 220),
            
            middleSection.topAnchor.constraint(equalTo: topSection.bottomAnchor, constant: 20),
            middleSection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            middleSection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            middleSection.heightAnchor.constraint(equalToConstant: 260),
            
            bottomSection.topAnchor.constraint(equalTo: middleSection.bottomAnchor, constant: 20),
            bottomSection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSection.heightAnchor.constraint(equalToConstant: 100),
            
        ]
        
        landscapeConstraints = [
            topSection.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            topSection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            topSection.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.32),
            topSection.heightAnchor.constraint(equalToConstant: 280),
            
            middleSection.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            middleSection.leadingAnchor.constraint(equalTo: topSection.trailingAnchor, constant: 20),
            middleSection.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.38),
            middleSection.heightAnchor.constraint(equalToConstant: 280),
            
            bottomSection.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            bottomSection.leadingAnchor.constraint(equalTo: middleSection.trailingAnchor, constant: 20),
            bottomSection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            bottomSection.heightAnchor.constraint(equalToConstant: 280)
        ]
        
        updateConstraintsForCurrentOrientation()
    }
    
    private func updateConstraintsForCurrentOrientation() {
        let isLandscape = view.bounds.width > view.bounds.height
        
        NSLayoutConstraint.deactivate(portraitConstraints)
        NSLayoutConstraint.deactivate(landscapeConstraints)
        
        if isLandscape {
            NSLayoutConstraint.activate(landscapeConstraints)
            titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold) // Slightly smaller for centered layout
            subtitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            startCameraButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            
            middleSection.layer.cornerRadius = 20
            
        } else {
            NSLayoutConstraint.activate(portraitConstraints)
            titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
            subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            startCameraButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            middleSection.layer.cornerRadius = 0
        }
    }
    
    private func setupDelegates() {
        streamKeyTextBox.delegate = self
    }
    
    // MARK: - Animations
    @objc private func buttonTouchDown() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
        
        UIView.animate(withDuration: 0.15) {
            self.startCameraButton.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
        }
    }
    
    @objc private func buttonTouchUp() {
        UIView.animate(withDuration: 0.2) {
            self.startCameraButton.transform = CGAffineTransform.identity
        }
    }
    
    // MARK: - Existing functionality (unchanged)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is LiveStreamViewController {
            let vc = segue.destination as? LiveStreamViewController
            vc?.streamKey = streamKey
            vc?.preset = segmentedPresets[presetSelector.selectedSegmentIndex]
        }
    }
    
    @objc func startCamera(_ sender: Any) {
        let enteredKey = streamKeyTextBox.text ?? ""
        
        if enteredKey.isEmpty && !defaultStreamKey.isEmpty {
            streamKey = defaultStreamKey
        } else if !enteredKey.isEmpty {
            streamKey = enteredKey
        } else {
            Loaf("Please Enter a Stream Key!", state: Loaf.State.warning, location: .top, sender: self).show(.short)
            return
        }
        
        let broadcastVC = LiveStreamViewController()
        broadcastVC.streamKey = streamKey
        broadcastVC.preset = segmentedPresets[presetSelector.selectedSegmentIndex]
        broadcastVC.modalPresentationStyle = .fullScreen
        broadcastVC.modalTransitionStyle = .crossDissolve
        
        present(broadcastVC, animated: true) {
            print("Successfully presented BroadcastViewController")
        }
    }
}

extension StreamSetupViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        topSection.alpha = 0
        middleSection.alpha = 0
        bottomSection.alpha = 0
        
        topSection.transform = CGAffineTransform(translationX: -100, y: 0)
        middleSection.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        bottomSection.transform = CGAffineTransform(translationX: 100, y: 0)
        
        UIView.animate(withDuration: 0.8, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            self.topSection.alpha = 1
            self.topSection.transform = CGAffineTransform.identity
        }
        
        UIView.animate(withDuration: 0.8, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            self.middleSection.alpha = 1
            self.middleSection.transform = CGAffineTransform.identity
        }
        
        UIView.animate(withDuration: 0.8, delay: 0.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            self.bottomSection.alpha = 1
            self.bottomSection.transform = CGAffineTransform.identity
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
