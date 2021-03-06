//
//  PostCell.swift
//  Engineering.ai.test
//
//  Created by PCQ182 on 25/12/19.
//  Copyright © 2019 PCQ182. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    // MARK: - Outlets -
    @IBOutlet private weak var selectedSwitch: UISwitch!
    @IBOutlet private weak var postDateLbl: UILabel!
    @IBOutlet private weak var postTitleLbl: UILabel!
    
    // MARK: - Variables -
    var switchSelected:((Bool)->Void)?
    private let dateformatter = DateFormatter()
    var post:Post! {
        didSet {
            postTitleLbl.text = post.title
            selectedSwitch.isOn = post.isSelected
            dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let date = dateformatter.date(from: post.created_at) as Date? {
                dateformatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss aaa"
                postDateLbl.text = dateformatter.string(from: date)
            }
        }
    }

    // MARK: - Switch Action -
    @IBAction private func selectedSwitchAction(_ sender: UISwitch) {
        switchSelected?(sender.isOn)
    }
}
