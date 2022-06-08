//
//  RecieverTableViewCell.swift
//  MesAmies
//
//  Created by Mohammad Olwan on 03/06/2022.
//

import UIKit

class RecieverTableViewCell: UITableViewCell {

    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var recieverDateMessegeLabel: UILabel!
    @IBOutlet weak var recieverTimeMessegeLabel: UILabel!
    @IBOutlet weak var recieverMessageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textView.backgroundColor = .cyan
        textView.layer.cornerRadius = 5
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        recieverMessageLabel.numberOfLines = 0
        recieverMessageLabel.textColor = .black
        recieverMessageLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension RecieverTableViewCell{
    func configure(with message: String ) {
        recieverMessageLabel.text = " " + message
        //applyAccessibility(student)
    }
}

// MARK: Accessibility
extension RecieverTableViewCell {
//  func applyAccessibility(_ student: Student) {
//      studentNameLabel.accessibilityTraits = .header
//      studentNameLabel.accessibilityLabel = student.username
//  }
}
