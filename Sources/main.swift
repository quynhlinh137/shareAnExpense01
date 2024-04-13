typealias Money = Int

struct Payer {
    var phoneNo : Int?
    var name = "to be input"
    var advance : Money = 0
}

    let payer1 = Payer (name: "Linh", advance: 50)
    var payer2 = Payer()
    payer2.name = "Nghia";
    payer2.advance = 100


struct Asset {
    var consignee = "TBD"
    var value: Money?
}

struct Participant {
    var phoneNo : Int?
    var name = "TBD"
    var expense: Money = 0
    var assets: [Asset] = []
}
var shoshin = ["Khang", "Hoang", "Lan Anh", "Minh Anh", "Linh", "Nghia"]
var jinshin = ["Hoa", "Phung", "Linh", "Nghia"]

var allParticipants : [Participant] = []

// func createNewParticipant(names:[String]) -> [Participant]{
//     var participants : [Participant] = []
//     var newParticipant : Participant
//     for name in names {
//         newParticipant = Participant(name: name)
//         participants += [newParticipant]
//     }
//     print(participants)
//     return participants
// }

func getParticipantsByName(names:[String]) -> [Participant]{
    var participants : [Participant] = []
    var participant : Participant
    for name in names {
        var isOld = false
        for p in allParticipants {
            if p.name == name {
               participants += [p]
               isOld = true
               break
            }
        }
        if !isOld {
              participant = Participant(name: name)
              participants.append(participant)
              allParticipants.append(participant)
        }
    }
    print(participants)
    return participants
}

var participants00 = getParticipantsByName(names: ["Linh", "Nghia"])

print(participants00)

var participants01 = getParticipantsByName(names: jinshin)

participants01 = getParticipantsByName(names: shoshin)


print("participants01: ", participants01)
print("All participants: ", allParticipants)

struct Debt {
    var creditor = "TBD"
    var debtor = "TBD"
    var amount : Money?
}
struct IndividualExpense {
    var name: String
    var amount: Money
}

struct Expense {
    var expenseId: Int?
    var payers : [Payer]
    var participantNames: [String]
    var fixedExpenses : [IndividualExpense]?
    var debts: [Debt]?
}

var expense01 = Expense(payers: [payer1, payer2], participantNames : shoshin, fixedExpenses: [IndividualExpense(name: "Linh", amount: 70)])
print(expense01)


func shareAnExpense(expense: Expense) -> [Debt] {

    func calTotal(payers: [Payer]) -> Money {
        var total : Money = 0;
        for p in payers { total += p.advance}
        return total
    }

    func calExpenseOfEach(total: Money, participantNames: [String], fixedExpenses: [IndividualExpense]?) -> [Participant] {
        var participants = getParticipantsByName(names: participantNames)

        var totalFixedExpenses : Money = 0;
        var numberOfSharingParticipants = participants.count
        if let actualFixedExpenses = fixedExpenses {
            for e in actualFixedExpenses {
                totalFixedExpenses += e.amount
                for (i,p) in participants.enumerated() {
                    if p.name == e.name {
                        participants[i].expense = e.amount
                        numberOfSharingParticipants -= 1
                    }
                }
            }
        }

        let sharedExpenses = total - totalFixedExpenses

        let sharedAmountOfEach : Money = Money(sharedExpenses/numberOfSharingParticipants)

        for (i,p) in participants.enumerated() {
            if p.expense == 0 {
               participants[i].expense = sharedAmountOfEach
            }
        }

        return participants
    }

    func calDebts(payers_arg: [Payer], participants_arg: [Participant]) -> [Debt]{
        var debts : [Debt] = []
        var payers = payers_arg
        var participants = participants_arg

        // compare advance & expense of each payers
        for (payerId,payer) in payers.enumerated() {
            for (participantId,participant) in participants.enumerated(){
                if payer.name == participant.name {
                    if payer.advance >= participant.expense {
                        payers[payerId].advance = payer.advance - participant.expense;
                        participants[participantId].expense = 0
                    } else {
                        participants[participantId].expense = participant.expense - payer.advance
                        payers[payerId].advance = 0
                    }
                break
                }
            }
        print("AFTER CLEANING")
        print ("Payers after cleaning:", payers)
        print ("Participants after cleaning:", participants)
        }

        for p in payers {
            if p.advance == 0 {continue}
            var payer = p
            for (participantId, participant) in participants.enumerated(){
                 if (payer.name != participant.name) && (participant.expense != 0) {
                    if payer.advance > participant.expense {
                        debts.append(Debt(creditor: payer.name, debtor:participant.name, amount:participant.expense))
                        payer.advance -= participant.expense;
                        participants[participantId].expense = 0
                        continue
                    } else {
                       debts.append(Debt(creditor: payer.name, debtor:participant.name, amount:payer.advance))
                       participants[participantId].expense -= payer.advance
                       payer.advance = 0
                       break
                    }
                 }
            }
        }
        return debts
    }

    let totalExpenses = calTotal(payers: expense.payers)
    print("Total Expense: ", totalExpenses)

    let participantsWithExpense = calExpenseOfEach(total: totalExpenses, participantNames: expense.participantNames, fixedExpenses: expense.fixedExpenses)
    print ("Participants: ", participantsWithExpense)

    return calDebts(payers_arg: expense.payers, participants_arg: participantsWithExpense)

}

