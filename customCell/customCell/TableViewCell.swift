//
//  TableViewCell.swift
//  customCell
//
//  Created by Scott Erlandson on 12/29/16.
//  Copyright © 2016 Scott Erlandson. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var levelField: UITextField!
    @IBOutlet weak var gradeField: UITextField!
    
    public func configure(nameText: String?, namePlaceholder: String,
                                    levelText: String?, levelPlaceholder: String,
                                    gradeText: String?, gradePlaceholder: String) {
        nameField.text = nameText
        nameField.placeholder = namePlaceholder
        nameField.accessibilityValue = nameText
        nameField.accessibilityLabel = namePlaceholder
        levelField.text = levelText
        levelField.placeholder = levelPlaceholder
        levelField.accessibilityValue = levelText
        levelField.accessibilityLabel = levelPlaceholder
        gradeField.text = gradeText
        gradeField.placeholder = gradePlaceholder
        gradeField.accessibilityValue = gradeText
        gradeField.accessibilityLabel = gradePlaceholder
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
