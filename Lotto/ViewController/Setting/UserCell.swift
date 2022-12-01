//
//  UserCell.swift
//  Lotto
//
//  Created by Qtec on 2022/12/01.
//

import UIKit

import SnapKit
import Then

protocol UserCellDelegate: AnyObject {
    func didTapProfile(_ isAnonymous: Bool)
    func didTapLogin()
}

class UserCell: UICollectionViewCell {
    
    static let cellId = "UserCellID"
    
    weak var delegate: UserCellDelegate?
    
    private(set) var profileIV: UIImageView!
    private(set) var nameLabel: UILabel!
    private(set) var subLabel: UILabel!
    private(set) var moreButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupControls()
        setupLayout()
        
        initData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initData() {
        nameLabel.text = "게스트"
        subLabel.text = "로그인 후 이용할 수 있어요"
    }
    
    @objc
    private func handleProfile() {
        delegate?.didTapProfile(true)
    }
    
    @objc
    private func handleLogin() {
        delegate?.didTapLogin()
    }
}

extension UserCell {
    
    private func setupNotifications() {
        
    }
    
    private func setupControls() {
        profileIV = UIImageView().then({ iv in
            iv.layer.masksToBounds = true
            iv.layer.cornerRadius = 40
            iv.backgroundColor = .backgroundColor
            iv.contentMode = .scaleAspectFit
            iv.image = UIImage(named: "user_profile")
            iv.isUserInteractionEnabled = true
            iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleProfile)))
        })
        
        nameLabel = UILabel().then({ l in
            l.textAlignment = .left
            l.textColor = .textColor
            l.font = .systemFont(ofSize: 20)
        })
        
        subLabel = UILabel().then({ l in
            l.textAlignment = .left
            l.textColor = .lightGray
            l.font = .systemFont(ofSize: 16)
        })
        
        moreButton = UIButton().then({ b in
            b.isUserInteractionEnabled = false
            b.setTitle("〉", for: .normal)
            b.setTitleColor(.darkGray, for: .normal)
            b.titleLabel?.font = .boldSystemFont(ofSize: 20)
        })
    }
    
    private func setupLayout() {
        backgroundColor = .subgroundColor
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleLogin)))
        
        addSubview(profileIV)
        addSubview(nameLabel)
        addSubview(subLabel)
        addSubview(moreButton)
        
        profileIV.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(25)
            make.width.height.equalTo(80)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-10)
            make.left.equalTo(profileIV.snp.right).offset(20)
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalTo(nameLabel.snp.left)
        }
        
        moreButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
    }
}
