//
//  Collect.swift
//  MesAmies
//
//  Created by Mohammad Olwan on 09/05/2022.
//
import Foundation

// MARK: - SchoolElement
struct SchoolElement: Decodable {
    let id, name: String
    let city: City
    let code: String
}

enum City: String, Decodable {
    case cherbourgEnCotentin = "Cherbourg-en-Cotentin"
}

typealias School = [SchoolElement]

//struct SchoolElement: Decodable {
//    let id, name: String
//    let city: String
//    let code: String
//}


