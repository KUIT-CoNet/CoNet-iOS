import Then
import UIKit

class PlanDateButtonSheetViewController: UIViewController {
    let background = UIView().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    let bottomSheetView: UIView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.clipsToBounds = true
    }
    
    let grayLine = UIView().then {
        $0.layer.backgroundColor = UIColor.iconDisabled?.cgColor
        $0.layer.cornerRadius = 1.5
    }
    
    let calendarVC = CalendarViewController()
    
    let applyButton = UIButton().then {
        $0.frame = CGRect(x: 0, y: 0, width: 345, height: 44)
        $0.backgroundColor = UIColor.gray200
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("적용하기", for: .normal)
        $0.titleLabel?.font = UIFont.body1Medium
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }
    
    var date: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addView()
        layoutConstraints()
        
        buttonActions()
        
        // PlanDateButtonSheetViewController의 인스턴스를 CalendarViewController의 프로퍼티에 할당
        calendarVC.makePlanDateSheetVC = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(dataReceivedByCalendarVC(notification:)), name: NSNotification.Name("ToPlanDateSheetVC"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dataReceivedByCalendarVC(notification:)), name: NSNotification.Name("ToMakePlanVC"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(dataReceivedByCalendarV(notification:)), name: NSNotification.Name("ToPlanInfoEditVC"), object: nil)
    }
    
    func buttonActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closePopUp))
        background.addGestureRecognizer(tapGesture)
        
        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
    }
    
    @objc func closePopUp() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func applyButtonTapped() {
        dismiss(animated: true) {
            NotificationCenter.default.post(name: NSNotification.Name("SendDateToMakePlanVC"), object: nil, userInfo: ["date": self.date])
        }
    }
    
    @objc func dataReceivedByCalendarVC(notification: Notification) {
        applyButton.backgroundColor = UIColor.purpleMain
        if let data = notification.userInfo?["date"] as? String {
            self.date = data
            
        }
    }
}

extension PlanDateButtonSheetViewController {
    private func addView() {
        view.addSubview(background)
        view.addSubview(bottomSheetView)
        view.addSubview(grayLine)
        addChild(calendarVC)
        view.addSubview(calendarVC.view)
        view.addSubview(applyButton)
    }
    
    private func layoutConstraints() {
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bottomSheetView.snp.makeConstraints { make in
            make.height.equalTo(400)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom)
        }
        grayLine.snp.makeConstraints { make in
            make.width.equalTo(36)
            make.height.equalTo(3)
            make.top.equalTo(bottomSheetView.snp.top).offset(10)
            make.centerX.equalTo(bottomSheetView)
        }
        calendarVC.didMove(toParent: self)
        calendarVC.view.snp.makeConstraints { make in
            make.height.equalTo(350)
            make.top.equalTo(grayLine.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(bottomSheetView.snp.horizontalEdges)
        }
        applyButton.snp.makeConstraints { make in
            make.width.equalTo(345)
            make.height.equalTo(44)
            make.top.equalTo(calendarVC.view.snp.bottom).offset(22)
            make.leading.equalTo(bottomSheetView.snp.leading).offset(24)
            make.trailing.equalTo(bottomSheetView.snp.trailing).offset(-24)
            make.bottom.equalTo(view.snp.bottom).offset(-45)
        }
    }
}
