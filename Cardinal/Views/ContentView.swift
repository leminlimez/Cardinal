//
//  ContentView.swift
//  ID Changer
//
//  Created by lemin on 8/29/23.
//

import SwiftUI
import MacDirtyCowSwift
import ACarousel

struct ContentView: View {
    @State var cardPaths: [Card] = []
    @State var fullPath = "/var/mobile/Library/Passes/Cards"
    
    // Card Variables
    @State private var changedSomething: Bool = false
    
    // KFD Exploit Stuffs
    @State private var kfd: UInt64 = 0
    @State private var vnodeOrig: UInt64 = 0
        
    private var puaf_pages_options = [16, 32, 64, 128, 256, 512, 1024, 2048]
    @AppStorage("PUAF_Pages_Index") private var puaf_pages_index = 7
    @AppStorage("PUAF_Pages") private var puaf_pages = 0
    
    private var puaf_method_options = ["physpuppet", "smith"]
    @AppStorage("PUAF_Method") private var puaf_method = 1
    
    private var kread_method_options = ["kqueue_workloop_ctl", "sem_open"]
    @AppStorage("KRead_Method") private var kread_method = 1
    
    private var kwrite_method_options = ["dup", "sem_open"]
    @AppStorage("KWrite_Method") private var kwrite_method = 1
    
    var body: some View {
        VStack {
            HStack {
                Text("ID Changer")
                    .font(.largeTitle)
                    .bold()
                Spacer()
                Button(action: {
                    UIApplication.shared.alert(title: "Default Image Sizes", body: "- Logo: 858x150\n- Strip: 1146x333\n- Thumbnail: 300x400?\n\nThese image sizes are not required, the card should automatically crop them.\n\nDevice will respring after applying/resetting.")
                }) {
                    Image(systemName: "info.circle")
                        .font(.title3)
                }
            }
            .padding(.bottom, 10)
            
            HStack {
                Spacer()
                Text("Tap on an image or text field to change it.")
                    .font(.headline)
                Spacer()
            }
            .padding(.vertical, 5)
            
            Spacer()
            
            // Cards View
            if !cardPaths.isEmpty {
                ACarousel($cardPaths) { i in
                    CardView(
                        kfd: kfd, vnodeOrig: vnodeOrig,
                        fullPath: fullPath, card: i,
                        changedSomething: $changedSomething
                    )
                }
            } else {
                Text("Error! No cards found!")
                    .foregroundColor(.red)
            }
            
            // Card View
//            if cardPath == "" {
//                Text("Error! Card not found!")
//                    .foregroundColor(.red)
//            } else {
//                CardView(kfd: kfd, vnodeOrig: vnodeOrig, cardPath: cardPath, fullPath: fullPath)
//            }
            
            Spacer()
            
            HStack {
                // Apply Button
                Button(action: {
                    print("Applying Card...")
                    MainCardController.setChanges(kfd, vnodeOrig: vnodeOrig, cards: cardPaths, fullPath: fullPath)
                }) {
                    Text("Apply")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .padding(.vertical, 16)
                        .opacity((changedSomething) ? 1 : 0)
                }
                .disabled(!changedSomething)
            }
            
//            if #available(iOS 16.2, *) {
//                Button(action: {
//                    UnRedirectAndRemoveFolder(vnodeOrig, fullPath + "/Cards/")
//                    do_kclose(kfd)
//
//                    respring()
//                }) {
//                    Text("kclose")
//                }
//            }
        }
        .padding()
        .onAppear {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
                if #available(iOS 16.5.1, *) {
                    UIApplication.shared.alert(title: "Device Not Supported", body: "Your device is not supported by the MDC or KFD exploits, the app will not function, sorry.")
//                } else if #available(iOS 16.2, *) {
//                    // kfd stuff
//                    UIApplication.shared.confirmAlert(title: "kopen needed", body: "The kernel needs to be opened in order for the app to work. Would you like to do that?\n\nNote: Your device may panic (auto reboot) after applying, this will only happen once and is not permanent.", onOK: {
//                        // kopen
//                        UIApplication.shared.alert(title: "Opening Kernel...", body: "Please wait...", withButton: false)
//
//                        puaf_pages = puaf_pages_options[puaf_pages_index]
//                        kfd = do_kopen(UInt64(puaf_pages), UInt64(puaf_method), UInt64(kread_method), UInt64(kwrite_method))
//
//                        // clear previous
//                        MainCardController.rmMountedDir()
//
//                        if !FileManager.default.fileExists(atPath: NSHomeDirectory() + "/Documents/mounted") {
//                            do {
//                                try FileManager.default.createDirectory(atPath: NSHomeDirectory() + "/Documents/mounted", withIntermediateDirectories: false)
//                            } catch {
//                                print(error.localizedDescription)
//                            }
//                        }
//
//                        if !FileManager.default.fileExists(atPath: NSHomeDirectory() + "/Documents/mounted/Cards") {
//                            do {
//                                try FileManager.default.createDirectory(atPath: NSHomeDirectory() + "/Documents/mounted/Cards", withIntermediateDirectories: false)
//                            } catch {
//                                print(error.localizedDescription)
//                            }
//                        }
//
//                        // init fun offsets
//                        _offsets_init()
//
//                        // redirect
//                        fullPath = NSHomeDirectory() + "/Documents/mounted"
//
//                        vnodeOrig = redirectCardsFolder()
//
//                        getCards()
//
//                        UIApplication.shared.dismissAlert(animated: true)
//                    }, noCancel: false)
                } else {
                    // mdc/trollstore stuff
                    do {
                        // TrollStore method
                        try FileManager.default.contentsOfDirectory(at: URL(fileURLWithPath: "/var/mobile/Library/Caches"), includingPropertiesForKeys: nil)
                        
                        // succeeded, get the cards
                        getCards()
                    } catch {
                        // MDC method
                        // grant r/w access
                        if #available(iOS 15, *) {
                            grant_full_disk_access() { error in
                                if (error != nil) {
                                    UIApplication.shared.alert(title: "Access Error", body: "Error: \(String(describing: error?.localizedDescription))\nPlease close the app and retry.")
                                } else {
                                    // succeeded, get the cards
                                    getCards()
                                }
                            }
                        } else {
                            UIApplication.shared.alert(title: "MDC Not Supported", body: "Please install via TrollStore")
                        }
                    }
                }
            }
        }
    }
    
    func getCards() {
        // get the cards
        cardPaths = MainCardController.getPasses(fullPath: fullPath)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
