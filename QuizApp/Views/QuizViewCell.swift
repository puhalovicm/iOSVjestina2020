//
//  QuizViewCell.swift
//  QuizApp
//
//  Created by five on 20/05/2020.
//

import UIKit
import Kingfisher

class QuizViewCell: UITableViewCell {

    @IBOutlet weak var quizImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    
    var quiz: Quiz? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    class func createCell() -> QuizViewCell? {
        let nib = Bundle.main.loadNibNamed("QuizViewCell", owner: self, options: nil)?.first as? QuizViewCell
        //let cell = nib.instantiate(withOwner: self, options: nil).last as? QuizViewCell
        return nib
    }
    
    func setValues(quiz: Quiz) {
        self.quiz = quiz
        quizImage.kf.setImage(with: URL(string: quiz.image))
        titleLabel.text = quiz.title
        descriptionLabel.text = quiz.description
        descriptionLabel.sizeToFit()
        difficultyLabel.text = String(repeating: "*", count: quiz.level)
    }
}
