import UIKit

struct ErrorModel {
    let message: String
    let actionText: String
    let action: () -> Void
    let cancelText: String?
    let cancelAction: (() -> Void)?
    
    init(
        message: String,
        actionText: String,
        action: @escaping () -> Void,
        cancelText: String? = nil,
        cancelAction: (() -> Void)? = nil
    ) {
        self.message = message
        self.actionText = actionText
        self.action = action
        self.cancelText = cancelText
        self.cancelAction = cancelAction
    }
}

protocol ErrorView {
    func showError(_ model: ErrorModel)
}

extension ErrorView where Self: UIViewController {

    func showError(_ model: ErrorModel) {
        let alert = UIAlertController(
            title: nil,
            message: model.message,
            preferredStyle: .alert
        )
        
        // Кнопка отмены (слева) - добавляем первой
        if let cancelText = model.cancelText {
            let cancelAction = UIAlertAction(title: cancelText, style: .cancel) { _ in
                model.cancelAction?()
            }
            alert.addAction(cancelAction)
        }
        
        // Кнопка действия (Повторить) - справа
        // Используем preferredAction для выделения кнопки (она будет визуально выделена)
        let action = UIAlertAction(title: model.actionText, style: .default) {_ in
            model.action()
        }
        alert.addAction(action)
        alert.preferredAction = action // Делает кнопку предпочтительной (выделенной)
        
        present(alert, animated: true)
    }
}
