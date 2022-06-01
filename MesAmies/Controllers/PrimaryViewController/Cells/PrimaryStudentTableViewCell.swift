//
//  StudentTableViewCell.swift
//  MesAmies
//
//  Created by Mohammad Olwan on 24/05/2022.
//

import UIKit

class PrimaryStudentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var studentPrimaryIdLabel: UILabel!
    @IBOutlet weak var studentPrimaryNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension PrimaryStudentTableViewCell{
    
    func configure(with studentName: String, and studentId: Int ) {
        
        studentPrimaryNameLabel.text = " " + studentName
        studentPrimaryIdLabel.text = " " + String(studentId)

        //applyAccessibility(student)
    }
}

// MARK: Accessibility
extension PrimaryStudentTableViewCell {
//  func applyAccessibility(_ student: Student) {
//      studentNameLabel.accessibilityTraits = .header
//      studentNameLabel.accessibilityLabel = student.username
//  }
}



