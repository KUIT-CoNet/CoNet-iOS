//
//  DecidedPlanListViewController.swift
//  CoNet
//
//  Created by 이안진 on 2023/07/23.
//

import UIKit

class DecidedPlanListViewController: UIViewController {
    var meetingId: Int = 0
    
    private lazy var mainView = PlanListCollectionView.init(frame: self.view.frame)

//    static func instance() -> ViewController {
//        return ViewController.init(nibName: nil, bundle: nil)
//    }
    
    var plansCount: Int = 0
    private var decidedPlanData: [DecidedPlanInfo] = []
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
        PlanAPI().getDecidedPlansAtMeeting(meetingId: meetingId) { count, plans in
            self.plansCount = count
            self.decidedPlanData = plans
            self.mainView.reload()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.title = "확정된 약속"
        
        view = mainView
        
        view.backgroundColor = UIColor.gray50
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(DecidedPlanCell.self, forCellWithReuseIdentifier: DecidedPlanCell.registerId)
    }
}

extension DecidedPlanListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // 각 셀을 클릭했을 때 이벤트 처리
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = DecidedPlanInfoViewController()
        nextVC.planId = decidedPlanData[indexPath.item].planId
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // 셀 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return decidedPlanData.count
    }
    
    // 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DecidedPlanCell.registerId, for: indexPath) as? DecidedPlanCell else {
            return UICollectionViewCell()
        }
        
        cell.dateLabel.text = decidedPlanData[indexPath.item].date
        cell.timeLabel.text = decidedPlanData[indexPath.item].time
        cell.leftDateLabel.text = "\(decidedPlanData[indexPath.item].dday)일 남았습니다."
        cell.planTitleLabel.text = decidedPlanData[indexPath.item].planName
        
        return cell
    }
    
    // 셀 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize.init(width: width, height: 110)
    }
    
    // 셀 사이의 위아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
