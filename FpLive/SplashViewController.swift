//
//  SplashViewController.swift
//  FpLive
//
//  Created by Neha Dereddy on 19/09/25.

import UIKit

class SplashViewController: UIViewController {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "fastpix-logo"))
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLogo()
        setupModernBackground()
    }
    
    private func setupModernBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1.0).cgColor,
            UIColor(red: 0.2, green: 0.1, blue: 0.3, alpha: 1.0).cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupLogo() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),  // Larger size
            logoImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
    }
    
    private func startAnimation() {
        UIView.animate(withDuration: 1.0, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseOut) {
            self.logoImageView.alpha = 1
            self.logoImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        } completion: { _ in
            
            UIView.animate(withDuration: 0.8, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
                self.logoImageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1).rotated(by: .pi / 180 * 5)
            } completion: { _ in
                
                UIView.animate(withDuration: 0.6, delay: 0, options: [.curveEaseInOut, .autoreverse, .repeat]) {
                    self.logoImageView.layer.shadowColor = UIColor.systemGreen.cgColor
                    self.logoImageView.layer.shadowOffset = .zero
                    self.logoImageView.layer.shadowRadius = 30
                    self.logoImageView.layer.shadowOpacity = 0.8
                }
                
                UIView.animate(withDuration: 0.8, delay: 1.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3) {
                    self.logoImageView.alpha = 0
                    self.logoImageView.transform = CGAffineTransform(scaleX: 1.8, y: 1.8).rotated(by: .pi / 180 * 15)
                } completion: { _ in
                    self.showMainApp()
                }
            }
        }
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    private func showMainApp() {
        let mainVC = StreamSetupViewController()
        let navController = UINavigationController(rootViewController: mainVC)
        navController.modalTransitionStyle = .crossDissolve
        navController.modalPresentationStyle = .fullScreen
        self.view.window?.rootViewController = navController
    }
}
