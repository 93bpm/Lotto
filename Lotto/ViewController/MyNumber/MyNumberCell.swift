//
//  MyNumberCell.swift
//  Lotto
//
//  Created by Qtec on 2022/11/29.
//

import UIKit

import SnapKit
import Then

class MyNumberCell: UITableViewCell {
    
    static let cellId = "MyNumberCellID"
    
    private(set) var rankLabel: UILabel!
    private(set) var typeLabel: UILabel!
    private(set) var stackView: UIStackView!
    private(set) var no1Label: UILabel!
    private(set) var no2Label: UILabel!
    private(set) var no3Label: UILabel!
    private(set) var no4Label: UILabel!
    private(set) var no5Label: UILabel!
    private(set) var no6Label: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupControls()
        setupLayout()
        
        typeLabel.text = "수동"
        no1Label.text = "1"
        no2Label.text = "2"
        no3Label.text = "3"
        no4Label.text = "4"
        no5Label.text = "5"
        no6Label.text = "6"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initData() {
        
    }
    
    private func updateView() {
        
    }
}

extension MyNumberCell {
    
    private func setupControls() {
        rankLabel = setupLabel(isBold: true)
        typeLabel = setupLabel(isBold: true)
        no1Label = setupLabel()
        no2Label = setupLabel()
        no3Label = setupLabel()
        no4Label = setupLabel()
        no5Label = setupLabel()
        no6Label = setupLabel()
        
        let views: [UIView] = [no1Label, no2Label, no3Label, no4Label, no5Label, no6Label]
        stackView = UIStackView(arrangedSubviews: views).then({ sv in
            sv.axis = .horizontal
            sv.distribution = .fillEqually
            sv.spacing = 15
        })
    }
    
    private func setupLabel(isBold: Bool = false) -> UILabel {
        return UILabel().then { l in
            l.textAlignment = .center
            l.textColor = .textColor
            l.font = isBold ? .boldSystemFont(ofSize: 16) : .systemFont(ofSize: 16)
        }
    }
    
    private func setupLayout() {
        backgroundColor = .subgroundColor
        
        addSubview(typeLabel)
        addSubview(stackView)
        
        typeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.2)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(typeLabel.snp.right)
            make.right.equalToSuperview().offset(-20)
        }
        
    }
}
