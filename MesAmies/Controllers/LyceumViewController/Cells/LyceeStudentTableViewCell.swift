//
//  LyceeStudentTableViewCell.swift
//  MesAmies
//
//  Created by Mohammad Olwan on 26/05/2022.
//

import UIKit

class LyceeStudentTableViewCell: UITableViewCell {

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

extension LyceeStudentTableViewCell{
    func configure(with studentName: String, and studentId: Int ) {
        
        studentNameLabel.text = " " + studentName
        studentIdLabel.text = " " + String(studentId)
        //applyAccessibility(student)
    }
}

// MARK: Accessibility
extension LyceeStudentTableViewCell {
//  func applyAccessibility(_ student: Student) {
//      studentNameLabel.accessibilityTraits = .header
//      studentNameLabel.accessibilityLabel = student.username
//  }
}
