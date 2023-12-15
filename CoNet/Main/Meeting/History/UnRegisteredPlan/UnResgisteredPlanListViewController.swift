//
//  UnResgisteredPlanListViewController.swift
//  CoNet
//
//  Created by 이안진 on 2023/08/06.
//

import UIKit

class UnResgisteredPlanListViewController: UIViewController {
    var meetingId: Int = 0
    
    private lazy var mainView = PlanListCollectionView.init(frame: self.view.frame)

//    static func instance() -> ViewController {
//        return ViewController.init(nibName: nil, bundle: nil)
//    }
    
    private var plansCount: Int = 0
    private var pastPlanData: [PastPlanInfo] = []
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
        PlanAPI().getUnRegisteredPastPlansAtMeeting(meetingId: meetingId) { plans in
            self.plansCount = plans.count
            self.pastPlanData = plans
            self.mainView.reload()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.title = "등록되지 않은 지난 약속"
        
        view = mainView
        
        view.backgroundColor = UIColor.gray50
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(UnRegisteredPlanCell.self, forCellWithReuseIdentifier: UnRegisteredPlanCell.registerId)
    }
}

extension UnResgisteredPlanListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // 각 셀을 클릭했을 때 이벤트 처리
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = HistoryAddViewController()
        nextVC.planId = pastPlanData[indexPath.item].planId
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // 셀 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pastPlanData.count
    }
    
    // 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UnRegisteredPlanCell.registerId, for: indexPath) as? UnRegisteredPlanCell else {
            return UICollectionViewCell()
        }
        
        cell.dateLabel.text = pastPlanData[indexPath.item].date
        cell.timeLabel.text = pastPlanData[indexPath.item].time
        cell.planTitleLabel.text = pastPlanData[indexPath.item].planName
        
        return cell
    }
    
    // 셀 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize.init(width: width, height: 88)
    }
    
    // 셀 사이의 위아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
