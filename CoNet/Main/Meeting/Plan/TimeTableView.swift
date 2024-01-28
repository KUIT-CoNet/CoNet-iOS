//
//  TimeTableView.swift
//  CoNet
//
//  Created by 가은 on 2023/07/27.
//

import SnapKit
import Then
import UIKit

class TimeTableView: UIViewController {
    // 시각 표시
    let hourStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .bottom
        $0.spacing = 11
        $0.distribution = .fillEqually
    }
    
    // 타임테이블
    let timeTableCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.register(TimeTableViewCell.self, forCellWithReuseIdentifier: TimeTableViewCell.identifier)
        $0.isScrollEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = timeTableCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        addView()
        layoutConstraints()
        timeTableSetting()
        hourSetting()
    }
    
    func timeTableSetting() {
        timeTableCollectionView.dataSource = self
        timeTableCollectionView.delegate = self
    }
    
    // 시각 stackView setting
    func hourSetting() {
        for idx in 0 ... 24 {
            let numLabel = UILabel().then {
                $0.font = UIFont.overline
                $0.textColor = UIColor.textMedium
                $0.text = String(idx) + ":00"
            }
            
            hourStackView.addArrangedSubview(numLabel)
        }
    }
    
}

extension TimeTableView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // 셀 클릭 시 이벤트 처리
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected cell at indexPath: \(indexPath)")
        print(indexPath.section, indexPath.row)
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        
        // 해당 시간에 가능한 멤버
//        let memberList = possibleMemberDateTime[page*3 + indexPath.section].possibleMember[indexPath.row]
//        
//        // 셀 색이 흰 색이 아닌 경우 약속 확정 팝업 띄우기
//        if collectionView.cellForItem(at: indexPath)?.contentView.backgroundColor != UIColor.grayWhite {
//            let nextVC = FixPlanPopUpViewController()
//            nextVC.timeShareVC = self
//            nextVC.planId = planId
//            nextVC.time = indexPath.row
//            nextVC.date = sendDate[page*3 + indexPath.section]
//            nextVC.memberList = memberList.memberNames.joined(separator: ", ")
//            nextVC.userIds = memberList.memberIds
//            nextVC.modalPresentationStyle = .overCurrentContext
//            nextVC.modalTransitionStyle = .crossDissolve
//            present(nextVC, animated: true, completion: nil)
//        }
    }
    
    // 셀 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        24
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        if page == 2 {
//            return 1
//        }
        return 3
    }
    
    // 셀 사이즈 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        return CGSize(width: 80, height: 24)
    }
    
    // 위 아래 space zero로 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -1
    }
    
    // 양옆 space zero로 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return -1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeTableViewCell.identifier, for: indexPath) as? TimeTableViewCell else { return UICollectionViewCell() }
        
//        if !apiCheck { return cell }
//        
//        let section = possibleMemberDateTime[page*3 + indexPath.section].possibleMember[indexPath.row].section
//        cell.showCellColor(section: section)
        
        return cell
    }
}

extension TimeTableView {
    func addView() {
        view.addSubview(hourStackView)
        view.addSubview(timeTableCollectionView)
    }
    
    func layoutConstraints() {
        // 시각
        hourStackView.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.top.equalToSuperview()
            make.leading.equalTo(view.snp.leading).offset(20)
        }
        
        // 타임테이블
        timeTableCollectionView.snp.makeConstraints { make in
            make.leading.equalTo(hourStackView.snp.trailing).offset(10)
            make.top.equalTo(hourStackView.snp.top).offset(6)
            make.bottom.trailing.equalToSuperview()
        }
    }
}
