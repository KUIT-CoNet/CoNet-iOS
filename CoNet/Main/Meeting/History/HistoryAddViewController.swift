//
//  HistoryAddViewController.swift
//  CoNet
//
//  Created by 정아현 on 2023/07/23.
//

import SnapKit
import Then
import UIKit

class HistoryAddViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var planId: Int = 0
    var members: [PlanDetailMember] = []
    
    var isPhotoUploaded = false
    var isContentsEntered = false
    
    let scrollview = UIScrollView().then { $0.backgroundColor = .clear }
    let contentView = UIView().then { $0.backgroundColor = .clear }
    
    let completionButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.font = UIFont.headline3Medium
        $0.setTitleColor(.textDisabled, for: .normal)
        $0.titleLabel?.lineBreakMode = .byClipping
    }
    
    let planNameLabel = UILabel().then {
        $0.text = "약속 이름"
        $0.font = UIFont.body2Bold
        $0.textColor = UIColor.textDisabled
    }
    
    let planNameText = UILabel().then {
        $0.text = "모임모임"
        $0.font = UIFont.headline3Regular
        $0.textColor = UIColor.textDisabled
    }
    
    let grayLine1 = UIView().then {
        $0.backgroundColor = UIColor.iconDisabled
    }
    
    let planDateLabel = UILabel().then {
        $0.text = "약속 날짜"
        $0.font = UIFont.body2Bold
        $0.textColor = UIColor.textDisabled
    }
    
    let planDateText = UILabel().then {
        $0.text = "2023.07.15"
        $0.font = UIFont.headline3Regular
        $0.textColor = UIColor.textDisabled
    }
    
    let grayLine2 = UIView().then {
        $0.backgroundColor = UIColor.iconDisabled
    }
    
    let planTimeLabel = UILabel().then {
        $0.text = "약속 시간"
        $0.font = UIFont.body2Bold
        $0.textColor = UIColor.textDisabled
    }
    
    let planTimeText = UILabel().then {
        $0.text = "10:00"
        $0.font = UIFont.headline3Regular
        $0.textColor = UIColor.textDisabled
    }

    let grayLine3 = UIView().then {
        $0.backgroundColor = UIColor.iconDisabled
    }
    
    // 참여자 label
    let memberLabel = UILabel().then {
        $0.text = "참여자"
        $0.font = UIFont.body2Bold
        $0.textColor = UIColor.textDisabled
    }
    
    // 참여자 collection view
    let memberCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.isScrollEnabled = false
        $0.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    let grayLine4 = UIView().then {
        $0.backgroundColor = UIColor.gray50
    }
    
    let historyLabel = UILabel().then {
        $0.text = "히스토리"
        $0.font = UIFont.headline3Bold
        $0.textColor = UIColor.black
        $0.adjustsFontSizeToFitWidth = true
    }
    
    let photoLabel = UILabel().then {
        $0.text = "사진"
        $0.font = UIFont.body2Bold
        $0.textColor = UIColor.textDisabled
    }
    
    let photoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = UIColor.white
        $0.layer.borderColor = UIColor.gray200?.cgColor
        $0.layer.borderWidth = 1
    }
    
    let photoAddButton = UIButton().then {
        $0.setImage(UIImage(named: "imageplus"), for: .normal)
    }
    
    let photoAddLabel = UILabel().then {
        $0.text = "사진 추가"
        $0.font = UIFont.overline
        $0.textColor = UIColor.iconDisabled
        $0.adjustsFontSizeToFitWidth = true
    }
    
    let contentsLabel = UILabel().then {
        $0.text = "내용"
        $0.font = UIFont.body2Bold
        $0.textColor = UIColor.textDisabled
    }
    
    let contentsView = UIView().then {
        $0.backgroundColor = UIColor.white
        $0.layer.borderColor = UIColor.gray200?.cgColor
        $0.layer.borderWidth = 1
    }
    
    private lazy var contentsTextView: UITextView = UITextView().then {
        $0.text = "내용을 입력하세요."
        $0.font = UIFont.body2Medium
        $0.textColor = UIColor.gray100
        $0.isScrollEnabled = false
        $0.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        $0.layer.borderWidth = 0
        $0.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        // navigation bar title "iOS 스터디"로 지정
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "히스토리 등록하기"
        
        // 네비게이션 바 item 추가 - 뒤로가기, 사이드바 버튼
        addNavigationBarItem()
        
        layoutConstraints()
        setupCollectionView()
        
        completionButton.addTarget(self, action: #selector(completionButtonTapped), for: .touchUpInside)
        photoAddButton.addTarget(self, action: #selector(photoAddButtonTapped), for: .touchUpInside)
        
        updatePhotoImageViewSize()
        updateContentsTextViewAppearance()
    }
    
    private func setupCollectionView() {
        memberCollectionView.delegate = self
        memberCollectionView.dataSource = self
        memberCollectionView.register(MemberCollectionViewCell.self, forCellWithReuseIdentifier: MemberCollectionViewCell.cellId)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        
        PlanAPI().getPlanDetail(planId: planId) { plans in
            self.planNameText.text = plans.planName
            self.planDateText.text = plans.date
            self.planTimeText.text = plans.time
            
            self.members = plans.members
            self.memberCollectionView.reloadData()
            
            self.layoutConstraints()
        }
    }
    
    private func addNavigationBarItem() {
        // 사이드바 버튼 추가
        completionButton.addTarget(self, action: #selector(completionButtonTapped), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: completionButton)
        navigationItem.rightBarButtonItem = barButtonItem
    }
}

extension HistoryAddViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        cell.name.textColor = UIColor.textDisabled
        
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

extension HistoryAddViewController {
    private func layoutConstraints() {
        view.addSubview(scrollview)
        scrollview.addSubview(contentView)
        applyConstraintsToscrollview()
        
        contentView.addSubview(planNameLabel)
        contentView.addSubview(planNameText)
        contentView.addSubview(grayLine1)
        applyConstraintsToPlanName()
        
        contentView.addSubview(planDateLabel)
        contentView.addSubview(planDateText)
        contentView.addSubview(grayLine2)
        applyConstraintsToPlanDate()
        
        contentView.addSubview(planTimeLabel)
        contentView.addSubview(planTimeText)
        contentView.addSubview(grayLine3)
        applyConstraintsToPlanTime()
        
        contentView.addSubview(memberLabel)
        contentView.addSubview(memberCollectionView)
        applyConstraintsToMember()
        
        contentView.addSubview(grayLine4)
        contentView.addSubview(historyLabel)
        applyConstraintsToHistory()
        
        contentView.addSubview(photoLabel)
        contentView.addSubview(photoImageView)
        contentView.addSubview(photoAddButton)
        contentView.addSubview(photoAddLabel)
        applyConstraintsToPhoto()
        
        contentView.addSubview(contentsLabel)
        contentView.addSubview(contentsView)
        contentView.addSubview(contentsTextView)
        applyConstraintsToContents()
    }
    
    private func applyConstraintsToscrollview() {
        scrollview.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(0)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollview.contentLayoutGuide)
            make.width.equalTo(scrollview.frameLayoutGuide)
            make.height.equalTo(1200)
        }
    }

    func applyConstraintsToPlanName() {
        planNameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(24)
            make.leading.equalTo(contentView.snp.leading).offset(24)
        }
        planNameText.snp.makeConstraints { make in
            make.top.equalTo(planNameLabel.snp.bottom).offset(10)
            make.leading.equalTo(contentView.snp.leading).offset(24)
            make.trailing.equalTo(contentView.snp.trailing).offset(-24)
        }
        grayLine1.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(planNameText.snp.bottom).offset(8)
            make.leading.equalTo(contentView.snp.leading).offset(24)
            make.trailing.equalTo(contentView.snp.trailing).offset(-24)
        }
    }

    func applyConstraintsToPlanDate() {
        planDateLabel.snp.makeConstraints { make in
            make.top.equalTo(grayLine1.snp.bottom).offset(26)
            make.leading.equalTo(contentView.snp.leading).offset(24)
        }
        planDateText.snp.makeConstraints { make in
            make.top.equalTo(planDateLabel.snp.bottom).offset(10)
            make.leading.equalTo(contentView.snp.leading).offset(24)
            make.trailing.equalTo(contentView.snp.trailing).offset(-24)
        }
        grayLine2.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(planDateText.snp.bottom).offset(8)
            make.leading.equalTo(contentView.snp.leading).offset(24)
            make.trailing.equalTo(contentView.snp.trailing).offset(-24)
        }
    }

    func applyConstraintsToPlanTime() {
        planTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(grayLine2.snp.bottom).offset(26)
            make.leading.equalTo(contentView.snp.leading).offset(24)
        }
        planTimeText.snp.makeConstraints { make in
            make.top.equalTo(planTimeLabel.snp.bottom).offset(10)
            make.leading.equalTo(contentView.snp.leading).offset(24)
            make.trailing.equalTo(contentView.snp.trailing).offset(-24)
        }
        grayLine3.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(planTimeText.snp.bottom).offset(8)
            make.leading.equalTo(contentView.snp.leading).offset(24)
            make.trailing.equalTo(contentView.snp.trailing).offset(-24)
        }
    }

    func applyConstraintsToMember() {
        memberLabel.snp.makeConstraints { make in
            make.top.equalTo(grayLine3.snp.bottom).offset(26)
            make.leading.equalTo(contentView.snp.leading).offset(24)
        }
        memberCollectionView.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-48)
            
            let memberRow = ceil(Double(members.count) / 2.0)
            let height = (memberRow * 42) + ((memberRow - 1) * 10)
            make.height.equalTo(height)
            
            make.top.equalTo(memberLabel.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }

    func applyConstraintsToHistory() {
        grayLine4.snp.makeConstraints { make in
            make.width.equalTo(393)
            make.height.equalTo(12)
            make.top.equalTo(memberCollectionView.snp.bottom).offset(32)
        }
        historyLabel.snp.makeConstraints { make in
            make.width.equalTo(62)
            make.top.equalTo(grayLine4.snp.bottom).offset(24)
            make.leading.equalTo(contentView.snp.leading).offset(24)
        }
    }
    
    func applyConstraintsToPhoto() {
        photoLabel.snp.makeConstraints { make in
            make.top.equalTo(historyLabel.snp.bottom).offset(26)
            make.leading.equalTo(contentView.snp.leading).offset(24)
        }
        photoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(88)
            make.top.equalTo(photoLabel.snp.bottom).offset(8)
            make.leading.equalTo(contentView.snp.leading).offset(24)
        }
        photoAddButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.top.equalTo(photoImageView.snp.top).offset(24)
            make.leading.equalTo(photoImageView.snp.leading).offset(32)
            make.trailing.equalTo(photoImageView.snp.trailing).offset(-32)
        }
        photoAddLabel.snp.makeConstraints { make in
            make.width.equalTo(37)
            make.top.equalTo(photoAddButton.snp.bottom).offset(4)
            make.leading.equalTo(photoImageView.snp.leading).offset(25)
            make.trailing.equalTo(photoImageView.snp.trailing).offset(-26)
        }
    }

    func applyConstraintsToContents() {
        contentsLabel.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.bottom).offset(26)
            make.leading.equalTo(contentView.snp.leading).offset(24)
        }
        contentsView.snp.makeConstraints { make in
            make.width.equalTo(345)
            make.height.equalTo(163)
            make.top.equalTo(contentsLabel.snp.bottom).offset(8)
            make.leading.equalTo(contentView.snp.leading).offset(24)
            make.trailing.equalTo(contentView.snp.trailing).offset(-24)
        }
        contentsTextView.snp.makeConstraints { make in
            make.top.equalTo(contentsView.snp.top).offset(25)
            make.leading.equalTo(contentsView.snp.leading).offset(25)
            make.trailing.equalTo(contentsView.snp.trailing).offset(-25)
        }
    }
}

