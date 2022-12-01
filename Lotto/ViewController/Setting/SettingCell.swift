//
//  SettingCell.swift
//  Lotto
//
//  Created by Qtec on 2022/12/01.
//

import UIKit

import SnapKit
import Then

class SettingCell: UICollectionViewCell {
    
    static let cellId = "SettingCellID"
    
    var type: SettingCollection.SettingType? {
        willSet {
            initData()
        }
        
        didSet {
            guard let type = type else {return}
            updateView(type)
        }
    }
    
    private(set) var imageView: UIImageView!
    private(set) var titleLabel: UILabel!
    private(set) var moreButton: UIButton!
    private(set) var versionLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupControls()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initData() {
        imageView.image = nil
        titleLabel.text = nil
    }
    
    private func updateView(_ type: SettingCollection.SettingType) {
        imageView.image = type.image
        titleLabel.text = type.title
        
        if type == .version {
            moreButton.isHidden = true
            versionLabel.isHidden = false
            
            if
                let info = Bundle.main.infoDictionary,
                let versionString = info["CFBundleShortVersionString"] as? String {
                versionLabel.text = versionString
            }
        } else {
            moreButton.isHidden = false
            versionLabel.isHidden = true
        }
    }
}

extension SettingCell {
    
    private func setupControls() {
        imageView = UIImageView().then({ iv in
            iv.layer.masksToBounds = true
            iv.contentMode = .scaleAspectFit
        })
        
        titleLabel = UILabel().then({ l in
            l.textAlignment = .left
            l.textColor = .textColor
            l.font = .systemFont(ofSize: 18)
        })
        
        moreButton = UIButton().then({ b in
            b.isUserInteractionEnabled = false
            b.backgroundColor = .subgroundColor
            b.setTitle("〉", for: .normal)
            b.setTitleColor(.darkGray, for: .normal)
            b.titleLabel?.font = .boldSystemFont(ofSize: 20)
        })
        
        versionLabel = UILabel().then({ l in
            l.textAlignment = .right
            l.textColor = .textColor
            l.font = .sandsFont(ofSize: 17)
        })
    }
    
    private func setupLayout() {
        backgroundColor = .subgroundColor
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(moreButton)
        addSubview(versionLabel)
        
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(35)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(imageView.snp.right).offset(10)
        }
        
        moreButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        
        versionLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-35)
        }
    }
}
