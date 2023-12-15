//
//  MeetingViewController.swift
//  CoNet
//
//  Created by 정아현 on 2023/08/01.
//

import Kingfisher
import SnapKit
import Then
import UIKit

class MeetingCell: UICollectionViewCell {
    static let identifier = "MeetingCell"
    var meetingId: Int = 0

    let imageView = UIImageView().then { $0.image = UIImage(named: "uploadImageWithNoDescription") }

    let titleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.text = "제목은 최대 두 줄, 더 길어지면 말 줄임표를 사용"
        $0.font = UIFont.body1Bold
    }

    let starButton = UIButton()
    let newImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutConstraints()
        starButton.addTarget(self, action: #selector(starButtonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutConstraints() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(starButton)
        contentView.addSubview(newImageView)

        imageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.width.equalTo(164)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
        }

        starButton.snp.makeConstraints { make in
            make.top.equalTo(imageView).offset(8)
            make.trailing.equalTo(imageView).offset(-8)
        }

        newImageView.snp.makeConstraints { make in
            make.width.equalTo(31)
            make.height.equalTo(12)
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.equalTo(imageView)
        }
    }
    
    var onStarButtonTapped: (() -> Void)?
    
    @objc func starButtonTapped() {
        onStarButtonTapped?()
    }
}

class MeetingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var item: UIStackView!
    var meetings: [MeetingDetailInfo] = []
    var favoritedMeetings: [MeetingDetailInfo] = []
    
    // 각 셀을 클릭했을 때 이벤트 처리
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = MeetingMainViewController()
        nextVC.hidesBottomBarWhenPushed = true
        nextVC.meetingId = meetings[indexPath.item].id
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == favcollectionView {
            return favoritedMeetings.count
        } else {
            return meetings.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MeetingCell.identifier, for: indexPath) as? MeetingCell else {
            return UICollectionViewCell()
        } 
        
