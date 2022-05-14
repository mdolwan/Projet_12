//
//  Collect.swift
//  MesAmies
//
//  Created by Mohammad Olwan on 09/05/2022.
//
import Foundation

// MARK: - SchoolElement
struct SchoolElement: Codable {
    let id, name, city, code: String?
}

typealias School = [SchoolElement]


