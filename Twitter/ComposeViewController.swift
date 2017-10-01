//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Mandy Chen on 9/30/17.
//  Copyright © 2017 Mandy Chen. All rights reserved.
//

import UIKit

//protocol ComposeViewControllerDelegate {
//    optional func composeViewController(
//        composeViewController : ComposeViewController,
//        )
//}

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var tweetText: UITextView!
    @IBOutlet weak var tweetButton: UIBarButtonItem!
    
    var user: User?
    var isFirstTyping = false
    var remainingChars: Int {
        return characterLimit - tweetText.text.characters.count
    }
    
    let characterLimit  = 140
    let characterLimitThreshold = 20
    let placeholderText = "What's happening?"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = User._currentUser {
            if let imageUrl = user.profileUrl {
                avatar.setImageWith(imageUrl)
            } else {
                avatar.image = UIImage(named: "defaultImage")
            }
            avatar.clipsToBounds = true
            avatar.layer.cornerRadius = 10
            name.text = user.name
            screenName.text = user.screenName
        }
        countDownLabel.textColor = UIColor.gray
        tweetText.delegate = self
        setPlaceHolderTweetText()
        updateTweetButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onTweetButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setPlaceHolderTweetText() {
        isFirstTyping = true
        tweetText.text = placeholderText
        tweetText.textColor = UIColor.lightGray
        tweetText.font = tweetText.font?.withSize(22)
        tweetText.becomeFirstResponder()
        let startPosition = tweetText.beginningOfDocument
        tweetText.selectedTextRange = tweetText.textRange(from: startPosition, to: startPosition)

    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        updateTextView(textView)
        updateCountDownLabel()
        updateTweetButton()
        
    }
    
    func updateTextView(_ textView: UITextView) {
        if isFirstTyping {
            let textWithPlaceHolder = textView.text!
            tweetText.text = textWithPlaceHolder.replacingOccurrences(of: placeholderText, with: "")
            textView.textColor = UIColor.black
            isFirstTyping = false
        } else if textView.text.isEmpty {
            setPlaceHolderTweetText()
        }
    }
    
    
    func updateCountDownLabel() {
        if remainingChars <= characterLimitThreshold {
            countDownLabel.textColor = UIColor.red
        } else {
            countDownLabel.textColor = UIColor.gray
        }
        countDownLabel.text = "\(remainingChars)"
    }
    
    func updateTweetButton() {
        if isFirstTyping || remainingChars < 0 || remainingChars == characterLimit{
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