var debtsFromExpense = shareAnExpense(expense:expense01)
print ("Debts from expense :", debtsFromExpense)


// //
// struct Resolution {
//     var width = 0
//     var height = 0
// }
// var resolution1 = Resolution(width: 1, height: 1)
// print(resolution1)
//
// var resolution2 = Resolution()
// print(resolution2)

// struct Point {
//     var x = 0.0, y = 0.0
//     mutating func moveBy(x deltaX: Double, y deltaY: Double) {
//         self.x += deltaX
//         self.y += deltaY
//     }
// }
// var somePoint = Point(x: 1.0, y: 1.0)
// somePoint.moveBy(x: 2.0, y: 3.0)
// print("The point is now at (\(somePoint.x), \(somePoint.y))")


// Prints "The point is now at (3.0, 4.0)"
// var b = 10
//
// var a = 0
// do {
// try print(b/a)
// } catch {
//     print("catch an error")
// }
// print(a/b)
//
// print(10/4.0)

// let a : Int
// var b : Int
// b = 2
// a = b + 1
// print(a)



//  var d : Int? = Int("11")
// print(d)
// struct Resolution {
//     var width = 0
//     var height = 0
// }
// struct VideoMode {
//     var resolution = Resolution()
//     var interlaced = false
//     var frameRate = 0.0
//     var name: String?
// }
//
// let someResolution = Resolution()
// let someVideoMode = VideoMode()
//
// print(someResolution)



// // while
// var square = 0
// var diceRoll = 0
// while square < finalSquare {
//     // roll the dice
//     diceRoll += 1
//     if diceRoll == 7 { diceRoll = 1 }
//     // move by the rolled amount
//     square += diceRoll
//     if square < board.count {
//         // if we're still on the board, move up or down for a snake or a ladder
//         square += board[square]
//     }
// }
// print("Game over!")
//
// // for-in loop
//
// let base = 3
// let power = 3
// var answer = 1
// for _ in 1...power {
//     answer *= base
// }
// print("\(base) to the power of \(power) is \(answer)")
//
// let minutes = 60
// let minuteInterval = 10
// for tickMark in stride(from: 0, to: minutes, by: minuteInterval) {
//     print(tickMark)
// } // 0 is included; 60 is excluded.
//
// let hours = 12
// let hourInterval = 3
// for tickMark in stride(from: 3, through: hours, by: hourInterval) {
//     print(tickMark)
// } // 3 & 12 are included


// //dictionary
//
// // var airports: [String: String] = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]
//
// var airports = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]
// airports["LHR"] = "London"
// airports["LHR"] = "London Heathrow"
//
// // the updateValue(_:forKey:) method returns the old value
// // after performing an update.
// if let oldValue = airports.updateValue("Dublin Airport", forKey: "DUB") {
//     print("The old value for DUB was \(oldValue).")
// } // Prints "The old value for DUB was Dublin."
//
// let airportCodes = [String](airports.keys)
// // airportCodes is ["LHR", "YYZ"]
//
// airports["APL"] = "Apple International"
// // "Apple International" isn't the real airport for APL, so delete it
// airports["APL"] = nil
// // APL has now been removed from the dictionary
//
// print(airportCodes)
//
// let airportNames = [String](airports.values)
// // airportNames is ["London Heathrow", "Toronto Pearson"]
//
// for airportCode in airports.keys {
//     print("Airport code: \(airportCode)")
// }
//


// // array
//
// var arr1 : [Int] = []
// var board = [Int](repeating: 0, count: finalSquare + 1)
//
// // if arr1.isEmpty {
// //     print("Array arr1 is empty.")
// // } else {
// //     print(arr1)
// // }
//
// arr1.append(contentsOf: [1,2,5,6,7])
// print(arr1)
//
// arr1.insert(3,at:1)
// print(arr1)
//
// // if var i = arr1.first {
// //     print("first = ",i);
// //     i += 1
// //     print(i)
// // }
//
// // var n = arr1.count
// // arr1.removeSubrange(_: 2..<n )
// // print(arr1)
//
// // let namedHues: [String: Int] = ["Vermillion": 18, "Magenta": 302,
// //         "Gold": 50, "Cerise": 320]
// // let colorNames = Array(namedHues.keys)
// // print(colorNames)
//
// typealias  debt = (creditor:String,debtor:String,amount:Int)
// var debts: [debt] = []
// var debtors:[String] = []
//
// let input = [("Linh","",1),("Nghia","",2),("Khang","",3)]
//
// for i in 0..<input.count {
//     debts += [input[i]]
//     debtors += [input[i].0]
// }
//
// let arr2 = Array(0...5)
// print(arr2)
// print(debts)
// print(debtors)
// debts[1...2] = [input[0]]


// // tuple again

// let person = ("Linh", 1980, "lawyer")

// var (x,_,y) = person
// print (x,y)

// var (x,_) = person
// print(x)


// var (name,birthYear) = person
// print ("name: ", name)
// print("Year of Birth: ",birthYear)



