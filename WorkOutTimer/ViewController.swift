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
        
        /*Graph layout*/
        prepareGraph.tag = 1
        prepareGraph.value = ceil(Settings().workOutTime)
        prepareGraph.maxValue = Settings().workOutTime
        prepareGraph.valueFontSize = 50
        prepareGraph.progressAngle = 100
        prepareGraph.progressLineWidth = 4
        prepareGraph.emptyLineWidth = 4
        prepareGraph.unitString = String().unit
        prepareGraph.unitFontSize = 20
        prepareGraph.progressCapType = 0
        prepareGraph.progressRotationAngle = 0
        prepareGraph.fontColor = Color().fontColor
        prepareGraph.progressColor = Color().red
        prepareGraph.progressStrokeColor = Color().red
        prepareGraph.emptyLineColor = Color().gray
        
        restGraph.tag = 2
        restGraph.value = ceil(Settings().restTime)
        restGraph.maxValue = Settings().restTime
        restGraph.valueFontSize = 50
        restGraph.progressAngle = 100
        restGraph.progressLineWidth = 4
        restGraph.emptyLineWidth = 4
        restGraph.unitString = String().unit
        restGraph.unitFontSize = 20
        restGraph.progressCapType = 0
        restGraph.progressRotationAngle = 0
        restGraph.fontColor = Color().fontColor
        restGraph.progressColor = Color().blue
        restGraph.progressStrokeColor = Color().blue
        restGraph.emptyLineColor = Color().gray
        
        workOutGraph.tag = 3
        workOutGraph.value = ceil(Settings().restTime)
        workOutGraph.maxValue = Settings().restTime
        workOutGraph.valueFontSize = 50
        workOutGraph.progressAngle = 100
        workOutGraph.progressLineWidth = 4
        workOutGraph.emptyLineWidth = 4
        workOutGraph.unitString = String().unit
        workOutGraph.unitFontSize = 20
        workOutGraph.progressCapType = 0
        workOutGraph.progressRotationAngle = 0
        workOutGraph.fontColor = Color().fontColor
        workOutGraph.progressColor = Color().yellow
        workOutGraph.progressStrokeColor = Color().yellow
        workOutGraph.emptyLineColor = Color().gray
        
        Graph_Set.tag = 4
        Graph_Set.value = ceil( CGFloat(Settings().counter_set) )
        Graph_Set.maxValue = CGFloat(Settings().counter_set)
        Graph_Set.valueFontSize = 20
        Graph_Set.progressAngle = 100
        Graph_Set.progressLineWidth = 2
        Graph_Set.unitString = ""//Design().unitString
        Graph_Set.emptyLineWidth = 2
        Graph_Set.unitFontSize = 10
        Graph_Set.progressCapType = 0
        Graph_Set.progressRotationAngle = 0
        Graph_Set.fontColor = Design().FontColor
        Graph_Set.progressColor = design.Orange
        Graph_Set.progressStrokeColor = design.Orange
        Graph_Set.emptyLineColor = UIColor.gray
        
        Graph_Total.tag = 5
        Graph_Total.value = ceil( CGFloat(Settings().endTime) )
        Graph_Total.maxValue = CGFloat(Settings().endTime)
        Graph_Total.valueFontSize = 20
        Graph_Total.progressAngle = 100
        Graph_Total.progressLineWidth = 2
        Graph_Total.unitString = ""//Design().unitString
        Graph_Total.emptyLineWidth = 2
        Graph_Total.unitFontSize = 10
        Graph_Total.progressCapType = 0
        Graph_Total.progressRotationAngle = 0
        Graph_Total.fontColor = Design().FontColor
        Graph_Total.progressColor = design.Orange
        Graph_Total.progressStrokeColor = design.Orange
        Graph_Total.emptyLineColor = UIColor.gray
        
        /*Graph position*/
        //
        //
        
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

enum String {
    var unit = "Sec"
}

enum Color {
    var fontColor = formatter().colorWithHexString(hex: "6F7179", Alpha: 1.0 )
    let yellow:UIColor = formatter().colorWithHexString(hex: "B9AD1E", Alpha: 1.0)
    let red:UIColor = formatter().colorWithHexString(hex: "CC2D62", Alpha: 1.0)
    let blue:UIColor = formatter().colorWithHexString(hex: "2D8CDD", Alpha: 1.0)
    let green:UIColor = formatter().colorWithHexString(hex: "70BF41", Alpha: 1.0)
    let orange:UIColor = formatter().colorWithHexString(hex: "F39019", Alpha: 1.0)
}
