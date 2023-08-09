//
//  PreGameLobbyPage.swift
//  Murojaah Squad Challenge Feature
//
//  Created by Nur Azizah on 07/08/23.
//

import SwiftUI

struct PreGameLobbyView: View {
    @EnvironmentObject var multipeerConnectionSession: MultipeerConnectionSession
    @EnvironmentObject var aPIViewModel: APIViewModel
    @EnvironmentObject private var roomPlayListCoreDataVM: RoomPlayListCoreDataViewModel
    
    @State var selectedOptionStartSurahIndex: Int = 0
    @State var selectedOptionLastSurahIndex: Int = 0
    @State var selectedOptionStartVerseIndex: Int = 0
    @State var selectedOptionLastVerseIndex: Int = 0
    @State var limitVerses: String = ""
    @State var isViewActive: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Are you ready?, Here's your Squad...")
                ForEach(multipeerConnectionSession.session.connectedPeers, id: \.self) { connectedPeer in
                    Text(connectedPeer.displayName)
                }
                
                Text("Select your Squad target..")
                
                VStack {
                    HStack {
                        Picker("Surah Start", selection: $selectedOptionStartSurahIndex) {
                            ForEach(0..<aPIViewModel.quranDatas.count, id: \.self) { index in
                                Text(aPIViewModel.quranDatas[index].namaLatin ?? "").tag(index)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        
                        Spacer()
                        
                        Picker("Verse Start", selection: $selectedOptionStartVerseIndex) {
                            ForEach(0..<aPIViewModel.getSumVerseOfSurah(surah: selectedOptionStartSurahIndex), id: \.self) { index in
                                Text("\(index+1)").tag(index)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                    }
                    .padding()
                    
                    HStack {
                        Picker("Surah Last", selection: $selectedOptionLastSurahIndex) {
                            if selectedOptionStartVerseIndex+1 == aPIViewModel.quranDatas[selectedOptionStartSurahIndex].jumlahAyat {
                                ForEach(selectedOptionStartSurahIndex+1..<aPIViewModel.quranDatas.count, id: \.self) { index in
                                    Text(aPIViewModel.quranDatas[index].namaLatin ?? "").tag(index)
                                }
                            } else {
                                ForEach(selectedOptionStartSurahIndex..<aPIViewModel.quranDatas.count, id: \.self) { index in
                                    Text(aPIViewModel.quranDatas[index].namaLatin ?? "").tag(index)
                                }
                            }
                            
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        
                        Spacer()
                        
                        Picker("Verse Last", selection: $selectedOptionLastVerseIndex) {
                            if selectedOptionStartSurahIndex == selectedOptionLastSurahIndex {
                                if selectedOptionStartVerseIndex+1 == aPIViewModel.quranDatas[selectedOptionStartSurahIndex].jumlahAyat! {
                                    ForEach(0..<aPIViewModel.getSumVerseOfSurah(surah: selectedOptionLastSurahIndex+1), id: \.self) { index in
                                        Text("\(index+1)").tag(index)
                                    }
                                } else {
                                    ForEach(0..<aPIViewModel.getSumVerseOfSurah(surah: selectedOptionLastSurahIndex), id: \.self) { index in
                                        if selectedOptionStartSurahIndex == selectedOptionLastSurahIndex {
                                            if index > selectedOptionStartVerseIndex {
                                                Text("\(index+1)").tag(index)
                                            }
                                        }
                                    }
                                }
                                
                            } else {
                                ForEach(0..<aPIViewModel.getSumVerseOfSurah(surah: selectedOptionLastSurahIndex), id: \.self) { index in
                                    Text("\(index+1)").tag(index)
                                }
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                    }
                    .padding()
                }
                
                Text("Jumlah: \(multipeerConnectionSession.session.connectedPeers.count) pemain")
                
                HStack {
                    Text("Take your turn for every ")
                    TextField("seconds",
                              text: $limitVerses)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Text("START NOW!")
                    .onTapGesture {
                        roomPlayListCoreDataVM.addRoomPlayEntity(
                            name: multipeerConnectionSession.session.myPeerID.displayName,
                            limitVerses: limitVerses,
                            surahStartRange: String(selectedOptionStartSurahIndex),
                            surahLastRange: String(selectedOptionLastSurahIndex),
                            verseStartRange: String(selectedOptionStartVerseIndex),
                            verseLastRange: String(selectedOptionLastVerseIndex)
                        )
                        
                        isViewActive = true
                    }
                    .overlay (
                        NavigationLink(destination: GamePlayView(surahRand: "0", verseRand: "0")
                            .navigationBarBackButtonHidden(true), isActive: $isViewActive) {
                                EmptyView()
                            }
                    )
            }
        }
    }
}

struct PreGameLobbyView_Previews: PreviewProvider {
    static var previews: some View {
        PreGameLobbyView()
    }
}
