//
//  ViewController.swift
//  WordScramble
//
//  Created by Leonardo Gomes Fernandes on 05/07/20.
//  Copyright © 2020 Leonardo Gomes Fernandes. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        startGame()
    }

    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        
        return cell
    }

    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        print(answer)
        let lowerAnswer = answer.lowercased()
        
//         if isShorter(word: lowerAnswer){
//             if isSameStart(word: lowerAnswer) {
//                 if isPossible(word: lowerAnswer) {
//                     if isOriginal(word: lowerAnswer) {
//                         if isReal(word: lowerAnswer) {
//                             usedWords.insert(lowerAnswer, at: 0)

//                             let indexPath = IndexPath(row: 0, section: 0)
//                             tableView.insertRows(at: [indexPath], with: .automatic)

//                             return
//                         } else {
//                             showErrorMenssage(errorTitle: "Word not recognied", errorMessage: "You can't just make them up, you know!")
//                         }
//                     } else {
//                         showErrorMenssage(errorTitle: "Word already used", errorMessage: "Be more original!")
//                     }
//                 } else {
//                     guard let title = title else { return }
//                     showErrorMenssage(errorTitle: "Word not possible", errorMessage: "You can't spell that word from \(title.lowercased())")
//                 }
//             } else {
//                 showErrorMenssage(errorTitle: "Same of start word", errorMessage: "Be more original!")
//             }
//         } else {
//             showErrorMenssage(errorTitle: "Word is to shorter", errorMessage: "Let's try write more!")
//         }
        
        
       if !isShorter(word: lowerAnswer){
           showErrorMenssage(errorTitle: "Word is to shorter", errorMessage: "Let's try write more!")
           return
       }

       if !isSameStart(word: lowerAnswer) {
           showErrorMenssage(errorTitle: "Same of start word", errorMessage: "Be more original!")
           return
       }

       if !isPossible(word: lowerAnswer) {
           guard let title = title else { return }
           showErrorMenssage(errorTitle: "Word not possible", errorMessage: "You can't spell that word from \(title.lowercased())")
           return
       }

       if !isOriginal(word: lowerAnswer) {
           showErrorMenssage(errorTitle: "Word already used", errorMessage: "Be more original!")
           return
       }

       if !isReal(word: lowerAnswer) {
           showErrorMenssage(errorTitle: "Word not recognied", errorMessage: "You can't just make them up, you know!")
           return
       }
        
        usedWords.insert(lowerAnswer, at: 0)
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        return
    }
    
    func showErrorMenssage(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK!", style: .default))
        present(ac, animated: true)
        
    }
    
    func isShorter(word: String) -> Bool {
        return !(word.count <= 3)
    }
    
    func isSameStart(word: String) -> Bool {
        guard let title = title else { return false }
        return !(word == title.lowercased())
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
}

