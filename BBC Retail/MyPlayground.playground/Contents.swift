import UIKit

var greeting = "Hello, playground"


var a = 1
var b = 2

let c = a+b
print(c)

func printGreeting(to: String) -> String {
    print("In printGreeting()")
    return "Hello, \(to)"
}

func lazyTest() {
    print("Before lazy")
    lazy var greeting = printGreeting(to: "Paul")
    print("After lazy")
    print(greeting)
}

lazyTest()

class A{
    class func classFunction(){
    }
    static func staticFunction(){
    }
    class func classFunctionToBeMakeFinalInImmediateSubclass(){
    }
   }

class B: A {
    override class func classFunction(){
        
    }
    
    //Compile Error. Class method overrides a 'final' class method
//    override static func staticFunction(){
//
//    }
    
    //Let's avoid the function called 'classFunctionToBeMakeFinalInImmediateSubclass' being overriden by subclasses
    
    /* First way of doing it
    override static func classFunctionToBeMakeFinalInImmediateSubclass(){
    }
    */
    
    // Second way of doing the same
    override final class func classFunctionToBeMakeFinalInImmediateSubclass(){
    }
    
    //To use static or final class is choice of style.
    //As mipadi suggests I would use. static at super class. and final class to cut off further overrides by a subclass
    }

class C: B{
    //Compile Error. Class method overrides a 'final' class method
    override static func classFunctionToBeMakeFinalInImmediateSubclass(){
        
    }
}





