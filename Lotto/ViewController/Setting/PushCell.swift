//
//  PushCell.swift
//  Lotto
//
//  Created by Qtec on 2022/12/01.
//

import UIKit

import SnapKit
import Then

class PushCell: UICollectionViewCell {
    
    static let cellId = "PushCellID"
    
    private(set) var pushView: UIView!
    private(set) var pushLabel: UILabel!
    private(set) var moreButton: UIButton!
    
    private(set) var eventView: UIView!
    private(set) var eventLabel: UILabel!
    private(set) var eventSubLabel: UILabel!
    private(set) var eventSwitch: UISwitch!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupControls()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func handleNotification() {
        
    }
    
    @objc
    private func handleSwitch() {
        
    }
}

extension PushCell {
    
    private func setupControls() {
        pushView = UIView()
        pushView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleNotification)))
        
        pushLabel = UILabel().then({ l in
            l.text = "알림 설정하기"
            l.textAlignment = .left
            l.textColor = .textColor
            l.font = .systemFont(ofSize: 18)
        })
        
        moreButton = UIButton().then({ b in
            b.backgroundColor = .subgroundColor
            b.setTitle("〉", for: .normal)
            b.setTitleColor(.darkGray, for: .normal)
            b.titleLabel?.font = .boldSystemFont(ofSize: 20)
        })
        
        eventView = UIView()
        
        eventLabel = UILabel().then({ l in
            l.text = "이벤트 알림 수신"
            l.textAlignment = .left
            l.textColor = .textColor
            l.font = .systemFont(ofSize: 18)
        })
        
        eventSubLabel = UILabel().then({ l in
            l.text = "다양한 혜택을 확인하실 수 있습니다."
            l.textAlignment = .left
            l.textColor = .lightGray
            l.font = .systemFont(ofSize: 15)
        })
        
        eventSwitch = UISwitch()
        eventSwitch.addTarget(self, action: #selector(handleSwitch), for: .valueChanged)
    }
    
    private func setupLayout() {
        backgroundColor = .subgroundColor
        
        addSubview(pushView)
        addSubview(eventView)
        
        pushView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview()
            make.height.equalTo(65)
        }
        
        eventView.snp.makeConstraints { make in
            make.top.equalTo(pushView.snp.bottom)
            make.left.equalToSuperview().offset(30)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-35)
        }
        
        //
        pushView.addSubview(pushLabel)
        pushView.addSubview(moreButton)
        
        pushLabel.snp.makeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        
        //
        eventView.addSubview(eventLabel)
        eventView.addSubview(eventSubLabel)
        eventView.addSubview(eventSwitch)
        
        eventLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-15)
            make.left.equalToSuperview()
        }
        
        eventSubLabel.snp.makeConstraints { make in
            make.top.equalTo(eventLabel.snp.bottom)
            make.left.equalTo(eventLabel.snp.left)
        }
        
        eventSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(eventLabel.snp.centerY)
            make.right.equalToSuperview()
        }
    }
}
