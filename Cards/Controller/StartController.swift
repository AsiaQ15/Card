//
//  StartController.swift
//  Cards
//
//  Created by Ася Купинская on 28.12.2022.
//

import UIKit

class StartController: UIViewController {

    override func loadView() {
        super.loadView()
        // добавляем кнопку на сцену
        view.addSubview(startButtonView)
    }
    
    // кнопка для запуска/перезапуска игры
    lazy var startButtonView = getStartButtonView()
    private func getStartButtonView() -> UIButton {
        // 1
        // Создаем кнопку
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        // 2
        // Изменяем положение кнопки
        button.center.x = view.center.x
        button.center.y = view.center.y

        // 3
        // Настраиваем внешний вид кнопки
        // устанавливаем текст
        button.setTitle("Старт", for: .normal)
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
    @objc func startGame(_ sender: UIButton) {
        // получаем вью контроллер, в который происходит переход
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editScreen = storyboard.instantiateViewController(withIdentifier:"Game") as! UpdatingDataController
        // передаем данные
        //editScreen.updatingData = dataLabel.text ?? ""
        // переходим к следующему экрану
        self.navigationController?.pushViewController(editScreen as! UIViewController, animated: true)
    }
    


}
