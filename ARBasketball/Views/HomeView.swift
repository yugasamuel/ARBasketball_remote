//
//  HomeView.swift
//  ARBasketball
//
//  Created by Yuga Samuel on 30/05/23.
//

import SwiftUI

struct HomeView: View {
    
    @Binding var isPlaying: Bool
    
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()
            VStack {
                Image("ARBasketballLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                
                Button(action: {
                    isPlaying.toggle()
                }, label: {
                    Text("Start")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 155, height: 55)
                        .background(Color(UIColor.systemOrange))
                        .cornerRadius(12)
                        .shadow(radius: 1.5)
                })
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(isPlaying: .constant(false))
    }
}

