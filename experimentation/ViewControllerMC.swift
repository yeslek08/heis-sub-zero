//
//  ViewControllerMC.swift
//  experimentation
//
//  Created by l00p on 9/15/16.
//  Copyright © 2016 l00p. All rights reserved.
//

import MultipeerConnectivity
import UIKit

class ViewControllerMC: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    let startSessionButton = UIButton(frame: CGRect(x: 150, y: 200, width: 75, height: 40))
    let sendDataButton = UIButton(frame: CGRect(x: 150, y: 400, width: 75, height: 40))

    var label = UILabel(frame: CGRect(x: 150, y: 600, width: 200, height: 40))

    
    override func viewDidLoad() {
        super.viewDidLoad()
        startSessionButton.backgroundColor = UIColor.blue
        startSessionButton.setTitle("Start Sesh", for: UIControlState())
        startSessionButton.addTarget(self, action: #selector(showConnectionPrompt), for: .touchUpInside)
        self.view.addSubview(startSessionButton)
        
        sendDataButton.backgroundColor = UIColor.blue
        sendDataButton.setTitle("Send Data", for: UIControlState())
        sendDataButton.addTarget(self, action: #selector(sendData), for: .touchUpInside)
        self.view.addSubview(sendDataButton)


        label.textAlignment = NSTextAlignment.center
        label.text = "L"
        self.view.addSubview(label)
        
        // Int to NSData and back
        /*var src: NSInteger = 2525
        var out: NSInteger = 0
        
        let data = NSData(bytes: &src, length: MemoryLayout<NSInteger>.size)
        data.getBytes(&src, length: MemoryLayout<NSInteger>.size)
        */
        title = "Experimentation"
        
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
        //sendImage(data1: 4)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showConnectionPrompt() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }

    func sendData() {
    if mcSession.connectedPeers.count > 0 {
        var numVal: NSInteger = 655
        
        let data = NSData(bytes: &numVal, length: MemoryLayout<NSInteger>.size)

            do {
                try mcSession.send(data as Data, toPeers: mcSession.connectedPeers, with: .reliable)
                label.text?.append("1")
            } catch {
                let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(ac, animated: true)
                label.text?.append("2")
        }
        }
    
    
    }
    func startHosting(action: UIAlertAction!) {
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "experimentation", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
    }
    
    func joinSession(action: UIAlertAction!) {
        let mcBrowser = MCBrowserViewController(serviceType: "experimentation", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
    }
    //CANT SEND WHEN NO CONNECTED PEERS!!
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        var val: NSInteger = 0
        //var data1 = NSData(bytes: &src, length: MemoryLayout<NSInteger>.size)
        var data1 = data as NSData
        data1.getBytes(&val, length: MemoryLayout<NSInteger>.size)
        label.text?.append("D\(data1)")

        //print("THE DATA ISSSSSSSSSSSSSS: \(val)")
    }
    
    // NOT CALLED ANYWHERE
    func sendImage(data1: Int) {
        //print("SEND!!!!!1111")
        label.text?.append("1")
        if mcSession.connectedPeers.count < 5 {
            //print("SEND 2!!!!!")
            label.text?.append("2")
        /*
 String encoding first
        let numData = data1
        let numDataString = String(numData)
        let numDataNSString = numDataString as NSString
        let data = numDataNSString.data(using: String.Encoding.utf8.rawValue)
 */
            var numVal: NSInteger = 9
            
            let data = NSData(bytes: &numVal, length: MemoryLayout<NSInteger>.size)
    
        do {
                try mcSession.send(data as Data, toPeers: mcSession.connectedPeers, with: .reliable)
                //print("SEND 3!!!!!")
                label.text?.append("3")
            
            } catch let error as NSError {
                //print("SEND 4 ERROR!!!!!")
                label.text?.append("4")
                let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        }
    }
}

