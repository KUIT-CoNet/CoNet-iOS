//
//  MeetingViewController.swift
//  CoNet
//
//  Created by 정아현 on 2023/08/01.
//

import UIKit
import Kingfisher
import SnapKit
import Then

class MeetingViewController: UIViewController {

    var meetings: [MeetingDetailInfo] = []
    var favoritedMeetings: [MeetingDetailInfo] = []
    
    let refreshControl = UIRefreshControl()
    
    // label: 모임
    let gatherLabel = UILabel().then {
        $0.text = "모임"
        $0.font = UIFont.headline1
    }
    
    let gatherNumCircle = UIImageView().then {
        $0.image = UIImage(named: "calendarCellSelected")
    }
    
    let gatherNum = UILabel().then {
        $0.textColor = UIColor.purpleMain
        $0.font = UIFont.body3Bold
    }
    
    // tab: 전체
    let allTab = UIButton().then {
        $0.setTitle("전체", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.headline3Bold
    }
    
    // tab: 즐겨찾기
    let favTab = UIButton().then {
        $0.setTitle("즐겨찾기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.headline3Bold
    }
    
    lazy var item: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [allTab, favTab])
        stackView.axis = .horizontal
        stackView.spacing = 17
        return stackView
    }()
    
    // tab 선택시
    let selectedTabIndicator = UIView().then {
        $0.backgroundColor = UIColor.purpleMain
    }
    
