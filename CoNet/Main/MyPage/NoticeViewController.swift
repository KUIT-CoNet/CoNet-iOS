//
//  NoticeViewController.swift
//  CoNet
//
//  Created by 이안진 on 2023/07/09.
//

import UIKit

class NoticeViewController: UIViewController {
    let nothingNoticeLabel = UILabel().then {
        $0.text = "등록된 공지가 없습니다."
        $0.font = UIFont.body2Medium
        $0.textColor = UIColor.textMedium
    }
    
    private lazy var noticeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var noticeData: [NoticeResponse] = [NoticeResponse(title: "test1", content: "dkdkdkdk", date: "2024. 01. 11"), NoticeResponse(title: "test1", content: "dkdkdkdk", date: "2024. 01. 11")]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.title = "공지사항"
        
        // background color를 white로 설정 (default: black)
        view.backgroundColor = .white
        
        addView()
        layoutConstraints()
        setupCollectionView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func setupCollectionView() {
        noticeCollectionView.delegate = self
        noticeCollectionView.dataSource = self
        noticeCollectionView.register(NoticeItem.self, forCellWithReuseIdentifier: NoticeItem.registerId)
    }
}

extension NoticeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // 각 셀을 클릭했을 때 이벤트 처리
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    // 셀 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return noticeData.count
    }
    
    // 셀 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoticeItem.registerId, for: indexPath) as? NoticeItem else {
            return UICollectionViewCell()
        }
        
        cell.date.text = noticeData[indexPath.item].date
        cell.title.text = noticeData[indexPath.item].title
        cell.contents.text = noticeData[indexPath.item].content
        
        return cell
    }
    
    // 셀 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 48

        return CGSize(width: width, height: 100)
    }
    
}

// addView, layoutConstraints
extension NoticeViewController {
    private func addView() {
        view.addSubview(nothingNoticeLabel)
        view.addSubview(noticeCollectionView)
    }
    
    private func layoutConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        nothingNoticeLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.top.equalTo(safeArea.snp.top).offset(40)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
        }
        noticeCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeArea.snp.horizontalEdges)
            make.top.equalTo(safeArea.snp.top).offset(40)
            make.bottom.equalTo(safeArea.snp.bottom)
        }
    }
}
