//
//  ViewController.swift
//  SocketTest
//
//  Created by Leonardo Geus on 03/04/2018.
//  Copyright © 2018 Leonardo Geus. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var labelNote: UILabel!
    @IBOutlet weak var devicesCount: UILabel!
    
    let colorService = PeerServiceManager()
    var player: AVAudioPlayer?
    
    var notes = ["MI","MI","FA","SOL","SOL","FA","MI","RE","DO","DO","RE","MI","MI","RE","RE","MI","MI","FA","SOL","SOL","FA","MI","RE","DO","DO","RE","MI","RE","MI","DO"]
    
    enum Note:String {
        case Do = "DO"
        case Re = "RE"
        case Mi = "MI"
        case Fa = "FA"
        case Sol = "SOL"
    }
    @IBOutlet weak var doLabel: UIButton!
    @IBOutlet weak var reLabel: UIButton!
    @IBOutlet weak var miLabel: UIButton!
    @IBOutlet weak var faLabel: UIButton!
    @IBOutlet weak var solLabel: UIButton!
    @IBOutlet weak var showKeysLabel: UIButton!
    @IBOutlet weak var autoPlayLabel: UIButton!
    
    
    var devices = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        colorService.delegate = self
        
        doLabel.backgroundColor = .red
        reLabel.backgroundColor = .blue
        miLabel.backgroundColor = .green
        faLabel.backgroundColor = .orange
        solLabel.backgroundColor = .magenta
        showKeysLabel.backgroundColor = .black
        autoPlayLabel.backgroundColor = .black
        
        roundCorners(button: doLabel)
        roundCorners(button: reLabel)
        roundCorners(button: miLabel)
        roundCorners(button: faLabel)
        roundCorners(button: solLabel)
        roundCorners(button: showKeysLabel)
        roundCorners(button: autoPlayLabel)
    }
    
    func roundCorners(button:UIButton) {
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.setTitleColor(UIColor.white, for: .normal)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var timer:Timer!
    
    @IBAction func enabledTimer(_ sender: Any) {
        if let _ = timer {
        if timer.isValid {
            timer.invalidate()
        } else {
            self.keyboardView.isHidden = true
            timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { (timer) in
                self.sendMessage()
            }
        }
        } else {
            self.keyboardView.isHidden = true
            timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { (timer) in
                self.sendMessage()
            }
        }
        
    }
    
    func sendMessage() {
        var peerID = ""
        let note = notes[count]
        devices = colorService.pears.count
        let division = Float(devices-1)/5.0
        
        switch note {
        case "DO":
            peerID = "\(colorService.pears[Int(division)].displayName)"
        case "RE":
            peerID = "\(colorService.pears[Int(division*2)].displayName)"
        case "MI":
            peerID = "\(colorService.pears[Int(division*3)].displayName)"
        case "FA":
            peerID = "\(colorService.pears[Int(division*4)].displayName)"
        case "SOL":
            peerID = "\(colorService.pears[Int(division*5)].displayName)"
        default:
            break
        }
        
        let info = "\(peerID)%\(notes[count])"
        colorService.send(colorName: info)

        self.labelNote.text = "MESTRE: \(note)"
        self.view.backgroundColor = UIColor.white
        
        count = count + 1
        if count >= notes.count {
            count = 0
        }
    }
    
    func change(color : UIColor,note: Note) {
        switch note {
        case .Do:
            self.labelNote.text = "DO"
            playSound(note: .Do)
        case .Re:
            self.labelNote.text = "RE"
            playSound(note: .Re)
        case .Mi:
            self.labelNote.text = "MI"
            playSound(note: .Mi)
        case .Fa:
            self.labelNote.text = "FA"
            playSound(note: .Fa)
        case .Sol:
            self.labelNote.text = "SOL"
            playSound(note: .Sol)
        }
        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = color
        }
    }
    

    
    func playSound(note:Note) {
        var url:URL!
        switch note {
        case .Do:
            url = Bundle.main.url(forResource: "do", withExtension: "wav")
            break
        case .Re:
            url = Bundle.main.url(forResource: "re", withExtension: "wav")
            break
        case .Mi:
            url = Bundle.main.url(forResource: "mi", withExtension: "wav")
            break
        case .Fa:
            url = Bundle.main.url(forResource: "fa", withExtension: "wav")
            break
        case .Sol:
            url = Bundle.main.url(forResource: "sol", withExtension: "wav")
            break
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }

    var count = 0
    

    @IBOutlet weak var toolsView: UIView!
    @IBOutlet weak var keyboardView: UIView!
    
    @IBAction func keyBoardShow(_ sender: Any) {
        keyboardView.isHidden = !keyboardView.isHidden
    }
    
    func sendNote(note:Note) {
        var peerID = ""
        devices = colorService.pears.count
        if devices >= 2 {
        let division = Float(devices-1)/5.0
            
        var info = ""
        switch note {
        case .Do:
            peerID = "\(colorService.pears[Int(division)].displayName)"
            info = "\(peerID)%DO"
        case .Re:
            peerID = "\(colorService.pears[Int(division*2)].displayName)"
            info = "\(peerID)%RE"
        case .Mi:
            peerID = "\(colorService.pears[Int(division*3)].displayName)"
            info = "\(peerID)%MI"
        case .Fa:
            peerID = "\(colorService.pears[Int(division*4)].displayName)"
            info = "\(peerID)%FA"
        case .Sol:
            peerID = "\(colorService.pears[Int(division*5)].displayName)"
            info = "\(peerID)%SOL"
        }
        
        colorService.send(colorName: info)
        }
    }
    
    @IBAction func doClick(_ sender: Any) {
        sendNote(note: .Do)
    }
    
    @IBAction func reClick(_ sender: Any) {
        sendNote(note: .Re)
    }
    
    @IBAction func miClick(_ sender: Any) {
        sendNote(note: .Mi)
    }
    
    @IBAction func faClick(_ sender: Any) {
        sendNote(note: .Fa)
    }
    
    @IBAction func solClick(_ sender: Any) {
        sendNote(note: .Sol)
    }
    
}



extension ViewController : ColorServiceManagerDelegate {
    
    func connectedDevicesChanged(manager: PeerServiceManager, connectedDevices: [String]) {
        DispatchQueue.main.async {
            self.devicesCount.text = "\(connectedDevices.count)"
        }
        
    }
    
    func colorChanged(manager: PeerServiceManager, colorString: String) {
        OperationQueue.main.addOperation {
            self.toolsView.isHidden = true
            self.keyboardView.isHidden = true
            let strings = colorString.split(separator: "%")
            
            if String(strings[0]) == "\(self.colorService.myPeerId.displayName)" {
                switch strings[1] {
                case "DO":
                    self.change(color: .red,note: .Do)
                    break
                case "RE":
                    self.change(color: .blue,note: .Re)
                    break
                case "MI":
                    self.change(color: .green,note: .Mi)
                    break
                case "FA":
                    self.change(color: .orange,note: .Fa)
                    break
                case "SOL":
                    self.change(color: .magenta,note: .Sol)
                    break
                default:
                    break
                }
            } else {
                self.labelNote.text = ""
                self.view.backgroundColor = UIColor.black
            }
        }
    }
    
}
