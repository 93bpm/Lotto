//
//  ScannerController.swift
//  Lotto
//
//  Created by Qtec on 2022/11/30.
//

import UIKit

import SnapKit
import Then

protocol ScannerControllerDelegate: AnyObject {
    func didScan(_ qrScan: QRScan)
}

class ScannerController: UIViewController {
    
    weak var delegate: ScannerControllerDelegate?
    
    var scannerView: ScannerView!
    var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControls()
        setupLayout()
    }
    
    @objc
    private func handleCancel() {
        dismiss(animated: true)
    }
}

extension ScannerController {
    
    private func setupControls() {
        scannerView = ScannerView()
        scannerView.delegate = self
        
        cancelButton = UIButton().then({ b in
            b.layer.masksToBounds = true
            b.layer.cornerRadius = 20
            b.backgroundColor = .systemBlue
            b.setTitle("닫기", for: .normal)
            b.setTitleColor(.white, for: .normal)
            b.titleLabel?.font = .boldSystemFont(ofSize: 20)
            b.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        })
    }
    
    private func setupLayout() {
        view.addSubview(scannerView)
        view.addSubview(cancelButton)
        
        scannerView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-100)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
    }
}

extension ScannerController: ScannerViewDelegate {
    
    //http://m.dhlottery.co.kr/?v=0950q091125283342q091014173537q041723323741q232635384145q1112131732431426094184
    /*
     round: 950
     1    : 09 11 25 28 33 42
     2    : 09 10 14 17 35 37
     3    : 04 17 23 32 37 41
     4    : 23 26 35 38 41 45
     5    : 11 12 13 17 32 43
     */
    func completion(in status: ScanStatus) {
        switch status {
        case .success(let url):
            guard let url = url, !url.isEmpty else {
                showToast(message: "잘못된 URL입니다.")
                return
            }
            
            if let qrScan = QRScan(from: url) {
                delegate?.didScan(qrScan)
                dismiss(animated: true)
            } else {
                showToast(message: "로또용지를 스캔해주세요")
            }
        case .fail:
            print("fail to capture")
        case .stop(let status):
            print("button status:", status)
        }
    }
}
