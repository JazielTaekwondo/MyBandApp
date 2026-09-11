//
//  StartMenuView.swift
//  MyBandApp
//
//  Created by Victor Flores on 09/09/26.
//

import SwiftUI

struct StartMenuView: View{
    var body: some View{
        NavigationStack{ //Inicio NavigationStack
            VStack{ //Inicio VStack
                ZStack{ //Inicio ZStack
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 150, height: 150)
                    Image(systemName: "person.fill")
                        .resizable()
                        .frame(width: 90, height: 90)
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(Color.white)
                } //Fin ZStack
                .padding(15)
                
                Text("WELCOME!")
                    .foregroundStyle(Color.black)
                    .font(.largeTitle)
                    .fontWeight(.regular)
                Text("Victor Flores")
                    .font(.title)
                    .fontWeight(.ultraLight)
                List{ // Inicio List
                    NavigationLink(destination: NewProjectMenuView()){
                        HStack{ //BOTON PARA CREAR PROYECCTO
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(.blue)
                            
                            Text("NEW PROJECT")
                                .font(.subheadline)
                                .fontWeight(.light)
                                .foregroundStyle(.black)
                        }.padding()
                    }
                    
                    HStack{ // BOTON PARA VER PROYECTOS
                        ZStack{
                            Image(systemName: "folder.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(.blue)
                            Image(systemName: "music.note")
                                .resizable()
                                .foregroundStyle(.white)
                                .frame(width: 10, height: 15)
                        }
                        Button("MY PROJECTS",action: {})
                            .font(.subheadline)
                            .fontWeight(.light)
                            .foregroundStyle(.black)
                    }.padding()
                    
                    HStack{ // BOTON PARA MENU SOCIAL
                        Image(systemName: "guitars")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.blue)
                        Button("MY BANDS", action: {})
                            .font(.subheadline)
                            .fontWeight(.light)
                            .foregroundStyle(.black)
                        
                    }.padding()

                } // Fin List
                .scrollContentBackground(.hidden)
                //.padding()
                
            } //Fin VStack
        }//Fin NavigationStack
    }
}

#Preview{
    StartMenuView()
}
