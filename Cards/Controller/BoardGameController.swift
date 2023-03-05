//
//  BoardGameController.swift
//  Cards
//
//  Created by Ася Купинская on 26.12.2022.
//

import UIKit
protocol UpdatingDataController: AnyObject {
        var cardsPairsCounts: Int { get set }
}


class BoardGameController: UIViewController,UpdatingDataController {

    
    // количество пар уникальных карточек
    var cardsPairsCounts = 3
    // сущность "Игра"
    lazy var game: Game = getNewGame()
    private func getNewGame() -> Game {
        let game = Game()
        game.cardsCount = self.cardsPairsCounts
        game.generateCards()
        return game
    }
    private var flippedCards = [UIView]()
    //перевернуты на лицевую сторону все карты на поле
    private var allCardsflipped = false
    
    var storage: GameStorage!
    //var storage: GameStorageProtocol!
 //MARK: Buttons
    // кнопка для запуска/перезапуска игры
    lazy var startButtonView = getStartButtonView()
    private func getStartButtonView() -> UIButton {
        // 1
        // Создаем кнопку
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        // 2
        // Изменяем положение кнопки
        button.center.x = view.center.x
        // получаем доступ к текущему окну
        let window = UIApplication.shared.windows[0]
        // определяем отступ сверху от границ окна до Safe Area
        let topPadding = window.safeAreaInsets.top + (self.navigationController?.navigationBar.frame.height ?? 0.0)
        // устанавливаем координату Y кнопки в соответствии с отступом
        button.frame.origin.y = topPadding
        // 3
        // Настраиваем внешний вид кнопки
        // устанавливаем текст
        button.setTitle("Начать игру", for: .normal)
        // устанавливаем цвет текста для обычного (не нажатого) состояния
        button.setTitleColor(.black, for: .normal)
        // устанавливаем цвет текста для нажатого состояния
        button.setTitleColor(.gray, for: .highlighted)
        // устанавливаем фоновый цвет
        button.backgroundColor = .systemGray4
        // скругляем углы
        button.layer.cornerRadius = 10
        // подключаем обработчик нажатия на кнопку
        button.addTarget(nil, action: #selector(startGame(_:)), for: .touchUpInside)
        return button
    }
    // кнопка для переворота всех карт
    lazy var overturnButtonView = getOverturnButtonView()
    private func getOverturnButtonView() -> UIButton {
        // 1
        // Создаем кнопку
        let buttomheight = 50
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: buttomheight))
        // 2
        // Изменяем положение кнопки
        button.center.x = view.center.x
        // получаем доступ к текущему окну
        let window = UIApplication.shared.windows[0]
        // определяем отступ cснизу от границ окна до Safe Area
        let bottomPadding = window.safeAreaInsets.bottom
        

