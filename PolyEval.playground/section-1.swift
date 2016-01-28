import UIKit
import Foundation

class polyEval
{
    class func evaluatePolynomial(pol:String , val:Double)
    {
        var terms: [String]
        var powers: [Double]
        
        printInputArguments(pol , val: val)
        
        (terms, powers) = extractMonomialsAndPowers(pol, val: val)
        
        calculateFinalResult(terms, powers: powers, val: val)
    }
    
    class func printInputArguments(pol: String , val:Double)
    {
        println("Polynomial = \(pol)\n")
        println("Value of x = \(val)\n")
    }
    
    class func extractMonomialsAndPowers(pol: String , val:Double) -> ([String], [Double])
    {
        var polWithoutSpaces: String
        var polWithPlusSigns: String
        var arrayOfMonomialsWithValueOfX: [String]
        var monomialsArray: [String]
        var arrayOfPowers: [Double]
        var arrayOfTerms: [String]
        
        polWithoutSpaces = removeWhitespacesFromPol(pol)
        polWithPlusSigns = addPlusSignsInPolForSplitting(polWithoutSpaces)
        monomialsArray = splitPolOnBasisOfPlusSigns(polWithPlusSigns)
        (arrayOfTerms , arrayOfPowers) = sortMonomialsArrayAndgetPowersArray(monomialsArray)
        arrayOfMonomialsWithValueOfX = createArrayOfMonomialsWithValueOfX(monomialsArray , val: val)
        
        return (arrayOfTerms, arrayOfPowers)
    }

    class func removeWhitespacesFromPol(pol: String) -> String
    {
        var polWithoutSpaces: String
        polWithoutSpaces = pol.stringByReplacingOccurrencesOfString(" ", withString: "");
        return polWithoutSpaces
    }
    
    class func addPlusSignsInPolForSplitting(polWithoutSpaces: String) -> String
    {
        var polWithPlusSigns: String = polWithoutSpaces
        
        for (index, value) in enumerate(polWithoutSpaces)
        {
            if(value == "-")
            {
                polWithPlusSigns = polWithoutSpaces.stringByReplacingOccurrencesOfString("-", withString: "+-");
            }
        }
        return polWithPlusSigns
    }
    
    class func sortMonomialsArrayAndgetPowersArray(arrayOfMonomials:[String]) -> ([String] , [Double])
    {
        var powers: [Double] = []
        var tempString: String = " "
        var flagHat: Bool = false
        var aom = arrayOfMonomials
        
        for (index , value) in enumerate(arrayOfMonomials)
        {
            tempString = value
            
            if(last(value) == "x")
            {
                powers.append(1)
                aom[index] = aom[index] + "^1"
            }
            
            if (tempString.rangeOfString("^") == nil)
            {
                if(last(value) != "x")
                {
                    powers.append(0)
                    aom[index] = aom[index] + "^0"
                }
            }
            
            if(tempString.rangeOfString("^") != nil)
            {
                var spl = split(value) {$0 == "^"}
                var d = (spl[1] as NSString).doubleValue
                powers.append(d)
                
            }
        }
        return(aom , powers)
    }
    
    
    class func splitPolOnBasisOfPlusSigns(polWithPlusSigns: String) -> [String]
    {
        var monomialsArray: [String]
        
        monomialsArray = split(polWithPlusSigns) {$0 == "+"}
        
        return monomialsArray
    }
    
    class func evaluateMonomial(monomial: String , val: Double)->String
    {
        var monomialWithValueOfX: String
        monomialWithValueOfX = putValueOfXInMonomial(monomial , val: val)
        
        return monomialWithValueOfX
    }

    class func putValueOfXInMonomial(monomial: String , val: Double)->String
    {
        var count = 0
        var tempString: String
        var sign = Array(monomial)[0]
        var hasSign = (sign == "-") || (sign == "+")
        
