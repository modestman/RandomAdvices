//
//  AdviceViewController.swift
//  RandomAdvices
//
//  Created by Anton Glezman on 14.06.17.
//  Copyright © 2017 Globus. All rights reserved.
//

import UIKit
import CoreData

class AdviceViewController: UIViewController {
    
    struct Constants {
        static let adviceUpdateTimeInterval = 30.0
        static let progressUpdateTimeInterval = 0.1
        static let step = Float(progressUpdateTimeInterval / adviceUpdateTimeInterval)
    }
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var adviceLabel: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    
    fileprivate var adviceUpdatetimer: Timer?
    fileprivate var progressUpdatetimer: Timer?
    fileprivate var progressValue = 0.0
    
    fileprivate lazy var datasource: AdvicesDataSource = {
        let result = AdvicesDataSource()
        result.delegate = self
        return result
    }()
    
    fileprivate var currentAdvice: ApiAdviceModel? {
        didSet {
            self.adviceLabel.attributedText = currentAdvice?.attributedStringWith(fontSize: 26)
            self.adviceLabel.textAlignment = .center
            if let adv = currentAdvice {
                self.isFavorite = adv.favorite
            }
        }
    }
    
    fileprivate var isFavorite: Bool = false {
        didSet {
            if isFavorite {
                self.favoriteButton.setImage(#imageLiteral(resourceName: "favorites_active"), for: .normal)
            } else {
                self.favoriteButton.setImage(#imageLiteral(resourceName: "favorites"), for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.datasource.getRandomAdvice()
        NotificationCenter.default.addObserver(self, selector: #selector(AdviceViewController.didDeleteFavAdvice(_:)), name: .onDeleteFavAdvice, object: nil)
    }

    private func configureUI() {
        self.adviceLabel.text = nil
        self.progress.progress = 0.0
    }
    
    fileprivate func startAdviceUpdating() {
        if let timer = self.adviceUpdatetimer {
            timer.invalidate()
        }
        self.adviceUpdatetimer = Timer.scheduledTimer(timeInterval: Constants.adviceUpdateTimeInterval,
                                                      target: self,
                                                      selector: #selector(AdviceViewController.adviceTimerFire),
                                                      userInfo: nil,
                                                      repeats: true)
    }
    
    fileprivate func startProgressUpdating() {
        if let timer = self.progressUpdatetimer {
            timer.invalidate()
        }
        self.progressUpdatetimer = Timer.scheduledTimer(timeInterval: Constants.progressUpdateTimeInterval,
                                                      target: self,
                                                      selector: #selector(AdviceViewController.progressTimerFire),
                                                      userInfo: nil,
                                                      repeats: true)
    }

    // MARK: - Actions
    
    @IBAction func updateAdviceTouched(_ sender: Any) {
        self.datasource.getRandomAdvice()
    }
    
    @IBAction func favoriteTouched(_ sender: Any) {
        if let adv = currentAdvice {
            adv.favorite = !adv.favorite
            self.isFavorite = adv.favorite
            if (adv.favorite) {
                self.datasource.saveAdvice(adv)
            } else {
                self.datasource.deleteAdvice(adv)
            }
        }
    }
    
    func didDeleteFavAdvice(_ ntf: Notification) {
        guard let objId = ntf.object else {
            return
        }
        if let id = objId as? Int32 {
            if (self.currentAdvice?.id == Int(id)) {
                self.currentAdvice!.favorite = false
                self.isFavorite = false
            }
        }
    }
    
    func adviceTimerFire() {
        self.datasource.getRandomAdvice()
    }
    
    func progressTimerFire() {
        self.progress.setProgress(self.progress.progress + Constants.step, animated: true)
    }
    
    deinit {
        self.adviceUpdatetimer?.invalidate()
        self.progressUpdatetimer?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
}

extension AdviceViewController: AdvicesDataSourceDelegate {
    
    func advice(_ advice: ApiAdviceModel, inDatasource: AdvicesDataSource) {
        self.currentAdvice = advice
        self.progress.progress = 0.0
        self.startAdviceUpdating()
        self.startProgressUpdating()
    }
    
    func error(_ error: Error, inDatasource: AdvicesDataSource) {
        print(error)
    }
}
