//
//  NoticeViewController.swift
//  CoNet
//
//  Created by 이안진 on 2023/07/09.
//

import UIKit

class NoticeViewController: UIViewController {
    let nothingNoticeLabel = UILabel().then {
        $0.text = "등록된 공지가 없습니다."
        $0.font = UIFont.body2Medium
        $0.textColor = UIColor.textMedium
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.title = "공지사항"
        
        // background color를 white로 설정 (default: black)
        view.backgroundColor = .white
        
        addView()
        layoutConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
}

// addView, layoutConstraints
extension NoticeViewController {
    private func addView() {
        view.addSubview(nothingNoticeLabel)
    }
    
    private func layoutConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        nothingNoticeLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.top.equalTo(safeArea.snp.top).offset(40)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
        }
    }
}
