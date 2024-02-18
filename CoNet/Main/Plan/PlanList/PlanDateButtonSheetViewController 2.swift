import Then
import UIKit

class PlanDateButtonSheetViewController: UIViewController {
    // 배경 비쳐보이는 view
    private let dimmedView: UIView = UIView().then {
        $0.backgroundColor = UIColor.darkGray.withAlphaComponent(0.8)
    }
    private let bottomSheetView: UIView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.clipsToBounds = true
    }
    // bottomSheet 높이 조절
    private var bottomSheetViewTopConstraint: NSLayoutConstraint?
    // 열린 BottomSheet의 기본 높이
    var defaultHeight: CGFloat = 469
    let calendarView = CalendarView()
    let applyButton = UIButton().then {
        $0.frame = CGRect(x: 0, y: 0, width: 345, height: 44)
        $0.backgroundColor = UIColor.gray200
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("적용하기", for: .normal)
        $0.titleLabel?.font = UIFont.body1Medium
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(dimmedView)
        view.addSubview(bottomSheetView)
        view.addSubview(calendarView)
        view.addSubview(applyButton)
        
        dimmedView.alpha = 0.0
        layoutConstraints()
        
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedView.addGestureRecognizer(dimmedTap)
        dimmedView.isUserInteractionEnabled = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        defaultHeight = 469
        showBottomSheet()
    }
    
    private func showBottomSheet() {
        let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom
        
        bottomSheetViewTopConstraint?.constant = (safeAreaHeight + bottomPadding) - defaultHeight
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedView.alpha = 0.7
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func hideBottomSheetAndGoBack() {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        bottomSheetViewTopConstraint?.constant = safeAreaHeight + bottomPadding
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedView.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        })
    }

    private func layoutConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bottomSheetView.snp.makeConstraints { make in
            make.top.equalTo(safeArea.snp.top).offset(290)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        calendarView.snp.makeConstraints { make in
            make.height.equalTo(448)
            make.top.equalTo(bottomSheetView.snp.top).offset(0)
            make.leading.equalTo(bottomSheetView.snp.leading).offset(0)
            make.trailing.equalTo(bottomSheetView.snp.trailing).offset(0)
            make.bottom.equalTo(applyButton.snp.bottom).offset(22)
        }
        applyButton.snp.makeConstraints { make in
            make.width.equalTo(345)
            make.height.equalTo(44)
            make.top.equalTo(calendarView.calendarCollectionView.snp.bottom).offset(22)
            make.leading.equalTo(bottomSheetView.snp.leading).offset(24)
            make.trailing.equalTo(bottomSheetView.snp.trailing).offset(-24)
        }
    }
    
    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideBottomSheetAndGoBack()
    }
}
#if canImport(SwiftUI) && DEBUG
 import SwiftUI

 struct ViewControllerPreview: PreviewProvider {
     static var previews: some View {
         PlanDateButtonSheetViewController().showPreview(.iPhone14Pro)
     }
 }
 #endif
