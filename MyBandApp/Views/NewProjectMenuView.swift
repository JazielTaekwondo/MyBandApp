//
//  NewProjectMenuView.swift
//  MyBandApp
//
//  Created by Victor Flores on 09/09/26.
//

import SwiftUI

struct NewProjectMenuView: View{
    var body: some View{
        NavigationStack{
            VStack{
                Spacer()
                Text("Choose the type of track to get started!")
                    .foregroundStyle(Color.black)
                    .font(.title2)
                    .fontWeight(.regular)
                List{
                    // Boton 1
                        HStack{
                            ZStack{
                                Rectangle()
                                    .fill(Color.cyan)
                                    .frame(width: 50, height: 50)
                                Image(systemName: "metronome.fill")
                                    .resizable()
                                    .frame(width: 30, height: 35)
                            }
                            VStack{
                                Text("RYTHM")
                                Text("Record your song's lead vocal or your guitar solo.")
                            }
                        } // Fin HStack
                    // Fin Boton 1
                    .background(Color.blue)
                    
                    NavigationLink(destination: RecorderView()){ // Boton 2
                        HStack{
                            ZStack{
                                Rectangle()
                                    .fill(Color.yellow)
                                    .frame(width: 50, height: 50)
                                
                                Image(systemName: "waveform")
                                    .resizable()
                                    .frame(width: 30, height: 35)
                            }
                            VStack{
                                Text("MELODY")
                                Text("Record your song's lead vocal or your guitar solo.")
                            }
                        }
                    } // Fin Boton 2
                    .background(Color.orange)
                    
                    NavigationLink(destination: RecorderView()){ // Boton 3
                        HStack{
                            ZStack{
                                Rectangle()
                                    .fill(Color.pink)
                                    .frame(width: 50, height: 50)
                                Image(systemName: "music.note")
                                    .resizable()
                                    .frame(width: 30, height: 35)
                            }
                            VStack{
                                Text("HARMONY")
                                Text("Record the chords for your song's accompaniment.")
                            }
                        }
                    } // Fin Boton 3
                    .background(Color.red)
                } // FIN List
                .padding()
                
            } // Fin VStack
            .scrollContentBackground(.hidden)
            .padding()
        } // Fin NavigationStack
    }
}

#Preview {
    NewProjectMenuView()
}
