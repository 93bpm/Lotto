//
//  SettingCollection.swift
//  Lotto
//
//  Created by Qtec on 2022/11/28.
//

import UIKit

import SnapKit
import Then

/**
 switch section {
 case 0:
    로그인(카카오, 구글, 네이버 등...)
 case 1:
    알림(푸시, 위치) & 이벤트 수신 여부(선택)
 case 2:
    광고
 case 3:
    추천하기, 평가하기, 버그신고, 이용약관, 버전정보
 }
 */

class SettingCollection: UICollectionViewController {
    
    enum SettingType: Int, CaseIterable {
        case recommend, evaluate, bug, terms, version, ad
        
        var title: String {
            switch self {
            case .recommend: return "추천하기"
            case .evaluate : return "평가하기"
            case .bug      : return "버그신고"
            case .terms    : return "이용약관"
            case .version  : return "버전정보"
            case .ad       : return "광고"
            }
        }
        
        var image: UIImage? {
            return nil
        }
    }
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupCollection()
        setupControls()
        setupLayout()
    }
}

extension SettingCollection {
    
    private func setupNavigation() {
        navigationItem.title = "내 정보"
        navigationItem.largeTitleDisplayMode = .always
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .subgroundColor
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupCollection() {
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: UserCell.cellId)
        collectionView.register(PushCell.self, forCellWithReuseIdentifier: PushCell.cellId)
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: SettingCell.cellId)
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
    
        collectionView.backgroundColor = .backgroundColor
    }
    
    private func setupControls() {
        
    }
    
    private func setupLayout() {
        
    }
}

extension SettingCollection: UICollectionViewDelegateFlowLayout {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch section {
        case 0: //로그인
            return 1
        case 1: //알림(푸시, 위치) & 이벤트 수신 여부(선택)
            return 1
        case 2: //광고
            return 1
        default: //추천하기, 평가하기, 버그신고, 이용약관, 버전정보
            return SettingType.allCases.count - 1
        }
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCell.cellId, for: indexPath) as! UserCell
            
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PushCell.cellId, for: indexPath) as! PushCell
            
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingCell.cellId, for: indexPath) as! SettingCell
            
            if indexPath.section == 2 {
                cell.type = .ad
            } else {
                cell.type = SettingType(rawValue: indexPath.item)
            }
            return cell
        }
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        switch indexPath.section {
        case 0: //로그인
            return
        case 1: //푸시
            return
        default: //그 외
            let cell = collectionView.cellForItem(at: indexPath)
            guard
                let cell = cell as? SettingCell
            else {
                return
            }
                
            
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.frame.width
        
        switch indexPath.section {
        case 0:
            return CGSize(width: width, height: 110)
        case 1:
            return CGSize(width: width, height: 180)
        default:
            return CGSize(width: width, height: 65)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
}