        for (index, value) in enumerate(monomial)
        {
            if(value == "x")
            {
                count++
                
                var x = insertAsterisk(index, hasSign: hasSign)
                
                tempString = monomial.stringByReplacingOccurrencesOfString("x", withString: x + String(format:"%f", val));
                
                if(sign == "+")
                {
                    tempString = tempString.stringByReplacingOccurrencesOfString("+", withString: "")
                }
                return tempString
            }
        }
        
        if(count == 0)
        {
            tempString = monomial
            return tempString
        }
    }
    
    class func insertAsterisk(index: Int, hasSign: Bool) -> String
    {
        if (index == 0)
        {
            return ""
        }
        if (index != 1)
        {
            return "*"
        }
        
        if (!hasSign)
        {
            return "*"
        }
        return ""
    }

    class func createArrayOfMonomialsWithValueOfX(monomialsArray: [String] , val:Double)->[String]
    {
        var arrayOfMonomialsWithValueOfX: [String] = []
        
        for (index, value) in enumerate(monomialsArray)
        {
            var tempString = (evaluateMonomial(monomialsArray[index], val: val))
            
            arrayOfMonomialsWithValueOfX.append(tempString)
        }
        return arrayOfMonomialsWithValueOfX
    }

    class func calculateFinalResult(monomials: [String] , powers: [Double] , val: Double)
    {
        var coeffsArray = extractCoeffs(monomials)
        runPolyEvalAlgorithm(coeffsArray , powers: powers , val: val)
    }
    
    class func extractCoeffs(sortedTerms: [String]) -> [Double]
    {
        var Coeffs: [Double] = []
        var tempArray: [String] = []
        var tempString: String = ""
        
        tempString = join("+", sortedTerms)
        tempArray = split(tempString) {$0 == "^"}
        tempString = join("+", tempArray)
        tempArray.removeAll(keepCapacity: true)
        tempArray = split(tempString) {$0 == "+"}
        
        for(index, value) in enumerate(tempArray)
        {
            if(value == "x")
            {
                tempArray[index] = tempArray[index].stringByReplacingOccurrencesOfString("x", withString: "1")
            }
            else if(value == "-x")
            {
                tempArray[index] = tempArray[index].stringByReplacingOccurrencesOfString("x", withString: "1")
            }
            else
            {
                tempArray[index] = tempArray[index].stringByReplacingOccurrencesOfString("x", withString: "")
            }
        }
        
        for(index, value) in enumerate(tempArray)
        {
            if(index % 2 != 1)
            {
                Coeffs.append((tempArray[index] as NSString).doubleValue)
            }
        }
        return Coeffs
    }
    
    class func runPolyEvalAlgorithm(coeffsArray: [Double] , powers: [Double], val:Double)
    {
        var res: Double = 0.0
        
        for (index, value) in enumerate (coeffsArray)
        {
            res = res + (value * pow(val , Double(powers[index])))
        }
        println("Result     = \(res)\n")
    }
}


/*
Test Code
*/

polyEval.evaluatePolynomial("x", val: 2)
println("\n\n")

polyEval.evaluatePolynomial("+x^12", val: 2)
println("\n\n")

polyEval.evaluatePolynomial("-2x^10", val: 2)
println("\n\n")

polyEval.evaluatePolynomial("+100 -100", val: 2)
println("\n\n")

polyEval.evaluatePolynomial("2x^3 + 2x + 2", val: 2)
println("\n\n")

polyEval.evaluatePolynomial("-2x^3-2x-2", val: 2)
println("\n\n")

polyEval.evaluatePolynomial("x^100 + 1", val: 1)
println("\n\n")

polyEval.evaluatePolynomial("3 + x^2", val: 2)
println("\n\n")

polyEval.evaluatePolynomial("-3  -x^2 + 3x^3", val: 2)
println("\n\n")

polyEval.evaluatePolynomial("1 + 1x^2 + 3x^3 + 5x^5 + 7x^7", val: 1)
println("\n\n")

polyEval.evaluatePolynomial("1+1x^2+3x^3+5x^5+7x^7+0-0", val: 0)
println("\n\n")




