//
//  OrderDataManager.swift
//  loopr-ios
//
//  Created by xiaoruby on 2/5/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import Foundation
import Geth

// It's to all orders of an address.
class OrderDataManager {

    static let shared = OrderDataManager()

    private var orders: [Order]
    private var dateOrders: [String: [Order]]

    private init() {
        orders = []
        dateOrders = [:]
    }

    func getOrders(hideOtherPairs: Bool, currentMarket: Market, orderStatuses: [OrderStatus]? = nil) -> [Order] {
        guard let orderStatuses = orderStatuses else {
            return orders
        }
        let filteredOrder = orders.filter { (order) -> Bool in
            orderStatuses.contains(order.orderStatus)
        }
        if hideOtherPairs {
            return filteredOrder.filter({ (order) -> Bool in
                order.tradingPairDescription == currentMarket.description
            })
        } else {
            return filteredOrder
        }
    }
    
    func getOrders(token: String? = nil) -> [Order] {
        guard let token = token else {
            return orders
        }
        return orders.filter { (order) -> Bool in
            let pair = order.originalOrder.market.components(separatedBy: "-")
            return pair[0].lowercased() == token.lowercased()
        }
    }
    
    func getDateOrders(orderStatuses: [OrderStatus]? = nil) -> [String: [Order]] {
        guard let orderStatuses = orderStatuses else {
            return dateOrders
        }
        var result: [String: [Order]] = [:]
        for (date, orders) in dateOrders {
            var temp: [Order] = []
            for order in orders {
                if orderStatuses.contains(where: { (status) -> Bool in
                    order.orderStatus == status
                }) {
                    temp.append(order)
                }
            }
            if !temp.isEmpty {
                result[date] = temp
            }
        }
        return result
    }
    
    func getDateOrders(tokenSymbol: String? = nil) -> [String: [Order]] {
        guard let tokenSymbol = tokenSymbol else {
            return dateOrders
        }
        var result: [String: [Order]] = [:]
        for (date, orders) in dateOrders {
            for order in orders {
                let pair = order.originalOrder.market.components(separatedBy: "-")
                if pair[0].lowercased() == tokenSymbol.lowercased() {
                    if result[date] == nil {
                        result[date] = []
                    }
                    result[date]!.append(order)
                }
            }
        }
        return result
    }
    
    func shouldCancelAll() -> Bool {
        let defaults = UserDefaults.standard
        var result = defaults.bool(forKey: UserDefaultsKeys.cancelledAll.rawValue)
        guard !result else { return false }
        let hide = SettingDataManager.shared.getHideOtherPairs()
        if let market = PlaceOrderDataManager.shared.market {
            let openOrders = self.getOrders(hideOtherPairs: hide, currentMarket: market, orderStatuses: [.opened])
            if let cancellingOrders = defaults.stringArray(forKey: UserDefaultsKeys.cancellingOrders.rawValue) {
                openOrders.forEach { (order) in
                    if !cancellingOrders.contains(order.originalOrder.hash) {
                        result = true
                    }
                }
            } else {
                result = openOrders.count > 0
            }
        }
        return result
    }

    func getOrdersFromServer(completionHandler: @escaping (_ orders: [Order]?, _ error: Error?) -> Void) {
        if let owner = CurrentAppWalletDataManager.shared.getCurrentAppWallet()?.address {
            LoopringAPIRequest.getOrders(owner: owner) { orders, error in
                guard let orders = orders, error == nil else {
                    return
                }
                self.dateOrders = [:]
                for order in orders {
                    let time = UInt(order.originalOrder.validSince)
                    let valid = DateUtil.convertToDate(time, format: "MM/dd/yyyy")
                    if self.dateOrders[valid] == nil {
                        self.dateOrders[valid] = []
                    }
                    self.dateOrders[valid]!.append(order)
                }
                self.orders = orders
                completionHandler(orders, error)
            }
        }
    }
}
