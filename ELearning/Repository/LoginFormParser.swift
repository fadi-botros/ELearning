//
//  HtmlFormParser.swift
//  ELearning
//
//  Created by fadi on 29/06/2022.
//

import UIKit

struct LoginForm {
    let noonce: String
    let wpHttpReferer: String
}

protocol CharacterConsumer {
    func consume(character: UInt8) -> CharacterConsumer?
}

struct InvalidConsumer: CharacterConsumer {
    func consume(character: UInt8) -> CharacterConsumer? {
        return InvalidConsumer()
    }
}

struct LiteralConsumer: CharacterConsumer {
    let string: Data
    let consumedCharacters: Int

    func consume(character: UInt8) -> CharacterConsumer? {
        if consumedCharacters == string.count { return nil }
        if character == string[consumedCharacters] {
            return LiteralConsumer(string: string, consumedCharacters: consumedCharacters + 1)
        }
        return InvalidConsumer()
    }
}

struct QuoteConsumer: CharacterConsumer {
    let numberOfQuote: Int
    let isCurrentlyBackslashed: Bool
    let data: Data

    func consume(character: UInt8) -> CharacterConsumer? {
        if numberOfQuote == 2 { return nil }
        if character == "\"".utf8.first && !isCurrentlyBackslashed {
            return QuoteConsumer(numberOfQuote: numberOfQuote + 1, isCurrentlyBackslashed: isCurrentlyBackslashed, data: data)
        }
        if character == "\\".utf8.first && !isCurrentlyBackslashed {
            return QuoteConsumer(numberOfQuote: numberOfQuote, isCurrentlyBackslashed: true, data: data)
        }
        if isCurrentlyBackslashed {
            if character == "n".utf8.first {
                return QuoteConsumer(numberOfQuote: numberOfQuote, isCurrentlyBackslashed: false, data: data + ["\n".utf8.first!])
            }
        }
        return QuoteConsumer(numberOfQuote: numberOfQuote, isCurrentlyBackslashed: isCurrentlyBackslashed, data: data + [character])
    }
}

struct IdentifierConsumer: CharacterConsumer {
    let data: Data
    let firstCharacterConsumed: Bool

    func consume(character: UInt8) -> CharacterConsumer? {
        if (character >= "0".utf8.first! && character < "9".utf8.first! && firstCharacterConsumed) ||
            (character >= "a".utf8.first! && character < "z".utf8.first!) ||
            (character >= "A".utf8.first! && character < "Z".utf8.first!) ||
            (character == "_".utf8.first! || character == "-".utf8.first!) {
            return IdentifierConsumer(data: data, firstCharacterConsumed: true)
        }
        if firstCharacterConsumed == false {
            return InvalidConsumer()
        } else {
            return nil
        }
    }
}
//
//struct AttributeConsumer: CharacterConsumer {
//    static func identifierConsumer() -> IdentifierConsumer {
//        return IdentifierConsumer(data: Data(), firstCharacterConsumed: false)
//    }
//    static func equalSignConsumer() -> LiteralConsumer {
//        return LiteralConsumer(string: "=".data(using: .utf8)!, consumedCharacters: 0)
//    }
//    static func quoteConsumer() -> QuoteConsumer {
//        return QuoteConsumer(numberOfQuote: 0, isCurrentlyBackslashed: false, data: Data())
//    }
//
//    let currentConsumer: CharacterConsumer
//
//    let identifier: IdentifierConsumer
//    let equalSign: LiteralConsumer?
//    let quote: QuoteConsumer?
//
//    func consume(character: UInt8) -> CharacterConsumer? {
//        let newConsumer = currentConsumer.consume(character: character)
//        if newConsumer == nil {
//            if currentConsumer is IdentifierConsumer {
//                let equalSignConsumer = AttributeConsumer.equalSignConsumer()
//                return AttributeConsumer(currentConsumer: equalSignConsumer, identifier: identifier, equalSign: equalSignConsumer, quote: <#T##QuoteConsumer?#>)
//            }
//        }
//    }
//}

struct ConcatConsumer: CharacterConsumer {
    let first: CharacterConsumer
    let generatorForSecond: () -> CharacterConsumer

    let second: CharacterConsumer?

    func consume(character: UInt8) -> CharacterConsumer? {
        if let second = second {
            if let newSecondAfterConsumingCharacter = second.consume(character: character) {
                if newSecondAfterConsumingCharacter is InvalidConsumer { return InvalidConsumer() }
                return ConcatConsumer(first: first, generatorForSecond: generatorForSecond, second: newSecondAfterConsumingCharacter)
            }
            return nil
        }
        if let newFirstAfterConsumingCharacter = first.consume(character: character) {
            if newFirstAfterConsumingCharacter is InvalidConsumer { return InvalidConsumer() }
            return ConcatConsumer(first: newFirstAfterConsumingCharacter, generatorForSecond: generatorForSecond, second: nil)
        }
        return ConcatConsumer(first: first, generatorForSecond: generatorForSecond, second: generatorForSecond())
    }
}

extension CharacterConsumer {
    static func +(_ lhs: Self, _ rhs: @escaping @autoclosure () -> CharacterConsumer) -> ConcatConsumer {
        return ConcatConsumer(first: lhs, generatorForSecond: rhs, second: nil)
    }
}

struct MultipleConcatOrEnd: CharacterConsumer {
    let childFactory: () -> CharacterConsumer
    let oldChildren: [CharacterConsumer]
    let currentChild: CharacterConsumer
    let terminal: CharacterConsumer
    let isInTerminal: Bool

    func consume(character: UInt8) -> CharacterConsumer? {
        if isInTerminal {
            if let terminalConsumer = terminal.consume(character: character) {
                return MultipleConcatOrEnd(childFactory: childFactory, oldChildren: oldChildren, currentChild: currentChild, terminal: terminalConsumer, isInTerminal: true)
            }
            return nil
        }

        if let childConsumer = currentChild.consume(character: character) {
            if childConsumer is InvalidConsumer { return InvalidConsumer() }
            return MultipleConcatOrEnd(childFactory: childFactory, oldChildren: oldChildren, currentChild: childConsumer, terminal: terminal, isInTerminal: false)
        }
        if let terminalConsumer = currentChild.consume(character: character), !(terminalConsumer is InvalidConsumer) {
            return MultipleConcatOrEnd(childFactory: childFactory, oldChildren: oldChildren, currentChild: currentChild, terminal: terminal, isInTerminal: true)
        }
        let newChild = childFactory()
        if let childConsumer = newChild.consume(character: character) {
            if childConsumer is InvalidConsumer { return InvalidConsumer() }
            return MultipleConcatOrEnd(childFactory: childFactory, oldChildren: oldChildren + [currentChild], currentChild: childConsumer, terminal: terminal, isInTerminal: false)
        }
        if let terminalConsumer = currentChild.consume(character: character), !(terminalConsumer is InvalidConsumer) {
            return MultipleConcatOrEnd(childFactory: childFactory, oldChildren: oldChildren, currentChild: currentChild, terminal: terminal, isInTerminal: true)
        }
        return InvalidConsumer()
    }

}

func attributeConsumer() -> ConcatConsumer {
    return IdentifierConsumer(data: Data(), firstCharacterConsumed: false)
           + LiteralConsumer(string: "=".data(using: .utf8)!, consumedCharacters: 0)
           + QuoteConsumer(numberOfQuote: 0, isCurrentlyBackslashed: false, data: Data())
}

//func

//struct LoginFormParser {
//    func loginForm(string: String) -> LoginForm {
//
//    }
//}
