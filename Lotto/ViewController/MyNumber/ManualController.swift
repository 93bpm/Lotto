//
//  ManualController.swift
//  Lotto
//
//  Created by Qtec on 2022/11/30.
//

import UIKit

import SnapKit
import Then

protocol ManualControllerDelegate: AnyObject {
    func didSaveNumber(_ number: [Int])
}

class ManualController: UIViewController {
    
    weak var delegate: ManualControllerDelegate?
    
    private var selectedNums = [Int]()

    var cancelButton: UIButton!
    
    var roundLabel: UILabel!
    var dateLabel: UILabel!
    var buttonStackView: UIStackView!
    var resetButton: UIButton!
    var randomButton: UIButton!
    
    var numView: UIView!
    var numStackView: UIStackView!
    var noDataLabel: UILabel!
    
    var choiceStackView: UIStackView!
    
    var saveButton: UIButton!
    var bottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControls()
        setupNavigation()
        setupLayout()
        
        initData()
    }
    
    private func initData() {
        roundLabel.text = "1111회"
        dateLabel.text = "2022-11-18"
    }
    
    @objc
    private func handleBall(_ sender: UIButton) {
        switch sender.backgroundColor {
        case UIColor.subgroundColor: //unselect → select
            guard selectedNums.count < 6 else {
                return
            }
            sender.didSelected(true)
            sender.titleLabel?.font = .customFont(ofSize: 20, isBold: true)
            
            selectedNums.append(sender.tag)
        default: //select → unselect
            guard let index = selectedNums.firstIndex(of: sender.tag) else {
                break
            }
            sender.didSelected(false)
            sender.titleLabel?.font = .customFont(ofSize: 20)
            
            selectedNums.remove(at: index)
        }
        
        setNumbers()
    }
    
    @objc
    private func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc
    private func handleReset() {
        guard !selectedNums.isEmpty else {return}
        selectedNums.removeAll()
        
        choiceStackView.subviews.forEach { view in
            guard let sv = view as? UIStackView else {
                return
            }
            
            sv.subviews.forEach { view in
                guard let button = view as? UIButton else {
                    return
                }
                
                button.didSelected(false)
            }
        }
        
        setNumbers()
    }
    
    @objc
    private func handleRandom() {
        selectedNums.removeAll()
        
        while true {
            let rand = Int.random(in: 1...45)
            if !selectedNums.contains(rand) {
                selectedNums.append(rand)
                
                if selectedNums.count == 6 {
                    break
                }
            }
        }
        
        choiceStackView.subviews.forEach { view in
            guard let sv = view as? UIStackView else {
                return
            }
            
            sv.subviews.forEach { view in
                guard let button = view as? UIButton else {
                    return
                }
                
                if selectedNums.contains(button.tag) {
                    button.didSelected(true)
                    button.titleLabel?.font = .customFont(ofSize: 20, isBold: true)
                } else {
                    button.didSelected(false)
                    button.titleLabel?.font = .customFont(ofSize: 20)
                }
            }
        }
        
        setNumbers()
    }
    
    @objc
    private func handleSave() {
        guard selectedNums.count == 6 else {return}
        delegate?.didSaveNumber(selectedNums)
    }
    
    private func setNumbers() {
        guard !selectedNums.isEmpty else {
            numStackView.isHidden = true
            noDataLabel.isHidden = false
            return
        }
        
        numStackView.isHidden = false
        noDataLabel.isHidden = true
        
        selectedNums.sort()
        numStackView.subviews.enumerated().forEach { i, view in
            guard let label = view as? UILabel else {
                return
            }
            
            if i < selectedNums.count {
                label.setBallInfo(selectedNums[i])
            } else {
                label.text = nil
                label.backgroundColor = .clear
            }
            
            label.layer.cornerRadius = label.frame.width / 2
        }
    }
}

extension ManualController {

    private func setupNavigation() {
        navigationItem.title = "직접입력"
        
        cancelButton.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(35)
        }
        
