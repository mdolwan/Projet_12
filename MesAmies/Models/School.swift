//
//  Collect.swift
//  MesAmies
//
//  Created by Mohammad Olwan on 09/05/2022.
//
import Foundation
// MARK: - SchoolElement
import Foundation

// MARK: - SchoolElement
struct SchoolElement: Codable {
    let id, name, city, code: String
}

typealias School = [SchoolElement]

//struct SchoolElement: Decodable {
//    let id, name: String
//    let city: String
//    let code: String
//}

//struct SchoolElement: Decodable {
//    let school: [Schools]
//}
//
//struct Schools: Decodable{
//        let id, name: String
//        let city: String
//        let code: String
//}
