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
            let title = isOpen ? "접기" : "더보기"
            openButton.setTitle(title, for: .normal)
        }
    }
    
    private(set) var roundLabel: UILabel!
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

        roundLabel.text = "111회"
        countLabel.text = "50장"
        dateLabel.text = "2022-11-18"
    }
    
    private func initData() {
        roundLabel.text = nil
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
        
        roundLabel = UILabel().then({ l in
            l.textAlignment = .center
            l.textColor = .textColor
            l.font = .boldSystemFont(ofSize: 22)
        })
        
        countLabel = UILabel().then({ l in
            l.layer.masksToBounds = true
            l.layer.cornerRadius = 10
            l.backgroundColor = .systemBlue
            l.textAlignment = .center
            l.textColor = .white
            l.font = .sandsFont(ofSize: 13)
        })
        
        dateLabel = UILabel().then({ l in
            l.textColor = .lightGray
            l.font = .sandsFont(ofSize: 15)
        })
        
        openButton = UIButton().then({ b in
            b.backgroundColor = .subgroundColor
            b.setTitle("더보기", for: .normal)
            b.setTitleColor(.lightGray, for: .normal)
            b.titleLabel?.font = .systemFont(ofSize: 14)
            b.isEnabled = false
            b.adjustsImageWhenDisabled = false
        })
    }
    
    private func setupLayout() {
        contentView.backgroundColor = .subgroundColor
        
        addSubview(roundLabel)
        addSubview(countLabel)
        addSubview(dateLabel)
        addSubview(openButton)
        
        roundLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(30)
        }
        
        countLabel.snp.makeConstraints { make in
            make.centerY.equalTo(roundLabel.snp.centerY)
            make.left.equalTo(roundLabel.snp.right).offset(10)
            make.width.equalTo(60)
            make.height.equalTo(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(roundLabel.snp.bottom).offset(7)
            make.left.equalTo(roundLabel.snp.left)
        }
        
        openButton.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.25)
        }
    }
}
