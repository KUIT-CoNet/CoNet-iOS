//
//  EnterNameViewController.swift
//  CoNet
//
//  Created by 가은 on 2023/07/05.
//

import KeychainSwift
import SnapKit
import Then
import UIKit

class EnterNameViewController: UIViewController, UITextFieldDelegate {
    // 이용약관 페이지에서 넘어온 이용약관 동의 여부
    var termsSelectedStates: [Bool]?
    
    // 회원가입 진행률 - 진행률 (보라색 선)
    let progressBar = UIView().then {
        $0.backgroundColor = UIColor.purpleMain
    }
    
    // 타이틀
    let enterNameLabel = UILabel().then {
        $0.text = "이름을 입력해주세요"
        $0.font = UIFont.headline1
        $0.textColor = UIColor.black
    }
    
    // Component: 이름 입력 텍스트필드
    let nameTextField = UITextField().then {
        $0.placeholder = "이름 입력"
        $0.font = UIFont.body1Regular
        $0.tintColor = UIColor.black
        $0.becomeFirstResponder()
    }
    
    let clearButton = UIButton().then {
        $0.setImage(UIImage(named: "clearBtn"), for: .normal)
    }
    
    // textfield underline
    let underlineView = UIView().then {
        $0.layer.backgroundColor = UIColor.gray100?.cgColor
    }
    
    let nameVaildCondition = TextFieldHelperMessage().then {
        $0.setTitle("공백 없이 20자 이내의 한글, 영어, 숫자로 입력해주세요.")
    }
    
    let realNameCondition = TextFieldHelperMessage().then {
        $0.setTitle("참여자 간 원활한 소통을 위해 실명을 권장합니다.")
    }
    
    // Component: 완료 버튼
    let nextBtn = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor.gray200
        $0.titleLabel?.font = UIFont.body1Medium
        $0.layer.cornerRadius = 12
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // background color를 white로 설정 (default: black)
        view.backgroundColor = .white
        
        addView()
        layoutConstraints()
        buttonActions()
    }
    
    private func buttonActions() {
        // .editingChanged: editing이 될 때마다 didChangeNameTextField 함수가 호출됩니다.
        self.nameTextField.addTarget(self, action: #selector(self.didChangeNameTextField), for: .editingChanged)
        // 텍스트필드 클리어버튼
        self.clearButton.addTarget(self, action: #selector(didClickClearButton), for: .touchUpInside)
        // 완료 버튼
        self.nextBtn.addTarget(self, action: #selector(signUp), for: .touchUpInside)
    }
    
    // 이름 입력 텍스트필드에 값이 입력될 경우 입력한 값이 이름 조건에 맞는지 확인합니다.
    // - Return: 조건에 맞는 경우 -> true, 조건에 맞지 않은 경우 -> false
    @objc func didChangeNameTextField(_ sender: Any?) {
        guard let newName = nameTextField.text else { return }
        
        if newName.isEmpty {
            // 아무것도 입력되지 않았을 경우 return true
            textFieldStatus(.nothing)
            nameVaildCondition.setType(.basic)
            nextButtonEnable(false)
        } else if isValidName(newName) == false {
            // 조건 만족하지 않을 경우 return false
            textFieldStatus(.error)
            nameVaildCondition.setType(.error)
            nextButtonEnable(false)
        } else {
            // 조건 모두 만족
            textFieldStatus(.correct)
            nameVaildCondition.setType(.basic)
            nextButtonEnable(true)
        }
    }
    
    enum TextFieldStatus { case nothing, correct, error }
    private func textFieldStatus(_ type: TextFieldStatus) {
        switch type {
        case .nothing:
            underlineView.layer.backgroundColor = UIColor.gray100?.cgColor
            clearButton.setImage(UIImage(), for: .normal)
        case .correct:
            underlineView.layer.backgroundColor = UIColor.purpleMain?.cgColor
            clearButton.setImage(UIImage(named: "clearBtn"), for: .normal)
        case .error:
            underlineView.layer.backgroundColor = UIColor.error?.cgColor
            clearButton.setImage(UIImage(named: "emarkRedEmpty"), for: .normal)
        }
    }
    
    private func isValidName(_ newName: String) -> Bool {
        let nameRegEx = "^[0-9A-Za-z가-힣]{1,20}$"
        let namePred = NSPredicate(format: "SELF MATCHES %@", nameRegEx)
        return namePred.evaluate(with: newName)
    }
    
    private func nextButtonEnable(_ status: Bool) {
        if status {
            // 다음 버튼 활성화
            nextBtn.layer.backgroundColor = UIColor.purpleMain?.cgColor
            nextBtn.isEnabled = true
        } else {
            // 다음 버튼 비활성화
            nextBtn.layer.backgroundColor = UIColor.gray200?.cgColor
            nextBtn.isEnabled = false
        }
    }
    
    // 이름 입력 텍스트필드의 클리어 버튼을 클릭했을 때
    // 입력된 텍스트를 지웁니다.
    @objc func didClickClearButton() {
        if clearButton.currentImage == UIImage(named: "clearBtn") {
            nameTextField.text = ""
        }
    }
    
    // 회원가입 api 요청
    @objc func signUp(_ sender: UIView) {
        let name = nameTextField.text ?? ""
        let isButtonAvailable = name.isEmpty == false && isValidName(name)
        
        if isButtonAvailable {
            AuthAPI().signUp(name: name) { isSuccess in
                if isSuccess {
                    self.showTabBarViewController()
                }
            }
        }
    }
    
    // TabBarVC로 화면 전환
    func showTabBarViewController() {
        let nextVC = TabbarViewController()
        navigationController?.pushViewController(nextVC, animated: true)
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.changeRootVC(TabbarViewController(), animated: false)
    }
    
    // 텍스트필드 외의 공간 클릭시 키보드가 내려갑니다.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// addView & layoutConstraints
extension EnterNameViewController {
    private func addView() {
        view.addSubview(progressBar)
        view.addSubview(enterNameLabel)
        
        view.addSubview(nameTextField)
        view.addSubview(underlineView)
        view.addSubview(clearButton)
        
        view.addSubview(nameVaildCondition)
        view.addSubview(realNameCondition)
        
        view.addSubview(nextBtn)
    }
    
    private func layoutConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        progressBar.snp.makeConstraints { make in
            make.height.equalTo(4)
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(safeArea.snp.top).offset(24)
        }
        
        enterNameLabel.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.top.equalTo(progressBar.snp.bottom).offset(40)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(enterNameLabel.snp.bottom).offset(42)
        }
        
        underlineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalTo(nameTextField.snp.bottom).offset(8)
        }
        
        clearButton.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.trailing.equalTo(nameTextField.snp.trailing)
            make.centerY.equalTo(nameTextField.snp.centerY)
        }
        
        // 한글, 영어, 숫자 조건 helper message
        nameVaildCondition.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.top.equalTo(underlineView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().offset(24)
        }
        
        // 실명 조건 helper message
        realNameCondition.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.top.equalTo(nameVaildCondition.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().offset(24)
        }
        
        nextBtn.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalTo(safeArea.snp.bottom).inset(20)
        }
    }
}
