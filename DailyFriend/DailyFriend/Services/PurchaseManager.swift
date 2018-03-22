//
//  PurchaseManager.swift
//  DailyFriend
//
//  Created by Sonali Patel on 3/21/18.
//  Copyright © 2018 Sonali Patel. All rights reserved.
//

import Foundation
import StoreKit

class PurchaseManager: NSObject, SKProductsRequestDelegate,SKPaymentTransactionObserver  {
    
    static let instance = PurchaseManager()
    
    let IAP_REMOVE_ADS = "edu.self.developer.sonali.DailyFriend.remove.ads"
    
    var productsRequest: SKProductsRequest!
    var products = [SKProduct]()
    
    func fetchProducts() {
        let productIds = NSSet(object: IAP_REMOVE_ADS) as! Set<String>
        productsRequest = SKProductsRequest(productIdentifiers: productIds)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func purchaseRemoveAds() {
        if SKPaymentQueue.canMakePayments() && products.count > 0 {
            let removeAdsProduct = products[0]
            let payment = SKPayment(product: removeAdsProduct)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        }
    }
    
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        if response.products.count > 0 {
            print(response.products.debugDescription)
            products = response.products
            print(products.count)
        }
    }
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
            SKPaymentQueue.default().finishTransaction(transaction)
            if transaction.payment.productIdentifier == IAP_REMOVE_ADS {
                UserDefaults.standard.set(true, forKey: IAP_REMOVE_ADS)
            }
            break
            case .failed:
             SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
             SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
}
