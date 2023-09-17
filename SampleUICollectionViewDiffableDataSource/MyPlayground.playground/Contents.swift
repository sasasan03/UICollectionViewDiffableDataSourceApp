import UIKit

var dataArray = [Data()]
dataArray.append(Data(count: 1))

dataArray.map({ count in
   print("数字は:\(count)") 
})


//返す型は自由
let intArray = [1, 2, 3, 4, 5]
let stringArray = intArray.map { String($0) }
print(stringArray)


//🍔Voidを返す
//let intArray = [1, 2, 3, 4, 5]
//let stringArray = intArray.forEach { String($0) }
//print(stringArray)
