//
//  ChangeNameViewController.swift
//  CoNet
//
//  Created by 이안진 on 2023/07/14.
//

import SnapKit
import Then
import UIKit

class ChangeNameViewController: UIViewController {
    // label: 이름
    let nameLabel = UILabel().then {
        $0.text = "이름"
        $0.font = UIFont.body2Medium
        $0.textColor = UIColor.gray300
    }
    
    // Component: 이름 입력 텍스트필드
    let nameTextField = UITextField().then {
        $0.placeholder = "이름 입력"
        $0.font = UIFont.body1Regular
        $0.tintColor = UIColor.black
        $0.becomeFirstResponder()
    }
    
    // 텍스트 지우기 버튼
    let clearButton = UIButton().then {
        $0.setImage(UIImage(), for: .normal)
    }
    
    // textfield underline
    let underlineView = UIView().then {
        $0.layer.backgroundColor = UIColor.gray100?.cgColor
    }
    
    // FIXME: 헬퍼 message custom view로 만들기
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
    
    // Component: 확인 버튼
    let nextBtn = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor.gray200
        $0.layer.cornerRadius = 12
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "이름변경"
        
        // background color를 white로 설정 (default: black)
        view.backgroundColor = .white
        
        addView()
        layoutConstraints()
        buttonActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    private func buttonActions() {
        // .editingChanged: editing이 될 때마다 didChangeNameTextField 함수가 호출됩니다.
        nameTextField.addTarget(self, action: #selector(didChangeNameTextField(_:)), for: .editingChanged)
        // 텍스트필드 클리어버튼
        clearButton.addTarget(self, action: #selector(didClickClearButton), for: .touchUpInside)
        // 확인 버튼
        nextBtn.addTarget(self, action: #selector(showTabView(_:)), for: .touchUpInside)
    }
    
    // 이름 입력 텍스트필드에 값이 입력될 경우 입력한 값이 이름 조건에 맞는지 확인합니다.
    // - Return: 조건에 맞는 경우 -> true, 조건에 맞지 않은 경우 -> false
    @objc func didChangeNameTextField(_ sender: Any?) {
        guard let newName = nameTextField.text else { return }
        
        if newName.isEmpty {
            // 아무것도 입력되지 않았을 경우 return true
            textFieldStatus(.nothing)
            isConditionCorrect(true)
            nextButtonEnable(false)
        } else if isValidName(newName) == false {
            // 조건 만족하지 않을 경우 return false
            textFieldStatus(.error)
            isConditionCorrect(false)
            nextButtonEnable(false)
        } else {
            // 조건 모두 만족
            textFieldStatus(.correct)
            isConditionCorrect(true)
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
    
    private func isConditionCorrect(_ status: Bool) {
        if status {
            nameCondition1.textColor = UIColor.black
            eMarkView1.image = UIImage(named: "emarkPurple")
        } else {
            nameCondition1.textColor = UIColor.error
            eMarkView1.image = UIImage(named: "emarkRed")
        }
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
        nameTextField.text = ""
        nextButtonEnable(false)
    }
    
    // 텍스트필드 외의 공간 클릭시 키보드가 내려갑니다.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // 확인 버튼 클릭 시
    @objc func showTabView(_ sender: UIView) {
        let newName = nameTextField.text ?? ""
        MyPageAPI().editName(name: newName) { isSuccess in
            if isSuccess {
                // 현재 화면 pop
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

// addView와 layoutConstraints에 대한 extension
extension ChangeNameViewController {
    private func addView() {
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(underlineView)
        view.addSubview(clearButton)
        
        view.addSubview(eMarkView1)
        view.addSubview(nameCondition1)
        view.addSubview(eMarkView2)
        view.addSubview(nameCondition2)
        
        view.addSubview(nextBtn)
    }
    
    private func layoutConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        // label: 이름
        nameLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.top.equalTo(safeArea.snp.top).offset(46)
            make.horizontalEdges.equalTo(view.snp.horizontalEdges).offset(24)
        }
        
        // 이름 텍스트필드
        nameTextField.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
        
        // textfield underline
        underlineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
            make.top.equalTo(nameTextField.snp.bottom).offset(10)
        }
        
        // textfield clear button
        clearButton.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.trailing.equalTo(nameTextField.snp.trailing).offset(0)
            make.top.equalTo(nameTextField.snp.top).offset(2)
            make.bottom.equalTo(nameTextField.snp.bottom).offset(-2)
        }
        
        // Component: 느낌표 마크 1
        eMarkView1.snp.makeConstraints { make in
            make.height.width.equalTo(12)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.top.equalTo(underlineView.snp.bottom).offset(12)
        }
        
        // Component: 이름 입력 조건 label 1
        nameCondition1.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.leading.equalTo(eMarkView1.snp.trailing).offset(5)
            make.top.equalTo(underlineView.snp.bottom).offset(10)
        }
        
        // Component: 느낌표 마크 2
        eMarkView2.snp.makeConstraints { make in
            make.height.width.equalTo(12)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.top.equalTo(eMarkView1.snp.bottom).offset(8)
        }
        
        // Component: 이름 입력 조건 label 2
        nameCondition2.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.leading.equalTo(eMarkView2.snp.trailing).offset(5)
            make.top.equalTo(nameCondition1.snp.bottom).offset(4)
        }
        
        // Component: 확인 버튼
        nextBtn.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
            make.bottom.equalTo(view.snp.bottom).offset(-46)
        }
    }
}
