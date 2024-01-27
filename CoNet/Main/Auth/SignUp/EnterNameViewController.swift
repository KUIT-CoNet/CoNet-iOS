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

    // Component: xmark image (창 끄기)
    let xMarkView = UIButton().then { $0.setImage(UIImage(named: "closeBtn"), for: .normal) }
    
    // Component: top purple bar
    let topBar = UIView().then {
        $0.layer.backgroundColor = UIColor.purpleMain?.cgColor
    }
    
    // Component: enter name label
    let enterNameLabel = UILabel().then {
        $0.text = "이름을 입력해주세요"
        $0.font = UIFont.headline1
    }
    
    // Component: 이름 입력 텍스트필드
    let nameTextField = UITextField().then {
        $0.placeholder = "이름 입력"
        $0.font = UIFont.body1Regular
        $0.tintColor = UIColor.black
        $0.becomeFirstResponder()
    }
    
    let clearButton = UIButton().then {
        $0.setImage(UIImage(), for: .normal)
    }
    
    // textfield underline
    let underlineView = UIView().then {
        $0.layer.backgroundColor = UIColor.gray100?.cgColor
    }
    
    // Component: 느낌표 마크 1
    let eMarkView1 = UIImageView().then {
        $0.image = UIImage(named: "emarkPurple")
    }
    
    // Component: 이름 입력 조건 label 1
    let nameCondition1 = UILabel().then {
        $0.text = "공백 없이 20자 이내의 한글, 영어, 숫자로 입력해주세요."
        $0.font = UIFont.caption
    }
    
    // Component: 느낌표 마크 2
    let eMarkView2 = UIImageView().then {
        $0.image = UIImage(named: "emarkPurple")
    }
    
    // Component: 이름 입력 조건 label 2
    let nameCondition2 = UILabel().then {
        $0.text = "참여자 간 원활한 소통을 위해 실명을 권장합니다."
        $0.font = UIFont.caption
    }
    
    // Component: 완료 버튼
    let nextBtn = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor.gray200
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
        // x 버튼
        self.xMarkView.addTarget(self, action: #selector(xButtonTapped), for: .touchUpInside)
    }
    
    // 상단 X 버튼 로그인 화면으로 이동
    @objc private func xButtonTapped() {
        logout()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // 로그아웃
    private func logout() {
        let keychain = KeychainSwift()
        keychain.clear()
    }
    
    // 회원가입 api 요청
    @objc func signUp(_ sender: UIView) {
        let isButtonAvailable = nextBtn.backgroundColor?.cgColor == UIColor.purpleMain?.cgColor
        
        if isButtonAvailable {
            let name = nameTextField.text ?? ""
            let isOptionTermSelected = termsSelectedStates?[3] ?? false
            
            AuthAPI().signUp(name: name, optionTerm: isOptionTermSelected) { isSuccess in
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
    
    // 이름 입력 텍스트필드에 값이 입력될 경우 입력한 값이 이름 조건에 맞는지 확인합니다.
    // - Return: 조건에 맞는 경우 -> true, 조건에 맞지 않은 경우 -> false
    @objc func didChangeNameTextField(_ sender: Any?) -> Bool {
        let editText = nameTextField.text
        
        // 아무것도 입력되지 않았을 경우 return true
        if editText == "" {
            underlineView.layer.backgroundColor = UIColor.gray100?.cgColor
            nameCondition1.textColor = UIColor.black
            eMarkView1.image = UIImage(named: "emarkPurple")
            nextBtn.layer.backgroundColor = UIColor.gray200?.cgColor
            clearButton.setImage(UIImage(), for: .normal)
            return true
        }
        
        // 공백없이 한글, 영어, 숫자로만 20자 이내
        let regexPattern = "^[0-9A-Za-z가-힣]{1,20}$"
        guard let _ = editText!.range(of: regexPattern, options: .regularExpression)
        else {
            // 조건 만족하지 않을 경우 return false
            clearButton.setImage(UIImage(named: "emarkRedEmpty"), for: .normal)
            underlineView.layer.backgroundColor = UIColor.error?.cgColor
            nameCondition1.textColor = UIColor.error
            eMarkView1.image = UIImage(named: "emarkRed")
            nextBtn.layer.backgroundColor = UIColor.gray200?.cgColor
            
            return false
        }
        
        // 조건 만족한 경우 return true
        clearButton.setImage(UIImage(named: "clearBtn"), for: .normal)
        underlineView.layer.backgroundColor = UIColor.purpleMain?.cgColor
        nameCondition1.textColor = UIColor.black
        eMarkView1.image = UIImage(named: "emarkPurple")
        nextBtn.layer.backgroundColor = UIColor.purpleMain?.cgColor
        
        return true
    }
    
    // 이름 입력 텍스트필드의 클리어 버튼을 클릭했을 때
    // 입력된 텍스트를 지웁니다.
    @objc func didClickClearButton() {
        if clearButton.currentImage == UIImage(named: "clearBtn") {
            nameTextField.text = ""
        }
    }

    // 텍스트필드 외의 공간 클릭시 키보드가 내려갑니다.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// addView & layoutConstraints
extension EnterNameViewController {
    private func addView() {
        view.addSubview(xMarkView)
        view.addSubview(topBar)
        view.addSubview(enterNameLabel)
        
        view.addSubview(nameTextField)
        view.addSubview(underlineView)
        view.addSubview(clearButton)
        
        view.addSubview(eMarkView1)
        view.addSubview(nameCondition1)
        view.addSubview(eMarkView1)
        view.addSubview(nameCondition2)
        
        view.addSubview(nextBtn)
    }
    
    private func layoutConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        xMarkView.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(24)
            make.leading.equalTo(safeArea.snp.leading).offset(21)
            make.top.equalTo(safeArea.snp.top).offset(21)
        }
        
        topBar.snp.makeConstraints { make in
            make.height.equalTo(4)
            make.leading.equalTo(safeArea.snp.leading).offset(0)
            make.trailing.equalTo(safeArea.snp.trailing).offset(0)
            make.top.equalTo(xMarkView.snp.bottom).offset(14)
        }
        
        enterNameLabel.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.top.equalTo(topBar.snp.bottom).offset(40)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
            make.top.equalTo(enterNameLabel.snp.bottom).offset(42)
        }
        
        underlineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
            make.top.equalTo(nameTextField.snp.bottom).offset(10)
        }
        
        clearButton.snp.makeConstraints { make in
            make.width.equalTo(16)
            make.height.equalTo(16)
            make.trailing.equalTo(nameTextField.snp.trailing).offset(0)
            make.top.equalTo(nameTextField.snp.top).offset(2)
            make.bottom.equalTo(nameTextField.snp.bottom).offset(-2)
        }
        
        eMarkView1.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.width.equalTo(12)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.top.equalTo(underlineView.snp.bottom).offset(12)
        }
        
        nameCondition1.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.leading.equalTo(eMarkView1.snp.trailing).offset(5)
            make.top.equalTo(underlineView.snp.bottom).offset(10)
        }
        
        eMarkView2.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.width.equalTo(12)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.top.equalTo(eMarkView1.snp.bottom).offset(8)
        }
        
        nameCondition2.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.leading.equalTo(eMarkView2.snp.trailing).offset(5)
            make.top.equalTo(nameCondition1.snp.bottom).offset(4)
        }
        
        nextBtn.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
//            make.bottom.equalTo(safeArea.snp.bottom).offset(-46)
            make.bottom.equalTo(safeArea.snp.bottom)
        }
        
    }
}
