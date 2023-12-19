//
//  PastPlanInfoViewController.swift
//  CoNet
//
//  Created by 이안진 on 2023/08/08.
//

import UIKit

class PastPlanInfoViewController: UIViewController {
    var planId: Int = 0
    var members: [PlanDetailMember] = [PlanDetailMember(id: 0, name: "얍", image: "https://t3.ftcdn.net/jpg/05/66/82/84/360_F_566828475_gypf1EwiRh5Cmji2FaUlF9vx0MHOW3Vj.jpg"), PlanDetailMember(id: 0, name: "얍", image: "https://t3.ftcdn.net/jpg/05/66/82/84/360_F_566828475_gypf1EwiRh5Cmji2FaUlF9vx0MHOW3Vj.jpg"), PlanDetailMember(id: 0, name: "얍", image: "https://t3.ftcdn.net/jpg/05/66/82/84/360_F_566828475_gypf1EwiRh5Cmji2FaUlF9vx0MHOW3Vj.jpg")]
    
    var isHistoryExist: Bool = true
    var isPhotoExist: Bool = false
    var isDescriptionExist: Bool = true
    
    // 배경 - .clear
    let scrollview = UIScrollView().then { $0.backgroundColor = .clear }
    let contentsView = UIView().then { $0.backgroundColor = .clear }
    
    // 우측 상단 점 세개 아이콘 - bottom sheet 버튼
    let bottomSheetButton = UIButton().then { $0.setImage(UIImage(named: "sidebar"), for: .normal) }
    
    // 약속 이름
    let nameRow = PlanInfoRow().then {
        $0.setLabel("약속 이름")
        $0.setText("모임 입니당")
    }
    
    // 약속 날짜
    let dateRow = PlanInfoRow().then {
        $0.setLabel("약속 날짜")
        $0.setText("2023. 07. 15")
    }
    
    // 약속 시간
    let timeRow = PlanInfoRow().then {
        $0.setLabel("약속 시간")
        $0.setText("10:00")
    }
    
    // 참여자 label
    let memberLabel = UILabel().then {
        $0.text = "참여자"
        $0.font = UIFont.body2Bold
        $0.textColor = UIColor.textDisabled
    }
    
    // 참여자 collection view
    lazy var memberCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.isScrollEnabled = false
        $0.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // 히스토리 구분선
    let divider = UIView().then { $0.backgroundColor = .gray50 }
    
    // 히스토리 타이틀 label
    let historyLabel = UILabel().then {
        $0.text = "히스토리"
        $0.font = UIFont.headline3Bold
        $0.textColor = UIColor.black
    }
    
    // 히스토리 등록하기 버튼
    let historyAddButton = UIButton().then {
        $0.frame = CGRect(x: 0, y: 0, width: 160, height: 40)
        $0.backgroundColor = UIColor.white
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor.purpleMain?.cgColor
        $0.layer.borderWidth = 1
        $0.layer.masksToBounds = true
    }
    let historyAddLabel = UILabel().then {
        $0.text = "히스토리 등록하기"
        $0.font = UIFont.body2Medium
        $0.textColor = UIColor.black
    }
    let historyAddImage = UIImageView().then { $0.image = UIImage(named: "archive") }
    
    // 히스토리 사진 label
    let photoLabel = UILabel().then {
        $0.text = "사진"
        $0.font = UIFont.body2Bold
        $0.textColor = UIColor.textDisabled
    }
    let photoView = UIView().then { $0.backgroundColor = .clear }
    
    // 히스토리 사진 없음
    let noPhotoImageView = UIView().then {
        $0.backgroundColor = UIColor.clear
        $0.layer.borderColor = UIColor.gray200?.cgColor
        $0.layer.borderWidth = 1
    }
    let noPhotoImage = UIImageView().then { $0.image = UIImage(named: "image-x") }
    let noPhotoLabel = UILabel().then {
        $0.text = "사진 없음"
        $0.font = UIFont.overline
        $0.textColor = UIColor.iconDisabled
        $0.adjustsFontSizeToFitWidth = true
    }
    
    // 히스토리 사진 이미지
    let photoImageView = UIImageView().then { $0.image = UIImage(named: "space") }
    
    // 내용 label
    let descriptionLabel = UILabel().then {
        $0.text = "내용"
        $0.font = UIFont.body2Bold
        $0.textColor = UIColor.textDisabled
    }
    
    // 내용 박스 view
    let descriptionView = UIView().then {
        $0.backgroundColor = UIColor.white
        $0.layer.borderColor = UIColor.gray200?.cgColor
        $0.layer.borderWidth = 1
    }
    
