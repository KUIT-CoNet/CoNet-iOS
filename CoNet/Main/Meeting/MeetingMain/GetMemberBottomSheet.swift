//
//  GetMemberBottomSheet.swift
//  CoNet
//
//  Created by 가은 on 4/7/24.
//

import SnapKit
import Then
import UIKit

class GetMemberBottomSheet: UIViewController {
    var meetingId: Int = 0
    
    let memberLabel = UILabel().then {
        $0.text = "구성원"
        $0.font = UIFont.headline2Bold
    }
    
    let memberCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    var memberList: [MeetingMember] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addView()
        layoutContraints()
        setupCollectionView()
        
        getMemberAPI()
    }
    
    private func setupCollectionView() {
        memberCollectionView.delegate = self
        memberCollectionView.dataSource = self
        memberCollectionView.register(MemberCell.self, forCellWithReuseIdentifier: MemberCell.registerId)
    }
    
    private func getMemberAPI() {
        MeetingAPI().getMeetingMembers(teamId: meetingId) { members in
            self.memberList = members ?? []
            self.memberCollectionView.reloadData()
        }
    }
}

extension GetMemberBottomSheet: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memberList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemberCell.registerId, for: indexPath) as? MemberCell else {
            return UICollectionViewCell()
        }
        
        cell.userNickname.text = memberList[indexPath.item].name
        if let url = URL(string: memberList[indexPath.item].memberImgUrl) {
            cell.userProfileImage.kf.setImage(with: url, placeholder: UIImage(named: "defaultProfile"))
        }
        
        return cell
    }
    
    // 셀 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let halfWidth = (width - 48) / 2
        return CGSize(width: halfWidth, height: 42)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        }
}

extension GetMemberBottomSheet {
    func addView() {
        view.addSubview(memberLabel)
        view.addSubview(memberCollectionView)
    }
    
    func layoutContraints() {
        memberLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(40)
            make.centerX.equalTo(view.snp.centerX)
        }
        memberCollectionView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(memberLabel.snp.bottom).offset(25)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}

class MemberCell: UICollectionViewCell {
    static let registerId = "\(MemberCell.self)"
    
    let background = UIView().then {
        $0.layer.cornerRadius = 22
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.mainSub2?.cgColor
    }
    
    var userProfileImage = UIImageView().then {
        $0.image = UIImage(named: "defaultProfile")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
    }
    
    var userNickname = UILabel().then {
        $0.font = UIFont.body1Medium
        $0.textColor = .textHigh
        $0.lineBreakMode = .byTruncatingTail
        $0.numberOfLines = 1
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetting()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewSetting()
    }
    
    private func viewSetting() {
        addView()
        layoutConstraints()
    }
    
    private func addView() {
        addSubview(background)
        background.addSubview(userProfileImage)
        background.addSubview(userNickname)
    }
    
    private func layoutConstraints() {
        background.snp.makeConstraints { make in
            make.height.width.equalToSuperview()
        }
        
        userProfileImage.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalTo(background.snp.centerY)
        }
        
        userNickname.snp.makeConstraints { make in
            make.width.equalTo(82)
            make.leading.equalTo(userProfileImage.snp.trailing).offset(12)
            make.centerY.equalTo(background.snp.centerY)
        }
    }
}
