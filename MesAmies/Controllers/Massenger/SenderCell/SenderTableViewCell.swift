//
//  SenderTableViewCell.swift
//  MesAmies
//
//  Created by Mohammad Olwan on 03/06/2022.
//

import UIKit

class SenderTableViewCell: UITableViewCell {

    @IBOutlet weak var senderTimeMessegeLabel: UILabel!
    @IBOutlet weak var senderDateMessageLabel: UILabel!
    @IBOutlet weak var sendermessageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension SenderTableViewCell{
    func configure(with message: String ) {
        sendermessageLabel.text = " " + message
        //applyAccessibility(student)
    }
}

// MARK: Accessibility
extension SenderTableViewCell {
//  func applyAccessibility(_ student: Student) {
//      studentNameLabel.accessibilityTraits = .header
//      studentNameLabel.accessibilityLabel = student.username
//  }
}

