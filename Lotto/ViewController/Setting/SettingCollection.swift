//
//  SettingCollection.swift
//  Lotto
//
//  Created by Qtec on 2022/11/28.
//

import UIKit

import SnapKit
import Then

class SettingCollection: UICollectionViewController {
    
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
        
        view.backgroundColor = .systemRed
        collectionView.backgroundColor = .clear
    }
}

extension SettingCollection {
    
    private func setupCollection() {
        
    }
    
    private func setupControls() {
        
    }
    
    private func setupLayout() {
        
    }
}
