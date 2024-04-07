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
    let memberLabel = UILabel().then {
        $0.text = "구성원"
        $0.font = UIFont.headline2Bold
    }
    
    let memberCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    var memberList: [TeamMember] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addView()
        layoutContraints()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        memberCollectionView.delegate = self
        memberCollectionView.dataSource = self
        memberCollectionView.register(MemberCell.self, forCellWithReuseIdentifier: MemberCell.registerId)
    }
}

extension GetMemberBottomSheet: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memberList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemberCell.registerId, for: indexPath) as? MemberCell else {
            return UICollectionViewCell()
        }
        
        return cell
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
    
    let userProfileImage = UIImageView().then {
        $0.image = UIImage(named: "defaultProfile")
    }
    
    let userNickname = UILabel().then {
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
