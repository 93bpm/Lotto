//
//  HomeController.swift
//  Lotto
//
//  Created by Qtec on 2022/11/28.
//

import UIKit

import SafariServices

import SnapKit
import Then

class HomeController: UIViewController {
    
    var scannerView: ScannerView!
    
    var scrollView: UIScrollView!
    var resultButton: UIButton!
    var qrButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControls()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    @objc
    private func handleResult() {
        
    }
    
    @objc
    private func handleTouchUpQR() {
        setLayer(false)
        UIView.animate(withDuration: 0.1) {
            self.qrButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.qrButton.imageView?.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    @objc
    private func handleTouchDownQR() {
        setLayer(true)
        UIView.animate(withDuration: 0.1) {
            self.qrButton.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            self.qrButton.imageView?.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }
    }
    
    private func setLayer(_ isHidden: Bool) {
        scrollView.layer.removeAllAnimations()
        scannerView.layer.removeAllAnimations()
        
        navigationController?.navigationBar.isHidden = isHidden
        
        UIView.animate(withDuration: 0.3) {
            self.scrollView.alpha = isHidden ? 0 : 1
            self.scannerView.alpha = isHidden ? 1 : 0
        } completion: { _ in
            guard isHidden else {return}
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
}

extension HomeController {
    
    private func setupControls() {
        
        let frame = view.frame
        scannerView = ScannerView(frame: frame).then({ sv in
            sv.delegate = self
            sv.alpha = 0
        })
        
        scrollView = UIScrollView().then({ sv in
            sv.showsVerticalScrollIndicator = false
            sv.bounces = true
            sv.alwaysBounceVertical = true
        })
        
        resultButton = UIButton().then({ b in
            b.layer.shadowColor = UIColor.systemBlue.cgColor
            b.layer.shadowOffset = CGSize(width: 1.5,
                                          height: 1.5)
            b.layer.shadowOpacity = 0.05
            b.layer.shadowRadius = 0.5
            
            b.layer.cornerRadius = 25
            
            b.backgroundColor = .systemBlue
            b.semanticContentAttribute = .forceLeftToRight
            b.setTitle("나의 당첨내역 확인하기", for: .normal)
            b.setTitleColor(.white, for: .normal)
            b.titleLabel?.font = .boldSystemFont(ofSize: 19)
            b.addTarget(
                self,
                action: #selector(handleResult),
                for: .touchUpInside
            )
        })
        
        qrButton = UIButton().then({ b in
            b.adjustsImageWhenHighlighted = false
            b.layer.shadowColor = UIColor.black.cgColor
            b.layer.shadowOffset = CGSize(width: 1, height: 1)
            b.layer.shadowOpacity = 0.3
            b.layer.shadowRadius = 1
            
            b.layer.cornerRadius = 30
            
            b.backgroundColor = .systemBlue
            b.setImage(UIImage(named: "qr"), for: .normal)
            
            b.addTarget(
                self,
                action: #selector(handleTouchUpQR),
                for: .touchUpInside
            )
            
            b.addTarget(
                self,
                action: #selector(handleTouchUpQR),
                for: .touchUpOutside
            )
            
            b.addTarget(
                self,
                action: #selector(handleTouchDownQR),
                for: .touchDown
            )
        })
        
    }
    
    private func setupNavigation() {
        navigationItem.title = "로또"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil
        )
    }
    
    private func setupLayout() {
        view.backgroundColor = .backgroundColor
        
        view.addSubview(scrollView)
        view.addSubview(scannerView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        scannerView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        guard let tabBar = tabBarController?.tabBar else {
            return
        }
        
        tabBar.addSubview(qrButton)
        qrButton.snp.makeConstraints { make in
            make.centerX.equalTo(tabBar.snp.centerX)
            make.bottom.equalTo(tabBar.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
    }
}

extension HomeController: ScannerViewDelegate {
    
    func completion(in status: ScanStatus) {
        switch status {
        case .success(let url):
            guard let url = url, !url.isEmpty else {
                return print("url is empty")
            }
            
            guard let url = URL(string: url) else {
                return print("invalid url:", url)
            }
            
            guard UIApplication.shared.canOpenURL(url) else {
                return print("can not open url")
            }
            
            let safariViewController = SFSafariViewController(url: url)
            safariViewController.modalPresentationStyle = .fullScreen
            safariViewController.modalTransitionStyle = .coverVertical
            
            present(safariViewController, animated: true) {
                self.handleTouchUpQR()
            }
            
        case .fail:
            print("fail to capture")
        case .stop(let status):
            print("button status:", status)
        }
    }
}
