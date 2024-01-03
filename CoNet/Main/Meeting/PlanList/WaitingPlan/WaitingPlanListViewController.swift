//
//  WaitingPlanListViewController.swift
//  CoNet
//
//  Created by 이안진 on 2023/07/22.
//

import SnapKit
import Then
import UIKit

class WaitingPlanListViewController: UIViewController {
    var meetingId: Int = 0
    
    private lazy var mainView = PlanListCollectionView.init(frame: self.view.frame)
    private var plansCount: Int = 0
    private var waitingPlanData: [WaitingPlanInfo] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        getWatingPlans() // 대기 중 약속 데이터 가져오기
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.title = "대기중인 약속"
        
        view = mainView
        view.backgroundColor = UIColor.gray50
        setupCollectionView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // CollectionView 설정
    private func setupCollectionView() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(WaitingPlanCell.self, forCellWithReuseIdentifier: WaitingPlanCell.registerId)
    }
    
    // 대기 중 약속 데이터 가져오기
    private func getWatingPlans() {
        PlanAPI().getWaitingPlansAtMeeting(meetingId: meetingId) { count, plans in
            self.plansCount = count
            self.waitingPlanData = plans
            self.mainView.reload()
        }
    }
}

extension WaitingPlanListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // 각 셀을 클릭했을 때 이벤트 처리
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = TimeShareViewController()
        nextVC.planId = waitingPlanData[indexPath.item].planId
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // 셀 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plansCount
    }
    
    // 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WaitingPlanCell.registerId, for: indexPath) as? WaitingPlanCell else {
            return UICollectionViewCell()
        }
        
        cell.startDateLabel.text = waitingPlanData[indexPath.item].startDate
        cell.finishDateLabel.text = waitingPlanData[indexPath.item].endDate
        cell.planTitleLabel.text = waitingPlanData[indexPath.item].planName
        
        return cell
    }
    
    // 셀 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize.init(width: width, height: 92)
    }
    
    // 셀 사이의 위아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    /*
    // 셀 좌우 여백 값 조절
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let leftRightInset: CGFloat = 16.0
        return UIEdgeInsets(top: 0, left: leftRightInset, bottom: 0, right: leftRightInset)
    }
     */
}

protocol MeetingMainViewControllerDelegate: AnyObject {
    func sendDataBack(data: SideBarMenu)
    func sendIntDataBack(data: Int)
}
