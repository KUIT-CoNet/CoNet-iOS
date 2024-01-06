//
//  MeetingInfoEditViewController.swift
//  CoNet
//
//  Created by 정아현 on 2023/07/20.
//

import SnapKit
import Then
import UIKit

class MeetingInfoEditViewController: UIViewController, UITextFieldDelegate {
    var meetingId: Int = 0
    
    let xButton = UIButton().then {
        $0.setImage(UIImage(named: "closeBtn"), for: .normal)
    }
    
    let meetingInfoEditLabel = UILabel().then {
        $0.text = "모임 정보 수정"
        $0.font = UIFont.headline3Bold
        $0.textColor = UIColor.black
        $0.numberOfLines = 0
    }
    
    let completionButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.font = UIFont.headline3Medium
        $0.setTitleColor(.textDisabled, for: .normal)
    }
    
    let meetingnameLabel = UILabel().then {
        $0.text = "모임 이름"
        $0.font = UIFont.body2Bold
        $0.textColor = UIColor.textDisabled
        $0.numberOfLines = 0
    }
    
    // 텍스크 필드 x 버튼
    let xnameButton = UIButton().then {
        $0.setImage(UIImage(named: "clearBtn"), for: .normal)
        $0.isHidden = false
    }
    
    let meetingnameTextField = UITextField().then {
        $0.placeholder = "모임 이름 입력"
        $0.font = UIFont.headline3Regular
        $0.tintColor = UIColor.textDisabled
        $0.becomeFirstResponder()
    }
    
    let grayLine = UIView().then {
        $0.backgroundColor = UIColor.iconDisabled
    }
    
    // 텍스트 수 라벨
    let textCountLabel = UILabel().then {
        $0.font = UIFont.caption
        $0.textColor = UIColor.textDisabled
        $0.isHidden = false
    }
    
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
    
    let photoUploadLabel = UILabel().then {
        $0.text = "업로드할 이미지를 첨부해주세요.\n1:1의 정방향 이미지를 추천합니다."
        $0.font = UIFont.body3Medium
        $0.textColor = UIColor.textDisabled
        $0.numberOfLines = 0
    }
    
    // 사진 수정 버튼
    let photoEditButton = UIButton().then {
        $0.setTitle("수정", for: .normal)
        $0.titleLabel?.font = UIFont.body3Medium
        $0.setTitleColor(.textMedium, for: .normal)
        $0.backgroundColor = UIColor.gray100
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        addView()
        layoutConstriants()
        buttonClicks()
        meetingnameTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.meetingnameTextField.becomeFirstResponder()
        MeetingAPI().getMeetingDetailInfo(teamId: meetingId) { meeting in
            self.meetingnameTextField.text = meeting.name
            guard let url = URL(string: meeting.imgUrl) else { return }
            self.photoImageView.kf.setImage(with: url)
            self.photoImageView.alpha = 0.8
            self.updateTextCountLabel()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 버튼 addTarget
    func buttonActions() {
        completionButton.addTarget(self, action: #selector(updateMeeting), for: .touchUpInside)
        xButton.addTarget(self, action: #selector(xButtonTapped), for: .touchUpInside)
        photoEditButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        meetingnameTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        xnameButton.addTarget(self, action: #selector(xnameButtonTapped), for: .touchUpInside)
    }
    
    func updateTextCountLabel() {
        let nameCount = meetingnameTextField.text?.count ?? 0
        textCountLabel.text = "\(nameCount)/20"
    }
    
    // 텍스트필드 클릭 시
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == meetingnameTextField {
            grayLine.backgroundColor = UIColor.purpleMain
            textCountLabel.textColor = UIColor.black
        }
    }
    
    // x버튼 클릭시
    @objc private func xButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // 텍스트필드 내용 변경 시
    @objc private func textFieldEditingChanged() {
        guard let text = meetingnameTextField.text else { return }
        completionButton.isEnabled = !text.isEmpty && photoImageView.image != nil
        
        if text.count > 20 {
            xnameButton.setImage(UIImage(named: "emarkRedEmpty"), for: .normal)
        } else {
            xnameButton.setImage(UIImage(named: "clearBtn"), for: .normal)
        }
        completionButton.setTitleColor(completionButton.isEnabled ? .purpleMain : .textDisabled, for: .normal)
        updateTextCountLabel()
        textFieldDidBeginEditing(meetingnameTextField)
    }
    
    // 텍스트필드 x버튼 클릭시
    @objc private func xnameButtonTapped() {
        meetingnameTextField.text = ""
        textFieldEditingChanged()
    }
    
    // 사진 업로드버튼 클릭시
    @objc private func editButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func updateMeeting() {
        guard let name = meetingnameTextField.text else { return }
        guard let image = photoImageView.image else { return }
        
        MeetingAPI().updateMeeting(id: meetingId, name: name, image: image) { isSuccess in
            if isSuccess {
                print("DEBUG (모임 수정 api): isSuccess true")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension MeetingInfoEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            photoImageView.image = selectedImage
            photoImageView.alpha = 0.8
        }
        picker.dismiss(animated: true, completion: nil)
        textFieldEditingChanged()
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// addView, layout
extension MeetingInfoEditViewController {
    func addView() {
        self.view.addSubview(xButton)
        self.view.addSubview(meetingInfoEditLabel)
        self.view.addSubview(completionButton)
        self.view.addSubview(meetingnameLabel)
        self.view.addSubview(xnameButton)
        self.view.addSubview(meetingnameTextField)
        self.view.addSubview(grayLine)
        self.view.addSubview(textCountLabel)
        self.view.addSubview(meetingphotoLabel)
        self.view.addSubview(photoImageView)
        self.view.addSubview(photoUploadImage)
        self.view.addSubview(photoUploadLabel)
        self.view.addSubview(photoEditButton)
    }
    
    func layoutConstriants() {
        applyConstraintsToTopSection()
        applyConstraintsToMeetingname()
        applyConstraintsToMeetingphoto()
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
        meetingInfoEditLabel.snp.makeConstraints { make in
            make.top.equalTo(safeArea.snp.top).offset(42)
            make.leading.equalTo(xButton.snp.trailing).offset(99)
        }
    }
    
    func applyConstraintsToMeetingname() {
        let safeArea = view.safeAreaLayoutGuide
        
        meetingnameLabel.snp.makeConstraints { make in
            make.top.equalTo(xButton.snp.bottom).offset(45)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
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
            make.top.equalTo(meetingnameLabel.snp.bottom).offset(40)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
        }
        textCountLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.top.equalTo(grayLine.snp.bottom).offset(4)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
        }
    }
    
    func applyConstraintsToMeetingphoto() {
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
            make.centerX.equalTo(safeArea.snp.centerX)
        }
        photoUploadLabel.snp.makeConstraints { make in
            make.top.equalTo(photoUploadImage.snp.bottom).offset(6)
            make.centerX.equalTo(safeArea.snp.centerX)
        }
        photoEditButton.snp.makeConstraints { make in
            make.top.equalTo(photoUploadLabel.snp.bottom).offset(20)
            make.centerX.equalTo(safeArea.snp.centerX)
        }
    }
}
