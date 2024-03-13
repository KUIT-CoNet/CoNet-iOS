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
    var members: [PlanDetailMember] = []
    var allMembers: [EditPlanMember] = []
    weak var delegate: PlanMemberBottomSheetViewControllerDelegate?
    
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
        
        addView()
        layoutConstraints()
        setupCollectionView()
        buttonActions()
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
    
    func buttonActions() {
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopUp))
        background.addGestureRecognizer(tapGesture)
    }

    @objc func addButtonTapped() {
        var newMembers: [PlanDetailMember] = []
        
        for member in allMembers where member.isAvailable {
            let newMember = PlanDetailMember(id: member.id, name: member.name, image: member.image)
            newMembers.append(newMember)
        }
        self.members = newMembers
        delegate?.didUpdateMembers(members: newMembers)
        dismiss(animated: true, completion: nil)
    }
    
    // 추가하기 버튼 활성화
    func updateAddButtonBackgroundColor() {
        let isSelectedMemberExists = allMembers.contains { $0.isAvailable }
        addButton.backgroundColor = isSelectedMemberExists ? .purpleMain : UIColor.iconDisabled
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
        
        let member = allMembers[indexPath.item]
        cell.name.text = member.name
        if let url = URL(string: member.image) {
            cell.profileImage.kf.setImage(with: url, placeholder: UIImage(named: "defaultProfile"))
        }
        let imageName = member.isAvailable ? "check-circle" : "uncheck-circle"
        cell.checkButton.setImage(UIImage(named: imageName), for: .normal)
        
        // 체크 상태 변경시 
        cell.toggleSelection = { [weak self] (isSelected: Bool) in
            guard let self = self else { return }
            self.allMembers[indexPath.item].isAvailable = isSelected
            self.updateAddButtonBackgroundColor()
        }
        
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

// addView, layout
extension PlanMemberBottomSheetViewController {
    private func addView() {
        view.addSubview(background)
        view.addSubview(bottomSheet)
        bottomSheet.addSubview(grayLine)
        bottomSheet.addSubview(memberCollectionView)
        bottomSheet.addSubview(addButton)
    }
    
    private func layoutConstraints() {
        applyConstraintsToBackground()
        applyConstraintsToComponents()
    }
    
    private func applyConstraintsToBackground() {
        let safeArea = view.safeAreaLayoutGuide
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
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
        
        grayLine.snp.makeConstraints { make in
            make.width.equalTo(36)
            make.height.equalTo(3)
            make.top.equalTo(bottomSheet.snp.top).offset(10)
            make.centerX.equalToSuperview()
        }
        
        memberCollectionView.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-48)
            
            let memberRow = ceil(Double(allMembers.count) / 2.0)
            let height = (memberRow * 42) + ((memberRow - 1) * 10)
            make.height.equalTo(height)
            
            make.top.equalTo(grayLine.snp.bottom).offset(44)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        addButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.centerX.equalTo(bottomSheet.snp.centerX)
            make.horizontalEdges.equalTo(bottomSheet.snp.horizontalEdges).inset(24)
            make.bottom.equalTo(view.snp.bottom).offset(-45)
        }
    }
}

protocol PlanMemberBottomSheetViewControllerDelegate: AnyObject {
    func didUpdateMembers(members: [PlanDetailMember])
}
