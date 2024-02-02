//
//  ContentView.swift
//  IAModel
//
//  Created by HUMBLOT Stéphane on 10/01/2024.
//

import SwiftUI

struct ContentView: View {
    
    enum Sentiment: String {
        case positive = "POSITIVE",
             neutral = "NEUTRAL",
             mixed = "MIXED",
             negative = "NEGATIVE"
        
        func getEmoji() -> String {
            switch (self) {
                case .positive : return "😃"
                case .neutral : return "😑"
                case .mixed : return "🤔"
                case .negative: return  "😡"
            }
        }
        
        func getColor() -> Color {
            switch (self) {
            case .positive: return Color.green
            case .neutral: return Color.gray
            case .mixed: return Color.purple
            case .negative: return Color.red
            }
        }
    }
    
    @State var modelInput: String = ""
    @State var outputSentiment : Sentiment?
    @State var modelOutput : String = ""
    
    func classify() {
        do {
            let model = try SentimentML_1(configuration: .init())
            let prediction = try model.prediction(text: modelInput)
            // A vous de travailler la suite
            outputSentiment = Sentiment(rawValue: prediction.label)
        } catch {
            modelOutput = "Something went wrong"
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 18) {
                Text("Entrez une phrase, l'IA va deviner votre sentiment")
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                    .foregroundStyle(.white)
                    .padding()
                
                
                TextEditor(text: $modelInput)
                    .onChange(of: modelInput, perform: { oldValue in outputSentiment = nil})
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                    .padding()
                
                Button(
                    "Deviner le sentiment",
                    action: {
                        classify()
                    }
                )
                    .buttonStyle(BorderedProminentButtonStyle())
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    .disabled(modelInput.isEmpty)
                    .padding()
                
            }.background(.purple)
                .cornerRadius(18)
                .padding()
            
            VStack {
                Text(outputSentiment?.getEmoji() ?? "").padding()
                Text(outputSentiment?.rawValue ?? "").padding()
            }.frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                .background(outputSentiment?.getColor().gradient ?? Color.blue.gradient)
                .cornerRadius(18)
                .opacity(outputSentiment == nil ? 0 : 1.0)
                .scaleEffect(outputSentiment == nil ? 0.3 : 1.0)
                .animation(.easeIn, value: outputSentiment)
                .padding()
            
            Spacer()
        }.navigationBarTitle("IA du futur")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
