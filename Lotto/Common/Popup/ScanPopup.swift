//
//  ScanPopup.swift
//  Lotto
//
//  Created by Qtec on 2022/12/01.
//

import UIKit

import SnapKit
import Then

protocol ScanPopupDelegate: AnyObject {
    func didSaveScan(_ qrScan: QRScan)
}

class ScanPopup: UIView {
    
    weak var delegate: ScanPopupDelegate?
    
    private var stackHeight: CGFloat = 0
    
    private let qrScan: QRScan
    
    var baseView: UIView!
    
    var titleView: UIView!
    var roundLabel: UILabel!
    var dateLabel: UILabel!
    
    var numStackView: UIStackView!
    
    var buttonStackView: UIStackView!
    var cancelButton: UIButton!
    var submitButton: UIButton!
    
    init(data qrScan: QRScan) {
        self.qrScan = qrScan
        stackHeight = CGFloat(50 * qrScan.nums.count)
        
        super.init(frame: .zero)
        
        setupControls()
        setupLayout()
        
        initData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initData() {
        roundLabel.text = "111회"
        dateLabel.text = "2022-11-18"
        
        setupNumStackView()
    }
    
    @objc
    private func handleCancel() {
        UIView.animate(withDuration: 0.25) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    @objc
    private func handleSubmit() {
        delegate?.didSaveScan(qrScan)
        handleCancel()
    }
    
    func show() {
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
}

extension ScanPopup {
    
    private func setupControls() {
        
        baseView = UIView().then({ v in
            v.layer.masksToBounds = true
            v.layer.cornerRadius = 15
            v.backgroundColor = .tabBarColor
        })
        
        titleView = UIView().then({ v in
            v.layer.masksToBounds = true
            v.layer.cornerRadius = 12
            v.layer.maskedCorners = [
                .layerMinXMinYCorner, .layerMaxXMinYCorner
            ]
            v.backgroundColor = .subgroundColor
        })
        
        roundLabel = UILabel().then({ l in
            l.textAlignment = .center
            l.textColor = .textColor
            l.font = .boldSystemFont(ofSize: 25)
        })
        
        dateLabel = UILabel().then({ l in
            l.textColor = .lightGray
            l.font = .sandsFont(ofSize: 18)
        })
        
        numStackView = UIStackView().then({ sv in
            sv.axis = .vertical
            sv.distribution = .fillEqually
            sv.spacing = 5
        })
        
        cancelButton = UIButton().then({ b in
            b.layer.masksToBounds = true
            b.layer.maskedCorners = [.layerMinXMaxYCorner]
            b.layer.cornerRadius = 12
            b.layer.borderColor = UIColor.systemBlue.cgColor
            b.layer.borderWidth = 0.5
            b.backgroundColor = .subgroundColor
            b.setTitle("취소", for: .normal)
            b.setTitleColor(.systemBlue, for: .normal)
            b.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        })
        
        submitButton = UIButton().then({ b in
            b.layer.masksToBounds = true
            b.layer.maskedCorners = [.layerMaxXMaxYCorner]
            b.layer.cornerRadius = 12
            b.backgroundColor = .systemBlue
            b.setTitle("저장", for: .normal)
            b.setTitleColor(.white, for: .normal)
            b.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        })
        
        buttonStackView = UIStackView(arrangedSubviews: [cancelButton, submitButton]).then({ sv in
            sv.axis = .horizontal
            sv.distribution = .fillEqually
            sv.spacing = 5
        })
    }
    
    private func setupLayout() {
        guard let window = AppDelegate.keyWindow else {
            return
        }
        
        window.addSubview(self)
        self.frame = window.frame
        self.backgroundColor = UIColor(white: 0.2, alpha: 0.6)
        self.alpha = 0
        
        addSubview(baseView)
        baseView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.height.equalTo(stackHeight + 120)
        }
        
        //
        baseView.addSubview(titleView)
        baseView.addSubview(numStackView)
        baseView.addSubview(buttonStackView)
        
        titleView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.height.equalTo(70)
        }
        
        numStackView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.bottom.equalTo(buttonStackView.snp.top).offset(-8)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-5)
            make.height.equalTo(50)
        }
        
        //
        titleView.addSubview(roundLabel)
        titleView.addSubview(dateLabel)
        
        roundLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().multipliedBy(0.7)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(roundLabel.snp.right).offset(8)
            make.bottom.equalTo(roundLabel.snp.bottom).offset(-3)
        }
    }
    
    private func setupNumStackView() {
        qrScan.nums.enumerated().forEach { i, nums in
            let label = UILabel().then { l in
                l.text = String(UnicodeScalar(65 + i)!)
                l.textAlignment = .center
                l.textColor = .textColor
                l.font = .boldSandsFont(osSize: 17)
            }
            
            var views = [UIView]()
            nums.forEach { num in
                let label = UILabel().then { l in
                    l.text = String(num)
                    l.textAlignment = .center
                    l.textColor = .textColor
                    l.font = .sandsFont(ofSize: 17)
                }

                views.append(label)
            }
            
            let stackView = UIStackView(arrangedSubviews: views).then { sv in
                sv.axis = .horizontal
                sv.distribution = .fillEqually
                sv.spacing = 5
            }
            
            let view = UIView()
            view.backgroundColor = .subgroundColor
            
            view.addSubview(label)
            view.addSubview(stackView)
            
            label.snp.makeConstraints { make in
                make.top.left.bottom.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.15)
            }
            
            stackView.snp.makeConstraints { make in
                make.top.bottom.right.equalToSuperview()
                make.left.equalTo(label.snp.right)
            }
            
            numStackView.addArrangedSubview(view)
        }
    }
}
