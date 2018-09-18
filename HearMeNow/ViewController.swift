//
//  ViewController.swift
//  HearMeNow
//
//  Created by jdethwick on 9/14/18.
//  Copyright © 2018 MSShop Tech. All rights reserved.
//
//From the book Beginning xcode

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

    var hasRecording = false
    var soundPlayer: AVAudioPlayer?
    var soundRecorder: AVAudioRecorder?
    var session: AVAudioSession?
    var soundPath: String?
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func recordPressed(_ sender: Any) {
        if soundRecorder?.isRecording == true {
            soundRecorder?.stop()
            recordButton.setTitle("Record", for: UIControlState.normal)
            hasRecording = true
        } else {
            session?.requestRecordPermission{ (hasPermission) in
                if hasPermission {
                    print ("Accepted")
                    self.soundRecorder?.record()
                    self.recordButton.setTitle("Stop", for: UIControlState.normal)
                } else {
                    print("Permission is denied")
                }
            }
        }
    }

    @IBAction func playPressed(_ sender: Any) {
        if soundPlayer?.isPlaying == true {
            soundPlayer?.pause()
            playButton.setTitle("Play", for: UIControlState.normal)
            
        } else if hasRecording == true {
            let url = NSURL(fileURLWithPath: soundPath!)
            
            do {
                try soundPlayer = AVAudioPlayer(contentsOf: url as URL)
                soundPlayer?.delegate = self
                soundPlayer?.enableRate = true
                soundPlayer?.rate = 0.5
                soundPlayer?.play()
            } catch {
                print("Error initializing player \(error)")
            }
            
            playButton.setTitle("Pause", for: UIControlState.normal)
            hasRecording = false
            
        } else if soundPlayer != nil {
            soundPlayer?.play()
            playButton.setTitle("Pause", for: UIControlState.normal)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
//soundRecorder object initialized BEG
        //extension needs to match format
        soundPath = "\(NSTemporaryDirectory())hearmenow.acc"
        let url = NSURL(fileURLWithPath: soundPath!)

        
        session = AVAudioSession.sharedInstance()

        //var error: NSError?

        do {
            try session?.setActive(true)
        } catch {
            print ("setActive(false) ERROR : \(error)")
        }
        
        let settings = [
            AVSampleRateKey: 1000.0, //12000.0,
            AVNumberOfChannelsKey: 1 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
            AVFormatIDKey: kAudioFormatMPEG4AAC as NSNumber
            ] as [String : Any]
        
        
        do {
            try session?.setCategory(AVAudioSessionCategoryPlayAndRecord)
            soundRecorder = try AVAudioRecorder(url: url as URL, settings: settings)
        } catch {
            print("Error initializing the recorder: \(error)")
        }
        
        soundRecorder?.delegate = self
        soundRecorder?.prepareToRecord()
//soundRecorder object initialized END
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        recordButton.setTitle("Record", for: UIControlState.normal)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playButton.setTitle("Play", for: UIControlState.normal)
    }

    //OLD
//    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
//        recordButton.setTitle("Record", forState: UIControlState.Normal)
//    }
//
//    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
//        playButton.setTitle("Play", forState: UIControlState.Normal)
//    }
}

