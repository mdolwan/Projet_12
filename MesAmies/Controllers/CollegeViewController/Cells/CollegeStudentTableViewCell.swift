//
//  CollegeStudentTableViewCell.swift
//  MesAmies
//
//  Created by Mohammad Olwan on 25/05/2022.
//

import UIKit

class CollegeStudentTableViewCell: UITableViewCell {

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

extension CollegeStudentTableViewCell{
    func configure(with studentName: String, and studentId: String ) {
        
        studentNameLabel.text = " " + studentName
        studentIdLabel.text = " " + studentId

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
