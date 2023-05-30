//
//  ContentView.swift
//  ARBasketball
//
//  Created by Yuga Samuel on 30/05/23.
//

import SwiftUI

struct ContentView : View {
    
    @State private var isPlaying = false
    
    var body: some View {
        VStack {
            if isPlaying {
                PlayView(isPlaying: $isPlaying)
            } else {
                HomeView(isPlaying: $isPlaying)
            }
        }
        .animation(.default, value: isPlaying)
    }
}

struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
