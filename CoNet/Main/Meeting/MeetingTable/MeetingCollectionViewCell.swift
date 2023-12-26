//
//  MeetingCollectionViewCell.swift
//  CoNet
//
//  Created by 정아현 on 12/24/23.
//

import UIKit
import Then
import SnapKit

class MeetingCollectionViewCell: UICollectionViewCell {
    static let identifier = "MeetingCell"
    var meetingId: Int = 0

    let imageView = UIImageView().then { $0.image = UIImage(named: "uploadImageWithNoDescription") }
    let titleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.text = "제목은 최대 두 줄, 더 길어지면 말 줄임표를 사용"
        $0.font = UIFont.body1Bold
    }
    let starButton = UIButton()
    let newImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutConstraints()
        starButton.addTarget(self, action: #selector(starButtonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layoutConstraints() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(starButton)
        contentView.addSubview(newImageView)

        imageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.width.equalTo(164)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
        }

        starButton.snp.makeConstraints { make in
            make.top.equalTo(imageView).offset(8)
            make.trailing.equalTo(imageView).offset(-8)
        }

        newImageView.snp.makeConstraints { make in
            make.width.equalTo(31)
            make.height.equalTo(12)
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.equalTo(imageView)
        }
    }

    var onStarButtonTapped: (() -> Void)?

    @objc func starButtonTapped() {
        onStarButtonTapped?()
    }
}

