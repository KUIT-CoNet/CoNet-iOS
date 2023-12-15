//
//  GatherAddViewController.swift
//  CoNet
//
//  Created by 정아현 on 2023/07/17.
//

import SnapKit
import Then
import UIKit

class MeetingAddViewController: UIViewController {
    let xButton = UIButton().then {
        $0.setImage(UIImage(named: "closeBtn"), for: .normal)
    }
    let gatherAddLabel = UILabel().then {
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
    let gathernameLabel = UILabel().then {
        $0.text = "모임 이름"
        $0.font = UIFont.body2Bold
        $0.textColor = UIColor.textDisabled
        $0.numberOfLines = 0
    }
    let xnameButton = UIButton().then {
        $0.setImage(UIImage(named: "clearBtn"), for: .normal)
        $0.isHidden = true
    }
    let gathernameTextField = UITextField().then {
        $0.placeholder = "모임 이름 입력"
        $0.font = UIFont.headline3Regular
        $0.tintColor = UIColor.textDisabled
        $0.becomeFirstResponder()
    }
    let grayLine = UIView().then {
        $0.backgroundColor = UIColor.iconDisabled
    }
    let textCountLabel = UILabel().then {
        $0.font = UIFont.caption
        $0.textColor = UIColor.textDisabled
    }
    let gatherphotoLabel = UILabel().then {
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
    let photoUploadButton = UIButton().then {
        $0.setTitle("첨부", for: .normal)
        $0.titleLabel?.font = UIFont.body3Medium
        $0.setTitleColor(.textMedium, for: .normal)
        $0.backgroundColor = UIColor.gray100
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(xButton)
        self.view.addSubview(gatherAddLabel)
        self.view.addSubview(completionButton)
        applyConstraintsToTopSection()
        
        self.view.addSubview(gathernameLabel)
        self.view.addSubview(xnameButton)
        self.view.addSubview(gathernameTextField)
        self.view.addSubview(grayLine)
        self.view.addSubview(textCountLabel)
        applyConstraintsToGathername()
        
        self.view.addSubview(gatherphotoLabel)
        self.view.addSubview(photoImageView)
        self.view.addSubview(photoUploadImage)
        self.view.addSubview(photoUploadLabel)
        self.view.addSubview(photoUploadButton)
        applyConstraintsToGatherphoto()
        
        xButton.addTarget(self, action: #selector(xButtonTapped), for: .touchUpInside)
        photoUploadButton.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
        gathernameTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        xnameButton.addTarget(self, action: #selector(xnameButtonTapped), for: .touchUpInside)
        completionButton.addTarget(self, action: #selector(createMeeting), for: .touchUpInside)
    }
    
    @objc func createMeeting() {
        guard let newName = gathernameTextField.text else { return }
        guard let selectedImage = photoImageView.image else { return }
        MeetingAPI().createMeeting(name: newName, image: selectedImage) { isSuccess in
            if isSuccess {
                self.dismiss(animated: true)
            }
        }
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
        gatherAddLabel.snp.makeConstraints { make in
            make.top.equalTo(safeArea.snp.top).offset(42)
            make.leading.equalTo(safeArea.snp.leading).offset(149)
        }
    }
    
    func applyConstraintsToGathername() {
        let safeArea = view.safeAreaLayoutGuide
        
        gathernameLabel.snp.makeConstraints { make in
            make.top.equalTo(xButton.snp.bottom).offset(45)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
        }
        gathernameTextField.snp.makeConstraints { make in
            make.top.equalTo(gathernameLabel.snp.bottom).offset(10)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
        }
        xnameButton.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.top.equalTo(gathernameLabel.snp.bottom).offset(13)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
        }
        grayLine.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(gathernameLabel.snp.bottom).offset(40)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
        }
        textCountLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.top.equalTo(grayLine.snp.bottom).offset(4)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
        }
    }
    
    func applyConstraintsToGatherphoto() {
        let safeArea = view.safeAreaLayoutGuide
        
        gatherphotoLabel.snp.makeConstraints { make in
            make.height.equalTo(14)
            make.top.equalTo(grayLine.snp.bottom).offset(32)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
        }
        photoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(345)
            make.top.equalTo(gatherphotoLabel.snp.bottom).offset(8)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
        }
        photoUploadImage.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.top.equalTo(gatherphotoLabel.snp.bottom).offset(122)
            make.leading.equalTo(safeArea.snp.leading).offset(181)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-180)
        }
        photoUploadLabel.snp.makeConstraints { make in
            make.top.equalTo(photoUploadImage.snp.bottom).offset(6)
            make.leading.equalTo(photoImageView.snp.leading).offset(95)
            make.trailing.equalTo(photoImageView.snp.trailing).offset(95)
        }
        photoUploadButton.snp.makeConstraints { make in
            make.top.equalTo(photoUploadLabel.snp.bottom).offset(20)
            make.leading.equalTo(photoImageView.snp.leading).offset(147)
            make.trailing.equalTo(photoImageView.snp.trailing).offset(-147)
        }
    }
    
    @objc private func xButtonTapped() {
        dismiss(animated: true) {
            if let tabBarController = self.presentingViewController as? TabbarViewController {
                tabBarController.selectedIndex = 1
            }
        }
    }
    
    @objc private func textFieldEditingChanged() {
        guard let text = gathernameTextField.text else { return }
        let nameCount = text.count
        xnameButton.isHidden = nameCount == 0
        completionButton.isEnabled = !text.isEmpty && photoImageView.image != nil
        
        if nameCount > 30 {
            xnameButton.setImage(UIImage(named: "emarkRedEmpty"), for: .normal)
        } else {
            xnameButton.setImage(UIImage(named: "clearBtn"), for: .normal)
        }
        completionButton.setTitleColor(completionButton.isEnabled ? .purpleMain : .textDisabled, for: .normal)
        
        textCountLabel.text = "\(nameCount)/30"
    }
    
    @objc private func xnameButtonTapped() {
        gathernameTextField.text = ""
        textFieldEditingChanged()
    }
    
    @objc private func uploadButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
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
