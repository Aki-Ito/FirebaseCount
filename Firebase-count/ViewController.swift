//
//  ViewController.swift
//  Firebase-count
//
//  Created by 伊藤明孝 on 2021/08/16.
//

import UIKit
import FirebaseFirestore

class ViewController: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var multiplyButton: UIButton!
    @IBOutlet weak var divideButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    // MARK: 変数
    var number: Int = 0
    let db  = Firestore.firestore()
    // MARK: override
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButtonDesign(button: plusButton)
        updateButtonDesign(button: minusButton)
        updateButtonDesign(button: multiplyButton)
        updateButtonDesign(button: divideButton)
        updateButtonDesign(button: clearButton)
        
        observeNumber()
    }
    
    // MARK: @IBAction
    @IBAction func plus() {
        number += 1
        updateLabel()
        updateFirestore()
    }
    
    @IBAction func minus() {
        number -= 1
        updateLabel()
        updateFirestore()
    }
    
    @IBAction func multiply() {
        number *= 2
        updateLabel()
        updateFirestore()
    }
    
    @IBAction func divide() {
        number /= 2
        updateLabel()
        updateFirestore()
    }
    
    @IBAction func clear() {
        number = 0
        updateLabel()
        updateFirestore()
    }
    
    // MARK: ラベルに数字を表示するメソッド
    func updateLabel() {
        label.text = String(number)
    }
    
    // MARK: FirestoreにNumberを更新するメソッド
    func updateFirestore() {
        let data: [String: Int] = [
            "number": number
        ]
        db.collection("counts")
            .document("checkwork")
            .setData(data, merge: true)
    }

    // MARK: FirestoreからNumberの変更を監視するメソッド
    func observeNumber() {
        db.collection("counts")
            .document("checkwork")
            .addSnapshotListener { (snapshot: DocumentSnapshot?, error: Error?) in
            if let number = snapshot?.data()?["number"] as? Int {
                self.number = number
                self.updateLabel()
            }
        }
    }
    
    // MARK: Buttonのデザインを変更するメソッド
    func updateButtonDesign(button: UIButton) {
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 2
        button.layer.borderColor = button.tintColor.cgColor
    }
}

