//
//  MyPageViewController.swift
//  CoNet
//
//  Created by 이안진 on 2023/07/08.
//

import SnapKit
import Then
import UIKit

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
    lazy var noticeView = myPageList.arrowView(title: "공지사항", labelFont: UIFont.body1Regular!)
    lazy var inquireView = myPageList.arrowView(title: "문의하기", labelFont: UIFont.body1Regular!)
    lazy var termView = myPageList.arrowView(title: "이용약관", labelFont: UIFont.body1Regular!)
    lazy var logoutView = myPageList.noArrowView(title: "로그아웃")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        // background color를 white로 설정 (default: black)
        view.backgroundColor = .white
        
        addView()
        layoutConstraints()
        buttonActions() // button 동작
    }
    
    private func buttonActions() {
        userInfoView.addTarget(self, action: #selector(showUserInfoViewController), for: .touchUpInside)
        noticeView.addTarget(self, action: #selector(showNoticeViewController), for: .touchUpInside)
        inquireView.addTarget(self, action: #selector(showInquireViewController), for: .touchUpInside)
        logoutView.addTarget(self, action: #selector(showLogoutPopup), for: .touchUpInside)
    }
    
    private func getUser() {
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
    
    private func addView() {
        view.addSubview(titleLabel)
        
        view.addSubview(profileImage)
        view.addSubview(nameLabel)
        view.addSubview(divider)
        
        view.addSubview(userInfoView)
        view.addSubview(shortDivider)
        view.addSubview(secondShortDivider)
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
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.top.equalTo(safeArea.snp.top).offset(40)
            make.leading.equalTo(view.snp.leading).offset(24)
        }
    }
    
    // 프로필 이미지, 이름 constraints
    private func userConstraints() {
        profileImage.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.equalTo(view.snp.leading).offset(24)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.height.equalTo(26)
            make.centerY.equalTo(profileImage)
            make.leading.equalTo(profileImage.snp.trailing).offset(20)
        }
        
        divider.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.width.equalTo(view.snp.width)
            make.top.equalTo(profileImage.snp.bottom).offset(22)
        }
    }
    
    // 마이페이지 리스트 contents constraints
    private func contentsConstraints() {
        userInfoView.snp.makeConstraints { make in
            make.width.equalTo(view.snp.width).offset(-48)
            make.top.equalTo(divider.snp.bottom).offset(32)
            make.horizontalEdges.equalTo(view.snp.horizontalEdges).inset(24)
        }
        
        shortDivider.snp.makeConstraints { make in
            dividerConstraints(make: make)
            make.top.equalTo(userInfoView.snp.bottom).offset(24)
        }
        
        myPageListLayoutConstraints(noticeView, previousView: shortDivider)
        myPageListLayoutConstraints(inquireView, previousView: noticeView)
        myPageListLayoutConstraints(termView, previousView: inquireView)
        
        secondShortDivider.snp.makeConstraints { make in
            dividerConstraints(make: make)
            make.top.equalTo(termView.snp.bottom).offset(24)
        }
        
        myPageListLayoutConstraints(logoutView, previousView: secondShortDivider)
    }
    
    // 마이 페이지 리스트의 공통된 constraints
    private func myPageListLayoutConstraints(_ listView: UIView, previousView: UIView) {
        view.addSubview(listView) // 공통 layout이라서 여기에 남겨둠
        listView.snp.makeConstraints { make in
            make.width.equalTo(view.snp.width).offset(-48)
            make.top.equalTo(previousView.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(view.snp.horizontalEdges).inset(24)
        }
    }
    
    // 얇은 구분선 constraints
    private func dividerConstraints(make: ConstraintMaker) {
        make.height.equalTo(1)
        make.width.equalTo(view.snp.width).offset(-48)
        make.horizontalEdges.equalTo(view.snp.horizontalEdges).inset(24)
    }
}
