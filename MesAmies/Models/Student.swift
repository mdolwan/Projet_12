//
//  Student.swift
//  MesAmies
//
//  Created by Mohammad Olwan on 24/05/2022.
//

import Foundation

// MARK: - Student
struct Student: Codable {
    let username,level, userid, schoolname: String
}

typealias Students = [Student]
