//
//  StudentTableViewCell.swift
//  MesAmies
//
//  Created by Mohammad Olwan on 24/05/2022.
//

import UIKit

class StudentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var studentIdLabel: UILabel!
    @IBOutlet weak var studentNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension StudentTableViewCell{
    
    func configure(with studentName: String, and studentId: String ) {
        
        studentNameLabel.text = " " + studentId
        studentIdLabel.text = " " + studentName

        //applyAccessibility(student)
    }
}

// MARK: Accessibility
extension StudentTableViewCell {
//  func applyAccessibility(_ student: Student) {
//      studentNameLabel.accessibilityTraits = .header
//      studentNameLabel.accessibilityLabel = student.username
//  }
}


