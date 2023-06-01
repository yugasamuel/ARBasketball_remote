//
//  BasketballManager.swift
//  ARBasketball
//
//  Created by Yuga Samuel on 01/06/23.
//

import Foundation

class BasketballManager: ObservableObject {
    static let shared = BasketballManager()
    
    @Published var totalShots: Int = 0
    @Published var totalScore: Int = 0
}
