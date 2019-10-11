//
//  ViewController.swift
//  MyWearON
//
//  Created by TAKAHASHI Naoki on 2019/10/06.
//  Copyright © 2019 TAKAHASHI Naoki. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController{
    
    var performanceMode : Int = 0
    var blindMode : Bool = false
    var shakeMode : Bool = true
    var volumeValue : Float = 1.0
    var firstClickTime : Float = 0.0
    var initialVolume: Float = 0.0
    var volumeView: MPVolumeView!

    var segmentedControl: UISegmentedControl!
    var audioPlayer: AVAudioPlayer!
    
    var timerCounter : Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let volumeView = MPVolumeView(frame: CGRect(origin:CGPoint(x:/*-3000*/ 0, y:0), size:CGSize.zero))
        self.view.addSubview(volumeView)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.volumeChanged(notification:)), name:
        NSNotification.Name("AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
        
        playSound(name: "start")
        
        let params = ["robot", "glass", "gun", "ball", "mario", "money", "quiz", "run", "rider", "None"]
        segmentedControl = UISegmentedControl(items: params)
        segmentedControl.frame = CGRect(x: 0, y: view.frame.height-100, width: view.frame.width, height: 100)
        
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        self.view.addSubview(segmentedControl)
        
        let shakeButton = UIButton(type: UIButton.ButtonType.system)
        shakeButton.addTarget(self, action: #selector(shakeButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        shakeButton.setTitle("↑↓", for: UIControl.State.normal)
        shakeButton.setTitleColor(UIColor.white, for: .normal)
        shakeButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
        shakeButton.frame = view.frame
        shakeButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(shakeButton)
        shakeButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        shakeButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        shakeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 200).isActive = true
        shakeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        
        let plusButton = UIButton(type: UIButton.ButtonType.system)
        plusButton.addTarget(self, action: #selector(plusButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        plusButton.setTitle("single", for: UIControl.State.normal)
        plusButton.setTitleColor(UIColor.white, for: .normal)
        plusButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
        plusButton.frame = view.frame
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(plusButton)
        plusButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        plusButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        plusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 250).isActive = true
        plusButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        
        let minusButton = UIButton(type: UIButton.ButtonType.system)
         minusButton.addTarget(self, action: #selector(minusButtonEvent(_:)), for: UIControl.Event.touchUpInside)
         minusButton.setTitle("double", for: UIControl.State.normal)
         minusButton.setTitleColor(UIColor.white, for: .normal)
         minusButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
         minusButton.frame = view.frame
         minusButton.translatesAutoresizingMaskIntoConstraints = false
         self.view.addSubview(minusButton)
         minusButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
         minusButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
         minusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 160).isActive = true
         minusButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        
        
        let screenButton = UIButton(type: UIButton.ButtonType.system)
        screenButton.addTarget(self, action: #selector(screenButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        screenButton.setTitle("", for: UIControl.State.normal)
        screenButton.setTitleColor(UIColor.white, for: .normal)
        screenButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
        screenButton.frame = view.frame
        screenButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(screenButton)
        screenButton.widthAnchor.constraint(equalToConstant: 400).isActive = true
        screenButton.heightAnchor.constraint(equalToConstant: 200).isActive = true
        screenButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -125).isActive = true
        screenButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        
        let blindButton = UIButton(type: UIButton.ButtonType.system)
        blindButton.addTarget(self, action: #selector(blindButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        blindButton.setTitle("👁", for: UIControl.State.normal)
        blindButton.setTitleColor(UIColor.white, for: .normal)
        blindButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
        blindButton.frame = view.frame
        blindButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(blindButton)
        blindButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        blindButton.heightAnchor.constraint(equalToConstant: 200).isActive = true
        blindButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 350).isActive = true
        blindButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        
        // タイマーを作る
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.onUpdate(timer:)), userInfo: nil, repeats: true)

    }

    @objc func segmentChanged(_ sender: UISegmentedControl){
        switch sender.selectedSegmentIndex{
        case 0:
            performanceMode = 1
        case 1:
            performanceMode = 2
        case 2:
            performanceMode = 3
        case 3:
            performanceMode = 4
        case 4:
            performanceMode = 5
        case 5:
            performanceMode = 6
        case 6:
            performanceMode = 7
        case 7:
            performanceMode = 8
        case 8:
            performanceMode = 9
        case 9:
            performanceMode = 0
        default:
            break
        }
        print(performanceMode)
    }
    
    // ボタンが押された時に呼ばれるメソッド
    @objc func shakeButtonEvent(_ sender: UIButton) {
        shakeMode = !shakeMode
        if shakeMode{
            print("shake mode ON")
            onButton()
            
        }
        else{
            print("shake mode OFF")
            offButton()
        }
    }
    
    //shake detection
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if shakeMode{
            shakeAction()
        }
        else{
            
        }
    }
    
    @objc func plusButtonEvent(_ sender: UIButton) {
        doubleClicker()
    }
    
    @objc func minusButtonEvent(_ sender: UIButton) {
        minusAction()
    }
    
    @objc func screenButtonEvent(_ sender: UIButton) {
        screenAction()
    }
    
    @objc func blindButtonEvent(_ sender: UIButton) {
        blindMode = !blindMode
        if blindMode{
            //create blind
            print("create blind")
            
        }
        else{
            //delete blind
            print("delete blind")
        }
    }
    
    func plusAction(){
        let musicFile = String(performanceMode*10 + 1)
        print(musicFile)
        playSound(name: musicFile)
    }
    
    func minusAction(){
        let musicFile = String(performanceMode*10 + 0)//現在shakeと同じ
        print(musicFile)
        playSound(name: musicFile)
    }
    
    func shakeAction(){
        let musicFile = String(performanceMode*10 + 0)
        print(musicFile)
        playSound(name: musicFile)
    }
    
    func screenAction(){
        let musicFile = String(performanceMode*10 + 2)
        print(musicFile)
        playSound(name: musicFile)
    }
    func playMusic(filename : String){
        print(filename + ".mp3")
        playSound(name: filename)
    }
    
    @objc func volumeChanged(notification: NSNotification) {

        if let userInfo = notification.userInfo {
            if let volumeChangeType = userInfo["AVSystemController_AudioVolumeChangeReasonNotificationParameter"] as? String {
                if volumeChangeType == "ExplicitVolumeChange" {
                    print(userInfo[AnyHashable("AVSystemController_AudioVolumeNotificationParameter")])
                    if volumeValue > userInfo[AnyHashable("AVSystemController_AudioVolumeNotificationParameter")] as! Float{
                        print("volume down")
                        minusAction()//minusActionをあとでつくる
                    }
                    else if volumeValue < userInfo[AnyHashable("AVSystemController_AudioVolumeNotificationParameter")] as! Float{
                        print("volume up")
                        doubleClicker()
                    }
                    else if volumeValue == userInfo[AnyHashable("AVSystemController_AudioVolumeNotificationParameter")] as! Float && volumeValue == 1{
                        print("volume max")
                        doubleClicker()
                    }
                    else if volumeValue == userInfo[AnyHashable("AVSystemController_AudioVolumeNotificationParameter")] as! Float && volumeValue == 0{
                        print("volume min")
                        minusAction()
                    }
                    volumeValue = userInfo[AnyHashable("AVSystemController_AudioVolumeNotificationParameter")] as! Float
                }
            }
        }
    }
}

extension ViewController: AVAudioPlayerDelegate {
    func playSound(name: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: "mp3") else {
            print("音源ファイルが見つかりません")
            return
        }

        do {
            // AVAudioPlayerのインスタンス化
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))

            // AVAudioPlayerのデリゲートをセット
            audioPlayer.delegate = self as AVAudioPlayerDelegate

            // 音声の再生
            audioPlayer.play()
        } catch {
        }
    }
    
    func getNowTime() -> String{
        // 現在日時を取得
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMMHms", options: 0, locale: Locale(identifier: "ja_JP"))
        print(dateFormatter.string(from: now))
        return dateFormatter.string(from: now)
    }
    
    func doubleClicker(){
        if firstClickTime + 0.5 >= timerCounter{
            minusAction()
            print("double click")
        }
        else{
            plusAction()
            print("single click")
        }
        firstClickTime = timerCounter
    }
    
    // TimerのtimeIntervalで指定された秒数毎に呼び出されるメソッド
    @objc func onUpdate(timer : Timer){
         // カウントの値1増加
        timerCounter += 0.1
     }
    

}

