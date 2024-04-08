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
    
    // 셀 사이의 위아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}

extension GetMemberBottomSheet {
    func addView() {
        view.addSubview(memberLabel)
    }
    
    func layoutContraints() {
        memberLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(40)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
}

class MemberCell: UICollectionViewCell {
    static let registerId = "\(MemberCell.self)"
    
    var userProfileImage = UIImageView().then {
        $0.image = UIImage(named: "defaultProfile")
    }
    
    var userNickname = UILabel().then {
        $0.font = UIFont.body1Medium
        $0.textColor = .textHigh
        $0.lineBreakMode = .byTruncatingTail
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
        // border 설정
        layer.cornerRadius = 50
        layer.borderWidth = 1
        layer.borderColor = UIColor.mainSub2?.cgColor
        
        addView()
        layoutConstraints()
    }
    
    private func addView() {
        addSubview(userProfileImage)
        addSubview(userNickname)
    }
    
    private func layoutConstraints() {
        snp.makeConstraints { make in
            make.height.equalTo(42)
            make.width.equalTo(164)
        }
        
        userProfileImage.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        userNickname.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.leading.equalTo(userProfileImage.snp.trailing).offset(12)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
}
