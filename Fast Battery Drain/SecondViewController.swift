//
//  SecondViewController.swift
//  Fast Battery Drain
//
//  Created by Muhammad umair ali on 21/01/2019.
//  Copyright © 2019 Muhammad umair ali. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox


class SecondViewController: UIViewController {

    var player = AVAudioPlayer()
    var buttonIsSelected = false
    var buttonselected = false
    var  isTourch = false
    
 
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavBarImage()
        // Do any additional setup after loading the view.
    }
    func addNavBarImage() {
   let navController = navigationController!
         let image = #imageLiteral(resourceName: "title")
        let imageView = UIImageView(image: image)
         let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        let bannerX = bannerWidth / 2 - image.size.width / 2
        let bannerY = bannerHeight / 2 - image.size.width / 2
        imageView.frame = CGRect(x: bannerX,y: bannerY,width:bannerWidth,height:bannerHeight)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
    static let soundId: SystemSoundID? = {
        guard let soundURL = Bundle.main.url(forResource: "opening", withExtension: "mp3")
            else {
                return nil
        }
        
        var soundId: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundId)
        return soundId
    }()
    
    static let timerInterval: TimeInterval = 1
    
    var soundTimer: Timer?
    var vibrationTimer: Timer?
    var playCount = 0 {
        didSet {
            
        }
    }
    
    func invalidateTimers() {
        if let vibrationTimer = vibrationTimer {
            vibrationTimer.invalidate()
        }
        if let soundTimer = soundTimer {
            soundTimer.invalidate()
        }
    }
    
    
    var playCountLabel: UILabel!
    func vibrate(_ sender: AnyObject) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        playCount += 1
    }
    
    
    
    @IBAction func Flashlight(_ sender: UISwitch) {
        
        guard let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else { return }
        
        
        
        if device.hasTorch {
            
            isTourch = !isTourch
            
            do {
                
                try device.lockForConfiguration()
                
                
                
                if isTourch == true {
                    
                    device.torchMode = .on
                    
                } else {
                    
                    device.torchMode = .off
                    
                }
                
                
                
                device.unlockForConfiguration()
                
            } catch {
                
                print("Torch is not working.")
            }
            
            
        } else {
            
            print("Torch not compatible with device.")
            
        }
        
    }
    
    
    
    @IBAction func Vibrator(_ sender: UISwitch) {
        
        buttonIsSelected = !buttonIsSelected
        updateOnOffButton()
        
    }
    
    @IBAction func Ringtones(_ sender: UISwitch) {
        
        buttonselected = !buttonselected
        updateStateButton()
        
    }
   
    func updateOnOffButton()
    {
        if buttonIsSelected {
            invalidateTimers()
            soundTimer = Timer.scheduledTimer(timeInterval: SecondViewController.timerInterval, target: self, selector: #selector(vibrate(_:)), userInfo: nil, repeats: true)
            
        }
        else {
            invalidateTimers()
        }
    }
    
    
    
    
    func updateStateButton()
    {
        if buttonselected {
            do {
                let audioPath = Bundle.main.path(forResource: "opening", ofType: "mp3")
                try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!) as URL)
            }
            catch {
                print("error !")
            }
            player.play()
            player.volume = 1
            player.numberOfLoops = -1
        }
        else {
            player.stop()
            
        }
    }
    
    
    
    @IBAction func Brightness(_ sender: UISlider) {
        
        UIScreen.main.brightness = CGFloat(sender.value)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
