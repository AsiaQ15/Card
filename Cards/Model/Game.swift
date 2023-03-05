//
//  Game.swift
//  Cards
//
//  Created by Ася Купинская on 26.12.2022.
//

import Foundation
class Game {
    // количество пар уникальных карточек
    var cardsCount = 0
    // массив сгенерированных карточек
    var cards = [Card]()
    // количество найденных пар
    var cardsFind = 0
    // количество переворотов
    var turnCount = 0
    // генерация массива случайных карт
    func generateCards() {
    // генерируем новый массив карточек
        var cards = [Card]()
        for _ in 0...cardsCount - 1 {
            let randomElement = (type: CardType.allCases.randomElement()!, color: CardColor.allCases.randomElement()!)
            cards.append(randomElement)
        }
        self.cards = cards
    }
    // проверка эквивалентности карточек
    func checkCards(_ firstCard: Card, _ secondCard: Card) -> Bool {
        if firstCard == secondCard {
            return true
        }
        return false
    }
    
    //массив пар тип и цвет
    func cardsToarray() -> [(String,String)]{
        var array = [(String,String)]()
        for card in cards {
            let colorS = returnColorString(cardColor: card.color)
            let typeS = returnTypeString(cardtype: card.type)
            array.append((colorS,typeS))
        }
        return array
    }
    
}
//protocol GameStorageProtocol {
//    // Загрузка списка контактов
//    func load() -> Game
//    // Обновление списка контактов
//    func save(game: Game)
//}
//class GameStorage:GameStorageProtocol{
//    func load() -> Game {
//        <#code#>
//    }
//    
//    func save(game: Game) {
//        <#code#>
//    }
//    
//    
//}
