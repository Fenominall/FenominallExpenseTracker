import UIKit

class CustomMainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private var selectedTab: Int = 0
    
    private var buttons = [UIButton]()
    private var buttonsColors = [UIColor]()
    private var dotView: DotView?
    
    private let customTabBarView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .systemBackground
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.applyShadow(color: .label)
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // Define colors for selected and unselected states
    private let selectedColor: UIColor = .label
    private let unselectedColor: UIColor = .gray
    
    override var viewControllers: [UIViewController]? {
        didSet {
            if let viewControllers = viewControllers {
                createButtonsStack(viewControllers)
                selectInitialTab()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isHidden = true
        addCustomTabBarView()
        if let viewControllers = viewControllers {
            createButtonsStack(viewControllers)
            selectInitialTab()
        }
        autolayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        customTabBarView.layer.cornerRadius = customTabBarView.frame.size.height / 2
    }
    
    func makeControllerForTabBar(with controller: UIViewController, withItemTitle: String, itemImage: String, itemTag: Int, itemBackgroundColor: UIColor) -> UIViewController {
        let controller = UINavigationController(rootViewController: controller)
        controller.tabBarItem = CustomMainTabBarItem(title: withItemTitle, image: UIImage(systemName: itemImage), tag: itemTag)
        (controller.tabBarItem as? CustomMainTabBarItem)?.backgroundColor = itemBackgroundColor
        return controller
    }
    
    private func createButtonsStack(_ viewControllers: [UIViewController]) {
        buttons.removeAll()
        buttonsColors.removeAll()
        
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        for (index, viewController) in viewControllers.enumerated() {
            guard let tabBarItem = viewController.tabBarItem as? CustomMainTabBarItem else {
                assertionFailure("TabBarItems class must be CustomMainTabBarItem")
                return
            }
            buttonsColors.append(tabBarItem.backgroundColor)
            
            let button = UIButton()
            button.tag = index
            button.addTarget(self, action: #selector(didSelectIndex(sender:)), for: .touchUpInside)
            if let image = viewController.tabBarItem.image?.withRenderingMode(.alwaysTemplate) {
                button.setImage(image, for: .normal)
                button.tintColor = unselectedColor
            }
            button.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(button)
            buttons.append(button)
        }
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    private func autolayout() {
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            customTabBarView.widthAnchor.constraint(equalTo: tabBar.widthAnchor, constant: -20),
            customTabBarView.heightAnchor.constraint(equalToConstant: 70),
            customTabBarView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -10),
            customTabBarView.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: customTabBarView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: customTabBarView.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: customTabBarView.heightAnchor),
            stackView.centerYAnchor.constraint(equalTo: customTabBarView.centerYAnchor)
        ])
    }
    
    private func addCustomTabBarView() {
        customTabBarView.frame = tabBar.frame
        view.addSubview(customTabBarView)
        view.bringSubviewToFront(self.tabBar)
        customTabBarView.addSubview(stackView)
    }
    
    private func selectInitialTab() {
        guard !buttons.isEmpty else { return }
        self.selectedIndex = 0
        self.selectedTab = 0
        buttons[0].tintColor = selectedColor
        
        addDotView(to: buttons[0])
    }
    
    @objc private func didSelectIndex(sender: UIButton) {
        let index = sender.tag
        
        buttons[selectedTab].tintColor = unselectedColor

        sender.tintColor = selectedColor
        
        self.selectedIndex = index
        self.selectedTab = index
        
        addDotView(to: sender)
    }
    
    private func addDotView(to button: UIButton) {
        // Remove the previous dot view if it exists
        dotView?.removeFromSuperview()
        
        let dotSize: CGFloat = 5
        let dotView = DotView(frame: CGRect(x: 0, y: 0, width: dotSize, height: dotSize))
        dotView.backgroundColor = .red
        
        // Add the dot view to the custom tab bar view, not the button
        customTabBarView.addSubview(dotView)
        
        // Position the dot view under the button
        dotView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dotView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            dotView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 2),
            dotView.widthAnchor.constraint(equalToConstant: dotSize),
            dotView.heightAnchor.constraint(equalToConstant: dotSize)
        ])
        
        self.dotView = dotView
    }
    
    // Delegate:
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard
            let items = tabBar.items,
            let index = items.firstIndex(of: item)
        else {
            return
        }
        didSelectIndex(sender: self.buttons[index])
    }
}


extension UIView {
    func applyShadow(color: UIColor = .black,
                     opacity: Float = 0.5,
                     offset: CGSize = CGSize(width: 0, height: 2),
                     radius: CGFloat = 4) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        clipsToBounds = false
    }
}


