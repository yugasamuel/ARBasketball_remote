//
//  PlayView.swift
//  ARBasketball
//
//  Created by Yuga Samuel on 30/05/23.
//

import SwiftUI

struct PlayView: View {
    
    @Binding var isPlaying: Bool
    @State private var shoot: Int = 0
    
    @ObservedObject var arManager = ARManager.shared
    
    var body: some View {
        ZStack {
            CustomARViewRepresentable()
                .ignoresSafeArea()
            VStack {
                Spacer()
                Button(action: {
                    shoot+=1
                    arManager.actionStream.send(.shoot)
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
                        Text("\(shoot)")
                    }
                    Spacer()
                    VStack {
                        Text("Score")
                        Text("\(arManager.totalGoals)")
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
