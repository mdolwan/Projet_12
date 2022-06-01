//
//  AllMessages.swift
//  MesAmies
//
//  Created by Mohammad Olwan on 31/05/2022.
//

import Foundation

// MARK: - AllMessage
struct AllMessage: Codable {
    let fromID, toID, date, time: String
    let message: String

    enum CodingKeys: String, CodingKey {
        case fromID = "FromId"
        case toID = "ToId"
        case date = "Date"
        case time = "Time"
        case message = "Message"
    }
}

typealias AllMessages = [AllMessage]
