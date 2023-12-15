//
//  TabbarViewController.swift
//  CoNet
//
//  Created by 가은 on 2023/07/08.
//

import UIKit

class TabbarViewController: UITabBarController {

    // 초기 인덱스를 0으로 설정합니다.
    // 아이템이 선택되면 그 아이템의 인덱스가 defaultIndex에 저장됩니다.
    var defaultIndex = 0 {
        didSet {
            self.selectedIndex = defaultIndex
        }
    }
    
    // 홈탭
    let firstNVController = UINavigationController().then {
        let firstTabController = HomeViewController()
        $0.addChild(firstTabController)
        $0.tabBarItem.image = UIImage(named: "tabbarHome")
        $0.tabBarItem.selectedImage = UIImage(named: "tabbarHomeSelected")
        $0.tabBarItem.title = "홈"
    }
    
    // 모임탭
    let secondNVController = UINavigationController().then {
        let secondTabController = MeetingViewController()
        $0.addChild(secondTabController)
        $0.tabBarItem.image = UIImage(named: "tabbarMeeting")
        $0.tabBarItem.selectedImage = UIImage(named: "tabbarMeetingSelected")
        $0.tabBarItem.title = "모임"
    }
    
    // 마이페이지 탭
    let thirdNVController = UINavigationController().then {
        let thirdTabController = MyPageViewController()
        $0.addChild(thirdTabController)
        $0.tabBarItem.image = UIImage(named: "tabbarMypage")
        $0.tabBarItem.selectedImage = UIImage(named: "tabbarMypageSelected")
        $0.tabBarItem.title = "MY"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        self.view.backgroundColor = .white
        self.selectedIndex = defaultIndex
        
        let viewControllers = [firstNVController, secondNVController, thirdNVController]
        self.setViewControllers(viewControllers, animated: true)
    }
    
}
