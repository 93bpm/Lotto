//
//  HomeController.swift
//  Lotto
//
//  Created by Qtec on 2022/11/28.
//

import UIKit

import SafariServices

import SnapKit
import Then

class HomeController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControls()
        setupLayout()
    }
}

extension HomeController {
    
    private func setupControls() {

    }
    
    private func setupLayout() {
        
    }
    
    
}

extension HomeController: ScannerViewDelegate {
    
    func completion(in status: ScanStatus) {
        
    }
}
