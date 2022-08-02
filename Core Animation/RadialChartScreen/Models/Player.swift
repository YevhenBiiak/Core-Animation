//
//  Player.swift
//  Core Animation
//
//  Created by Евгений Бияк on 31.07.2022.
//

struct Player {
    let name: String
    let pace: Int
    let shooting: Int
    let dribbling: Int
    let passing: Int
    let defending: Int
    let physical: Int
}

extension Player: Equatable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.name == rhs.name &&
               lhs.pace == rhs.pace &&
               lhs.shooting == rhs.shooting &&
               lhs.dribbling == rhs.dribbling &&
               lhs.passing == rhs.passing &&
               lhs.defending == rhs.defending &&
               lhs.physical == rhs.physical
    }
}

extension Player {
    static func getTestPlayers() -> [Player] {
        let players = [
            Player(name: "ADAMA TRAORÉ", pace: 96, shooting: 66, dribbling: 86, passing: 68, defending: 38, physical: 80),
            Player(name: "MBAPPÉ", pace: 96, shooting: 86, dribbling: 91, passing: 78, defending: 39, physical: 76),
            Player(name: "DAVIES", pace: 96, shooting: 67, dribbling: 82, passing: 69, defending: 76, physical: 76),
            Player(name: "JAMES", pace: 95, shooting: 70, dribbling: 76, passing: 69, defending: 43, physical: 63),
            Player(name: "NAGAI", pace: 95, shooting: 67, dribbling: 68, passing: 63, defending: 41, physical: 75),
            Player(name: "VALVERDE", pace: 86, shooting: 74, dribbling: 80, passing: 78, defending: 77, physical: 80),
            Player(name: "KLOSTERMANN", pace: 84, shooting: 51, dribbling: 71, passing: 66, defending: 82, physical: 77),
            Player(name: "LAIMER", pace: 85, shooting: 68, dribbling: 78, passing: 78, defending: 80, physical: 77),
            Player(name: "VINÍCIUS JR.", pace: 95, shooting: 69, dribbling: 86, passing: 71, defending: 29, physical: 66)
        ]
        return players
    }
}
