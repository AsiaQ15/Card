//
//  Card.swift
//  Cards
//
//  Created by Ася Купинская on 26.12.2022.
//

import Foundation

// типы фигуры карт
enum CardType: CaseIterable {
    case circle
    case cross
    case square
    case fill
    case unfillcircle
}
// цвета карт
enum CardColor: CaseIterable {
    case red
    case green
    case black
    case gray
    case brown
    case yellow
    case purple
    case orange
}
// игральная карточка
typealias Card = (type: CardType, color: CardColor)
// игральная карточка текст
typealias CardS = (type: String, color: String)
func returnTypeString(cardtype: CardType) -> String{
    switch cardtype{
    case .circle: return "circle"
    case .cross: return "cross"
    case .square: return "square"
    case .fill: return "fill"
    case .unfillcircle: return "unfillcircle"
    }
}
func returnType(cardtype: String) -> CardType{
    switch cardtype{
    case "circle": return .circle
    case "cross": return .cross
    case "square": return .square
    case "fill": return .fill
    case "unfillcircle": return .unfillcircle
    default: return .unfillcircle
    }
}
func returnColorString(cardColor: CardColor) -> String{
    switch cardColor{
    case .red: return "red"
    case .green: return "green"
    case .black: return "black"
    case .gray: return "gray"
    case .brown: return "brown"
    case .yellow: return "yellow"
    case .purple: return "purple"
    case .orange: return "orange"
    }
}
func returnColor(cardColor: String) -> CardColor{
    switch cardColor{
    case "red": return .red
    case "green": return .green
    case "black": return .black
    case "gray": return .gray
    case "brown:": return .brown
    case "yellow": return .yellow
    case "purple": return .purple
    case "orange": return .orange
    default: return .orange
    }
}
