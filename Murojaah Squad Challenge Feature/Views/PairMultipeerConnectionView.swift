//
//  PairedMultipeerConnectionView.swift
//  Murojaah Squad Challenge Feature
//
//  Created by Nur Azizah on 07/08/23.
//

import SwiftUI
import MultipeerConnectivity

struct PairMultipeerConnectionView: View {
    @EnvironmentObject var multipeerConnectionSession: MultipeerConnectionSession
    @EnvironmentObject var aPIViewModel: APIViewModel
    @EnvironmentObject var roomPlayListCoreDataVM: RoomPlayListCoreDataViewModel
    
    var isHost: Bool
    
    var body: some View {
        VStack {
            if !multipeerConnectionSession.paired || multipeerConnectionSession.session.connectedPeers.count<3 {
                Text(!multipeerConnectionSession.is_host ? "Connect with your squad now..." : "Waiting for your Squad...")
                HStack {
                    if !multipeerConnectionSession.is_host {
                        List(multipeerConnectionSession.availablePeers, id: \.self) { peer in
                            Button(peer.displayName) {
                                if let serviceBrowser = multipeerConnectionSession.serviceBrowser {
                                    serviceBrowser.invitePeer(peer, to: multipeerConnectionSession.session, withContext: nil, timeout: 30)
                                } else {
                                    print("Service browser or session is not available.")
                                }
                            }
                            .foregroundColor(multipeerConnectionSession.session.connectedPeers.contains(peer) ? .green : .black)
                        }
                    } else {
                        List(multipeerConnectionSession.session.connectedPeers, id: \.self) { connectedPeer in
                            Text(connectedPeer.displayName)
                        }
                    }
                }
                .alert("Received an invite from \(multipeerConnectionSession.receiveInvitationFrom?.displayName ?? "ERR")!", isPresented: $multipeerConnectionSession.receiveInvitation) {
                    
                    Button("Accept invite") {
                        if multipeerConnectionSession.invitationHandler != nil {
                            multipeerConnectionSession.invitationHandler!(true, multipeerConnectionSession.session)
                        }
                    }
                    
                    Button("Reject invite") {
                        if multipeerConnectionSession.invitationHandler != nil {
                            multipeerConnectionSession.invitationHandler!(false, nil)
                        }
                    }
                }
            }
            else {
                if isHost {
                    PreGameLobbyView()
                }
            }
        }
        .onAppear {
            if isHost {
                multipeerConnectionSession.hostASession()
            } else {
                multipeerConnectionSession.joinASession()
            }
        }
    }
}

struct PairMultipeerConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        PairMultipeerConnectionView(isHost: false)
    }
}
