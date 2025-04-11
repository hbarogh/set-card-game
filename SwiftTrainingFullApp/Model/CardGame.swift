//will be the model of the mvvm 
import Foundation

struct CardGame<CardContent> where CardContent: Equatable {
    private(set) var cardsInPlay: Array<Card> = []
    private(set) var deck: Array<Card> = []
    private(set) var userScore: Int = 0
    init(cardContentFactory: (Int) -> CardContent) {
        var allCards: Array<Card> = []
        for index in 0..<81 {
            let content = cardContentFactory(index)
            allCards.append(Card(id: "\(index + 1)", content: content))
        }
        
        allCards.shuffle() //randomizing the cards
        
        //this deals only 12 cards at the beginning
        cardsInPlay = Array(allCards.prefix(12))
        deck = Array(allCards.dropFirst(12)) //remaining 69 cards
        
    }
    
    mutating func dealCards() where CardContent == SetCardContent {
        let selectedCards = cardsInPlay.filter { $0.isSelected}
        let numberOfCardsToDeal: Int = 3
        let numbers = Set(selectedCards.map { $0.content.number })
        let shapes = Set(selectedCards.map { $0.content.shape })
        let shadings = Set(selectedCards.map { $0.content.shading })
        let colors = Set(selectedCards.map { $0.content.color })
        
        let attributeSets: [Set<AnyHashable>] = [
            Set(numbers.map { $0 as AnyHashable }),
            Set(shapes.map { $0 as AnyHashable }),
            Set(shadings.map { $0 as AnyHashable }),
            Set(colors.map { $0 as AnyHashable })
        ]
        
        let isMatch = attributeSets.allSatisfy{ $0.count == 1 || $0.count == 3 }
        if selectedCards.count == 3 && isMatch {
            if deck.count >= 3{
                for selectedCard in selectedCards {
                    if let matchIndex = cardsInPlay.firstIndex(where: { $0.id == selectedCard.id })
                    {
                        if let newCardReplace = deck.popLast() {
                            cardsInPlay[matchIndex] = newCardReplace
                        }
                    }
                }
            }
        }
        else {
            for _ in 0..<numberOfCardsToDeal {
                if let newCard = deck.popLast() {
                    cardsInPlay.append(newCard)
                }
            }
        }
        
        for selectedCard in selectedCards {
            if let selectedIndex = cardsInPlay.firstIndex(where: { $0.id == selectedCard.id }) {
                cardsInPlay[selectedIndex].isSelected = false
            }
        }
    }
    
    struct Card: Equatable, Identifiable{
        var isMatched = false
        var id: String
        let content: CardContent
        var isSelected = false
        var isMisMatch = false
    }
}

extension CardGame where CardContent == SetCardContent {
    mutating func choose(_ card: Card) {
        
        
        
        guard let index = cardsInPlay.firstIndex(where: { $0.id == card.id }) else { return }
        
        if cardsInPlay[index].isSelected {
            cardsInPlay[index].isSelected = false
            return
        }
        
//       Select the tapped card
        cardsInPlay[index].isSelected = true
        let selectedCards = cardsInPlay.filter { $0.isSelected }
        let misMatchedCards = cardsInPlay.filter { $0.isMisMatch }
        let matchedCards = cardsInPlay.filter { $0.isMatched }
        
        // Check if it's a match before clearing
        let numbers = Set(selectedCards.map { $0.content.number })
        let shapes = Set(selectedCards.map { $0.content.shape })
        let shadings = Set(selectedCards.map { $0.content.shading })
        let colors = Set(selectedCards.map { $0.content.color })

        let attributeSets: [Set<AnyHashable>] = [
            Set(numbers.map { $0 as AnyHashable }),
            Set(shapes.map { $0 as AnyHashable }),
            Set(shadings.map { $0 as AnyHashable }),
            Set(colors.map { $0 as AnyHashable })
        ]
        
        let isMatch = attributeSets.allSatisfy{ $0.count == 1 || $0.count == 3 }
        
        
        
        if selectedCards.count == 3 {
            //setting the matches for the cards here
            if isMatch {
                for selectedCard in selectedCards {
                    if let matchIndex = cardsInPlay.firstIndex(where: { $0.id == selectedCard.id}) {
                        cardsInPlay[matchIndex].isMatched = true
                        userScore += 1
                    }
                }
            }
            //setting the mismatch flag
            else {
                for selectedCard in selectedCards {
                    if let misMatchIndex = cardsInPlay.firstIndex(where: { $0.id == selectedCard.id }) {
                        cardsInPlay[misMatchIndex].isMisMatch = true
                        userScore -= 1
                    }
                }
            }

            // Deselect all current cards
            for selectedCard in selectedCards {
                if let selectedIndex = cardsInPlay.firstIndex(where: { $0.id == selectedCard.id }) {
                    cardsInPlay[selectedIndex].isSelected = false
                }
            }
        }
        else if misMatchedCards.count == 3 && selectedCards.count == 1 {
            for misMatchCard in misMatchedCards {
                if let MisMatchedIndex = cardsInPlay.firstIndex(where: { $0.id == misMatchCard.id }){
                    cardsInPlay[MisMatchedIndex].isMisMatch = false
                }
            }
        }
        else if matchedCards.count == 3 && selectedCards.count == 1 {
            if isMatch {
                for matchedCard in matchedCards {
                    if let matchIndex = cardsInPlay.firstIndex(where: { $0.id == matchedCard.id}) {
                        if deck.isEmpty {
                            cardsInPlay.remove(at: matchIndex)
                        }
                        else if let newCard = deck.popLast() {
                            cardsInPlay[matchIndex] = newCard
                        }
                    }
                }
            }
        }
        else {
            cardsInPlay[index].isSelected = true
        }
    }
}

