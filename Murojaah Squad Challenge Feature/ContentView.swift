//
//  ContentView.swift
//  Murojaah Squad Challenge Feature
//
//  Created by Nur Azizah on 07/08/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var aPIViewModel: APIViewModel
    @StateObject var roomPlayListCoreDataVM: RoomPlayListCoreDataViewModel = RoomPlayListCoreDataViewModel()
    
    @State var multipeerConnectionSession: MultipeerConnectionSession?
    
    @State var username: String = ""
    @State var isEmptyUsername: Bool = true
    
    var body: some View {
        NavigationStack {
            VStack {
                if isEmptyUsername {
                    introductionView
                } else {
                    NavigationLink(
                        destination: PairMultipeerConnectionView(isHost: true)
                            .environmentObject(multipeerConnectionSession!)
                            .environmentObject(aPIViewModel)
                            .environmentObject(roomPlayListCoreDataVM),
                        label: {
                            Text("Open Room Match!")
                        }
                    )
                    
                    NavigationLink(
                        destination: PairMultipeerConnectionView(isHost: false)
                            .environmentObject(multipeerConnectionSession!)
                            .environmentObject(aPIViewModel)
                            .environmentObject(roomPlayListCoreDataVM),
                        label: {
                            Text("Join Room Match!")
                        }
                    )
                }
            }
        }
        .onAppear {
            aPIViewModel.fetchDatas()
        }
    }
    
    var introductionView: some View {
        VStack {
            Text("Enter your username below. Choose something your friend will recognize!")
                .font(.caption2)
                .fontWeight(.semibold)
                .padding(.horizontal, 40)
                .multilineTextAlignment(.center)
            TextField("Username", text: $username)
                .padding([.horizontal], 75.0)
                .padding(.bottom, 24)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Continue →") {
                multipeerConnectionSession = MultipeerConnectionSession(username: username)
                isEmptyUsername.toggle()
            }.buttonStyle(BorderlessButtonStyle())
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
                .foregroundColor(.white)
                .background(Color.accentColor)
                .cornerRadius(12)
                .disabled(username.isEmpty ? true : false)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
