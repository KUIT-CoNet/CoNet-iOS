//
//  MonthViewController.swift
//  CoNet
//
//  Created by 가은 on 2023/07/22.
//

import SnapKit
import Then
import UIKit

class MonthViewController: UIViewController {
    let background = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let popUpView = UIView().then {
        $0.layer.backgroundColor = UIColor.white.cgColor
        $0.layer.cornerRadius = 10
        $0.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.12).cgColor
        $0.layer.shadowRadius = 4
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
        $0.layer.shadowOpacity = 1
    }
    
    // 이전 해 버튼
    let prevBtn = UIButton().then {
        $0.setImage(UIImage(named: "prevBtn"), for: .normal)
    }
    
    // label: 년도
    let year = UILabel().then {
        $0.text = "2023"
        $0.font = UIFont.headline2Bold
    }
    
    // 다음 해 버튼
    let nextBtn = UIButton().then {
        $0.setImage(UIImage(named: "nextBtn"), for: .normal)
    }
    
    let monthCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.register(MonthCollectionViewCell.self, forCellWithReuseIdentifier: MonthCollectionViewCell.identifier)
    }
    
    var calendarClosure: ((Int, Int) -> Void)?
    
    init(year: String) {
        self.year.text = year
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monthCollectionView.dataSource = self
        monthCollectionView.delegate = self
        
        layoutConstraints()
        
        btnEvents()
    }
    
    func btnEvents() {
        // 배경 탭
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopUp))
        background.addGestureRecognizer(tapGesture)
        
        prevBtn.addTarget(self, action: #selector(didClickPrevBtn), for: .touchUpInside)
        nextBtn.addTarget(self, action: #selector(didClickNextBtn), for: .touchUpInside)
    }
    
    // 배경 탭 시 팝업 닫기
    @objc func dismissPopUp() {
        dismiss(animated: true, completion: nil)
    }
    
    // 이전 해 이동 버튼
    @objc func didClickPrevBtn() {
        year.text = String((Int(year.text!) ?? 0) - 1)
    }
    
    // 다음 해 이동 버튼
    @objc func didClickNextBtn() {
        year.text = String((Int(year.text!) ?? 0) + 1)
    }
    
    func layoutConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(background)
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(0)
        }
        
        view.addSubview(popUpView)
        popUpView.snp.makeConstraints { make in
            make.top.equalTo(safeArea.snp.top).offset(79)
            make.leading.trailing.equalTo(safeArea).inset(24)
            make.height.equalTo(286)
        }
        
        // 이전 해로 이동 버튼
        popUpView.addSubview(prevBtn)
        prevBtn.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
            make.top.equalTo(popUpView.snp.top).offset(32)
            make.leading.equalTo(popUpView.snp.leading).offset(20)
        }
        
        // label: 해
        popUpView.addSubview(year)
        year.snp.makeConstraints { make in
            make.height.equalTo(26)
            make.top.equalTo(popUpView.snp.top).offset(31)
            make.centerX.equalTo(popUpView.snp.centerX)
        }
        
        // 다음 해로 이동 버튼
        popUpView.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
            make.top.equalTo(popUpView.snp.top).offset(32)
            make.trailing.equalTo(popUpView.snp.trailing).offset(-20)
        }
        
        // month
        popUpView.addSubview(monthCollectionView)
        monthCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(popUpView).inset(18)
            make.top.equalTo(year.snp.bottom).offset(30)
            make.bottom.equalTo(popUpView.snp.bottom).offset(-30)
        }
    }
}

extension MonthViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // 각 셀을 클릭했을 때 이벤트 처리
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected cell at indexPath: \(indexPath)")
        
        // 데이터 전달
        calendarClosure?(Int(year.text!) ?? 0, indexPath.item + 1)
        
        // 팝업 닫기
        dismiss(animated: true, completion: nil)
    }
    
    // 셀 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    // 셀 사이즈 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 99, height: 38)
    }
    
    // 위 아래 space 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
    // 양옆 space 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthCollectionViewCell.identifier, for: indexPath) as? MonthCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureMonth(month: indexPath.item)
        
        return cell
    }
}
