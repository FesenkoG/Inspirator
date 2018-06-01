//
//  RatingCell.swift
//  Inspirator
//
//  Created by Георгий Фесенко on 27.05.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import UIKit

class RatingCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var pointsLbl: UILabel!

    func configureCell(participant: ParticipantModel) {
        nameLbl.text = participant.name
        pointsLbl.text = String(describing: participant.points)
    }
}
