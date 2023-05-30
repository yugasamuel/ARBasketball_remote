//
//  ARManager.swift
//  ARBasketball
//
//  Created by Yuga Samuel on 30/05/23.
//

import Combine

class ARManager: ObservableObject {
    @Published var totalGoals: Int = 0
    
    static let shared = ARManager()
    private init() { }
    
    var actionStream = PassthroughSubject<ARAction, Never>()
}