//        if selectedTabIndicator.frame.origin.x == favTab.frame.origin.x {
//            meetingIndex = favoritedMeetings[indexPath.row]
//        } else {
//            meetingIndex = indexPath.row
//        }
      
        // url로 image 불러오기 (with KingFisher)
        let url = URL(string: meetings[indexPath.item].imgUrl)!
        cell.imageView.kf.setImage(with: url, placeholder: UIImage(named: "uploadImageWithNoDescription"))
        
        // 모임 이름
        cell.titleLabel.text = meetings[indexPath.item].name
        
        // 북마크 여부
        if meetings[indexPath.item].bookmark {
            cell.starButton.setImage(UIImage(named: "fullstar"), for: .normal)
        } else {
            cell.starButton.setImage(UIImage(named: "star"), for: .normal)
        }
        
        // 북마크 기능
        cell.onStarButtonTapped = {
            if cell.starButton.currentImage == UIImage(named: "fullstar") {
                // 북마크 되어 있을 때
                MeetingAPI().postDeleteBookmark(teamId: self.meetings[indexPath.item].id) { isSuccess in
                    if isSuccess {
                        cell.starButton.setImage(UIImage(named: "star"), for: .normal)
                    }
                }
            } else {
                // 북마크 되어 있지 않을 때
                MeetingAPI().postBookmark(teamId: self.meetings[indexPath.item].id) { isSuccess in
                    if isSuccess {
                        cell.starButton.setImage(UIImage(named: "fullstar"), for: .normal)
                    }
                }
            }
        }
        
        // new 태그
        if meetings[indexPath.item].isNew {
            cell.newImageView.image = UIImage(named: "new")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let _: CGFloat = (collectionView.frame.width / 2) - 17
        return CGSize(width: 164, height: 232)
    }
    
    let refreshControl = UIRefreshControl()
    
    let gatherLabel = UILabel().then {
        $0.text = "모임"
        $0.font = UIFont.headline1
    }
    
    let gatherNumCircle = UIImageView().then {
        $0.image = UIImage(named: "calendarCellSelected")
    }
    
    let gatherNum = UILabel().then {
        $0.text = "4"
        $0.textColor = UIColor.purpleMain
        $0.font = UIFont.body3Bold
    }
    
    let allTab = UIButton().then {
        $0.setTitle("전체", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.headline3Bold
    }
    
    let favTab = UIButton().then {
        $0.setTitle("즐겨찾기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.headline3Bold
    }
    
    let selectedTabIndicator = UIView().then {
        $0.backgroundColor = UIColor.purpleMain
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
            
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
        
    let favcollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    let plusButton = UIButton().then {
        $0.setImage(UIImage(named: "plus"), for: .normal)
    }
    
    let peopleButton = UIButton().then {
        $0.setImage(UIImage(named: "gatherPeople"), for: .normal)
    }
    
    let participateButton = UIButton().then {
        $0.setImage(UIImage(named: "add"), for: .normal)
    }
    
    let joinLabel = UILabel().then {
        $0.text = "모임 참여"
        $0.font = UIFont.body1Bold
        $0.textColor = UIColor.white
    }
    
    let addLabel = UILabel().then {
        $0.text = "모임 추가"
        $0.font = UIFont.body1Bold
        $0.textColor = UIColor.white
    }
    
    let overlayView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        navigationItem.title = ""
        
        item = UIStackView(arrangedSubviews: [allTab, favTab]).then {
            $0.axis = .horizontal
            $0.spacing = 17
        }
        
        self.view.backgroundColor = .white
        
        layoutConstriants()
        
        // UIRefreshControl을 UICollectionView에 추가
        collectionView.refreshControl = refreshControl
        favcollectionView.refreshControl = refreshControl
        
        // UIRefreshControl의 새로고침 동작 설정
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        setupCollectionView()
        collectionView.showsVerticalScrollIndicator = false
        
        setupFavCollectionView()
        
        allTab.addTarget(self, action: #selector(didSelectAllTab), for: .touchUpInside)
        favTab.addTarget(self, action: #selector(didSelectFavoriteTab), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(didTapPlusButton), for: .touchUpInside)
        participateButton.addTarget(self, action: #selector(didTapparticipateButton), for: .touchUpInside)
        peopleButton.addTarget(self, action: #selector(didTapPeopleButton), for: .touchUpInside)
        
        UIView.animate(withDuration: 0.3) {
            self.peopleButton.alpha = 0
            self.participateButton.alpha = 0
            self.joinLabel.alpha = 0
            self.addLabel.alpha = 0
            self.overlayView.alpha = 0
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopUp))
        overlayView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllMeetings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getAllMeetings()
    }
    
    // 배경 탭 시 팝업 꺼짐
    @objc func dismissPopUp() {
        plusButton.setImage(UIImage(named: "plus"), for: .normal)
        
        UIView.animate(withDuration: 0.3) {
            self.peopleButton.alpha = 0
            self.participateButton.alpha = 0
            self.joinLabel.alpha = 0
            self.addLabel.alpha = 0
            self.overlayView.alpha = 0
        }
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MeetingCell.self, forCellWithReuseIdentifier: MeetingCell.identifier)
    }
    
    func setupFavCollectionView() {
        favcollectionView.dataSource = self
        favcollectionView.delegate = self
        favcollectionView.register(MeetingCell.self, forCellWithReuseIdentifier: MeetingCell.identifier)
    }
    
    // UIRefreshControl의 새로고침 동작을 처리하는 메서드
    @objc func refreshData() {
        // 여기에 새로고침을 수행하는 코드를 작성
        getAllMeetings()
        getBookmarkedMeetings()
        
        // 새로고침 완료 후 refreshControl.endRefreshing()을 호출하여 새로고침 상태를 종료
        refreshControl.endRefreshing()
    }
    
    @objc func didSelectAllTab() {
        getAllMeetings()
        
        selectedTabIndicator.snp.remakeConstraints { make in
            make.top.equalTo(allTab.snp.bottom).offset(2)
            make.height.equalTo(2)
            make.left.right.equalTo(allTab)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func didSelectFavoriteTab() {
        getBookmarkedMeetings()
        
        selectedTabIndicator.snp.remakeConstraints { make in
            make.top.equalTo(favTab.snp.bottom).offset(2)
            make.height.equalTo(2)
            make.left.right.equalTo(favTab)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func getAllMeetings() {
        MeetingAPI().getMeeting { meetings in
            self.meetings = meetings
            self.gatherNum.text = "\(meetings.count)"
            self.collectionView.reloadData()
        }
    }
    
    func getBookmarkedMeetings() {
        MeetingAPI().getBookmark { meetings in
            self.meetings = meetings
            self.gatherNum.text = "\(meetings.count)"
            self.collectionView.reloadData()
        }
    }
    
    @objc func didTapPlusButton() {
        if plusButton.currentImage == UIImage(named: "plus") {
            plusButton.setImage(UIImage(named: "x"), for: .normal)
            
            UIView.animate(withDuration: 0.3) {
                self.peopleButton.alpha = 1
                self.participateButton.alpha = 1
                self.joinLabel.alpha = 1
                self.addLabel.alpha = 1
                self.overlayView.alpha = 0.8
            }
        } else {
            plusButton.setImage(UIImage(named: "plus"), for: .normal)
            
            UIView.animate(withDuration: 0.3) {
                self.peopleButton.alpha = 0
                self.participateButton.alpha = 0
                self.joinLabel.alpha = 0
                self.addLabel.alpha = 0
                self.overlayView.alpha = 0
                
            }
        }
    }
    
    @objc func didTapparticipateButton(_ sender: Any) {
        dismissPopUp()
        let popupVC = MeetingAddViewController()
        popupVC.modalPresentationStyle = .overFullScreen
        present(popupVC, animated: false, completion: nil)
    }
    
    @objc func didTapPeopleButton(_ sender: Any) {
        dismissPopUp()
        let addVC = MeetingPopUpViewController()
        addVC.modalPresentationStyle = .overFullScreen
        present(addVC, animated: false, completion: nil)
    }
}

// layout
extension MeetingViewController {
    private func layoutConstriants() {
        self.view.addSubview(gatherLabel)
        self.view.addSubview(gatherNumCircle)
        self.view.addSubview(gatherNum)
        self.view.addSubview(item)
        self.view.addSubview(selectedTabIndicator)
        applyConstraintsToTabs(stackView: item)
        
        self.view.addSubview(plusButton)
        applyConstraintsToPlusButton()
        
        self.view.addSubview(collectionView)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        applyConstraintsToCollectionView()
        
        self.view.addSubview(peopleButton)
        self.view.addSubview(joinLabel)
        self.view.addSubview(participateButton)
        self.view.addSubview(addLabel)

        applyConstraintsToPlusButton()
        applyConstraintsToPeopleButtonAndJoinLabel()
        applyConstraintsToPartButtonAndAddLabel()
        
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        overlayView.frame = self.view.bounds
        overlayView.alpha = 0
        self.view.addSubview(overlayView)
        self.view.bringSubviewToFront(plusButton)
        self.view.bringSubviewToFront(peopleButton)
        self.view.bringSubviewToFront(participateButton)
        self.view.bringSubviewToFront(addLabel)
        self.view.bringSubviewToFront(joinLabel)
    }
    
    func applyConstraintsToPlusButton() {
        plusButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.right.equalTo(self.view).offset(-24)
        }
    }
        
    func applyConstraintsToCollectionView() {
        let safeArea = view.safeAreaLayoutGuide
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(selectedTabIndicator.snp.bottom).offset(16)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
            make.bottom.equalTo(plusButton.snp.bottom).offset(16)
        }
    }
    
    func applyConstraintsToFavCollectionView() {
        let safeArea = view.safeAreaLayoutGuide
        
        favcollectionView.snp.makeConstraints { make in
            make.top.equalTo(selectedTabIndicator.snp.bottom).offset(16)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-24)
            make.bottom.equalTo(plusButton.snp.bottom).offset(16)
        }
    }
    
    func applyConstraintsToTabs(stackView: UIStackView) {
        let safeArea = view.safeAreaLayoutGuide
        gatherLabel.snp.makeConstraints { make in
            make.top.equalTo(safeArea.snp.top).offset(38)
            make.leading.equalTo(safeArea.snp.leading).offset(24)
        }
        gatherNumCircle.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalTo(gatherLabel)
            make.leading.equalTo(gatherLabel.snp.trailing).offset(6)
        }
        gatherNum.snp.makeConstraints { make in
            make.centerX.equalTo(gatherNumCircle)
            make.centerY.equalTo(gatherNumCircle)
        }
        item.snp.makeConstraints { make in
            make.top.equalTo(gatherLabel.snp.bottom).offset(24)
            make.left.equalTo(self.view).offset(24)
        }
        selectedTabIndicator.snp.makeConstraints { make in
            make.top.equalTo(allTab.snp.bottom).offset(2)
            make.height.equalTo(2)
            make.left.right.equalTo(allTab)
        }
    }
    
    func applyConstraintsToPeopleButtonAndJoinLabel() {
        peopleButton.snp.makeConstraints { make in
            make.bottom.equalTo(plusButton.snp.top).offset(-14)
            make.centerX.equalTo(plusButton)
        }
        
        joinLabel.snp.makeConstraints { make in
            make.centerY.equalTo(peopleButton)
            make.right.equalTo(peopleButton.snp.left).offset(-11)
        }
    }

    func applyConstraintsToPartButtonAndAddLabel() {
        participateButton.snp.makeConstraints { make in
            make.bottom.equalTo(peopleButton.snp.top).offset(-14)
            make.centerX.equalTo(plusButton)
        }
        
        addLabel.snp.makeConstraints { make in
            make.centerY.equalTo(participateButton)
            make.right.equalTo(participateButton.snp.left).offset(-11)
        }
    }
}