    let descriptionText = UILabel().then {
        $0.numberOfLines = 0
        $0.text = "내용이 입력되었다!내용이 입력되었다!내용이 입력되었다!내용이 입력되었다!내용이 입력되었다!내용이 입력되었다!"
        $0.font = UIFont.body2Medium
        $0.textColor = UIColor.black
    }
    
    let noDescriptionText = UILabel().then {
        $0.text = "내용 없음"
        $0.font = UIFont.body2Medium
        $0.textColor = UIColor.textDisabled
        $0.adjustsFontSizeToFitWidth = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.title = "상세 페이지"
        
        // bottom sheet 버튼 추가
        bottomSheetButton.addTarget(self, action: #selector(showBottomSheet), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: bottomSheetButton)
        navigationItem.rightBarButtonItem = barButtonItem
        
        layoutConstraints()
        setupCollectionView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
        PlanAPI().getPlanDetail(planId: planId) { plans in
            self.nameRow.setText(plans.planName)
            self.dateRow.setText(plans.date)
            self.timeRow.setText(plans.time)
            
            self.members = plans.members
            self.memberCollectionView.reloadData()
            
            if plans.isRegisteredToHistory {
                self.isHistoryExist = true
                self.historyContentsConstraints()
                
                if let url = URL(string: plans.historyImgUrl ?? "") {
                    self.isPhotoExist = true
                    self.photoImageView.kf.setImage(with: url, placeholder: UIImage(named: "uploadImage"))
                    self.photoImageConstraints()
                } else {
                    self.isPhotoExist = false
                    self.noPhotoImageConstraints()
                }
                
                if let description = plans.historyDescription {
                    self.isDescriptionExist = true
                    self.descriptionText.text = description
                    self.descriptionContraints()
                } else {
                    self.isDescriptionExist = false
                    self.descriptionContraints()
                }
            } else {
                self.isHistoryExist = false
                self.isPhotoExist = false
                self.isDescriptionExist = false
                self.historyAddButtonConstraints()
            }
        }
    }
    
    private func setupCollectionView() {
        memberCollectionView.delegate = self
        memberCollectionView.dataSource = self
        memberCollectionView.register(MemberCollectionViewCell.self, forCellWithReuseIdentifier: MemberCollectionViewCell.cellId)
    }
    
    @objc private func showBottomSheet() {
        let bottomSheetViewController = PlanEditDelBottomSheetViewController()
        bottomSheetViewController.planId = planId
        bottomSheetViewController.delegate = self
        bottomSheetViewController.modalPresentationStyle = .overCurrentContext
        bottomSheetViewController.modalTransitionStyle = .crossDissolve
        present(bottomSheetViewController, animated: true, completion: nil)
    }
}

extension PastPlanInfoViewController {
    // 전체 layout
    private func layoutConstraints() {
        viewConstraints()
        rowConstraints()
        memberConstraints()
        historyLabelConstraints()
    }
    
    // scrollview, contentsview layout
    private func viewConstraints() {
        view.addSubview(scrollview)
        scrollview.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(0)
        }
        
        scrollview.addSubview(contentsView)
        contentsView.snp.makeConstraints { make in
            make.edges.equalTo(scrollview.contentLayoutGuide)
            make.width.equalTo(scrollview.frameLayoutGuide)
            make.height.equalTo(1200)
        }
    }
    
