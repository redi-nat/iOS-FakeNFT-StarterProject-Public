import Foundation

/// Протокол для View в архитектуре MVP экрана выбора валюты
protocol CurrencySelectionView: AnyObject, ErrorView, LoadingView {
    /// Отображает список валют
    func displayCurrencies(_ currencies: [Currency])
    
    /// Обновляет состояние кнопки оплаты
    func updatePayButton(enabled: Bool)
    
    /// Показывает экран успешной оплаты
    func showPaymentSuccess()
}

