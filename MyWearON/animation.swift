//
//  animation.swift
//  MyWearON
//
//  Created by TAKAHASHI Naoki on 2019/10/11.
//  Copyright © 2019 TAKAHASHI Naoki. All rights reserved.
//

import UIKit

extension ViewController {
    func onButton(){
        var imgView:UIImageView!
        imgView = UIImageView()
        imgView.frame = CGRect(x: self.view.frame.width/2 + 150, y:self.view.frame.height/2 , width: 110, height: 60)
        imgView.image = UIImage(named: "on.png")
        
        view.addSubview(imgView)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            imgView.removeFromSuperview()
        }
    }
    
    func offButton(){
        var imgView:UIImageView!
        imgView = UIImageView()
        imgView.frame = CGRect(x: self.view.frame.width/2 + 150, y:self.view.frame.height/2 , width: 110, height: 60)
        imgView.image = UIImage(named: "off.png")
        
        view.addSubview(imgView)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            imgView.removeFromSuperview()
        }
    }
}
