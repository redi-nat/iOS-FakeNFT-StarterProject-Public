# Архитектура и способ верстки

## Выбранная архитектура

### Архитектурный паттерн: **MVP (Model-View-Presenter)**

Выбран паттерн MVP для реализации экрана корзины по следующим причинам:
- Четкое разделение ответственности между компонентами
- Легкое тестирование бизнес-логики (Presenter)
- Слабая связанность между View и Model
- Соответствие требованиям проекта

### Структура компонентов:

#### Model
- **CartNFT** - модель данных NFT в корзине
- **Currency** - модель данных валюты
- **Order** - модель заказа (корзины)
- **CartNFTCellModel** - модель для отображения в ячейке

#### View
- **CartViewController** - экран корзины (UIViewController)
- **CartNFTTableViewCell** - ячейка таблицы для NFT
- **CartSummaryView** - нижняя панель с итогами
- **CartLoadingView** - кастомный индикатор загрузки
- **CartView** - протокол для общения с Presenter

#### Presenter
- **CartPresenter** - протокол презентера
- **CartPresenterImpl** - реализация презентера
  - Управление состоянием корзины (enum CartState)
  - Обработка бизнес-логики
  - Координация между View и Service

#### Service
- **CartService** - сервис для работы с корзиной
- **CurrencyService** - сервис для работы с валютами
- **PaymentService** - сервис для оплаты

#### Assembly
- **CartAssembly** - Dependency Injection контейнер
- **ServicesAssembly** - сборка сервисов

### Поток данных:
```
View → Presenter → Service → NetworkClient → API
  ↑                                    ↓
  └─────────── Update UI ─────────────┘
```

### Управление состоянием:
Используется паттерн State Machine через enum `CartState`:
- `.initial` - начальное состояние
- `.loading` - загрузка данных
- `.data([CartNFT])` - данные загружены
- `.empty` - корзина пуста
- `.failed(Error)` - ошибка загрузки

---

## Способ верстки

### Фреймворк: **UIKit**

### Метод верстки: **Auto Layout (Programmatic UI)**

Все UI компоненты создаются программно без использования Storyboard/XIB:
- Использование `NSLayoutConstraint` для constraints
- Все view создаются через `lazy var` свойства
- `translatesAutoresizingMaskIntoConstraints = false` для всех кастомных view

### Преимущества выбранного подхода:
- Полный контроль над кодом
- Легче отслеживать изменения в Git
- Нет проблем с merge конфликтами
- Более гибкая настройка constraints
- Соответствие требованиям проекта

### Пример структуры верстки:
```swift
private lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
}()
```

### Использованные компоненты:
- **UITableView** - для отображения списка NFT
- **UIStackView** - для рейтинга (звезды)
- **UILabel** - для текстовых элементов
- **UIImageView** - для изображений
- **UIButton** - для кнопок действий
- **UIActivityIndicatorView** - для индикатора загрузки

### Библиотеки:
- **Kingfisher** - для загрузки и кеширования изображений
- Нативные компоненты UIKit для остального функционала

---

## Многопоточность

### Использование: **GCD (Grand Central Dispatch)**

- Все сетевые запросы выполняются в фоновом потоке
- Обновление UI происходит в главном потоке через `DispatchQueue.main.async`
- Использование `URLSession` для сетевых запросов
- Правильная обработка `weak self` для предотвращения retain cycles

### Пример:
```swift
cartService.loadCart { [weak self] result in
    DispatchQueue.main.async {
        // Обновление UI
    }
}
```

---

## Dependency Injection

Используется паттерн Dependency Injection через Assembly:
- **CartAssembly** - создает и связывает компоненты экрана корзины
- **ServicesAssembly** - создает и управляет сервисами
- Все зависимости передаются через инициализаторы

Это обеспечивает:
- Тестируемость кода
- Слабое связывание компонентов
- Легкую замену зависимостей

