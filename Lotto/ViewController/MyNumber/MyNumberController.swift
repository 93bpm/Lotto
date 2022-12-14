//
//  MyNumberController.swift
//  Lotto
//
//  Created by Qtec on 2022/11/28.
//

import UIKit

import SnapKit
import Then

class MyNumberController: UIViewController {
    
    private(set) var selectedSection: Int?
    
    lazy var keyboardHeight: CGFloat = 0
    
    private let bottomHeight: CGFloat = 115
    
    var titleView: UIView!
    var titleLabel: UILabel!
    var subTitleLabel: UILabel!
    var profileIV: UIImageView!
    
    var noDataLabel: UILabel!
    
    var tableView: UITableView!
    
    var searchView: UIView!
    var addView: UIView!
    var numLabel: UILabel!
    var addStackView: UIStackView!
    var manualButton: UIButton!
    var qrButton: UIButton!
    var searchBar: UISearchBar!
    var betweenView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotifications()
        setupControls()
        setupLayout()
        
        initData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.25) {
            self.searchView.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            }
            
            self.searchView.superview?.layoutIfNeeded()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIView.animate(withDuration: 0.15) {
            self.searchView.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(self.bottomHeight)
            }
            
            self.searchView.superview?.layoutIfNeeded()
        }
    }
    
    private func initData() {
        tableView.isHidden = false
        noDataLabel.isHidden = true
    }
    
    @objc
    private func dismissKeyboard() {
        searchBar.endEditing(true)
    }
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        guard
            keyboardHeight == 0,
            let info = notification.userInfo,
            let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else {
            return
        }
        let rect = keyboardFrame.cgRectValue
        keyboardHeight = rect.height
        
        let height = rect.height - (tabBarController?.tabBar.frame.height ?? 0)
        
        searchView.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-height)
        }
        
        searchView.superview?.layoutIfNeeded()
    }
    
    @objc
    private func keyboardWillHide() {
        guard keyboardHeight != 0 else {return}
        keyboardHeight = 0
        
        searchView.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchView.superview?.layoutIfNeeded()
    }
    
    @objc
    private func handleManual() {
        let vc = ManualController()
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    @objc
    private func handleQR() {
        let vc = ScannerController()
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}

extension MyNumberController {
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    private func setupControls() {
        titleView = UIView().then({ v in
            v.backgroundColor = .backgroundColor
            v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        })
        
        titleLabel = UILabel().then({ l in
            l.text = "?????? ??????"
            l.textAlignment = .left
            l.textColor = .textColor
            l.font = .boldSystemFont(ofSize: 28)
        })
        
        subTitleLabel = UILabel().then({ l in
            l.text = "????????? ??????????????? ??????????????????."
            l.textAlignment = .left
            l.textColor = .lightGray
            l.font = .systemFont(ofSize: 16)
        })
        
        profileIV = UIImageView().then({ iv in
            iv.layer.masksToBounds = true
            iv.layer.cornerRadius = 40
            iv.contentMode = .scaleAspectFit
            iv.image = UIImage(named: "user_profile")
        })
        
        noDataLabel = UILabel().then({ l in
            l.text = "????????? ????????????."
            l.textAlignment = .center
            l.textColor = .darkGray
            l.font = .systemFont(ofSize: 20)
            l.isUserInteractionEnabled = true
            l.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        })
        
        tableView = UITableView().then({ tv in
            tv.register(MyNumberCell.self, forCellReuseIdentifier: MyNumberCell.cellId)
            tv.register(MyNumberHeader.self, forHeaderFooterViewReuseIdentifier: MyNumberHeader.headerId)
            
            tv.backgroundColor = .backgroundColor
            tv.contentInset.bottom = bottomHeight
            
            tv.dataSource = self
            tv.delegate = self
        })
        
        searchView = UIView().then({ v in
            v.layer.shadowColor = UIColor.darkGray.cgColor
            v.layer.shadowOffset = CGSize(width: 0, height: -1)
            v.layer.shadowOpacity = 0.1
            
            v.layer.cornerRadius = 40
            v.layer.maskedCorners = [
                .layerMinXMinYCorner, .layerMaxXMinYCorner
            ]
            
            v.backgroundColor = .tabBarColor
        })
        
        addView = UIView()
        
        numLabel = UILabel().then({ l in
            l.text = "????????????"
            l.textAlignment = .center
            l.textColor = .textColor
            l.adjustsFontSizeToFitWidth = true
            l.font = .systemFont(ofSize: 18)
        })
        
        manualButton = UIButton().then({ b in
            b.layer.masksToBounds = true
            b.layer.cornerRadius = 15
            b.backgroundColor = .systemBlue
            b.setTitle("????????????", for: .normal)
            b.setTitleColor(.white, for: .normal)
            b.titleLabel?.adjustsFontSizeToFitWidth = true
            b.titleLabel?.font = .systemFont(ofSize: 18)
            b.addTarget(self, action: #selector(handleManual), for: .touchUpInside)
        })
        
        qrButton = UIButton().then({ b in
            b.layer.masksToBounds = true
            b.layer.cornerRadius = 15
            b.backgroundColor = .systemBlue
            b.setTitle("QR??????", for: .normal)
            b.setTitleColor(.white, for: .normal)
            b.titleLabel?.adjustsFontSizeToFitWidth = true
            b.titleLabel?.font = .systemFont(ofSize: 18)
            b.addTarget(self, action: #selector(handleQR), for: .touchUpInside)
        })
        
        addStackView = UIStackView(arrangedSubviews: [manualButton, qrButton]).then({ sv in
            sv.axis = .horizontal
            sv.distribution = .fillProportionally
            sv.spacing = 10
        })
        
        searchBar = UISearchBar().then({ sb in
            sb.delegate = self
            sb.backgroundImage = UIImage()
            sb.placeholder = "????????? ??????????????????"
            sb.keyboardType = .numbersAndPunctuation
            sb.searchTextField.layer.masksToBounds = true
            sb.searchTextField.layer.cornerRadius = 17
            sb.barTintColor = .tabBarColor
            sb.backgroundColor = .tabBarColor
            sb.returnKeyType = .search
            sb.searchBarStyle = .minimal
            sb.enablesReturnKeyAutomatically = false
        })
        
        betweenView = UIView()
        betweenView.backgroundColor = .tabBarColor
    }
    
    private func setupLayout() {
        view.backgroundColor = .backgroundColor
        
        view.addSubview(titleView)
        view.addSubview(noDataLabel)
        view.addSubview(tableView)
        view.addSubview(betweenView)
        view.addSubview(searchView)
        
        titleView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.25)
        }
        
        noDataLabel.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.top)
            make.left.bottom.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        betweenView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
        
        searchView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(bottomHeight)
            make.height.equalTo(bottomHeight)
        }
        
        //
        titleView.addSubview(titleLabel)
        titleView.addSubview(subTitleLabel)
        titleView.addSubview(profileIV)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(subTitleLabel.snp.left)
            make.bottom.equalTo(subTitleLabel.snp.top).offset(-5)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.bottom.equalToSuperview().offset(-25)
        }
        
        profileIV.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-25)
            make.right.equalToSuperview().offset(-35)
            make.width.height.equalTo(80)
        }
        
        //
        searchView.addSubview(addView)
        searchView.addSubview(searchBar)
        
        addView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(searchBar.snp.top)
        }
        
        searchBar.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview()
            make.height.equalTo(65)
        }
        
        //
        addView.addSubview(numLabel)
        addView.addSubview(addStackView)
        
        numLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(25)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalToSuperview().multipliedBy(0.7)
        }
        
        addStackView.snp.makeConstraints { make in
            make.left.equalTo(numLabel.snp.right).offset(10)
            make.right.equalToSuperview().offset(-25)
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
        }
    }
}

