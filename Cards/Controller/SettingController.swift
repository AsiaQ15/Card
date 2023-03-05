//
//  SettingController.swift
//  Cards
//
//  Created by Ася Купинская on 29.12.2022.
//

import UIKit

class SettingController: UIViewController {
    
    var cardsPairsCounts = 0
    var completionHandler: ((Int) -> Void)?
    
    lazy var label = getLabel()
    private func getLabel() -> UILabel{
        let label = UILabel(frame: CGRect(x: 10, y: 92, width: 200, height: 21))
        //label.center = CGPoint(x: 20, y: 92)
        label.center.x =  view.center.x
        label.center.y =  view.center.y
        label.textAlignment = .center
        label.backgroundColor = .orange
        label.text = "Количество пар"
        return label
    }
    lazy var textfield = getTextfield()
    private func getTextfield() -> UITextField{
        let text = UITextField(frame: CGRect(x: 10, y: 92, width: 200, height: 21))
        text.text = String(cardsPairsCounts)
        text.center.x = view.center.x
        text.textAlignment = .center
        // определяем отступ сверху от границ окна до Safe Area
        let topPadding = view.center.y + 31
        // устанавливаем координату Y кнопки в соответствии с отступом
        text.frame.origin.y = topPadding
        return text
    }
    //кнопка сохранения
    private lazy var buttonSave = getSaveButton()
    private func getSaveButton() -> UIBarButtonItem{
        
        var rightBarButton = UIBarButtonItem(title: "Сохранить", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveDataWithClosure))

        return rightBarButton

    }
    private func updatetextfield(){
        textfield.text = String(cardsPairsCounts)
    }
    
    override func loadView() {
        super.loadView()
        //добавляем лейбл
        view.addSubview(label)
        //добавляем текстовое поле
        view.addSubview(textfield)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = buttonSave
        updatetextfield()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updatetextfield()
    }
    // Переход от Б к А
    // Передача данных с помощью замыкания
    @objc func saveDataWithClosure(_ sender: UIButton) {
        // получаем обновленные данные
        let updatedData = Int(textfield.text ?? "") ?? 0
        // вызваем замыкание
        completionHandler?(updatedData)
        // возвращаемся на предыдущий экран
        navigationController?.popViewController(animated: true)
    }

}
