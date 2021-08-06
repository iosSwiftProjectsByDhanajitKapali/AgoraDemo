//
//  ViewController.swift
//  Agora Demo
//
//  Created by unthinkable-mac-0025 on 04/08/21.
//

import UIKit
import AgoraRtcKit

class ViewController: UIViewController {
    
    //
    // Defines agoraKit
    var agoraKit: AgoraRtcEngineKit?
    
    @IBOutlet var remoteView: UIView!
    @IBOutlet var localView: UIView!
    @IBOutlet var leaveButton: UIButton!
    @IBOutlet var joinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        initializeAgoraEngine()
        setupLocalVideo()
        joinChannel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AgoraRtcEngineKit.destroy()
    }
 
    @IBAction func leaveButtonPressed(_ sender: UIButton) {
        print("Leaving Channel")
        leaveChannel()
        joinButton.isHidden = false
        leaveButton.isHidden = true
    }
    
    @IBAction func joinButtonPressed(_ sender: UIButton) {
        joinChannel()
        leaveButton.isHidden = false
        joinButton.isHidden = true
    }
    
}

extension ViewController{
    
    ///Use this function for calling Agora APIs
    func initializeAgoraEngine() {
        //Generate your appID from Agora console
        let appID = "c3a94e784e6741e9a08779dc87b66cf4"
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: appID, delegate: self)
    }
    
    func setupLocalVideo() {
        // Enables the video module
        agoraKit?.enableVideo()
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.renderMode = .hidden
        videoCanvas.view = localView
        // Sets the local video view
        agoraKit?.setupLocalVideo(videoCanvas)
    }
    
    func joinChannel(){
        print("Joining channel")
        // The uid of each user in the channel must be unique.
        let token = "006c3a94e784e6741e9a08779dc87b66cf4IACCPMcghP2nC/o8TiKuXJSBza66yqn8rzoY6htZt7o0ayMni+gAAAAAEABYI5phj/ELYQEAAQCP8Qth"
        agoraKit?.joinChannel(byToken: token, channelId: "demoChannel", info: nil, uid: 0, joinSuccess: { (channel, uid, elapsed) in
            print("Successfully Joined Channel \(channel)")
        })
    }
    
    func leaveChannel() {
        agoraKit?.leaveChannel(nil)
        print("Leaved the Channel")
    }
}

//MARK: - AgoraRtcEngineDelegate
extension ViewController: AgoraRtcEngineDelegate {
    // Monitors the didJoinedOfUid callback
    // The SDK triggers the callback when a remote user joins the channel
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.renderMode = .hidden
        videoCanvas.view = remoteView
        // Sets the remote video view
        agoraKit?.setupRemoteVideo(videoCanvas)
    }
}

