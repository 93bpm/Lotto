//
//  MyNumberHeader.swift
//  Lotto
//
//  Created by Qtec on 2022/11/29.
//

import UIKit

import SnapKit
import Then

protocol MyNumberHeaderDelegate: AnyObject {
    func didTapSection(at section: Int)
}

class MyNumberHeader: UITableViewHeaderFooterView {
    
    static let headerId = "MyNumberHeaderID"
    
    weak var delegate: MyNumberHeaderDelegate?
    
    var section = 0
    var isOpen = false {
        didSet {
            let title = isOpen ? "접기" : "모두보기"
            openButton.setTitle(title, for: .normal)
        }
    }
    
    private(set) var titleLabel: UILabel!
    private(set) var countLabel: UILabel!
    private(set) var dateLabel: UILabel!
    private(set) var openButton: UIButton!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupControls()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        titleLabel.text = "111회"
        countLabel.text = "50장"
        dateLabel.text = "2022-11-18"
    }
    
    private func initData() {
        titleLabel.text = nil
        countLabel.text = nil
        dateLabel.text = nil
    }
    
    private func updateView() {
        
    }
    
    @objc
    private func handleOpen() {
        delegate?.didTapSection(at: section)
    }
}

extension MyNumberHeader {
    
    private func setupControls() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleOpen)))
        
        titleLabel = UILabel().then({ l in
            l.textAlignment = .center
            l.textColor = .textColor
            l.font = .customFont(ofSize: 21, isBold: true)
        })
        
        countLabel = UILabel().then({ l in
            l.layer.masksToBounds = true
            l.layer.cornerRadius = 10
            l.backgroundColor = .systemBlue
            l.textAlignment = .center
            l.textColor = .white
            l.font = .customFont(ofSize: 13)
        })
        
        dateLabel = UILabel().then({ l in
            l.textColor = .lightGray
            l.font = .customFont(ofSize: 15)
        })
        
        openButton = UIButton().then({ b in
            b.backgroundColor = .subgroundColor
            b.setTitle("모두보기", for: .normal)
            b.setTitleColor(.lightGray, for: .normal)
            b.titleLabel?.font = .customFont(ofSize: 13)
            b.isEnabled = false
            b.adjustsImageWhenDisabled = false
        })
    }
    
    private func setupLayout() {
        contentView.backgroundColor = .subgroundColor
        
        addSubview(titleLabel)
        addSubview(countLabel)
        addSubview(dateLabel)
        addSubview(openButton)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(30)
        }
        
        countLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.width.equalTo(60)
            make.height.equalTo(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(7)
            make.left.equalTo(titleLabel.snp.left)
        }
        
        openButton.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.25)
        }
    }
}