        // устанавливаем координату Y кнопки в соответствии с отступом
        button.frame.origin.y = window.bounds.height - bottomPadding - CGFloat(buttomheight)
        // 3
        // Настраиваем внешний вид кнопки
        // устанавливаем текст
        button.setTitle("Перевернуть", for: .normal)
        // устанавливаем цвет текста для обычного (не нажатого) состояния
        button.setTitleColor(.black, for: .normal)
        // устанавливаем цвет текста для нажатого состояния
        button.setTitleColor(.gray, for: .highlighted)
        // устанавливаем фоновый цвет
        button.backgroundColor = .systemGray4
        // скругляем углы
        button.layer.cornerRadius = 10
        // подключаем обработчик нажатия на кнопку
        button.addTarget(nil, action: #selector(overturnCards(_:)), for: .touchUpInside)
        return button
    }
    //кнопка вызова окна с настройками
    private lazy var buttonSettings = getSettingButton()
    private func getSettingButton() -> UIBarButtonItem{
        
        var rightBarButton = UIBarButtonItem(title: "Настройки", style: UIBarButtonItem.Style.plain, target: self, action: #selector(buttonSetting))

        return rightBarButton

    }
    //лейбл с количеством переворотов
    lazy var labelTurnCount = getLabelTurnView()
    private func getLabelTurnView() -> UILabel{
        let label = UILabel(frame: CGRect(x: 10, y: 123, width: 200, height: 21))
        //label.center = CGPoint(x: 20, y: 92)
        label.center.x =  view.center.x
        label.textAlignment = .center
        label.backgroundColor = .orange
        label.text = "0"
        return label
    }
    //лейбл с количеством переворотов
    lazy var labelTurnText = getLabelTextView()
    private func getLabelTextView() -> UILabel{
        let label = UILabel(frame: CGRect(x: 10, y: 92, width: 200, height: 21))
        //label.center = CGPoint(x: 20, y: 92)
        label.center.x =  view.center.x
        label.textAlignment = .center
        label.backgroundColor = .orange
        label.text = "Количество ходов"
        return label
    }
    override func loadView() {
        super.loadView()
        // добавляем кнопку на сцену
        //view.addSubview(startButtonView)
        // добавляем игровое поле на сцену
        view.addSubview(boardGameView)
        // добавляем кнопку-переворот на сцену
        view.addSubview(overturnButtonView)

        //добавляем лейбл со счетом
        view.addSubview(labelTurnCount)
        //добавляем лейбл со счетом
        view.addSubview(labelTurnText)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = buttonSettings
        startGame2()
        storage = GameStorage()
    }
    
    @objc func startGame(_ sender: UIButton) {
        game = getNewGame()
        let cards = getCardsBy(modelData: game.cards)
        placeCardsOnBoard(cards)
        game.turnCount = 0
        game.cardsFind = 0
        updateTextFieldData()
        
    }
    func startGame2() {
        game = getNewGame()
        let cards = getCardsBy(modelData: game.cards)
        placeCardsOnBoard(cards)
        game.turnCount = 0
        game.cardsFind = 0
        updateTextFieldData()
        print("start")
        print(game.cards)
        print(cardViews)
        print(cardViews[0].frame.minX)
        print(cardViews[0].frame.origin)
    }
    @objc func overturnCards(_ sendrt: UIButton){
        if flippedCards.count == 2*game.cardsCount - 2*game.cardsFind {
            //все карточки лицевой стороной вверх - переворот всех на обратную сторону
            for card in self.flippedCards {
                (card as! FlippableView).flip()
            }
      
        }else{
            // хотя бы одна карточка перевернута обратной стороной - все карточки на лицевую
            for card in cardViews{
                let flippedCard = card as! FlippableView
                if !flippedCard.isFlipped{
                    flippedCard.flip()
                }
            }
            allCardsflipped = true
        }
    }
    // передача данных с помощью свойства и инициализация замыкания
    @objc private func buttonSetting() {
        // получаем вью контроллер, в который происходит переход
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editScreen = storyboard.instantiateViewController(withIdentifier:"Settings")  as! SettingController
        // передаем данные
        editScreen.cardsPairsCounts = cardsPairsCounts
        // передаем необходимое замыкание
        editScreen.completionHandler = { [unowned self] updatedValue in
                cardsPairsCounts = updatedValue
                startGame2()
        }
        // переходим к следующему экрану
        self.navigationController?.pushViewController(editScreen, animated: true)
    }

    // игровое поле
    lazy var boardGameView = getBoardGameView()
    private func getBoardGameView() -> UIView {
        // отступ игрового поля от ближайших элементов
        let margin: CGFloat = 10
        let boardView = UIView()
        // указываем координаты
        // x
        boardView.frame.origin.x = margin // y
        let window = UIApplication.shared.windows[0]
        let topPadding = window.safeAreaInsets.top + (self.navigationController?.navigationBar.frame.height ?? 0.0)
        boardView.frame.origin.y = CGFloat(topPadding) + startButtonView.frame.height + margin
        // рассчитываем ширину
        boardView.frame.size.width = UIScreen.main.bounds.width - margin*2
        // рассчитываем высоту
        // c учетом нижнего отступа
        let bottomPadding = window.safeAreaInsets.bottom
        boardView.frame.size.height = UIScreen.main.bounds.height - boardView.frame.origin.y - margin - bottomPadding - overturnButtonView.frame.height
        // изменяем стиль игрового поля
        boardView.layer.cornerRadius = 5
        boardView.backgroundColor = UIColor(red: 0.1, green: 0.9, blue: 0.1,
        alpha: 0.3)
        return boardView
        
    }
    

    // генерация массива карточек на основе данных Модели
    private func getCardsBy(modelData: [Card]) -> [UIView] {
    // хранилище для представлений карточек
        var cardViews = [UIView]()
    // фабрика карточек
        let cardViewFactory = CardViewFactory()
        // перебираем массив карточек в Модели
        for (index, modelCard) in modelData.enumerated() {
            // добавляем первый экземпляр карты
            let cardOne = cardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
            cardOne.tag = index
            cardViews.append(cardOne)
        // добавляем второй экземпляр карты
            let cardTwo = cardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
            cardTwo.tag = index
            cardViews.append(cardTwo)
            
        }
        
        // добавляем всем картам обработчик переворота
        for card in cardViews {
            (card as! FlippableView).flipCompletionHandler = { [self] flippedCard in
              //   переносим карточку вверх иерархии
                flippedCard.superview?.bringSubviewToFront(flippedCard)
                
                // добавляем или удаляем карточку
                if flippedCard.isFlipped {
                    self.flippedCards.append(flippedCard)
                    game.turnCount += 1
                } else {
                    if let cardIndex = self.flippedCards.firstIndex(of: flippedCard) {
                        self.flippedCards.remove(at: cardIndex)
                    }
                }
              //   если перевернуто 2 карточки
                if self.flippedCards.count == 2 && allCardsflipped == false{
                    // получаем карточки из данных модели
                    let firstCard = game.cards[self.flippedCards.first!.tag]
                    let secondCard = game.cards[self.flippedCards.last!.tag]
                    // если карточки одинаковые
                    if game.checkCards(firstCard, secondCard) {
                        // сперва анимировано скрываем их
                        UIView.animate(withDuration: 0.3, animations: {
                            self.flippedCards.first!.layer.opacity = 0
                            self.flippedCards.last!.layer.opacity = 0
                            // после чего удаляем из иерархии
                        }, completion: {_ in
                            self.flippedCards.first!.removeFromSuperview()
                            self.flippedCards.last!.removeFromSuperview()
                            self.flippedCards = []
                            self.allCardsflipped = false

                        })
                        game.cardsFind += 1
                        // в ином случае
                    } else {
                        // переворачиваем карточки рубашкой вверх
                        for card in self.flippedCards {
                            (card as! FlippableView).flip()
                        }
                    }

                    }
                if self.flippedCards.count == 0{
                    self.allCardsflipped = false
                }
                updateTextFieldData()
                if game.cardsFind == game.cardsCount {
                    self.showAlertWith(score: game.turnCount)
                    print("finish")
                    print(cardViews)
                }
           }
        }
        return cardViews
    }
    
    // размеры карточек
    private var cardSize: CGSize {
        CGSize(width: 80, height: 120)
    }
        // предельные координаты размещения карточки
    
    private var cardMaxXCoordinate: Int {
        Int(boardGameView.frame.width - cardSize.width) }
    private var cardMaxYCoordinate: Int {
        Int(boardGameView.frame.height - cardSize.height)
        }
    
    // игральные карточки
    var cardViews = [UIView]()
    private func placeCardsOnBoard(_ cards: [UIView]) {
        // удаляем все имеющиеся на игровом поле карточки
        for card in cardViews {
            card.removeFromSuperview()
        }
        cardViews = cards
        // перебираем карточки
        for card in cardViews {
            // для каждой карточки генерируем случайные координаты
            let randomXCoordinate = Int.random(in: 0...cardMaxXCoordinate)
            let randomYCoordinate = Int.random(in: 0...cardMaxYCoordinate)
            card.frame.origin = CGPoint(x: randomXCoordinate, y: randomYCoordinate)
            // размещаем карточку на игровом поле
            boardGameView.addSubview(card)
        }
        //storage.save(game: game, cardViews:  cardViews)
    }
    
    private func updateTextFieldData() {
        labelTurnCount.text = String(game.turnCount)
    }
    
    // Отображение всплывающего окна со счетом
    private func showAlertWith(score: Int) {
        storage.save(game: game, cardViews:  cardViews)
        let alert = UIAlertController( title: "Игра окончена", message: "Вы сделали \(score) переворотов", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Начать заново", style: .default, handler: {_ in self.startGame2()}))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
}


protocol GameStorageProtocol {
    // Загрузка списка контактов
    //func load() -> Game
    // Обновление списка контактов
    func save(game: Game, cardViews: [UIView])
}
class GameStorage: GameStorageProtocol{
    // Ссылка на хранилище
    private var storage = UserDefaults.standard
    // Ключ, по которому будет происходить сохранение хранилища
    private var storageKey = "cards"
    private var storageKeyCoord = "coordinates"
    // Перечисление с ключами для записи в User Defaults
    
    
//    func load() -> Game {
//        <#code#>
//    }

    func save(game: Game, cardViews: [UIView]) {
        let arraycards = game.cardsToarray()
        storage.set(arraycards, forKey: storageKey)
        print(arraycards)
        var arraycoordinates = [(Float, Float, Float, Int)]()
        
        for cards in cardViews{
            arraycoordinates.append((Float(cards.frame.origin.x),Float(cards.frame.origin.y), Float(cards.alpha), Int(cards.tag)))
        }
        print(arraycoordinates)
        storage.set(arraycoordinates,forKey: storageKeyCoord)
    }


}
