//
//  MyPageViewController.swift
//  CoNet
//
//  Created by 이안진 on 2023/07/08.
//

import SnapKit
import Then
import UIKit

class NextViewController {
    var next = ""
}

class MyPageViewController: UIViewController {
    // "MY" 타이틀
    let titleLabel = UILabel().then {
        $0.text = "MY"
        $0.font = UIFont.headline1
        $0.textColor = UIColor.textHigh
    }
    
    // 프로필 이미지 - 현재 기본 이미지로 보여줌
    var profileImage = UIImageView().then {
        $0.image = UIImage(named: "defaultProfile")
        $0.layer.cornerRadius = 30
        $0.clipsToBounds = true
    }
    
    // 이름
    var nameLabel = UILabel().then {
        $0.text = ""
        $0.font = UIFont.headline2Bold
        $0.textColor = UIColor.textHigh
    }
    
    // 구분선
    let divider = UIView().then { $0.backgroundColor = UIColor.gray50 }
    let shortDivider = UIView().then { $0.backgroundColor = UIColor.gray100 }
    let secondShortDivider = UIView().then { $0.backgroundColor = UIColor.gray100 }
    
    // 마이페이지 리스트
    let myPageList = MyPageList()
    lazy var userInfoView = myPageList.arrowView(title: "회원정보", labelFont: UIFont.body1Regular!)
    lazy var notificationView = myPageList.toggleView(title: "알림 설정")
    lazy var noticeView = myPageList.arrowView(title: "공지사항", labelFont: UIFont.body1Regular!)
    lazy var inquireView = myPageList.arrowView(title: "문의하기", labelFont: UIFont.body1Regular!)
    lazy var termView = myPageList.noArrowView(title: "이용약관")
    lazy var logoutView = myPageList.noArrowView(title: "로그아웃")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        // background color를 white로 설정 (default: black)
        view.backgroundColor = .white
        
        // 전체 layout constraints
        layoutConstraints()
        
        userInfoView.addTarget(self, action: #selector(showUserInfoViewController), for: .touchUpInside)
        noticeView.addTarget(self, action: #selector(showNoticeViewController), for: .touchUpInside)
        inquireView.addTarget(self, action: #selector(showInquireViewController), for: .touchUpInside)
        logoutView.addTarget(self, action: #selector(showLogoutPopup), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUser()
    }
    
    private func fetchUser() {
        MyPageAPI().getUser { name, imageUrl, _, _ in
            self.nameLabel.text = name
            
            guard let url = URL(string: imageUrl) else { return }
            self.profileImage.kf.setImage(with: url)
        }
    }
    
    @objc private func showUserInfoViewController(_ sender: UIView) {
        let nextVC = UserInfoViewController()
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc private func showNoticeViewController(_ sender: UIView) {
        let nextVC = NoticeViewController()
        navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    @objc private func showInquireViewController(_ sender: UIView) {
        let nextVC = InquireViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func showLogoutPopup(_ sender: UIView) {
        let popupVC = LogoutPopUpViewController()
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        present(popupVC, animated: true, completion: nil)
    }
    
    // 전체 layout constraints
    private func layoutConstraints() {
        titleConstraints()
        userConstraints()
        contentsConstraints()
    }
    
    // "MY" 타이틀 constraints
    private func titleConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.top.equalTo(safeArea.snp.top).offset(40)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
        }
    }
    
    // 프로필 이미지, 이름 constraints
    private func userConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(profileImage)
        profileImage.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(60)
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
        }
        
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.height.equalTo(26)
            make.centerY.equalTo(profileImage)
            make.leading.equalTo(profileImage.snp.trailing).offset(20)
        }
        
        view.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.width.equalTo(safeArea.snp.width)
            make.top.equalTo(profileImage.snp.bottom).offset(22)
        }
    }
    
    // 마이페이지 리스트 contents constraints
    private func contentsConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(userInfoView)
        userInfoView.snp.makeConstraints { make in
            make.width.equalTo(safeArea.snp.width).offset(-48)
            make.top.equalTo(divider.snp.bottom).offset(32)
            verticalPadding(make: make)
        }
        
        myPageListLayoutConstraints(notificationView, previousView: userInfoView)
        
        view.addSubview(shortDivider)
        shortDivider.snp.makeConstraints { make in
            dividerConstraints(make: make)
            make.top.equalTo(notificationView.snp.bottom).offset(24)
        }
        
        myPageListLayoutConstraints(noticeView, previousView: shortDivider)
        myPageListLayoutConstraints(inquireView, previousView: noticeView)
        myPageListLayoutConstraints(termView, previousView: inquireView)
        
        view.addSubview(secondShortDivider)
        secondShortDivider.snp.makeConstraints { make in
            dividerConstraints(make: make)
            make.top.equalTo(termView.snp.bottom).offset(24)
        }
        
        myPageListLayoutConstraints(logoutView, previousView: secondShortDivider)
    }
    
    // 리스트의 공통된 constraints
    private func myPageListLayoutConstraints(_ listView: UIView, previousView: UIView) {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.width.equalTo(safeArea.snp.width).offset(-48)
            make.top.equalTo(previousView.snp.bottom).offset(24)
            verticalPadding(make: make)
        }
    }
    
    // 얇은 구분선 constraints
    private func dividerConstraints(make: ConstraintMaker) {
        let safeArea = view.safeAreaLayoutGuide
        
        make.height.equalTo(1)
        make.width.equalTo(safeArea.snp.width).offset(-48)
        verticalPadding(make: make)
    }
    
    // 왼쪽, 오른쪽 여백 24
    private func verticalPadding(make: ConstraintMaker) {
        let safeArea = view.safeAreaLayoutGuide
        
        make.leading.equalTo(safeArea.snp.leading).offset(24)
        make.trailing.equalTo(safeArea.snp.trailing).offset(24)
    }
}
