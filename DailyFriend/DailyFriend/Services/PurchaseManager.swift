//
//  PurchaseManager.swift
//  DailyFriend
//
//  Created by Sonali Patel on 3/21/18.
//  Copyright © 2018 Sonali Patel. All rights reserved.
//

typealias CompletionHandler = (_ success: Bool) -> ()

import Foundation
import StoreKit

class PurchaseManager: NSObject, SKProductsRequestDelegate,SKPaymentTransactionObserver  {
    
    static let instance = PurchaseManager()
    
    let IAP_REMOVE_ADS = "edu.self.developer.sonali.DailyFriend.remove.ads"
    
    var productsRequest: SKProductsRequest!
    var products = [SKProduct]()
    var transcationComplete: CompletionHandler?
    
    func fetchProducts() {
        let productIds = NSSet(object: IAP_REMOVE_ADS) as! Set<String>
        productsRequest = SKProductsRequest(productIdentifiers: productIds)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func purchaseRemoveAds(onComplete: @escaping CompletionHandler) {
        if SKPaymentQueue.canMakePayments() && products.count > 0 {
            transcationComplete = onComplete
            let removeAdsProduct = products[0]
            let payment = SKPayment(product: removeAdsProduct)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            onComplete(false)
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
                transcationComplete?(true)
            }
            break
            case .failed:
             SKPaymentQueue.default().finishTransaction(transaction)
                transcationComplete?(false)
            case .restored:
             SKPaymentQueue.default().finishTransaction(transaction)
                transcationComplete?(true)
            default: transcationComplete?(false)
                break
            }
        }
    }
    
}