    // row layout
    private func rowConstraints() {
        contentsView.addSubview(nameRow)
        nameRow.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-48)
            make.height.equalTo(54)
            make.top.equalTo(contentsView.snp.top).offset(12)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        
        contentsView.addSubview(dateRow)
        dateRow.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-48)
            make.height.equalTo(54)
            make.top.equalTo(nameRow.snp.bottom).offset(26)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        
        contentsView.addSubview(timeRow)
        timeRow.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-48)
            make.height.equalTo(54)
            make.top.equalTo(dateRow.snp.bottom).offset(26)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
    }
    
    // 참여자 layout
    private func memberConstraints() {
        contentsView.addSubview(memberLabel)
        memberLabel.snp.makeConstraints { make in
            make.height.equalTo(14)
            make.top.equalTo(timeRow.snp.bottom).offset(26)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        
        contentsView.addSubview(memberCollectionView)
        memberCollectionView.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-48)
            
            let memberRow = ceil(Double(members.count) / 2.0)
            let height = (memberRow * 42) + ((memberRow - 1) * 10)
            make.height.equalTo(height)
            
            make.top.equalTo(memberLabel.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    // 히스토리 label layout
    private func historyLabelConstraints() {
        contentsView.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.width.equalToSuperview()
            make.top.equalTo(memberCollectionView.snp.bottom).offset(32)
        }
        
        contentsView.addSubview(historyLabel)
        historyLabel.snp.makeConstraints { make in
            make.height.equalTo(19)
            make.top.equalTo(divider.snp.bottom).offset(24)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
    }
    
    // 히스토리 등록하기 버튼 layout
    private func historyAddButtonConstraints() {
        contentsView.addSubview(historyAddButton)
        historyAddButton.snp.makeConstraints { make in
            make.width.equalTo(160)
            make.height.equalTo(40)
            make.top.equalTo(historyLabel.snp.bottom).offset(20)
            make.leading.equalTo(24)
        }
        
        historyAddButton.addSubview(historyAddImage)
        historyAddImage.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.centerY.equalTo(historyAddButton)
            make.leading.equalTo(historyAddButton.snp.leading).offset(20)
        }
        
        historyAddButton.addSubview(historyAddLabel)
        historyAddLabel.snp.makeConstraints { make in
            make.centerY.equalTo(historyAddButton)
            make.leading.equalTo(historyAddButton.snp.leading).offset(42)
        }
    }
    
    // 히스토리 내용 layout
    private func historyContentsConstraints() {
        contentsView.addSubview(photoLabel)
        photoLabel.snp.makeConstraints { make in
            make.top.equalTo(historyLabel.snp.bottom).offset(26)
            make.leading.equalTo(24)
        }
        
        contentsView.addSubview(photoView)
    }
    
    // 사진 없음 layout
    private func noPhotoImageConstraints() {
        photoView.snp.makeConstraints { make in
            make.width.height.equalTo(88)
            make.top.equalTo(photoLabel.snp.bottom).offset(8)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        
        photoView.addSubview(noPhotoImageView)
        noPhotoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(88)
            make.top.equalTo(photoLabel.snp.bottom).offset(8)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        
        noPhotoImageView.addSubview(noPhotoImage)
        noPhotoImage.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.top.equalTo(noPhotoImageView.snp.top).offset(24)
            make.centerX.equalTo(noPhotoImageView.snp.centerX)
        }
        
        noPhotoImageView.addSubview(noPhotoLabel)
        noPhotoLabel.snp.makeConstraints { make in
            make.width.equalTo(37)
            make.top.equalTo(noPhotoImage.snp.bottom).offset(4)
            make.centerX.equalTo(noPhotoImageView.snp.centerX)
        }
    }
    
    // 사진 layout
    private func photoImageConstraints() {
        photoView.snp.makeConstraints { make in
            make.width.height.equalTo(contentsView.snp.width).offset(-48)
            make.top.equalTo(photoLabel.snp.bottom).offset(8)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        
        photoView.addSubview(photoImageView)
        photoImageView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
    
    // 내용 layout
    private func descriptionContraints() {
        contentsView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(photoView.snp.bottom).offset(26)
            make.leading.equalTo(contentsView.snp.leading).offset(24)
        }
        
        contentsView.addSubview(descriptionView)
        descriptionView.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-48)
            make.height.equalTo(160)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(24)
        }
        
        if self.isDescriptionExist {
            descriptionView.addSubview(descriptionText)
            descriptionText.snp.makeConstraints { make in
                make.width.equalToSuperview().offset(-50)
                make.top.equalToSuperview().offset(25)
                make.leading.equalToSuperview().offset(25)
            }
        } else {
            descriptionView.addSubview(noDescriptionText)
            noDescriptionText.snp.makeConstraints { make in
                make.width.equalToSuperview().offset(-50)
                make.top.equalToSuperview().offset(25)
                make.leading.equalToSuperview().offset(25)
            }
        }
    }
}

extension PastPlanInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // 각 셀을 클릭했을 때 이벤트 처리
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected cell at indexPath: \(indexPath)")
    }
    
    // 셀 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return members.count
    }
    
    // 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemberCollectionViewCell.cellId, for: indexPath) as? MemberCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.name.text = members[indexPath.item].name
        if let url = URL(string: members[indexPath.item].image) {
            cell.profileImage.kf.setImage(with: url, placeholder: UIImage(named: "defaultProfile"))
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

extension PastPlanInfoViewController: PlanInfoViewControllerDelegate {
    func sendDataBack(data: String) {
        if data == "pop" {
            self.navigationController?.popViewController(animated: true)
        } else {
            let popUpVC = DeletePlanPopUpViewController()
            popUpVC.planId = planId
            popUpVC.delegate = self
            popUpVC.modalPresentationStyle = .overCurrentContext
            popUpVC.modalTransitionStyle = .crossDissolve
            present(popUpVC, animated: true, completion: nil)
        }
    }
}
