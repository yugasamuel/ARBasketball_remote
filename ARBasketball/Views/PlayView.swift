//
//  PlayView.swift
//  ARBasketball
//
//  Created by Yuga Samuel on 30/05/23.
//

import SwiftUI

struct PlayView: View {
    
    @Binding var isPlaying: Bool
    
    @ObservedObject var basketballManager = BasketballManager.shared
    
    var body: some View {
        ZStack {
            CustomARViewRepresentable()
                .ignoresSafeArea()
            VStack {
                Spacer()
                Button(action: {
                    basketballManager.totalShots+=1
                    ARManager.shared.actionStream.send(.shoot)
                }, label: {
                    Text("Shoot")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 155, height: 55)
                        .background(Color(UIColor.systemOrange))
                        .cornerRadius(12)
                        .shadow(radius: 1.5)
                })
                .padding(.bottom, 25)
            }
            VStack {
                HStack {
                    VStack {
                        Text("Shots")
                        Text("\(basketballManager.totalShots)")
                    }
                    Spacer()
                    VStack {
                        Text("Score")
                        Text("\(basketballManager.totalScore)")
                    }
                }
                .font(.title2)
                .foregroundColor(.white)
                .shadow(radius: 1.5)
                .padding(.all, 25)
                Spacer()
            }
        }
    }
}

struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        PlayView(isPlaying: .constant(true))
    }
}
