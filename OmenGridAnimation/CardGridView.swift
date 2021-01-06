//
//  CardGridView.swift
//  OmenGridAnimation
//
//  Created by Kit Langton on 1/4/21.
//

import SwiftUI

struct RingBuffer<Element> {
    var items: [Element]
    var currentIndex: Int = 0

    mutating func pop() -> Element {
        defer { normalizeIndex() }
        return items.remove(at: currentIndex)
    }

    mutating func next() {
        currentIndex += 1
        normalizeIndex()
    }

    private mutating func normalizeIndex() {
        if currentIndex >= items.count {
            currentIndex = 0
        }
    }
}

struct Card: Identifiable {
    var id = UUID()
    var rank = Int.random(in: 1 ... 9)
}

struct PositionedCardView: View {
    var card: Card
    var relativeIndex: Int
    var namespace: Namespace.ID

    private let maxXIndex = 4
    private let cardWidth: CGFloat = 35
    private let spacing: CGFloat = 8

    var isCurrentCard: Bool {
        relativeIndex == 0
    }

    var xOverflow: Int {
        max(0, relativeIndex - maxXIndex)
    }

    var x: CGFloat {
        var x = CGFloat(relativeIndex) * (cardWidth + spacing)
        if xOverflow > 0 {
            x = CGFloat(maxXIndex) * (cardWidth + spacing)
            x += CGFloat(xOverflow) * (cardWidth / 3)
        }
        return x
    }

    var shadow: Double {
        var shadow = isCurrentCard ? 0 : 0.2
        shadow += Double(xOverflow) * 0.2
        if relativeIndex < 0 {
            shadow += 0.6
        }
        return shadow
    }

    var body: some View {
        return CardView(rank: card.rank)
            .overlay(Color.black.opacity(shadow))
            .compositingGroup()
            .cornerRadius(8)
            .shadow(radius: 5)
            .zIndex(-Double(relativeIndex))
            .matchedGeometryEffect(id: card.id, in: namespace)
            .offset(
                x: x,
                y: isCurrentCard ? -15 : 0
            )
    }
}

struct CardGridView: View {
    @State var cards = RingBuffer(items: [Card(), Card(), Card(), Card(), Card(), Card(), Card(), Card(), Card(), Card(), Card()])

    @State var completed = [Card(), Card()]

    @Namespace var namespace

    func completedCardView(index: Int, card: Card) -> some View {
        return CardView(rank: card.rank, isComplete: true)
            .overlay(Color.black.opacity(Double(index) * 0.3))
            .compositingGroup()
            .cornerRadius(8)
            .matchedGeometryEffect(id: card.id, in: namespace)
            .offset(y: CGFloat(index * (35 / 3)))
            .zIndex(-Double(index))
    }

    var cardQueue: some View {
        ZStack {
            ForEachWithIndex(elements: cards.items) { index, card in
                PositionedCardView(card: card, relativeIndex: index - cards.currentIndex, namespace: namespace)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onTapGesture {
            cards.next()
        }
    }

    var completedView: some View {
        ZStack {
            ForEachWithIndex(elements: completed, content: self.completedCardView)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .onTapGesture {
            completed.insert(cards.pop(), at: 0)
        }
    }

    var body: some View {
        ZStack {
            cardQueue
            completedView
        }
        .padding()

        .animation(.spring())
    }
}

struct ForEachWithIndex<Element: Identifiable, Content: View>: View {
    let elements: [Element]
    let content: (Int, Element) -> Content

    var body: some View {
        ForEach(Array(elements.enumerated()), id: \.element.id) {
            content($0.offset, $0.element)
        }
    }
}

struct CardGridView_Previews: PreviewProvider {
    static var previews: some View {
        CardGridView()
            .preferredColorScheme(.dark)
    }
}
