//
//  CardView.swift
//  OmenGridAnimation
//
//  Created by Kit Langton on 1/4/21.
//

import SwiftUI

struct CardView: View {
    var rank: Int
    var isComplete = false
    var size: CGFloat = 35

    var transition =
        AnyTransition.asymmetric(insertion: .move(edge: .top), removal: .move(edge: .bottom)).combined(with: .opacity)

    
    var color : some View {
        isComplete ? Color.green : Color.white
    }
    
    var body: some View {
        color
            .frame(width: size, height: size)
            .cornerRadius(8)
            .overlay(
                Text("\(rank)")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .transition(transition)
                    .id(rank)
                    .animation(.spring())
            )
    }
}

struct CardView_Previews: PreviewProvider {
    struct Preview: View {
        @State var rank = 1

        var body: some View {
            CardView(rank: rank)
                .onTapGesture {
                    rank = Int.random(in: 1 ..< 10)
                }
        }
    }

    static var previews: some View {
        Preview()
            .preferredColorScheme(.dark)
    }
}
