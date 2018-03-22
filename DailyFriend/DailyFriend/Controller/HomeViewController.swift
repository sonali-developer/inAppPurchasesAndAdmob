//
//  ViewController.swift
//  DailyFriend
//
//  Created by Sonali Patel on 3/20/18.
//  Copyright © 2018 Sonali Patel. All rights reserved.
//

import UIKit
import GoogleMobileAds

class HomeViewController: UIViewController {
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var removeAdsBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAds()
    }
    
    func setUpAds() {
        if UserDefaults.standard.bool(forKey: PurchaseManager.instance.IAP_REMOVE_ADS)  {
            removeAdsBtn.removeFromSuperview()
            bannerView.removeFromSuperview()
        } else {
            bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        }
    }

    @IBAction func restoreBtnPressed(_ sender: Any) {
        PurchaseManager.instance.restorePurchases { (success) in
           self.setUpAds()
        }
    }
    @IBAction func removeAdsPressed(_ sender: Any) {
        
        //Show a loading spinner Activity Indicator
        PurchaseManager.instance.purchaseRemoveAds { (success) in
            //dismiss the spinner
            if success {
                self.bannerView.removeFromSuperview()
                self.removeAdsBtn.removeFromSuperview()
            } else {
                //Show message to the user why failed
            }
        }
    }
    

}

