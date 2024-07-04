//
//  TimeTableViewCell.swift
//  CoNet
//
//  Created by 가은 on 2023/07/27.
//

import UIKit

class TimeTableViewCell: UICollectionViewCell {
    static let identifier = "\(TimeTableViewCell.self)"
    var cellColor = UIColor.grayWhite?.cgColor
    var enableTouchEvents = false
    var selectedTime: [PossibleTime] = []
    var removedTime: [PossibleTime] = Array(repeating: PossibleTime(date: "", availableTimes: []), count: 7)

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray100?.cgColor
        contentView.backgroundColor = UIColor.grayWhite
        selectedTime = TimeInputViewController.shared.possibleTime
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 셀 클릭 시 background color 바꾸기
    func changeCellColor() -> Int {
        if contentView.layer.backgroundColor == UIColor.grayWhite?.cgColor {
            contentView.layer.backgroundColor = UIColor.mainSub1?.withAlphaComponent(0.5).cgColor
            return 1
        } else {
            contentView.layer.backgroundColor = UIColor.grayWhite?.cgColor
            return 0
        }
    }

    // 인원수에 따른 셀 색
    func showCellColor(section: Int) {
        if section == 0 {
            contentView.layer.backgroundColor = UIColor.grayWhite?.cgColor
        } else if section == 1 {
            contentView.layer.backgroundColor = UIColor.mainSub1?.withAlphaComponent(0.2).cgColor
        } else if section == 2 {
            contentView.layer.backgroundColor = UIColor.mainSub1?.withAlphaComponent(0.5).cgColor
        } else if section == 3 {
            contentView.layer.backgroundColor = UIColor.mainSub1?.withAlphaComponent(0.8).cgColor
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if enableTouchEvents {
            cellColor = contentView.layer.backgroundColor == UIColor.grayWhite?.cgColor ? UIColor.mainSub1?.withAlphaComponent(0.5).cgColor : UIColor.grayWhite?.cgColor
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if enableTouchEvents {
            handleTouch(touches)
        }
    }

    private func handleTouch(_ touches: Set<UITouch>) {
        guard let collectionView = superview as? UICollectionView, let touch = touches.first
        else { return }

        let location = touch.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: location),
           let cell = collectionView.cellForItem(at: indexPath) as? TimeTableViewCell
        {
            cell.contentView.layer.backgroundColor = cellColor
            let idx = TimeInputViewController.shared.page*3 + indexPath.section
            if cellColor == UIColor.mainSub1?.withAlphaComponent(0.5).cgColor {
                selectedTime[idx].availableTimes = Array(Set(selectedTime[idx].availableTimes).union([indexPath.row]))
            } else {
                removedTime[idx].availableTimes = Array(Set(removedTime[idx].availableTimes).union([indexPath.row]))
            }
            NotificationCenter.default.post(name: NSNotification.Name("selectedTimeToTimeInputVC"), object: nil, userInfo: ["selectedTime": selectedTime, "removedTime": removedTime])
        }
    }
}
