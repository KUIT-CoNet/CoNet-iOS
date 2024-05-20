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
    var noticeData: [NoticeResponse] = []
    let noticeItem = NoticeItem()
    var noticeCellHeight: [CGFloat] = []

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
        noticeAPI()
    }
    
    private func setupCollectionView() {
        noticeCollectionView.delegate = self
        noticeCollectionView.dataSource = self
        noticeCollectionView.register(NoticeItem.self, forCellWithReuseIdentifier: NoticeItem.registerId)
    }
    
    private func noticeAPI() {
        NoticeAPI().getNotice { notices in
            self.noticeData = notices ?? []
            self.noticeCellHeight = Array(repeating: 0.0, count: self.noticeData.count)
            self.noticeCollectionView.reloadData()
        }
    }
}

extension NoticeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // 셀 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if noticeData.count == 0 {
            noticeCollectionView.isHidden = true
        }
        noticeCollectionView.isHidden = false
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
        
        cell.showNoticeContents = { height in
            self.noticeCellHeight[indexPath.item] = height
            collectionView.collectionViewLayout.invalidateLayout()
        }
        
        return cell
    }
    
    // 셀 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 48
        return CGSize(width: width, height: noticeCellHeight[indexPath.item]+50)
    }
    
    // 셀 사이의 위아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
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
