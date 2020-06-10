//
//  ScoreViewCell.swift
//  QuizApp
//
//  Created by Mateo Puhalović on 09/06/2020.
//

import UIKit

class ScoreViewCell: UITableViewCell {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    func setLabels(score: String, username: String) {
        DispatchQueue.main.async {
            self.scoreLabel.text = "Score: \(score)"
            self.usernameLabel.text = "Username: \(username)"
        }
    }
    
    class func createCell() -> ScoreViewCell? {
        let nib = Bundle.main.loadNibNamed("ScoreViewCell", owner: self, options: nil)?.first as? ScoreViewCell
        //let cell = nib.instantiate(withOwner: self, options: nil).last as? QuizViewCell
        return nib
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