    // 약속 collectionView
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isScrollEnabled = true
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
    }
    
    // 즐겨찾기 collectionView
    private lazy var favcollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isScrollEnabled = true
    }
    
    // 플로팅버튼
    let plusButton = UIButton().then {
        $0.setImage(UIImage(named: "plus"), for: .normal)
    }
    
    // 플로팅버튼: 모임참여
    let participateButton = UIButton().then {
        $0.setImage(UIImage(named: "gatherPeople"), for: .normal)
    }
    
    // 플로팅버튼: 모임추가
    let addButton = UIButton().then {
        $0.setImage(UIImage(named: "add"), for: .normal)
    }
    
    // label: 모임참여
    let joinLabel = UILabel().then {
        $0.text = "모임 참여"
        $0.font = UIFont.body1Bold
        $0.textColor = UIColor.white
    }
    
    // label: 모임추가
    let addLabel = UILabel().then {
        $0.text = "모임 추가"
        $0.font = UIFont.body1Bold
        $0.textColor = UIColor.white
    }
    
    // 오버레이뷰
    lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        view.frame = self.view.bounds
        view.alpha = 0
        
        // 오버레이뷰 탭하면 dismisspopup
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopUp))
        view.addGestureRecognizer(tapGesture)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        navigationItem.title = ""
        
        // 초기화면
        UIView.animate(withDuration: 0.3) {
            self.participateButton.alpha = 0
            self.addButton.alpha = 0
            self.joinLabel.alpha = 0
            self.addLabel.alpha = 0
            self.overlayView.alpha = 0
        }
        
        addView()
        layoutConstriants()
        buttonClicks()
        setupCollectionView()
        setupFavCollectionView()
        
        // UIRefreshControl을 UICollectionView에 추가
        collectionView.refreshControl = refreshControl
        favcollectionView.refreshControl = refreshControl
        
        // UIRefreshControl의 새로고침 동작 설정
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllMeetings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getAllMeetings()
    }
    
    func addView() {
        self.view.addSubview(gatherLabel)
        self.view.addSubview(gatherNumCircle)
        self.view.addSubview(gatherNum)
        self.view.addSubview(item)
        self.view.addSubview(selectedTabIndicator)
        self.view.addSubview(plusButton)
        self.view.addSubview(collectionView)
        self.view.addSubview(participateButton)
        self.view.addSubview(joinLabel)
        self.view.addSubview(addButton)
        self.view.addSubview(addLabel)
        self.view.addSubview(overlayView)
        self.view.bringSubviewToFront(plusButton)
        self.view.bringSubviewToFront(participateButton)
        self.view.bringSubviewToFront(addButton)
        self.view.bringSubviewToFront(addLabel)
        self.view.bringSubviewToFront(joinLabel)
    }
    
    func layoutConstriants() {
        applyConstraintsToTabs(stackView: item)
        applyConstraintsToCollectionView()
        applyConstraintsToFloatingButtonAndLabel()
    }
    
    func buttonClicks() {
        allTab.addTarget(self, action: #selector(didSelectAllTab), for: .touchUpInside)
        favTab.addTarget(self, action: #selector(didSelectFavoriteTab), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(didTapPlusButton), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(didTapparticipateButton), for: .touchUpInside)
        participateButton.addTarget(self, action: #selector(didTapPeopleButton), for: .touchUpInside)
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
    
    // 플로팅버튼: 모임참여
    func applyConstraintsToFloatingButtonAndLabel() {
        plusButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.right.equalTo(self.view).offset(-24)
        }
        participateButton.snp.makeConstraints { make in
            make.bottom.equalTo(plusButton.snp.top).offset(-14)
            make.centerX.equalTo(plusButton)
        }
        joinLabel.snp.makeConstraints { make in
            make.centerY.equalTo(participateButton)
            make.right.equalTo(participateButton.snp.left).offset(-11)
        }
        addButton.snp.makeConstraints { make in
            make.bottom.equalTo(participateButton.snp.top).offset(-14)
            make.centerX.equalTo(plusButton)
        }
        addLabel.snp.makeConstraints { make in
            make.centerY.equalTo(addButton)
            make.right.equalTo(addButton.snp.left).offset(-11)
        }
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(MeetingCollectionViewCell.self, forCellWithReuseIdentifier: MeetingCollectionViewCell.identifier)
    }
    
    func setupFavCollectionView() {
        favcollectionView.dataSource = self
        favcollectionView.delegate = self
        favcollectionView.showsVerticalScrollIndicator = false
        favcollectionView.register(MeetingCollectionViewCell.self, forCellWithReuseIdentifier: MeetingCollectionViewCell.identifier)
    }
    
    // 팝업 표시
    func presentPopUpViewController(_ viewController: UIViewController) {
        dismissPopUp()
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: false, completion: nil)
    }
    
    @objc func dismissPopUp() {
        UIView.animate(withDuration: 0.3) {
            self.overlayView.alpha = 0
            self.participateButton.alpha = 0
            self.addButton.alpha = 0
            self.joinLabel.alpha = 0
            self.addLabel.alpha = 0
            self.plusButton.setImage(UIImage(named: "plus"), for: .normal)
        }
    }
    
    @objc func didTapPlusButton() {
        if plusButton.currentImage == UIImage(named: "plus") {
            plusButton.setImage(UIImage(named: "x"), for: .normal)
            
            UIView.animate(withDuration: 0.3) {
                self.participateButton.alpha = 1
                self.addButton.alpha = 1
                self.joinLabel.alpha = 1
                self.addLabel.alpha = 1
                self.overlayView.alpha = 0.8
            }
        } else {
            plusButton.setImage(UIImage(named: "plus"), for: .normal)
            
            UIView.animate(withDuration: 0.3) {
                self.participateButton.alpha = 0
                self.addButton.alpha = 0
                self.joinLabel.alpha = 0
                self.addLabel.alpha = 0
                self.overlayView.alpha = 0
                
            }
        }
    }
    
    @objc func didTapparticipateButton(_ sender: Any) {
        let popupVC = MeetingAddViewController()
        presentPopUpViewController(popupVC)
    }

    @objc func didTapPeopleButton(_ sender: Any) {
        let addVC = MeetingCodeViewController()
        presentPopUpViewController(addVC)
    }
}

extension MeetingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // 모든 모임정보
    func getAllMeetings() {
        MeetingAPI().getMeeting { meetings in
            self.meetings = meetings
            self.gatherNum.text = "\(meetings.count)"
            self.collectionView.reloadData()
        }
    }
    
    // 즐겨찾기 모임정보
    func getBookmarkedMeetings() {
        MeetingAPI().getBookmark { meetings in
            self.meetings = meetings
            self.gatherNum.text = "\(meetings.count)"
            self.collectionView.reloadData()
        }
    }
    
    @objc func didSelectAllTab() {
        getAllMeetings()
        
        // 선택된 tab 표시 변경
        selectedTabIndicator.snp.remakeConstraints { make in
            make.top.equalTo(allTab.snp.bottom).offset(2)
            make.height.equalTo(2)
            make.left.right.equalTo(allTab)
        }
    }

    @objc func didSelectFavoriteTab() {
        getBookmarkedMeetings()
        
        // 선택된 tab 표시 변경
        selectedTabIndicator.snp.remakeConstraints { make in
            make.top.equalTo(favTab.snp.bottom).offset(2)
            make.height.equalTo(2)
            make.left.right.equalTo(favTab)
        }
    }
    
    // UIRefreshControl의 새로고침 동작을 처리하는 메서드
    @objc func refreshData() {
        getAllMeetings()
        getBookmarkedMeetings()
        
        // 새로고침 완료 후 refreshControl.endRefreshing()을 호출하여 새로고침 상태를 종료
        refreshControl.endRefreshing()
    }
    
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MeetingCollectionViewCell.identifier, for: indexPath) as? MeetingCollectionViewCell else {
            return UICollectionViewCell()
        }
      
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
    
    // 셀 개수
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    // 셀 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let _: CGFloat = (collectionView.frame.width / 2) - 17
        return CGSize(width: 164, height: 232)
    }
}
