//
//  MathChallengeView.swift
//  MageGameApp
//
//  Created by aluno-02 on 25/08/25.
//

import SwiftUI

struct Equation {
    let text: String
    let answer: Int
}

struct MathChallengeView: View {
    @State private var currentEquation: Equation?
    @State private var userAnswer: String = ""
    @Binding var isPlayersTurn : Bool
    
    @FocusState private var isAnswerFieldFocused: Bool
    
    var onAnswerSubmitted: (_ isCorrect: Bool) -> Void
    
    var body: some View {
        ZStack {
            Image("Math Scroll")
                .allowsHitTesting(false) 

            VStack(spacing: 10) {
                if let equation = currentEquation {
                    Text(equation.text)
                        .font(.custom("PixelifySans-Regular", size: 32))
                        .foregroundColor(.appTree)
                }
                
                TextField("?", text: $userAnswer)
                    .font(.custom("PixelifySans-Regular", size: 30))
                    .foregroundColor(.appTree)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .frame(width: 100)
                    .padding(5)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(8)
                    .focused($isAnswerFieldFocused)
                    .onSubmit(checkAnswer)
                    .disabled(!isPlayersTurn)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            
                            Button("Enviar") {
                                checkAnswer()
                            }
                            .font(.custom("PixelifySans-Regular", size: 18))
                            .foregroundColor(.appTree)
                            .disabled(!isPlayersTurn)
                        }
                    }
            }
        }
        .frame(maxWidth: .infinity)

        .onAppear {
            generateNewEquation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                isAnswerFieldFocused = true
            }
        }
        .onChange(of: isPlayersTurn) { newValue in
            // Abre o teclado automaticamente quando for o turno do jogador
            if newValue {
                DispatchQueue.main.async {
                    isAnswerFieldFocused = true
                    generateNewEquation()
                }
            } else {
                isAnswerFieldFocused = false
            }
        }
    }
    
    
    func generateNewEquation() {
        var number1 = Int.random(in: 1...10)
        var  number2 = Int.random(in: 1...10)
        let numeroOp = Int.random(in: 0...2)
        let operacao = ["+", "-", "x"]
        let text : String
        let answer : Int
        switch operacao[numeroOp]{
        case "+":
            answer = number1 + number2
            text = "\(number1) + \(number2) = ?"
        case "-":
            repeat{
                number1 = Int.random(in: 1...10)
                number2 = Int.random(in: 1...10)
            }
            while number1 < number2
                    answer = number1 - number2
                    text = "\(number1) - \(number2) = ?"
                    case "x":
                        answer = number1 * number2
                    text = "\(number1) x \(number2) = ?"
                    default:
                        return
        }
        
        
        currentEquation = Equation(text: text, answer: answer)
        userAnswer = ""
    }
    
    func checkAnswer() {
        guard let equation = currentEquation,
              let userAnswerInt = Int(userAnswer) else {
            return
        }
        
        let isCorrect = (userAnswerInt == equation.answer)
        
        onAnswerSubmitted(isCorrect)
        
        if isCorrect {
            generateNewEquation()
        } else {
            userAnswer = ""
            generateNewEquation()
        }
        
    }
    
    
}


