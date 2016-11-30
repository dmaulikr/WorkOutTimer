//
//  ViewController.swift
//  WorkOutTimer
//
//  Created by 田山　由理 on 2016/11/28.
//  Copyright © 2016年 Yuri Tayama. All rights reserved.
//

import UIKit
import MBCircularProgressBar
import AVFoundation
import Spring
import GoogleMobileAds
import MediaPlayer

class ViewController: UIViewController {
    
    let talker = AVSpeechSynthesizer()
    var timer = Timer()
    var angleHolder:CGFloat = 0
    var pauseFlg = false
    var status = Status.others
    var musicPlayer = MPMusicPlayerController
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var baseTurnView: UIView!
    
    @IBOutlet weak var restAnimView: SpringView!
    @IBOutlet weak var prepareAnimView: SpringView!
    @IBOutlet weak var workOutAnimView: SpringView!

    @IBOutlet weak var restGraph: MBCircularProgressBarView!
    @IBOutlet weak var prepareGraph: MBCircularProgressBarView!
    @IBOutlet weak var workOutGraph: MBCircularProgressBarView!
    @IBOutlet weak var setGraph: MBCircularProgressBarView!
    @IBOutlet weak var totalGraph: MBCircularProgressBarView!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        musicPlayer = MPMusicPlayerController.applicationMusicPlayer()
        musicPlayer.beginGeneratingPlaybackNotifications()
        
        graphInit()
        restAll()
        
        setUpTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func graphInit() {
    
        baseTurnView.frame.size = CGSize(width: UIScreen.main.bounds.size.height * 0.55, height: UIScreen.main.bounds.size.height * 0.55 )
        baseTurnView.x = self.view.center.x
        
        workOutAnimView.frame.size = CGSize(width:baseTurnView.frame.size.width * 0.7, height: baseTurnView.frame.size.height * 0.7 )
        workOutGraph.frame.size = workOutAnimView.frame.size
        
        prepareAnimView.frame.size = CGSize(width:baseTurnView.frame.size.width * 0.7, height: baseTurnView.frame.size.height * 0.7 )
        prepareGraph.frame.size = prepareAnimView.frame.size
        
        restAnimView.frame.size = CGSize(width:baseTurnView.frame.size.width * 0.7, height: baseTurnView.frame.size.height * 0.7 )
        restGraph.frame.size = restAnimView.frame.size
        
        setGraph.frame.size = CGSize(width: 60, height: 60)
        titleLabel.center.x = self.view.center.x
        
        workOutGraph.tag = 3
        workOutGraph.value = ceil(Settings().workOutTime)
    }
    
    func resetAll() {
        
    }
    
    func setUpTimer() {
        
    }
    
    @IBAction func startTimer(_ sender: AnyObject) {
        
        //【AVSpeechUtterance】
        // - iOS7で追加された音声読み上げライブラリ
        // - http://dev.classmethod.jp/smartphone/iphone/swfit-avspeechsynthesizer/
        
        let utterance = AVSpeechUtterance(string: "Ready")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        talker.speak(utterance)
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(Duration().TimerUpdateDuration), target:self, selector:#selector(self.onUpdate), userInfo:nil, repeats:true)
        timer.fire()
        
        prepareAnimView.animation = "morph"
        prepareAnimView.duration = Duration().prepareAnimDuration
        prepareAnimView.animate()
        
        turnBaseView(ang: angleHolder)
        turnTimerView(subview: workOutGraph, ang: -angleHolder, scale: Scale.goBack)
        turnTimerView(subview: prepareGraph, ang: -angleHolder, scale: Scale.comeFrount)
        turnTimerView(subview: restGraph, ang: -angleHolder, scale: Scale.goBack)
        
        startButton.isHidden = true
        stopButton.isHidden = false
        pauseButton.isHidden = false
        
        if !pauseFlg {
            stats = Stats.prepare
            
            titleLabel.text = "READY"
            titlelabel.textColor = UIColor.yellow
            titlelabel.animation = "fadeInLeft"
            titleLabel.duration = Duration.startTitleDuration
            titleLabel.animate()
            
        } else {
            
        }
        
    }

    func onUpdate(timer:Timer) {
        
    }
    
    func turnBaseView(ang:CGFloat) {
        
    }
    
    func turnTimerView(subview:UIView, ang:CGFloat, scale:CGFloat) {
        
    }
}

enum Duration {
    let TimerUpdateDuration = 1.0
    let prepareAnimDuration = 1.0
    let startTitleDuration = 1.0
}

enum Scale {
    let comeFront = 1.0
    let goBack = 0.5
}

enum Status {
    let prepare = 1
    let rest    = 2
    let workOut = 3
    let pause   = 4
    let others  = 0
}

enum Settings {
    var workOutTime:CGFloat = 20
    var prepareTime:CGFloat = 10
    var restTime:CGFloat = 10
    var setCounter:CGFloat = 8
    var endTime:CGFloat
    
    init() {
        endTime = prepareTime + ( workOutTime + resTime ) * setCounter - restTime
    }
}
