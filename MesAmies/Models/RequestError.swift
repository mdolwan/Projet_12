//
//  RequestError.swift
//  MesAmies
//
//  Created by Mohammad Olwan on 10/05/2022.
//
import Foundation
enum RequestError: Error {
    case noData, invalidResponse, undecodableData
}