extension MyNumberController: UITableViewDataSource,
                              UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        if selectedSection == section {
            return 10
        } else {
            return 0
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyNumberCell.cellId, for: indexPath) as! MyNumberCell
        
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MyNumberHeader.headerId) as! MyNumberHeader
        
        header.section = section
        header.isOpen = selectedSection == section
        header.delegate = self
        return header
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForFooterInSection section: Int
    ) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        return 70
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForFooterInSection section: Int
    ) -> CGFloat {
        return 2
    }
}

extension MyNumberController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {
        print("textDidChange:", searchText)
    }
}

extension MyNumberController: MyNumberHeaderDelegate {
    
    func didTapSection(at section: Int) {
        searchBar.endEditing(true)
        
        let indexPaths = (0...9).map({
            IndexPath(row: $0, section: section)
        })
        
        if selectedSection == section {
            selectedSection = nil
            
            tableView.performBatchUpdates {
                tableView.deleteRows(at: indexPaths, with: .top)
            } completion: { _ in
                self.tableView.reloadData()
            }
        } else {
            var delIndexPaths = [IndexPath]()
            if let selectedSection = selectedSection {
                delIndexPaths = (0...9).map({
                    IndexPath(row: $0, section: selectedSection)
                })
            }
            
            selectedSection = section
            
            tableView.performBatchUpdates {
                tableView.deleteRows(at: delIndexPaths, with: .top)
                tableView.insertRows(at: indexPaths, with: .top)
            } completion: { _ in
                self.tableView.reloadData()
            }
        }
    }
}

extension MyNumberController: ManualControllerDelegate {
    
    func didSave(_ number: [Int]) {
        
    }
}

extension MyNumberController: ScannerControllerDelegate {
    
    func didScan(_ qrScan: QRScan) {
        let scanPopup = ScanPopup(data: qrScan)
        scanPopup.delegate = self
        scanPopup.show()
    }
}

extension MyNumberController: ScanPopupDelegate {
    
    func didSaveScan(_ qrScan: QRScan) {
        
    }
}
