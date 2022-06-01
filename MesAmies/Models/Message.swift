//
//  Message.swift
//  MesAmies
//
//  Created by Mohammad Olwan on 31/05/2022.
//

import Foundation

// MARK: - Message
struct Message: Codable {
    let error: Bool
    let lastMessageID: Int
    let message: String

    enum CodingKeys: String, CodingKey {
        case error
        case lastMessageID = "lastMessageId"
        case message
    }
}
