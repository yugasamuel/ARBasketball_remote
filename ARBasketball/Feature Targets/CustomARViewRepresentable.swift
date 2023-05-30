//
//  CustomARViewRepresentable.swift
//  ARBasketball
//
//  Created by Yuga Samuel on 30/05/23.
//

import SwiftUI

struct CustomARViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> CustomARView {
        return CustomARView()
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) { }
}
