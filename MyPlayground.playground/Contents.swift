import UIKit

let constant = 10
var number = 10
var result = number + constant

var greeting = "Hello "
var name = "Benoît"
var message = greeting + name

message.uppercased()
message.lowercased()
message.count

var bookPrice = 39
var numOfCopies = 5
var totalPrice = bookPrice * numOfCopies
var totalPriceMessage = "The price of the book is $" + String(totalPrice)
var totalPriceMessage2 = "The price of the book is $\(totalPrice)"

var timeYouWakeUp = 6

if timeYouWakeUp == 6 {
    print("Cook yourself a big breakfast!")
} else {
    print("Go out for breakfast")
}

var bonus = 5000

if bonus >= 10000 {
    print("I will travel to Paris and London!")
} else if bonus >= 5000 && bonus < 10000 {
    print("I will travel to Tokyo")
} else if bonus >= 1000 && bonus < 5000 {
    print("I will travel to Bangkok")
} else {
    print("Just stay home")
}

var bookCollection = ["Tool of Titans", "Rework", "Your Move"]
bookCollection[0]
bookCollection.append("Authority")
bookCollection.count

for index in 0...bookCollection.count - 1 {
    print(bookCollection[index])
}

for book in bookCollection {
    print(book)
}

var bookCollectionDict = ["1328683788": "Tool of Titans", "0307463745": "Rework", "1612060919": "Authority"]
bookCollectionDict["0307463745"]
for (key, value) in bookCollectionDict {
    print("ISBN: \(key)")
    print("Title: \(value)")
}

var emojiDict: [String: String] = ["👻": "Ghost", "😤": "Angry", "😱": "Scream", "👾": "Alien"]
var wordToLookup = "👻"
var meaning = emojiDict[wordToLookup]

let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
containerView.backgroundColor = UIColor.orange
let emojiLabel = UILabel(frame: CGRect(x: 95, y: 20, width: 150, height: 150))
emojiLabel.text = wordToLookup
emojiLabel.font = UIFont.systemFont(ofSize: 100.0)
containerView.addSubview(emojiLabel)

let meaningLabel = UILabel(frame: CGRect(x: 110, y: 100, width: 150, height: 150))
meaningLabel.text = meaning
meaningLabel.font = UIFont.systemFont(ofSize: 30.0)
meaningLabel.textColor = UIColor.white
containerView.addSubview(meaningLabel)
