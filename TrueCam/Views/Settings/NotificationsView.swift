//
//  NotificationsView.swift
//  TrueCam
//
//  Created by Damoon saber on 3/2/1405 AP.
//

import SwiftUI

struct NotificationsView: View {
    
    @State var mentions = false
    @State var comments = false
    @State var friendRequests = false
    @State var lateTrueCam = false
    @State var realMojis = false
    
    @State var buttonActive = false
    
    @Environment(\.dismiss) var dismiss
    
    var isAnyToggleChanged: Bool {
        mentions || comments || friendRequests || lateTrueCam || realMojis
    }

    var body: some View {
        VStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    ZStack {
                        Text("Notifications")
                            .fontWeight(.semibold)
                        
                        
                        HStack {
                           
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "arrow.backward")
                                    .font(.system(size: 20))
                            }

                            
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .foregroundStyle(.white)
                
                VStack {
                    
                    VStack {
                        
                        HStack {
                            
                            Text("On TrueCam you're in control of your push notifications.")
                            
                            Spacer()
                        }
                        
                        HStack {
                            
                            Text("You can choose the type of notifications you want to receive.")
                            
                            Spacer()
                        }
                    }
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
                    .font(.system(size: 16))
                    
                    VStack(spacing: 14) {
                        
                        VStack {
                            NotificationsViewButton(icon: "person.crop.square.filled.and.at.rectangle", text: "Mentions", toggle: $mentions)
                            
                            HStack {
                                Text("timcook mentioned you on johnternus's TrueCam.")
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 12))
                                    .padding(.leading)
                                
                                Spacer()
                            }
                        }
                        
                        VStack {
                            NotificationsViewButton(icon: "bubble.left.fill", text: "Comments", toggle: $comments)
                            
                            HStack {
                                Text("johnmayer commented on your TrueCam.")
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 12))
                                    .padding(.leading)
                                
                                Spacer()
                            }
                        }
                        
                        VStack {
                            NotificationsViewButton(icon: "person.2.fill", text: "Friend Requests", toggle: $friendRequests)
                            
                            HStack {
                                Text("johnfrusciante just sent you a friend request.")
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 12))
                                    .padding(.leading)
                                
                                Spacer()
                            }
                        }
                        
                        VStack {
                            NotificationsViewButton(icon: "timer", text: "Late TrueCam", toggle: $lateTrueCam)
                            
                            HStack {
                                Text("chrislattner just posted late.")
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 12))
                                    .padding(.leading)
                                
                                Spacer()
                            }
                        }
                        
                        VStack {
                            NotificationsViewButton(icon: "face.smiling.fill", text: "RealMojis", toggle: $realMojis)
                            
                            HStack {
                                Text("stevewozniak just reacted to your TrueCam.")
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 12))
                                    .padding(.leading)
                                
                                Spacer()
                            }
                        }
                        
                    }
                    .padding(.top, 8)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 50)
                
                VStack {
                    Spacer()
                    
                    WhiteButtonView(buttonActive: $buttonActive, text: "Save")
                        .onChange(of: isAnyToggleChanged) {
                            self.buttonActive = true
                        }
                }
                .padding()
                
            }
        }
    }
}
#Preview {
    NotificationsView()
}
