//
//  ContentView.swift
//  Guess the flag
//
//  Created by Giovanni Gaffé on 2021/9/22.
//

import SwiftUI

struct ContentView: View {
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
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
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            //            LinearGradient(gradient: Gradient(colors: [.blue, .black]),
            //                           startPoint: .top, endPoint: .bottom)
            
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle)
                            .fontWeight(.black)
                    }
                    
                    ForEach(0 ..< 3) { number in
                        Button {
                            self.flagTapped(number)
                            self.opacityAmount = 0.4
                        } label: {
                            Color.white.flagStyle(of: countries[number])
                                .rotation3DEffect(.degrees(number == correctAnswer ? rotationAmount : 0), axis: (x: 0, y: 1, z: 0))
                            
                                .rotation3DEffect(.degrees(self.wrongRotationAmount[number]),axis: (x: 1, y: 0, z: 7))
                            
                                .opacity(number == correctAnswer ? 1 : opacityAmount)
                                .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
                            
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                HStack {
                    Text("Score")
                    Image(systemName: "\(userScore).circle")
                }
                .foregroundColor(.white)
                .font(.largeTitle)
                
                Spacer()
            }
            .padding()
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
            withAnimation(Animation.interpolatingSpring(mass: 1, stiffness: 120, damping: 40, initialVelocity: 200)) {
                self.wrongRotationAmount[number] = 30
            }
            if userScore > 1 {
                userScore -= 1
            } else { userScore = 0
            }
        }
        
        if userScore < 0 { userScore = 0 }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        withAnimation(.easeInOut) {
            self.opacityAmount = 1.0
        }
        self.rotationAmount = 0.0
        wrongRotationAmount = Array(repeating: 0.0, count: 3)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
