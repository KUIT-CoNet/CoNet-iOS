//
//  PlanMemberBottonSheetViewController.swift
//  CoNet
//
//  Created by 정아현 on 2023/07/28.
//

import SnapKit
import Then
import UIKit

class PlanMemberBottomSheetViewController: UIViewController {
    var planId: Int = 17
    var members: [PlanDetailMember] = [PlanDetailMember(id: 0, name: "wow", image: ""),
                                       PlanDetailMember(id: 0, name: "wow", image: ""),
                                       PlanDetailMember(id: 0, name: "wow", image: ""),
                                       PlanDetailMember(id: 0, name: "wow", image: ""),
                                       PlanDetailMember(id: 0, name: "wow", image: "")]
    
    var allMembers: [EditPlanMember] = [EditPlanMember(id: 0, name: "wow", image: "", isAvailable: true),
                                        EditPlanMember(id: 0, name: "wow", image: "", isAvailable: true),
                                        EditPlanMember(id: 0, name: "wow", image: "", isAvailable: true),
                                        EditPlanMember(id: 0, name: "wow", image: "", isAvailable: false),
                                        EditPlanMember(id: 0, name: "wow", image: "", isAvailable: false)]
    
    let background = UIView().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    let bottomSheet = UIView().then {
        $0.backgroundColor = UIColor.white
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    let grayLine = UIView().then {
        $0.layer.backgroundColor = UIColor.iconDisabled?.cgColor
        $0.layer.cornerRadius = 1.5
    }
    
    lazy var memberCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.isScrollEnabled = false
        $0.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    let addButton = UIButton().then {
        $0.frame = CGRect(x: 0, y: 0, width: 345, height: 52)
        $0.backgroundColor = UIColor.iconDisabled
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("추가하기", for: .normal)
        $0.titleLabel?.font = UIFont.body1Medium
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        layoutConstraints()
        setupCollectionView()
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopUp))
        background.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PlanAPI().getPlanMemberIsAvailable(planId: planId) { members in
            self.allMembers = members
            self.memberCollectionView.reloadData()
            
            self.layoutConstraints()
        }
    }
    
    private func setupCollectionView() {
        memberCollectionView.delegate = self
        memberCollectionView.dataSource = self
        memberCollectionView.register(SelectMemberCollectionViewCell.self, forCellWithReuseIdentifier: SelectMemberCollectionViewCell.cellId)
    }
    
    @objc func dismissPopUp() {
        dismiss(animated: true, completion: nil)
    }
    
    func updateAddButtonBackgroundColor() {
//        if isMember1Checked || isMember2Checked || isMember3Checked {
//            addButton.backgroundColor = .purple
//        } else {
//            addButton.backgroundColor = UIColor.iconDisabled
//        }
    }

    @objc func addButtonTapped() {
        // "추가하기" 버튼을 눌렀을 때 수행할 동작
        var newMembers: [PlanDetailMember] = []
        for member in allMembers {
            if member.isAvailable {
                let member = PlanDetailMember(id: member.id, name: member.name, image: member.image)
                newMembers.append(member)
            }
        }
        
        // 멤버를 선택된 멤버로 변경
        self.members = newMembers
    }
    
    private func layoutConstraints() {
        applyConstraintsToBackground()
        applyConstraintsToComponents()
    }
    
    private func applyConstraintsToBackground() {
        let safeArea = view.safeAreaLayoutGuide
        view.addSubview(background)
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(bottomSheet)
        bottomSheet.snp.makeConstraints { make in
            let memberRow = ceil(Double(allMembers.count) / 2.0)
            let height = (memberRow * 42) + ((memberRow - 1) * 10) + 240
            make.height.equalTo(height)
            
            make.top.equalTo(safeArea.snp.top).offset(471)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    private func applyConstraintsToComponents() {
        let safeArea = view.safeAreaLayoutGuide
        
        bottomSheet.addSubview(grayLine)
        grayLine.snp.makeConstraints { make in
            make.width.equalTo(36)
            make.height.equalTo(3)
            make.top.equalTo(bottomSheet.snp.top).offset(10)
            make.centerX.equalToSuperview()
        }
        
        bottomSheet.addSubview(memberCollectionView)
        memberCollectionView.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-48)
            
            let memberRow = ceil(Double(allMembers.count) / 2.0)
            let height = (memberRow * 42) + ((memberRow - 1) * 10)
            make.height.equalTo(height)
            
            make.top.equalTo(grayLine.snp.bottom).offset(44)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        bottomSheet.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-48)
            make.height.equalTo(44)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.bottom.equalTo(view.snp.bottom).offset(-40)
        }
    }
}

extension PlanMemberBottomSheetViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // 각 셀을 클릭했을 때 이벤트 처리
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected cell at indexPath: \(indexPath)")
    }
    
    // 셀 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allMembers.count
    }
    
    // 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectMemberCollectionViewCell.cellId, for: indexPath) as? SelectMemberCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.name.text = allMembers[indexPath.item].name
        if let url = URL(string: allMembers[indexPath.item].image) {
            cell.profileImage.kf.setImage(with: url, placeholder: UIImage(named: "defaultProfile"))
        }
        cell.checkButton.setImage(UIImage(named: allMembers[indexPath.item].isAvailable ? "check-circle" : "uncheck-circle"), for: .normal)
        
        return cell
    }
    
    // 셀 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let halfWidth = (width - 10) / 2
        return CGSize.init(width: halfWidth, height: 42)
    }
    
    // 셀 사이의 위아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
