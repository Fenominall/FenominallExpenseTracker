//
//  IconSection.swift
//  FenominallExpenseTrackeriOS
//
//  Created by Fenominall on 18.06.2024.
//

import UIKit

enum IconSection: String, CaseIterable {
    case finances = "Finances"
    case transportation = "Transportation"
    case shopping = "Shopping"
    case foodAndDrink = "Food and Drink"
    case home = "Home"
    case health = "Health"
    case beauty = "Beauty"
    case entertainment = "Entertainment"
    case accounts = "Accounts"
    case workout = "Workout"
    case relaxation = "Relaxation"
    case education = "Education"
    case familyChildren = "FamilyChildren"
    case farm = "Farm"
    case other = "Other"
    
    var assetNames: [String] {
        switch self {
        case .finances:
            return ["abstract"]
        case .transportation:
            return ["call"]
        case .shopping:
            return ["exclamation"]
        case .foodAndDrink:
            return ["gear"]
        case .home:
            return ["instagram"]
        case .health:
            return ["movie"]
        case .beauty:
            return ["pen"]
        case .entertainment:
            return ["shopping"]
        case .accounts:
            return ["trash"]
        case .workout:
            return ["user"]
        case .relaxation:
            return ["call"]
        case .education:
            return ["abstract"]
        case .familyChildren:
            return ["exclamation"]
        case .farm:
            return ["gear"]
        case .other:
            return ["instagram"]
        }
    }
}
