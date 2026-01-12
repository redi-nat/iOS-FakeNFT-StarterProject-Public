import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupTabs()
    }
    
    private func setupTabs() {
            let catalogVC = CatalogAssembly.assembly()
            let catalogNav = UINavigationController(rootViewController: catalogVC)
            
            catalogNav.tabBarItem = UITabBarItem(
                title: "Каталог",
                image: UIImage(named: "tab_catalog"),
                selectedImage: nil
            )
            
            viewControllers = [catalogNav]
        }
    
    private func setupAppearance() {
            let appearance = UITabBarAppearance()
            
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .white
            appearance.shadowColor = nil
        
            let normalAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 10, weight: .medium),
                .foregroundColor: UIColor.black
            ]
            
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = normalAttributes
            
            tabBar.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = appearance
            }
        }
}
