//
//  PlanTimePickerViewController.swift
//  CoNet
//
//  Created by 정아현 on 2023/07/27.
//

import SnapKit
import Then
import UIKit

class PlanTimePickerViewController: UIViewController {
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
    
    let timePicker = UIDatePicker().then {
        $0.datePickerMode = .time
        $0.preferredDatePickerStyle = .wheels
    }
    
    let applyButton = UIButton().then {
        $0.frame = CGRect(x: 0, y: 0, width: 345, height: 52)
        $0.backgroundColor = UIColor.purpleMain
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("적용하기", for: .normal)
        $0.titleLabel?.font = UIFont.body1Medium
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    var formattedTime = ""
    var onDismiss: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        addView()
        layoutConstraints()
        buttonActions()
    }
    
    func buttonActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopUp))
        background.addGestureRecognizer(tapGesture)
        
        timePicker.addTarget(self, action: #selector(timePickerValueChanged(_:)), for: .valueChanged)
        applyButton.addTarget(self, action: #selector(didClickApplyButton), for: .touchUpInside)
    }
    
    @objc func dismissPopUp() {
        self.onDismiss?()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didClickApplyButton() {
        self.onDismiss?()
        NotificationCenter.default.post(name: NSNotification.Name("ToPlanInfoEditVC"), object: nil, userInfo: ["time": formattedTime])
        dismissPopUp()
    }
    
    // timePicker에 변화가 있을 때
    @objc func timePickerValueChanged(_ sender: UIDatePicker) {
        let selectedTime = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "HH:mm"  // 24시간제
        
        formattedTime = dateFormatter.string(from: selectedTime)
    }
}

extension PlanTimePickerViewController {
    func addView() {
        view.addSubview(background)
        view.addSubview(bottomSheet)
        view.addSubview(grayLine)
        view.addSubview(timePicker)
        view.addSubview(applyButton)
    }
    
    func layoutConstraints() {
        applyConstraintsToBackground()
        applyConstraintsToComponents()
    }
    
    func applyConstraintsToBackground() {
        let safeArea = view.safeAreaLayoutGuide
        
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bottomSheet.snp.makeConstraints { make in
            make.height.equalTo(337)
            make.top.equalTo(safeArea.snp.top).offset(471)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    func applyConstraintsToComponents() {
        grayLine.snp.makeConstraints { make in
            make.width.equalTo(36)
            make.height.equalTo(3)
            make.top.equalTo(bottomSheet.snp.top).offset(10)
            make.centerX.equalTo(bottomSheet.snp.centerX)
        }
        timePicker.snp.makeConstraints { make in
            make.width.equalTo(335)
            make.height.equalTo(164)
            make.top.equalTo(grayLine.snp.bottom).offset(36)
            make.centerX.equalTo(bottomSheet.snp.centerX)
        }
        applyButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.centerX.equalTo(bottomSheet.snp.centerX)
            make.horizontalEdges.equalTo(bottomSheet.snp.horizontalEdges).inset(24)
            make.bottom.equalTo(view.snp.bottom).offset(-45)
        }
    }
}
