//
//  ContentView.swift
//  Guess the flag
//
//  Created by Giovanni Gaffé on 2021/9/22.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    
    @State private var rotationAmount = 0.0
    @State private var opacityAmount = 1.0
    @State private var wrongRotationAmount = [0.0, 0.0, 0.0]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .mint, .indigo]),
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                    Text(countries[correctAnswer])
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                .foregroundColor(.white)
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        Color.white.flagStyle(of: countries[number])
                            .rotation3DEffect(.degrees(number == correctAnswer ? rotationAmount : 0), axis: (x: 0, y: 1, z: 0))
                            .rotation3DEffect(.degrees(self.wrongRotationAmount[number]),
                                              axis: (x: 0, y: 1, z: 0))
                    }
                }
                
                HStack {
                    Text("Score")
                    Image(systemName: "\(userScore).circle")
                }
                .foregroundColor(.white)
                .font(.largeTitle)
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(userScore)"), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 1
            rotationAmount = 0.0
            
            withAnimation(.interpolatingSpring(stiffness: 20, damping: 5)) {
                self.rotationAmount = 360
            }
        } else {
            scoreTitle = "Wrong"
            guard userScore > 0 else { return }
            userScore -= 1
            
            withAnimation(Animation.interpolatingSpring(mass: 1, stiffness: 120, damping: 40, initialVelocity: 200)) {
                self.wrongRotationAmount[number] = 1
            }
        }
        
        if userScore < 0 { userScore = 0 }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        self.rotationAmount = 0.0
        wrongRotationAmount = Array(repeating: 0.0, count: 3)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