// MARK: - Button Actions Extensions
extension HistoryAddViewController {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if contentsTextView.textColor == UIColor.gray100 {
            contentsTextView.text = nil
            contentsTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateContentsTextViewAppearance()
        isContentsEntered = !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        updateCompletionButtonColor()
    }

    private func updateContentsTextViewAppearance() {
        let fixedWidth = contentsTextView.frame.size.width
        let newSize = contentsTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        contentsTextView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
    }
    
    @objc private func completionButtonTapped() {
        // 완료 버튼 후
        guard let image = photoImageView.image else { return }
        guard let description = contentsTextView.text else { return }
        HistoryAPI().postHistory(planId: planId, image: image, description: description) { isSuccess in
            if isSuccess {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc private func photoAddButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        isContentsEntered = !textField.text!.isEmpty
        updateCompletionButtonColor()
    }
    
    func updateCompletionButtonColor() {
        if isContentsEntered || isPhotoUploaded {
            completionButton.setTitleColor(.purpleMain, for: .normal)
        } else {
            completionButton.setTitleColor(.textDisabled, for: .normal)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            photoImageView.image = pickedImage
            isPhotoUploaded = true
            updatePhotoImageViewSize()
            updateCompletionButtonColor()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func updatePhotoImageViewSize() {
        photoImageView.clipsToBounds = true
        
        photoImageView.snp.remakeConstraints { make in
            if isPhotoUploaded {
                make.width.height.equalTo(345)
                make.top.equalTo(photoLabel.snp.bottom).offset(8)
                make.leading.equalTo(contentView.snp.leading).offset(24)
            } else {
                make.width.height.equalTo(88)
                make.top.equalTo(photoLabel.snp.bottom).offset(8)
                make.leading.equalTo(contentView.snp.leading).offset(24)
            }
        }
        photoAddButton.snp.makeConstraints { make in
            if isPhotoUploaded {
                make.width.height.equalTo(24)
                make.centerX.equalTo(photoImageView)
                make.centerY.equalTo(photoImageView)
            } else {
                make.width.height.equalTo(24)
                make.top.equalTo(photoImageView.snp.top).offset(24)
                make.leading.equalTo(photoImageView.snp.leading).offset(32)
                make.trailing.equalTo(photoImageView.snp.trailing).offset(-32)
            }
        }
        photoAddLabel.snp.makeConstraints { make in
            if isPhotoUploaded {
                make.width.equalTo(37)
                make.top.equalTo(photoAddButton.snp.bottom).offset(4)
                make.leading.equalTo(photoImageView.snp.leading).offset(25)
                make.trailing.equalTo(photoImageView.snp.trailing).offset(-26)
            } else {
                
            }
        }
    }
}
