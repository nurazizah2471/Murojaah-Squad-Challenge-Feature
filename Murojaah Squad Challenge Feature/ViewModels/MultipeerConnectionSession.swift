//
//  MultipeerConnectionSession.swift
//  Murojaah Squad Challenge Feature
//
//  Created by Nur Azizah on 07/08/23.
//

import Foundation
import MultipeerConnectivity

class MultipeerConnectionSession: NSObject, Identifiable, ObservableObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate {
    
    private var serviceType: String
    private var myPeerID: MCPeerID
    
    public var serviceAdvertiser: MCNearbyServiceAdvertiser?
    public var serviceBrowser: MCNearbyServiceBrowser?
    public var session: MCSession
    
    @Published var availablePeers: [MCPeerID] = []
    @Published var receivedSurah: String = ""
    @Published var reveiveInvitation: String = ""
    @Published var receiveInvitation: Bool = false
    @Published var receiveInvitationFrom: MCPeerID? = nil
    @Published var paired: Bool = false
    @Published var is_host: Bool = false
    @Published var invitationHandler: ((Bool, MCSession?) -> Void)?
    
    init(username: String) {
        self.myPeerID = MCPeerID(displayName: username)
        self.serviceType = "murojaah-squad"
        
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .none)
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: serviceType)
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        
        super.init()
        
        session.delegate = self
        serviceAdvertiser!.delegate = self
        serviceBrowser!.delegate = self
        
        //        serviceAdvertiser.startAdvertisingPeer()
        //        serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        serviceAdvertiser!.stopAdvertisingPeer()
        serviceBrowser!.stopBrowsingForPeers()
    }
    
    func hostASession() {
        serviceBrowser!.stopBrowsingForPeers()
        serviceAdvertiser!.startAdvertisingPeer()
        
        self.is_host = true
    }
    
    func joinASession() {
        serviceAdvertiser!.stopAdvertisingPeer()
        serviceBrowser!.startBrowsingForPeers()
        
        is_host = false
    }
    
    func send(data: String) {
        if !session.connectedPeers.isEmpty {
            print("Send data: \(data) to \(self.session.connectedPeers[0].displayName)")
            
            do {
                try session.send(data.data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
            } catch {
                print("Error sending: \(String(describing: error))")
            }
        }
    }
    
    // Control (update) my view when receive new data in my group peers
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let newData = String(data: data, encoding: .utf8) {
            print("didReceive new data \(newData)")
            
            // We receive a change from the opponent, tell the view
            DispatchQueue.main.async {
                self.receivedSurah = newData
            }
        } else {
            print("didReceive invalid value \(data.count) bytes")
        }
    }
    
    // Control limitation of my connection in peer connection when there is change at my peer status connection
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("peer \(peerID) didChangeState: \(state.rawValue)")
        
        switch state {
        case MCSessionState.notConnected:
            // Peer disconnected (i have disconnected from my group peers)
            DispatchQueue.main.async {
                self.paired = false
            }
            
            // Peer disconnected, start accepting invitations again
            
            if is_host {
                serviceAdvertiser!.startAdvertisingPeer()
            } else {
                serviceBrowser!.startBrowsingForPeers()
            }
            
            break
            
        case MCSessionState.connected:
            // Peer connected (i have connected with my group peers)
            DispatchQueue.main.async {
                self.paired = true
            }
            
            // i have paired, stop accepting invitations
            //            serviceAdvertiser.stopAdvertisingPeer()
            break
            
        default:
            // Peer connecting or something else
            DispatchQueue.main.async {
                self.paired = false
            }
            break
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("Receiving streams is not supported")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("Receiving resources is not supported")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("Receiving resources is not supported")
    }
    
    // Control when i'm finding another peer that available in my local area
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("ServiceBrowser found peer: \(peerID)")
        
        // Add this founded peer to the list of available peers
        DispatchQueue.main.async {
            if !self.availablePeers.contains(peerID) {
                self.availablePeers.append(peerID)
            }
        }
    }
    
    // Control when i'm losting a peer that available in my local area
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("ServiceBrowser lost peer: \(peerID)")
        
        // Remove lost peer from list of available peers
        DispatchQueue.main.async {
            self.availablePeers.removeAll(where: {
                $0 == peerID
            })
        }
    }
    
    // When system did not start to find a peer in my local area
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("ServiceBrowser didNotStartBrowsingForPeers: \(String(describing: error))")
    }
    
    // Control when there is another user that wanna connect with me
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("didReceiveInvitationFromPeer \(peerID)")
        
        DispatchQueue.main.async {
            // Tell the view to show the invitation alert
            self.receiveInvitation = true
            
            // Give the view peerID of the peer who invited me
            self.receiveInvitationFrom = peerID
            
            // Give the view "invitationHandler" so it can accept/deny the invitation
            self.invitationHandler = invitationHandler
        }
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("ServiceAdvertiser didNotStartAdvertisingPeer: \(String(describing: error))")
    }
}


