//
//  ViewController.swift
//  MyWearON
//
//  Created by TAKAHASHI Naoki on 2019/10/06.
//  Copyright © 2019 TAKAHASHI Naoki. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController{
    
    var performanceMode : Int = 0
    var blindMode : Bool = false

    var segmentedControl: UISegmentedControl!
    var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playSound(name: "start")
        
        let params = ["robot", "glass", "gun", "ball", "mario", "money", "quiz", "run", "sword", "None"]
        segmentedControl = UISegmentedControl(items: params)
        segmentedControl.frame = CGRect(x: 0, y: view.frame.height-100, width: view.frame.width, height: 100)
        
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        self.view.addSubview(segmentedControl)
        
        let shakeButton = UIButton(type: UIButton.ButtonType.system)
        shakeButton.addTarget(self, action: #selector(shakeButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        shakeButton.setTitle("SHAKE", for: UIControl.State.normal)
        shakeButton.setTitleColor(UIColor.black, for: .normal)
        shakeButton.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        shakeButton.frame = view.frame
        shakeButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(shakeButton)
        shakeButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        shakeButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        shakeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 200).isActive = true
        shakeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        
        let plusButton = UIButton(type: UIButton.ButtonType.system)
        plusButton.addTarget(self, action: #selector(plusButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        plusButton.setTitle("PLUS", for: UIControl.State.normal)
        plusButton.setTitleColor(UIColor.black, for: .normal)
        plusButton.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        plusButton.frame = view.frame
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(plusButton)
        plusButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        plusButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        plusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 200).isActive = true
        plusButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        
        let screenButton = UIButton(type: UIButton.ButtonType.system)
        screenButton.addTarget(self, action: #selector(screenButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        screenButton.setTitle("screen", for: UIControl.State.normal)
        screenButton.setTitleColor(UIColor.black, for: .normal)
        screenButton.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        screenButton.frame = view.frame
        screenButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(screenButton)
        screenButton.widthAnchor.constraint(equalToConstant: 400).isActive = true
        screenButton.heightAnchor.constraint(equalToConstant: 200).isActive = true
        screenButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -125).isActive = true
        screenButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        
        let blindButton = UIButton(type: UIButton.ButtonType.system)
        blindButton.addTarget(self, action: #selector(blindButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        blindButton.setTitle("blind", for: UIControl.State.normal)
        blindButton.setTitleColor(UIColor.white, for: .normal)
        blindButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        blindButton.frame = view.frame
        blindButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(blindButton)
        blindButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        blindButton.heightAnchor.constraint(equalToConstant: 200).isActive = true
        blindButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 350).isActive = true
        blindButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
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
        shakeAction()
    }
    
    @objc func plusButtonEvent(_ sender: UIButton) {
        plusAction()
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
}

