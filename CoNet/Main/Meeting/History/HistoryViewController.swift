//
//  HistoryViewController.swift
//  CoNet
//
//  Created by 가은 on 2023/07/23.
//

import Kingfisher
import SnapKit
import Then
import UIKit

class HistoryViewController: UIViewController {
    var meetingId: Int = 0
    
    // 추가 버튼
    let addBtn = UIButton().then {
        $0.setTitle("추가", for: .normal)
        $0.titleLabel?.font = UIFont.headline3Medium
        $0.setTitleColor(UIColor.purpleMain, for: .normal)
    }
    
    var histories: [GetHistoryResult] = []
    
    // collectionView: history
    let historyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // navigation bar title "iOS 스터디"로 지정
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "히스토리"
        
        // 네비게이션 바 item 추가 - 뒤로가기, 사이드바 버튼
        addNavigationBarItem()
        
        layoutConstraints()
        collectionViewSetting()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        
        HistoryAPI().getHistory(meetingId: meetingId) { histories in
            self.histories = histories
            self.historyCollectionView.reloadData()
        }
    }
    
    private func addNavigationBarItem() {
        // 사이드바 버튼 추가
        addBtn.addTarget(self, action: #selector(addHistory), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: addBtn)
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    // 추가 버튼
    @objc func addHistory() {
        let nextVC = UnResgisteredPlanListViewController()
        nextVC.meetingId = self.meetingId
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // history collectionView setting
    func collectionViewSetting() {
        historyCollectionView.delegate = self
        historyCollectionView.dataSource = self
        historyCollectionView.register(HistoryCell.self, forCellWithReuseIdentifier: HistoryCell.identifier)
    }
    
    // 전체 layout
    func layoutConstraints() {
        historyConstraints()
    }
    
    func historyConstraints() {
        historyCollectionView.showsVerticalScrollIndicator = false
        
        view.addSubview(historyCollectionView)
        historyCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalToSuperview()
        }
    }
}

extension HistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // 각 셀을 클릭했을 때 이벤트 처리
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = PastPlanInfoViewController()
        nextVC.planId = histories[indexPath.item].planId
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // 셀 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return histories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HistoryCell.identifier, for: indexPath) as? HistoryCell else {
            return UICollectionViewCell()
        }
        cell.date.text = histories[indexPath.item].planDate
        cell.planTitle.text = histories[indexPath.item].planName
        cell.memberNum.text = "\(histories[indexPath.item].planMemberNum)명"
        
        if let url = URL(string: histories[indexPath.item].historyImgUrl ?? "") {
            cell.historyImage.kf.setImage(with: url, placeholder: UIImage(named: "uploadImageWithNoDescription"))
            cell.historyImage.snp.makeConstraints { make in
                make.height.equalTo(collectionView.frame.width)
            }
        }
        
        if let description = histories[indexPath.item].historyDescription {
            cell.contents.text = description
        }
        
        return cell
    }
    
    // 셀 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        var height = CGFloat(200)
        if histories[indexPath.item].historyImgUrl != nil {
            height += width
        }
        
        return CGSize(width: width, height: height)
    }
    
    // 셀 사이의 위아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // 원래 80인데 20으로 함
        return 20
    }
}
