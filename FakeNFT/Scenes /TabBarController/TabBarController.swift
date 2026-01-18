import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarAppearance()
        setupViewControllers()
        
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - Private Methods
    
    private func setupTabBarAppearance() {
        // Настройка цветов Tab Bar согласно макету Figma
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        // Цвет фона Tab Bar
        appearance.backgroundColor = .white
        
        // Цвет активной вкладки
        appearance.stackedLayoutAppearance.selected.iconColor = .tabBarActive
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.tabBarActive,
            .font: UIFont.systemFont(ofSize: 10, weight: .medium),
            .kern: -0.24
        ]
        
        // Цвет неактивной вкладки
        appearance.stackedLayoutAppearance.normal.iconColor = .tabBarInactive
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.tabBarInactive,
            .font: UIFont.systemFont(ofSize: 10, weight: .medium),
            .kern: -0.24
        ]
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    private func setupViewControllers() {
        // Профиль - используем кастомную иконку из Assets
        // Для активного состояния используем ту же иконку с цветом #0A84FF (через appearance)
        // Для неактивного - с цветом #1A1B22 (через appearance)
        let profileController = ProfileViewController()
        let profileImage = UIImage(named: "profileTabBar")?.withRenderingMode(.alwaysTemplate)
        profileController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.profile", comment: ""),
            image: profileImage,
            tag: 0
        )
        
        // Каталог - используем кастомную иконку из Assets
        let catalogController = CatalogAssembly.assembly()
        let catalogNavController = UINavigationController(rootViewController: catalogController)
        let catalogImage = UIImage(named: "catalogTabBar")?.withRenderingMode(.alwaysTemplate)
        catalogController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.catalog", comment: ""),
            image: catalogImage,
            tag: 1
        )
        
        // Корзина - используем кастомную иконку из Assets
        // Встраиваем в Navigation Controller для отображения Navigation Bar
        let cartAssembly = CartAssembly(servicesAssembly: servicesAssembly)
        let cartController = cartAssembly.build()
        let cartNavigationController = UINavigationController(rootViewController: cartController)
        // Пробуем загрузить кастомную иконку, если не получается - используем системную
        let cartImage = UIImage(named: "cartTabBar")?.withRenderingMode(.alwaysTemplate) ?? 
                        UIImage(systemName: "cart")?.withRenderingMode(.alwaysTemplate)
        cartNavigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.cart", comment: ""),
            image: cartImage,
            tag: 2
        )
        
        // Статистика - используем кастомную иконку из Assets
        let statisticsController = StatisticsViewController()
        let statisticsImage = UIImage(named: "statisticTabBar")?.withRenderingMode(.alwaysTemplate)
        statisticsController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.statistics", comment: ""),
            image: statisticsImage,
            tag: 3
        )
        
        viewControllers = [
            profileController,
            catalogNavController,
            cartNavigationController,
            statisticsController
        ]
    }
}
