//
//  MeetingAddViewController.swift
//  CoNet
//
//  Created by 정아현 on 2023/07/17.
//

import SnapKit
import Then
import UIKit

class MeetingAddViewController: UIViewController, UITextFieldDelegate {
    let xButton = UIButton().then {
        $0.setImage(UIImage(named: "closeBtn"), for: .normal)
    }

    // label: 모임추가 타이틀
    let meetingAddLabel = UILabel().then {
        $0.text = "모임 추가하기"
        $0.font = UIFont.headline3Bold
        $0.textColor = UIColor.black
        $0.numberOfLines = 0
    }
    
    let completionButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.font = UIFont.headline3Medium
        $0.setTitleColor(.textDisabled, for: .normal)
    }
    
    // label: 모임이름
    let meetingnameLabel = UILabel().then {
        $0.text = "모임 이름"
        $0.font = UIFont.body2Bold
        $0.textColor = UIColor.textDisabled
        $0.numberOfLines = 0
    }
    
    let xnameButton = UIButton().then {
        $0.setImage(UIImage(named: "clearBtn"), for: .normal)
        $0.isHidden = true
    }
    
    let meetingnameTextField = UITextField().then {
        $0.placeholder = "모임 이름 입력"
        $0.font = UIFont.headline3Regular
        $0.tintColor = UIColor.textDisabled
        $0.becomeFirstResponder()
    }
    
    // textfield 하단 선
    let grayLine = UIView().then {
        $0.backgroundColor = UIColor.iconDisabled
    }
    
    // label: 입력된 text수
    let textcountLabel = UILabel().then {
        $0.font = UIFont.caption
        $0.textColor = UIColor.textDisabled
    }
    
    // label: 모임 대표 사진
    let meetingphotoLabel = UILabel().then {
        $0.text = "모임 대표 사진"
        $0.font = UIFont.body2Bold
        $0.textColor = UIColor.textDisabled
        $0.numberOfLines = 0
    }
    
    let photoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = UIColor.white
        $0.layer.borderColor = UIColor.gray200?.cgColor
        $0.layer.borderWidth = 1
    }
    
    let photoUploadImage = UIImageView().then {
        $0.image = UIImage(named: "imageplus")
        $0.tintColor = UIColor.iconDisabled
    }
    
    // label: 업로드
    let photoUploadLabel = UILabel().then {
        $0.text = "업로드할 이미지를 첨부해주세요.\n1:1의 정방향 이미지를 추천합니다."
        $0.font = UIFont.body3Medium
        $0.textColor = UIColor.textDisabled
        $0.numberOfLines = 0
    }
    
    let photoUploadButton = UIButton().then {
        $0.setTitle("첨부", for: .normal)
        $0.titleLabel?.font = UIFont.body3Medium
        $0.setTitleColor(.textMedium, for: .normal)
        $0.backgroundColor = UIColor.gray100
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        addView()
        layoutConstriants()
        buttonActions()
        
        meetingnameTextField.delegate = self
    }
    
    // 버튼 addTarget
    func buttonActions() {
        xButton.addTarget(self, action: #selector(xButtonTapped), for: .touchUpInside)
        photoUploadButton.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
        meetingnameTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        xnameButton.addTarget(self, action: #selector(xnameButtonTapped), for: .touchUpInside)
        completionButton.addTarget(self, action: #selector(createMeeting), for: .touchUpInside)
    }
    
    // 텍스트필드 20글자 제한
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField.text!.count < 20 else {
            return false
        }
        return true
    }
    
    // 텍스트필드 관련 색상 설정(수정시)
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == meetingnameTextField {
            grayLine.backgroundColor = UIColor.purpleMain
        }
    }

    // 텍스트필드 관련 색상 설정(수정 완료시)
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == meetingnameTextField {
            grayLine.backgroundColor = UIColor.iconDisabled
        }
    }

    @objc private func xButtonTapped() {
        dismiss(animated: true) {
            if let tabBarController = self.presentingViewController as? TabbarViewController {
                tabBarController.selectedIndex = 1
            }
        }
    }
    
    // 텍스트 필드 내용 변경 시
    @objc private func textFieldEditingChanged() {
        guard let text = meetingnameTextField.text else { return }
        let nameCount = text.count
        xnameButton.isHidden = nameCount == 0
        completionButton.isEnabled = !text.isEmpty && photoImageView.image != nil
        
        if nameCount > 20 {
            xnameButton.setImage(UIImage(named: "emarkRedEmpty"), for: .normal)
        } else {
            xnameButton.setImage(UIImage(named: "clearBtn"), for: .normal)
        }
        completionButton.setTitleColor(completionButton.isEnabled ? .purpleMain : .textDisabled, for: .normal)
        
        textcountLabel.text = "\(nameCount)/20"
    }
    
    // x버튼 클릭 시
    @objc private func xnameButtonTapped() {
        meetingnameTextField.text = ""
        textFieldEditingChanged()
    }
    
    @objc private func uploadButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // 모임 생성
    @objc func createMeeting() {
        guard let newName = meetingnameTextField.text else { return }
        guard let selectedImage = photoImageView.image else { return }
        MeetingAPI().createMeeting(name: newName, image: selectedImage) { isSuccess in
            if isSuccess {
                self.dismiss(animated: true)
            }
        }
    }
}

