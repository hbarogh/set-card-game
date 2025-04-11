//this will be the view part of the mvvm architecture
import SwiftUI

struct EmojiCardGameView: View {
    @ObservedObject var viewModel: EmojiCardGame
    var aspectRatio: CGFloat = 1
    var body: some View{
        
        VStack{
            Text("SET Game").font(.largeTitle)
            ScrollView{
                cards
                    .animation(.default, value: viewModel.cards)
            }
            Text("UserScore: \(viewModel.userScore)")
            myButtons
        }
    }
    

    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 85), spacing: 8)], spacing: 8) {
            ForEach(viewModel.cards) { card in
                CardView(card: card)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(4)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
            }
        }
        .padding()
    }
    
    var myButtons: some View {
        HStack{
            NewGameButton
            Spacer()
            dealCardsButton
        }
        .padding()
        
    }
    
    var NewGameButton: some View {
        VStack{
            Text("New Game")
                .font(.footnote)
                .fontWeight(.semibold)
            Button(action: {
                viewModel.newGame()
            }, label: {
                Image(systemName: "plus")
                    .font(.title2)
            })
        }
    }
    
    var dealCardsButton: some View {
        VStack{
            Text("Deal New Cards")
                .font(.footnote)
                .fontWeight(.semibold)
            Button (action: {
                viewModel.dealCards()
            }, label: {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
            })
            .disabled(
                viewModel.deck.isEmpty
            )
        }
    }
}

struct CardView: View {
    let card: CardGame<SetCardContent>.Card

    var body: some View {
        GeometryReader { geo in
            let cardSize = geo.size
            let symbolHeight = cardSize.height * 0.18
            let symbolWidth = symbolHeight * 2 // aspect ratio 2:1

            let base = RoundedRectangle(cornerRadius: 12)

            ZStack {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                if card.isSelected {
                    base.strokeBorder(Color.blue, lineWidth: 4)
                }
                else if card.isMatched {
                    base.strokeBorder(Color.green, lineWidth: 4)
                }
                else if card.isMisMatch{
                    base.strokeBorder(Color.red, lineWidth: 4)
                }
                else {
                    base.strokeBorder(Color.black, lineWidth: 2)
                }
                VStack(spacing: cardSize.height * 0.05) {
                    ForEach(0..<card.content.number, id: \.self) { _ in
                        SetSymbol(
                            shape: card.content.shape,
                            shading: card.content.shading,
                            color: card.content.color
                        )
                        .frame(width: symbolWidth, height: symbolHeight)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .aspectRatio(2/3, contentMode: .fit)
    }
}

//
//#Preview {
//    EmojiCardGameView(viewModel: EmojiCardGame())
//}
