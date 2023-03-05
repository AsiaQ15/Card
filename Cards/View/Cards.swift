//
//  Cards.swift
//  Cards
//
//  Created by Ася Купинская on 26.12.2022.
//

import UIKit

protocol FlippableView: UIView {
    var isFlipped: Bool { get set }  //перевернута ли карточка
    var flipCompletionHandler: ((FlippableView) -> Void)? { get set } //замыкание для выполнения после переворачивания
    func flip() // для анимирования переворота
}
class CardView<ShapeType: ShapeLayerProtocol>: UIView,FlippableView {
    // цвет фигуры
    var color: UIColor!
    var isFlipped: Bool = false{
        didSet {
            self.setNeedsDisplay()
            
        }
    }
    var flipCompletionHandler: ((FlippableView) -> Void)?
    // радиус закругления
    var cornerRadius = 20
    


    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        self.color = color
//        if isFlipped {
//            self.addSubview(backSideView)
//            self.addSubview(frontSideView)
//        } else {
//            self.addSubview(frontSideView)
//            self.addSubview(backSideView)
//        }
        setupBorders()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // удаляем добавленные ранее дочерние представления
        backSideView.removeFromSuperview()
        frontSideView.removeFromSuperview()
        // добавляем новые представления
        if isFlipped {
            self.addSubview(backSideView)
            self.addSubview(frontSideView)
        } else {
            self.addSubview(frontSideView)
            self.addSubview(backSideView)
            
        }
    }
    //func flip() {}
    
    // внутренний отступ представления
    private let margin: Int = 10
    // представление с лицевой стороной карты
    lazy var frontSideView: UIView = self.getFrontSideView()
    // представление с обратной стороной карты
    lazy var backSideView: UIView = self.getBackSideView()
    // возвращает представление для лицевой стороны карточки
    private func getFrontSideView() -> UIView {
        let view = UIView(frame: self.bounds)
        view.backgroundColor = .white
        let shapeView = UIView(frame: CGRect(x: margin, y: margin, width: Int(self.bounds.width)-margin*2, height: Int(self.bounds.height)-margin*2))
        view.addSubview(shapeView)
        // создание слоя с фигурой
        let shapeLayer = ShapeType(size: shapeView.frame.size, fillColor: color.cgColor)
        shapeView.layer.addSublayer(shapeLayer)
        // скругляем углы корневого слоя
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(cornerRadius)
        return view
    }
    // возвращает вью для обратной стороны карточки private
    func getBackSideView() -> UIView {
        let view = UIView(frame: self.bounds)
        view.backgroundColor = .white
    //выбор случайного узора для рубашки
        switch ["circle", "line"].randomElement()! {
        case "circle":
            let layer = BackSideCircle(size: self.bounds.size, fillColor: UIColor.black.cgColor)
            view.layer.addSublayer(layer)
        case "line":
            let layer = BackSideLine(size: self.bounds.size, fillColor: UIColor.black.cgColor)
            view.layer.addSublayer(layer)
        default:
            break
        }
        // скругляем углы корневого слоя
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(cornerRadius)

        return view
    }
    // настройка границ
    private func setupBorders(){
        self.clipsToBounds = true
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
    }
    // точка привязки
    private var anchorPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    //var sizeOfPoint: CGPoint = CGPoint(x: 0, y: 0)
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        anchorPoint.x = touches.first!.location(in: window).x - frame.minX
//        anchorPoint.y = touches.first!.location(in: window).y - frame.minY
//    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //view-родитель
        let parentFrame = self.superview!.bounds

        var pointX  = touches.first!.location(in: window).x - anchorPoint.x
        var pointY = touches.first!.location(in: window).y - anchorPoint.y
        //проверка выхода за границы
        pointX = pointX < 0 ? 0 : pointX
        pointY = pointY < 0 ? 0 : pointY
        let pointXMax = parentFrame.width - self.bounds.width
        pointX =  pointX > pointXMax ? pointXMax : pointX
        let pointYMax = parentFrame.height -  self.bounds.height
        pointY = pointY > pointYMax ? pointYMax : pointY

        self.frame.origin.x = pointX
        self.frame.origin.y = pointY

    }
    
    
    private var startTouchPoint: CGPoint!
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // изменяем координаты точки привязки
        anchorPoint.x = touches.first!.location(in: window).x - frame.minX
        anchorPoint.y = touches.first!.location(in: window).y - frame.minY
        // сохраняем исходные координаты
        startTouchPoint = frame.origin
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        // анимировано возвращаем карточку в исходную позицию
//        UIView.animate(withDuration: 0.5) {
//            self.frame.origin = self.startTouchPoint
//            // переворачиваем представление
//            if self.transform.isIdentity {
//                self.transform = CGAffineTransform(rotationAngle: .pi)
//            } else {
//            self.transform = .identity
//            }
//        }
        if self.frame.origin == startTouchPoint {
        flip()
            
        }
    }
    func flip() {
        // определяем, между какими представлениями осуществить переход
        let fromView = isFlipped ? frontSideView : backSideView
        let toView = isFlipped ? backSideView : frontSideView
        // запускаем анимированный переход
        UIView.transition(from: fromView, to: toView, duration: 0.5, options:[.transitionFlipFromTop], completion: { _ in // обработчик переворота
            self.flipCompletionHandler?(self) })
        isFlipped = !isFlipped
    }


}