extension MeetingAddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            photoImageView.image = selectedImage
            photoImageView.alpha = 0.8
            photoUploadButton.setTitle("수정", for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
        textFieldEditingChanged()
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// addView, layout
extension MeetingAddViewController {
    func addView() {
        self.view.addSubview(xButton)
        self.view.addSubview(meetingAddLabel)
        self.view.addSubview(completionButton)
        self.view.addSubview(meetingnameLabel)
        self.view.addSubview(xnameButton)
        self.view.addSubview(meetingnameTextField)
        self.view.addSubview(grayLine)
        self.view.addSubview(textcountLabel)
        self.view.addSubview(meetingphotoLabel)
        self.view.addSubview(photoImageView)
        self.view.addSubview(photoUploadImage)
        self.view.addSubview(photoUploadLabel)
        self.view.addSubview(photoUploadButton)
    }
    
    func layoutConstriants() {
        applyConstraintsToTopSection()
        applyConstraintsToGathername()
        applyConstraintsToGatherphoto()
    }
    
    func applyConstraintsToTopSection() {
        let safeArea = view.safeAreaLayoutGuide
        
        xButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.top.equalTo(safeArea.snp.top).offset(41)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
        }
        completionButton.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.top.equalTo(safeArea.snp.top).offset(42)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
        }
        meetingAddLabel.snp.makeConstraints { make in
            make.top.equalTo(safeArea.snp.top).offset(42)
            make.leading.equalTo(safeArea.snp.leading).offset(149)
        }
    }
    
    func applyConstraintsToGathername() {
        let safeArea = view.safeAreaLayoutGuide
        
        meetingnameLabel.snp.makeConstraints { make in
            make.top.equalTo(xButton.snp.bottom).offset(45)
            make.horizontalEdges.equalTo(safeArea.snp.horizontalEdges).offset(24)
        }
        meetingnameTextField.snp.makeConstraints { make in
            make.top.equalTo(meetingnameLabel.snp.bottom).offset(10)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-40)
        }
        xnameButton.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.top.equalTo(meetingnameLabel.snp.bottom).offset(13)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
        }
        grayLine.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(345)
            make.top.equalTo(meetingnameLabel.snp.bottom).offset(40)
            make.centerX.equalTo(safeArea.snp.centerX)
        }
        textcountLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.top.equalTo(grayLine.snp.bottom).offset(4)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
        }
    }
    
    func applyConstraintsToGatherphoto() {
        let safeArea = view.safeAreaLayoutGuide
        
        meetingphotoLabel.snp.makeConstraints { make in
            make.height.equalTo(14)
            make.top.equalTo(grayLine.snp.bottom).offset(32)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
        }
        photoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(345)
            make.top.equalTo(meetingphotoLabel.snp.bottom).offset(8)
            make.centerX.equalTo(safeArea.snp.centerX)
        }
        photoUploadImage.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.top.equalTo(meetingphotoLabel.snp.bottom).offset(122)
            make.centerX.equalTo(photoImageView.snp.centerX)
        }
        photoUploadLabel.snp.makeConstraints { make in
            make.top.equalTo(photoUploadImage.snp.bottom).offset(6)
            make.centerX.equalTo(photoImageView.snp.centerX)
        }
        photoUploadButton.snp.makeConstraints { make in
            make.width.equalTo(51)
            make.height.equalTo(28)
            make.top.equalTo(photoUploadLabel.snp.bottom).offset(20)
            make.centerX.equalTo(photoImageView.snp.centerX)
        }
    }
}
