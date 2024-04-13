// The Swift Programming Language
// https://docs.swift.org/swift-book

// print("Hello, world!")
//
// var var1 = "Linh"
// print (var1); print ("I am \(var1)"); print(var1, "is my name.")
//
let cat = "🐱"; print(cat)
//
// var http404Error = (404, "Not Found")
// http404Error.0 = 200
// print (http404Error)

// var tuple01 = (0, 1)
// var tuple02 = (tuple01, tuple01)
// print(tuple02.count)

// var var1 = Int.max
// print (var1)
// var1 += 1
// print (var1)


let currency = "VND"
typealias Money = Int // for USD, EUR:  Money = Double
// if currency == "VND" {
//    typealias Money = Int
//     } else {
//     typealias Money = Double}

var maxAmount = Money.max
print (Money.min)
print (maxAmount)


var debt : (creditor: String, debtor: String, amount: Money) // debt is type of tuple

var member : (name: String, debts: [(creditor: String, debtor: String, amount: Money)], totalAssets: Money) //member is also type of tuple

var members : [(name: String, debts: [(creditor: String, debtor: String, amount: Money)], totalAssets: Money)] = []

var expense : (payers: [(payerName: String, amount: Money)], participants:[String])
var expenses : [(payers: [(payerName: String, amount: Money)], participants:[String])]

// test declaration: success!
debt = ("Kihon","Linh", 50_000)
member = ("Linh", [debt], -50_000)
print (member)

var memberList = ["Linh","Nghia","Khang","Hoang","Lan Anh"]
var expense01 = ([("Linh", 500_000)],memberList)
var expense02 = ([("Linh", 100_000),("Nghia",50_000)],["Linh","Nghia"])
var expense03 = ([("Linh", 100_000),("Nghia",50_000)],memberList)

//create members from memberList
for newMember in memberList {
member = (newMember, [], 0)
members.append(member)
// print (member)
}
// print (members)
// print (expense01)
// print (expense02)
//
// expense = expense01


func shareAnExpense(expense: (payers: [(payerName: String, amount: Money)], participants:[String]))
-> [(creditor: String, debtor: String, amount: Money)] {


    var payerNames : [String] = []
    var total : Money = 0
    func dealPayers() -> (total: Money, payerNames: [String]) {
       for payer in expense.payers {
            total += payer.amount
            payerNames.append(payer.payerName)
        }
        print("total expense: ",total)
        print("Payer(s) is/are: ", payerNames)
        return (total, payerNames)
    }
    (total, payerNames) = dealPayers()
    print("total: \(total) , payer(s): \(payerNames)")

    var expenseOfEach: Money
    func calExpenseOfEach() -> Money {
        let expenseOfEach = -Money(total / expense.participants.count) // expense is a negative number (-)
        return expenseOfEach
    }
    expenseOfEach = calExpenseOfEach()
    print ("expense of each person : ", -expenseOfEach)


    var personalAssets: [(name:String, unsharedExpense: Money, assets: [(debtor:String, amount:Money)]) ]
    func listPersonalAssets() -> [(name:String, unsharedExpense: Money, assets: [(debtor:String, amount:Money)]) ] {
        var personalAsset: (name:String, unsharedExpense: Money, assets: [(debtor:String, amount:Money)])
        var tempPersonalAssets: [(name:String, unsharedExpense: Money, assets: [(debtor:String, amount:Money)]) ] = []
        for participant in expense.participants {
            personalAsset.name = participant
            personalAsset.unsharedExpense = expenseOfEach
            personalAsset.assets = []

            for payer in expense.payers {
                if participant == payer.payerName {
                    personalAsset.unsharedExpense += payer.amount
                    print("Payer: \(participant)")
                    break
                }
            }
            print(personalAsset)
            tempPersonalAssets.append(personalAsset)
        }
        print ("List of personal assets before sharing: ", tempPersonalAssets)
        return tempPersonalAssets
    }
    personalAssets = listPersonalAssets()
    print ("List of personal assets before sharing (outside function): ", personalAssets)

    var debts : [(creditor: String, debtor: String, amount: Money)] = []
    func calDebts() {
        for payer in expense.payers {
            for (idPayer, payerAsset) in personalAssets.enumerated() {
               if payerAsset.name == payer.payerName {
                    for (idParticipant,participantAsset) in personalAssets.enumerated() {
                        if (personalAssets[idPayer].unsharedExpense <= 0) { break } // the payer still lents someone.
                        if (personalAssets[idParticipant].unsharedExpense < 0) {   // find a potential debtor
                            var sharedAmount: Money
                            if ((personalAssets[idParticipant].unsharedExpense + personalAssets[idPayer].unsharedExpense) >= 0) {
                            sharedAmount = -personalAssets[idParticipant].unsharedExpense
                            }
                            else {sharedAmount = personalAssets[idPayer].unsharedExpense}

                            debts.append((payer.payerName,participantAsset.name,sharedAmount))

                            personalAssets[idParticipant].unsharedExpense += sharedAmount
                            personalAssets[idParticipant].assets.append((payer.payerName, -sharedAmount))

                            personalAssets[idPayer].unsharedExpense -= sharedAmount
                            personalAssets[idPayer].assets.append((participantAsset.name,sharedAmount))
                        }
                   }
                   break
               }
            }

        }
        print("List of debts: ",debts)
        print("After sharing: \(personalAssets)")
    }
    calDebts()

    return debts
}
shareAnExpense(expense: expense03)
//



// func say(name: String) {
// print ("Hello ",name)
// }
// func say1(name: String) -> String {
//     return ("Ms. " + name)
// }
//
// func say2(name: (i: Int , n: String)) {
// //tuple is fine as long as it is not  single-element tuple with an element label
// // name: (i: Int , n: String)   OK
// // name: (String) OK -> name: String
// // name: (n: String)   ERROR
// print ("Hi ",name)
// }

// var n : (m: String) = ("Linh") // error: cannot create a single-element tuple with an element label

// say2(name: (1, "Linh"))

//
// var score = 3
// if score < 4 {
//     defer {
//         print("defer: ", score)
//     }
//     score += 3
//     print(score)
// }
