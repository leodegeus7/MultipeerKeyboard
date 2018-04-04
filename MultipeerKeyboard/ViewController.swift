//
//  ViewController.swift
//  MultipeerKeyboard
//
//  Created by Leonardo Geus on 03/04/2018.
//  Copyright © 2018 Leonardo Geus. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var toolsView: UIView!
    @IBOutlet weak var keyboardView: UIView!
    @IBOutlet weak var labelNote: UILabel!
    @IBOutlet weak var devicesCount: UILabel!
    
    let peerService = PeerServiceManager()
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
    
    
    var timer:Timer!
    var count = 0
    var devices = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        peerService.delegate = self
        
        navigationController?.navigationBar.barStyle = .blackTranslucent
        
        doLabel.backgroundColor = Colors.color1
        reLabel.backgroundColor = Colors.color2
        miLabel.backgroundColor = Colors.color3
        faLabel.backgroundColor = Colors.color4
        solLabel.backgroundColor = Colors.color5
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
    }
    
    @IBAction func enabledTimer(_ sender: Any) {
        if let _ = timer {
        if timer.isValid {
            timer.invalidate()
        } else {
            self.keyboardView.isHidden = true
            timer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { (timer) in
                self.sendMessage()
            }
        }
        } else {
            self.keyboardView.isHidden = true
            timer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { (timer) in
                self.sendMessage()
            }
        }
        
    }
    
    func sendMessage() {
        var peerID = ""
        let note = notes[count]
        devices = peerService.pears.count

        if devices == 0 {
            print("There isn't connected devices, please connect other iOS gadgets")
            return
        } else {
            let a:Float = Float(Float(devices-1)/4)
            var vetor = [Int]()
            for i in 0...4 {
                vetor.append(Int(round(Float(i) * a)))
            }
            
            switch note {
            case "DO":
                peerID = "\(peerService.pears[vetor[0]].displayName)"
            case "RE":
                peerID = "\(peerService.pears[vetor[1]].displayName)"
            case "MI":
                peerID = "\(peerService.pears[vetor[2]].displayName)"
            case "FA":
                peerID = "\(peerService.pears[vetor[3]].displayName)"
            case "SOL":
                peerID = "\(peerService.pears[vetor[4]].displayName)"
            default:
                break
            }
            
            let info = "\(peerID)%\(notes[count])"
            peerService.send(string: info)
            self.labelNote.textColor = UIColor.black
            self.labelNote.text = "MESTRE: \(note)"
            self.view.backgroundColor = UIColor.white
            
            count = count + 1
            if count >= notes.count {
                count = 0
            }
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
    
    func sendNote(note:Note) {
        var peerID = ""
        devices = peerService.pears.count
        
        let a:Float = Float(Float(devices-1)/4)
        var vetor = [Int]()
        for i in 0...4 {
            vetor.append(Int(round(Float(i) * a)))
        }
            
        var info = ""
        switch note {
        case .Do:
            peerID = "\(peerService.pears[vetor[0]].displayName)"
            info = "\(peerID)%DO"
        case .Re:
            peerID = "\(peerService.pears[vetor[1]].displayName)"
            info = "\(peerID)%RE"
        case .Mi:
            peerID = "\(peerService.pears[vetor[2]].displayName)"
            info = "\(peerID)%MI"
        case .Fa:
            peerID = "\(peerService.pears[vetor[3]].displayName)"
            info = "\(peerID)%FA"
        case .Sol:
            peerID = "\(peerService.pears[vetor[4]].displayName)"
            info = "\(peerID)%SOL"
        }
        
        peerService.send(string: info)
        
    }
    
    @IBAction func keyBoardShow(_ sender: Any) {
        keyboardView.isHidden = !keyboardView.isHidden
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



extension ViewController : PeerServiceManagerDelegate {
    
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
            
            if String(strings[0]) == "\(self.peerService.myPeerId.displayName)" {
                switch strings[1] {
                case "DO":
                    self.change(color: Colors.color1,note: .Do)
                    break
                case "RE":
                    self.change(color: Colors.color2,note: .Re)
                    break
                case "MI":
                    self.change(color: Colors.color3,note: .Mi)
                    break
                case "FA":
                    self.change(color: Colors.color4,note: .Fa)
                    break
                case "SOL":
                    self.change(color: Colors.color5,note: .Sol)
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
