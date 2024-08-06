//
//  SceneDelegate.swift
//  FenominallExpenseTrackerApp
//
//  Created by Fenominall on 10.05.2024.
//

import UIKit
import Combine
import FenominallExpenseTrackeriOS
import FenominallExpenseTracker


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: - Properties
    var window: UIWindow?
    private lazy var store: TransactionsStore & CategoriesStore = {
        do {
            return try CoreDataTransactionStore(
                storeURL: CoreDataTransactionStore.storeURL)
        } catch {
            print("Error instantiating CoreData store: \(error.localizedDescription)")
            assertionFailure("Failed to instantiate CoreData store with error: \(error.localizedDescription)")
            return NullStore()
        }
    }()
    private lazy var localTransactionManager: LocalFeedTransactionManager = {
        LocalFeedTransactionManager(store: store)
    }()
    
    private lazy var localTransactionCategoryManager: LocalTransactionCategoryManager = {
        LocalTransactionCategoryManager(store: store)
    }()
    
    private let feedUpdateNotifier = FeedUIUpdateNotifier()
    private let subscriptionManager = SubscriptionManager()
    private lazy var transactionDeleter = TransactionDeleter(notifier: feedUpdateNotifier)
    private lazy var navigationController = UINavigationController(rootViewController: configureTabBar())
    
    // MARK: - Secene willConnectTo
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    // MARK: - TabBarHelper
    private func configureTabBar() -> CustomMainTabBarController {
        let tabBarController = CustomMainTabBarController()
        tabBarController.viewControllers = [
            makeTabBarItem(
                controller: makeFeedViewController(),
                title: "Expenses",
                image: "menucard.fill",
                tag: 0
            ),
            makeTabBarItem(
                controller: makeChartViewController(),
                title: "Charts",
                image: "chart.bar.xaxis.ascending",
                tag: 1
            )
        ]
        return tabBarController
    }
    
    
    private func makeTabBarItem(
        controller: UIViewController,
        title: String,
        image: String,
        tag: Int
    ) -> UIViewController {
        return CustomMainTabBarController()
            .makeControllerForTabBar(
                with: controller,
                withItemTitle: title,
                itemImage: image,
                itemTag: tag,
                itemBackgroundColor: .lightGray
            )
    }
    
    // MARK: - Feed UI Compsoer
    private func makeFeedViewController() -> UIViewController {
        FeedUIComposer.feedComposedWith(
            subscriptionManager: subscriptionManager,
            transactionDeleter: transactionDeleter,
            updateNotifier: feedUpdateNotifier,
            transactionLoader: makeLocalFeedLoader,
            selection: showTransactionDetails,
            deleteTransaction: makeLocalTransactionRemover,
            addNewTransaction: didTapAddNewTransaction,
            searchTransaction: showSearchTransactionsController
        )
    }
    
    // MARK: - Add Transaction Composer
    private func didTapAddNewTransaction() {
        let vc = AddTransactionUIComposer.feedComposedWith(
            notifier: feedUpdateNotifier,
            onFullCategoryListSelection: categorySelectionFactory,
            onSaveAddTransaction: makeSaveTransactionPublisher
        )
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func makeSaveTransactionPublisher(_ transaction: Transaction) -> AnyPublisher<Void, Error> {
        return localTransactionManager
            .savePublisher(transaction: transaction)
    }
    
    // MARK: - Chart Composer
    private func makeChartViewController() -> UIViewController {
        ChartUIComposer.chartComposedWith(
            subscriptionManager: subscriptionManager,
            transactionLoader: makeLocalFeedLoader,
            updateNotifier: feedUpdateNotifier
        )
    }
    
    // MARK: - Transaction Details Composer
    private func showTransactionDetails(for transaction: Transaction) {
        let vc = EditTransactionUIComposer
            .feedComposedWith(
                selectedModel: transaction,
                notifier: feedUpdateNotifier,
                onSaveUpdateTransaction: makeUpdateTransactionPublisher,
                deleteTransaction: makeLocalTransactionRemover
            )
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func makeUpdateTransactionPublisher(_ transaction: Transaction) -> AnyPublisher<Void, Error> {
        return localTransactionManager
            .updatePublisher(transaction: transaction)
    }
    
    
    // MARK: - Category Selection Composer
    private func categorySelectionFactory(
        transactionType: TransactionTypeViewModel
    ) {
        let vc = CategorySelectionUIComposer
            .categorySelectionComposedWith(
                transactionType: transactionType,
                didSelectCategory: passSelectedCategory,
                didDeleteCategory: makeLocalCategoriesRemover,
                onAddCategorySelected: showCreateCategoryController,
                categoriesLoader: makeLocalCategoriesLoader
            )
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func passSelectedCategory(_ selectedCategory: any TransactionCategory) {
        if let addEditVC = navigationController.viewControllers
            .first(where: { $0 is AddEditTransactionViewController })
            as? AddEditTransactionViewController {
            addEditVC.updateSelectedCategory(selectedCategory)
            navigationController.popViewController(animated: true)
        }
    }
    
    private func makeLocalCategoriesRemover(
        _ toRemove: TransactionCategory
    ) -> AnyPublisher<Void, Error> {
        return localTransactionCategoryManager
            .deleteCategoriesPublisher([toRemove])
    }
    
    private func makeLocalCategoriesLoader() -> AnyPublisher<[UserDefinedTransactionCategory], Error> {
        return localTransactionCategoryManager
            .loadCategoriesPublisher()
    }
    
    // MARK: - Create Category Composer
    private func showCreateCategoryController() {
        let controller = CreateCategoryUIComposer
            .categoryCreationComposedWith(
                onAddCategory: makeSaveCategoryPublisher
            )
        navigationController.pushViewController(controller, animated: true)
    }
    
    private func makeSaveCategoryPublisher(_ category: UserDefinedTransactionCategory) -> AnyPublisher<Bool, Error> {
        return localTransactionCategoryManager
            .saveCategoryPublisher(category: category)
    }
    
    
    // MARK: - Search Transactions Controller
    private func showSearchTransactionsController() {
        let vc = SearchUIComposer.searchComposedWith(
            searchHandler: makeSearchPublisher,
            selection: showTransactionDetails
        )
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func makeSearchPublisher(
        query: String,
        filterOption: FilterOption?
    ) -> AnyPublisher<[Transaction], Error> {
        return localTransactionManager
            .searchPublisher(query, filter: filterOption)
    }
}

// MARK: - Shared Helpers
extension SceneDelegate {
    private func makeLocalFeedLoader() -> AnyPublisher<[Transaction], Error> {
        return localTransactionManager
            .loadPublisher()
    }
    
    private func makeLocalTransactionRemover(
        _ toRemove: Transaction
    ) -> AnyPublisher<Void, Error> {
        return localTransactionManager
            .deletePublisher(transactions: [toRemove])
    }
}
