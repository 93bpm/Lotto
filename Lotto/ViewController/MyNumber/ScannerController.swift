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
    func didScanNumber(_ number: [Int])
}

class ScannerController: UIViewController {
    
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
                return print("url is empty")
            }
            
            var components = url.components(separatedBy: "q")
            if let round = components[0].components(separatedBy: "v=").last {
                print("round:", Int(round) ?? 0)
                components.removeFirst()
            }
            
            var nums = [[Int]]()
            for component in components {
                var value = component
                
                var num = [Int]()
                for _ in 0...5 {
                    let r = value.index(value.startIndex, offsetBy: 2)
                    if let no = Int(value[value.startIndex..<r]) {
                        value = String(value[r..<value.endIndex])
                        num.append(no)
                    }
                }
                
                print(num)
                nums.append(num)
            }
            
            print(nums)
            //TODO: 스캔 후 뒤로간 다음 등록번호 팝업창 띄우기
        case .fail:
            print("fail to capture")
        case .stop(let status):
            print("button status:", status)
        }
    }
}