        let cancel = UIBarButtonItem(customView: cancelButton)
        navigationItem.rightBarButtonItem = cancel
    }
    
    private func setupControls() {
        
        roundLabel = UILabel().then({ l in
            l.textAlignment = .center
            l.textColor = .textColor
            l.font = .boldSystemFont(ofSize: 30)
        })
        
        dateLabel = UILabel().then({ l in
            l.textAlignment = .left
            l.textColor = .lightGray
            l.font = .systemFont(ofSize: 23)
        })
        
        resetButton = UIButton().then({ b in
            b.layer.masksToBounds = true
            b.layer.cornerRadius = 17.5
            b.backgroundColor = .systemBlue
            b.setTitle("초기화", for: .normal)
            b.setTitleColor(.white, for: .normal)
            b.titleLabel?.font = .boldSystemFont(ofSize: 16)
            b.addTarget(self, action: #selector(handleReset), for: .touchUpInside)
        })
        
        randomButton = UIButton().then({ b in
            b.layer.masksToBounds = true
            b.layer.cornerRadius = 17.5
            b.backgroundColor = .systemBlue
            b.setTitle("랜덤생성", for: .normal)
            b.setTitleColor(.white, for: .normal)
            b.titleLabel?.font = .boldSystemFont(ofSize: 16)
            b.addTarget(self, action: #selector(handleRandom), for: .touchUpInside)
        })
        
        buttonStackView = UIStackView(arrangedSubviews: [resetButton, randomButton]).then({ sv in
            sv.axis = .horizontal
            sv.distribution = .fillEqually
            sv.spacing = 10
        })
        
        numView = UIView().then({ v in
            v.layer.masksToBounds = true
            v.layer.cornerRadius = 20
            v.backgroundColor = .subgroundColor
        })
        
        numStackView = setupNumStackView()
        numStackView.isHidden = true
        
        noDataLabel = UILabel().then({ l in
            l.text = "번호를 선택해주세요"
            l.textAlignment = .center
            l.textColor = .systemGray2
            l.font = .systemFont(ofSize: 18)
        })
        
        choiceStackView = setupChoiceStackView()
        
        cancelButton = UIButton().then({ b in
            b.setImage(UIImage.drawX(), for: .normal)
            b.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        })
        
        saveButton = UIButton().then({ b in
            b.backgroundColor = .systemBlue
            b.setTitle("저장하기", for: .normal)
            b.setTitleColor(.white, for: .normal)
            b.titleLabel?.font = .boldSystemFont(ofSize: 20)
            b.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        })
        
        bottomView = UIView()
        bottomView.backgroundColor = .systemBlue
    }
    
    private func setupLayout() {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 40
        view.layer.maskedCorners = [
            .layerMinXMinYCorner, .layerMaxXMinYCorner
        ]

        view.backgroundColor = .backgroundColor
        
        view.addSubview(roundLabel)
        view.addSubview(dateLabel)
        view.addSubview(buttonStackView)
        view.addSubview(numView)
        view.addSubview(choiceStackView)
        view.addSubview(saveButton)
        view.addSubview(bottomView)
        
        roundLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.left.equalToSuperview().offset(35)
            make.height.equalTo(25)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(roundLabel.snp.bottom).offset(8)
            make.left.equalTo(roundLabel.snp.left)
            make.height.equalTo(20)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.centerY.equalTo(roundLabel.snp.bottom)
            make.right.equalToSuperview().offset(-25)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(35)
        }
        
        numView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(75)
        }
        
        choiceStackView.snp.makeConstraints { make in
            make.top.equalTo(numView.snp.bottom).offset(25)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.bottom.equalTo(saveButton.snp.top).offset(-30)
        }
        
        saveButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(saveButton.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
        
        //
        numView.addSubview(numStackView)
        numView.addSubview(noDataLabel)
        
        numStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        setRadius()
        
        noDataLabel.snp.makeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
    
    private func setRadius() {
        numStackView.layoutIfNeeded()
        
        let width = Int(numStackView.frame.width / CGFloat(numStackView.subviews.count) - numStackView.spacing)
        
        
        numStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(width)
        }
        
        numStackView.subviews.forEach { view in
            guard let label = view as? UILabel else {
                return
            }
            
            label.layer.cornerRadius = CGFloat(width / 2)
        }
    }
    
    private func setupNumStackView() -> UIStackView {
        return UIStackView().then { sv in
            
            for _ in 0...5 {
                let label = setupBallLabel()
                sv.addArrangedSubview(label)
            }
            
            sv.axis = .horizontal
            sv.distribution = .fillEqually
            sv.spacing = 10
        }
    }
    
    private func setupBallLabel() -> UILabel {
        return UILabel().then { l in
            l.layer.masksToBounds = true
            l.adjustsFontSizeToFitWidth = true
            l.textAlignment = .center
            l.textColor = .white
            l.font = .customFont(ofSize: 19, isBold: true)
        }
    }
    
    private func setupChoiceStackView() -> UIStackView {
        return UIStackView().then { sv in
            
            for i in 0...8 { //y
                
                let xStack = UIStackView().then { sv in
                    for j in 1...5 { //x
                        let tag = (i * 5) + j
                        
                        let button = setupBallButton(tag)
                        sv.addArrangedSubview(button)
                    }
                    
                    sv.axis = .horizontal
                    sv.distribution = .fillEqually
                    sv.spacing = 8
                }
                
                sv.addArrangedSubview(xStack)
            }
            
            sv.axis = .vertical
            sv.distribution = .fillEqually
            sv.spacing = 8
        }
    }
    
    private func setupBallButton(_ tag: Int) -> UIButton {
        return UIButton(type: .system).then { b in
            b.layer.masksToBounds = true
            b.layer.borderColor = UIColor.systemGray3.cgColor
            b.layer.borderWidth = 0.1
            b.layer.cornerRadius = 8
            b.backgroundColor = .subgroundColor
            b.tag = tag
            b.setTitle(String(tag), for: .normal)
            b.setTitleColor(.textColor, for: .normal)
            b.titleLabel?.adjustsFontSizeToFitWidth = true
            b.titleLabel?.font = .customFont(ofSize: 20)
            b.addTarget(self, action: #selector(handleBall), for: .touchUpInside)
        }
    }
}

private extension UIButton {
    
    func didSelected(_ isSelected: Bool) {
        if isSelected {
            setTitleColor(.white, for: .normal)
            
            switch tag {
            case 1...10:
                backgroundColor = .systemOrange
            case 11...20:
                backgroundColor = .systemBlue
            case 21...30:
                backgroundColor = .systemRed
            case 31...40:
                backgroundColor = .darkGray
            case 41...45:
                backgroundColor = .systemGreen
            default:
                backgroundColor = .subgroundColor
            }
            
        } else {
            setTitleColor(.textColor, for: .normal)
            backgroundColor = .subgroundColor
        }
    }
}
