//
//  AppDelegate.swift
//  TestSwiftCrash
//
//  Created by Artiom Bastun on 14/03/2019.
//  Copyright © 2019 test_proj. All rights reserved.
//

import UIKit

// can be fixed by "protocol TestMixArtworkService: class {"
protocol TestMixArtworkService {
    func artwork(for url: String) -> Data
}

enum Test {

    class SomeClass: NSObject {
        let id = UUID()
    }

    final class FirstImpl: TestMixArtworkService {
        func artwork(for url: String) -> Data {
            return Data()
        }
    }

    final class SecondImpl: TestMixArtworkService {

        // can be fixed by removing lazy
        private lazy var some: SomeClass = SomeClass()

        func artwork(for url: String) -> Data {
            _ = some
            return Data()
        }
    }

    final class ItemsProvider {
        private let artworkService: TestMixArtworkService

        init(artworkService: TestMixArtworkService) {
            self.artworkService = artworkService
        }

        private func customMap(_ items: [Int]) -> [(Int, Data)] {
            // can be fixed by create manual copy of var
//            let artworkService = self.artworkService
            return items.map { [artworkService] num in
                return (num, artworkService.artwork(for: "\(num)"))
            }
        }

        func getItems() -> [(Int, Data)] {
            let items = [Array(0..<10)].map(customMap).flatMap { $0 }
            return items
        }
    }

    static func test() {
        let provider1 = ItemsProvider(artworkService: FirstImpl())
        let x = provider1.getItems()
        print(x)

        let provider2 = ItemsProvider(artworkService: SecondImpl())
        let y = provider2.getItems()
        print(y)
    }
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Test.test()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

