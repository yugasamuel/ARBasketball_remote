//
//  ARManager.swift
//  ARBasketball
//
//  Created by Yuga Samuel on 30/05/23.
//

import Combine

class ARManager {
    static let shared = ARManager()
    private init() { }
    
    var actionStream = PassthroughSubject<ARAction, Never>()
}
