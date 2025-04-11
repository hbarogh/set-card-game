//this will be the viewModel
import SwiftUI

class EmojiCardGame: ObservableObject {
    private static func createCardGame() -> CardGame<SetCardContent> {
        return CardGame {index in
            let number = index % 3 + 1
            let shape = SetCardContent.ShapeType.allCases[(index / 3) % 3]
            let shading = SetCardContent.Shading.allCases[(index / 9) % 3]
            let color = SetCardContent.ColorType.allCases[(index / 27) % 3]
            return SetCardContent(number: number, shape: shape, shading: shading, color: color)
        }
    }
        
    
    @Published private var model = createCardGame()
    
    var cards: Array<CardGame<SetCardContent>.Card> {
        return model.cardsInPlay
    }
    
    var deck: Array<CardGame<SetCardContent>.Card>{
        return model.deck 
    }
    
    var userScore: Int {
        return model.userScore
    }
    
    //MARK: - Intents
    
    func newGame() {
        model = EmojiCardGame.createCardGame()
    }
    
    func choose( _ card: CardGame<SetCardContent>.Card){
        model.choose(card)
    }
    
    func dealCards() {
        model.dealCards()
    }
}

