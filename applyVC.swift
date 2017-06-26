//
//  applyVC.swift
//  Calculator
//
//  Created by Erica Wang on 2017-02-04.
//  Copyright © 2017 Erica Wang. All rights reserved.
//

import UIKit
import CoreData

extension String {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return self[Range(start ..< end)]
    }
    subscript (a: Int, b: Int) -> String {
        let r = Range(uncheckedBounds: (lower: a, upper: b))
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return self[Range(start ..< end)]
    }
}

class applyVC: UIViewController {
    
    let index = 0
    var liVC : listVC!
    var pageVC: UIPageViewController!
    var paVC : pageVC!
    var count = 0
    
    var nameText = ""
    var leftText = ""
    var rightText = ""
    
    var obj : NSManagedObject!
    
    
    //MARK: Programmatic objects
    
    lazy var nameF : UILabel = {
        
        let lbl = UILabel(frame: CGRect(x: 30, y: 50, width: self.view.frame.width-60, height: 30))
        
        lbl.font = UIFont(name: lbl.font.fontName, size: 30)
        lbl.textAlignment = .center
        return lbl
        
        
    }()
    lazy var leftF : UILabel = {
        
        let lbl = UILabel(frame: CGRect(x: 30, y: 90, width: self.view.frame.width-60, height: 25))
        
        lbl.font = UIFont(name: lbl.font.fontName, size: 20)
        lbl.textAlignment = .center
        return lbl
        
    }()
    lazy var equalSign : UILabel = {
        
        let lbl = UILabel(frame: CGRect(x: self.view.frame.width/2-5, y: 115, width: 10, height: 15))
        lbl.font = UIFont(name: lbl.font.fontName, size: 20)
        lbl.textAlignment = .center
        return lbl
        
    }()
    lazy var rightF : UILabel = {
        
        let lbl = UILabel(frame: CGRect(x: 30, y: 130, width: self.view.frame.width-60, height: 25))
        
        lbl.font = UIFont(name: lbl.font.fontName, size: 20)
        lbl.textAlignment = .center
        return lbl
    }()
    
    //MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameF.text = nameText
        leftF.text = leftText
        rightF.text = rightText
        equalSign.text = "="
        
        self.view.addSubview(nameF)
        self.view.addSubview(leftF)
        self.view.addSubview(equalSign)
        self.view.addSubview(rightF)
        
        enter.addTarget(self, action: #selector(applyFormula), for: .touchUpInside)
        
    }
    
    func prep(){
        
        if obj != nil{
            let nameString = obj.value(forKey: "name") as!String
            let leftString = obj.value(forKey: "left") as! String
            let rightString = obj.value(forKey: "right") as! String
            
            self.nameText = nameString
            self.leftText = leftString
            self.rightText = rightString
        }
    }
    
    //MARK: Prep for Applying
    
    @IBOutlet weak var goalF: UITextField!
    @IBOutlet weak var enter: UIButton!
    
    var unknown: [Character] = []
    var arrayTxt: [UITextField] = []
    var arrayLbl: [UILabel] = []
    var goalText : Character!
    
    var editLeft = ""
    var editRight = ""
    
    lazy var scrollView : UIScrollView = {
        let view = UIScrollView(frame: CGRect(x: 16, y: self.view.frame.height/2-65, width: self.view.frame.width-32, height: self.view.frame.height/2-100))
        view.backgroundColor = UIColor.cyan
        return view
    }()
    lazy var calculateButton : UIButton = {
        var button = UIButton(frame: CGRect(x: self.view.frame.width-100, y: self.view.frame.height-150, width: 80, height: 30))
        button.setTitle("Calculate", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(calculateFunc), for: .touchUpInside)
        return button
    }()
    lazy var resultLbl : UILabel = {
        let lbl = UILabel(frame: CGRect(x: 25, y: self.view.frame.height-100, width: self.view.frame.width-50, height: 30))
        return lbl
    }()
    
    func applyFormula(){
        
        getVariables()
        adjustScroll()
        self.view.addSubview(calculateButton)
        self.view.addSubview(resultLbl)
        
    }
    
    func getVariables (){
        
        goalText = makeChar(str: goalF.text!)
        
        for char in leftText.characters{
            if (isLetter(char: char)){
                if(char==goalText){
                }else{
                    if(!unknown.contains(char)){
                        unknown.append(char)
                    }
                }
            }
        }
        
        for char in rightText.characters{
            if (isLetter(char: char)){
                if(char==goalText){
                }else{
                    if(!unknown.contains(char)){
                        unknown.append(char)
                    }
                }
            }
        }
        
    }
    
    func adjustScroll(){
        
        let length = unknown.count
        
        var heightOfScroll = 0
        
        for i in 0..<length{
            let newLabel = UILabel(frame: CGRect(x: 40, y: 10+i*30+(i+1)*10, width: 30, height: 30))
            let newTxt = UITextField(frame: CGRect(x: 80, y: 10+i*30+(i+1)*10, width: 150, height: 30))
            newLabel.text = (String(unknown[i]))
            newTxt.borderStyle = UITextBorderStyle.roundedRect
            
            heightOfScroll+=40
            
            arrayTxt.append(newTxt)
            arrayLbl.append(newLabel)
            
            self.scrollView.addSubview(newLabel)
            self.scrollView.addSubview(newTxt)
            
        }
        
        scrollView.contentSize = CGSize(width: Int(self.view.frame.width-32), height: heightOfScroll+80)
        self.view.addSubview(scrollView)
        
    }
    
    //MARK: Calculate
    
    func calculateFunc (){
        
        subInValue()
        
        var s = editLeft[0] as String
        if s != "-"{
            editLeft="+"+editLeft
        }
        
        s = editRight[0] as String
        if s != "-"{
            editRight = "+"+editRight
        }
        
        print(editLeft)
        print(editRight)
        
        addSub()
        mulDiv()
        
    }
    
    
    
    /*
     removes excess brackets
     */
    func removeBrackets(ori: String) -> String{
        var str = ori
        //remove brackets that go all the way around
        if str[0]=="(" && str[str.characters.count-1]==")"{
            str.remove(at: str.index(str.startIndex, offsetBy: str.characters.count-1))
            str.remove(at: str.index(str.startIndex, offsetBy: 0))
        }
        
        //remove brackets that only surround one number
        var curIndex = 0
        var length = str.characters.count
        
        while curIndex<length-1{
            
            if str[curIndex]=="("{
                var bool = true
                var endIndex = curIndex
                for u in curIndex+1..<length{
                    if str[u]==")"{
                        endIndex = u
                        break
                    }
                    if !isNumber(char:str[u]) && !(str[u]==".") && !(isVariable(char:str[u])){
                        bool = false
                        break
                    }
                }
                if bool{
                    str.remove(at: str.index(str.startIndex, offsetBy: endIndex))
                    str.remove(at: str.index(str.startIndex, offsetBy: curIndex))
                    length-=1
                    curIndex = endIndex-2
                }
            }
            
            curIndex+=1
        }
        
        return str
        
    }
    
    func exponent (str : String) -> String{
        var result = str
        var i = 1
        var length = result.characters.count-1
        while i < length{
            if result[i]=="^" && isNumber(char:result[i-1]) && isNumber(char: result[i+1]){
                
                var startIndex = i-2
                while startIndex >= 0 && isNumber(char:result[startIndex]){
                    startIndex-=1
                }
                startIndex+=1
                let range = Range(uncheckedBounds: (lower: startIndex, upper: i))
                let base : Double = Double(result[range])!
                var endIndex = i+2
                while endIndex < result.characters.count && isNumber(char: result[endIndex]){
                    endIndex+=1
                }
                let endRange = Range(uncheckedBounds: (lower: i+1, upper: endIndex))
                let exp : Double = Double(result[endRange])!
                
                let value : String = "\(pow(base, exp))"
                var count = endIndex-startIndex
                while count>0{
                    count-=1
                    result.remove(at: result.index(result.startIndex, offsetBy: startIndex))
                }
                
                result = insert(ori: result, inserted: value, index: startIndex)
                length = result.characters.count
                i = startIndex+value.characters.count-1
            }
            i+=1
        }
        return result
    }
    
    /*
     performs AS with numbers
     */
    func calcAS(ori: String) -> String{
        
        var i = 1
        
        var str : String = ori
        
        while i<str.characters.count{
            
            if isNumber(char:str[i-1])&&str[i]=="+"&&isNumber(char:str[i+1]){
                
                var index = i+1
                while index<str.characters.count && (isNumber(char:str[index])||Character(str[index])=="."){
                    index+=1
                }
                let upper = index-1
                if upper<str.characters.count-2&&(str[upper+1]=="*"||str[upper+1]=="/"){
                    i+=1
                    continue
                }
                let n1 = Double(str[i+1,upper+1])!
                index = i-1
                
                while index>=0 && (isNumber(char:str[index])||Character(str[index])=="."){
                    index-=1
                }
                let lower = index+1
                if lower>1&&(str[lower-1]=="*"||str[lower-1]=="/"){
                    i+=1
                    continue
                }
                let n2 = Double(str[lower,i])!
                
                let result = String(n2+n1)
                
                let tempStr = str[0,lower]+String(result)+str[upper+1,str.characters.count]
                str = tempStr
                
                i=lower+result.characters.count-1
            }else if isNumber(char:str[i-1])&&str[i]=="-"&&isNumber(char:str[i+1]){
                
                var index = i+1
                while index<str.characters.count && (isNumber(char:str[index])||Character(str[index])=="."){
                    index+=1
                }
                let upper = index-1
                if upper<str.characters.count-2&&(str[upper+1]=="*"||str[upper+1]=="/"){
                    i+=1
                    continue
                }
                let n1 = Double(str[i+1,upper+1])!
                
                index = i-1
                while index>=0 && (isNumber(char:str[index])||Character(str[index])=="."){
                    index-=1
                }
                let lower = index+1
                if lower>1&&(str[lower-1]=="*"||str[lower-1]=="/"){
                    i+=1
                    continue
                }
                let n2 = Double(str[lower,i])!
                
                let result = String(n2-n1)
                
                
                let tempStr = str[0,lower]+String(result)+str[upper+1,str.characters.count]
                str = tempStr
                
                i=lower+result.characters.count-1
                
            }else if isVariable(char: str[i-1])&&(str[i]=="-"||str[i]=="+")&&isNumber(char:str[i+1]){
                var numOfVar1 = 0
                while isVariable(char: str[i-1-numOfVar1]){
                    numOfVar1+=1
                }
                
                var index = i-1-numOfVar1
                while index>=0 && (isNumber(char:str[index])||Character(str[index])=="."){
                    index-=1
                }
                let lower = index+1
                
                if lower>1&&(str[lower-1]=="*"||str[lower-1]=="/"){
                    i+=1
                    continue
                }
                let n2 = Double(str[lower,i-numOfVar1])!
                
                index = i+1
                while index<str.characters.count && (isNumber(char:str[index])||Character(str[index])=="."){
                    index+=1
                }
                let upper = index-1
                if !isVariable(char: str[index]){
                    i+=1
                    continue
                }
                
                var numOfVar2 = 0
                while (upper+1+numOfVar2)<str.characters.count&&isVariable(char: str[upper+1+numOfVar2]){
                    numOfVar2+=1
                }
                
                if !(numOfVar2==numOfVar1){
                    i+=1
                    continue
                }
                
                if upper<str.characters.count-1-numOfVar2&&(str[upper+1+numOfVar2]=="*"||str[upper+1+numOfVar2]=="/"){
                    i+=1
                    continue
                }
                
                let n1 = Double(str[i+1,upper+1])!
                
                var result = ""
                if str[i]=="-"{
                    result = String(n2-n1)
                }else{
                    result = String(n2+n1)
                }
                
                let tempStr = str[0,lower]+String(result)+str[upper+1,str.characters.count]
                str = tempStr
                
                i=lower+result.characters.count-1
            }
            
            
            i+=1
        }
        
        
        
        
        return str
        
    }
    
    /*
     performs MD with numbers
     */
    func calcMD(ori: String) -> String{
        
        var i = 1
        
        var str : String = ori
        
        while i<str.characters.count-1{
            
            if isNumber(char:str[i-1])&&str[i]=="*"&&isNumber(char:str[i+1]){
                var index = i+1
                while index<str.characters.count && (isNumber(char:str[index])||Character(str[index])=="."){
                    index+=1
                }
                let upper = index-1
                let n1 = Double(str[i+1,upper+1])!
                index = i-1
                while index>=0 && (isNumber(char:str[index])||Character(str[index])=="."){
                    index-=1
                }
                let lower = index+1
                let n2 = Double(str[lower,i])!
                
                let result = String(n1*n2)
                
                let tempStr = str[0,lower]+String(result)+str[upper+1,str.characters.count]
                str = tempStr
                
                i=lower+result.characters.count-1
            }
            else if isNumber(char:str[i-1])&&str[i]=="/"&&isNumber(char:str[i+1]){
                var index = i+1
                while index<str.characters.count && (isNumber(char:str[index])||Character(str[index])=="."){
                    index+=1
                }
                let upper = index-1
                let n1 = Double(str[i+1,upper+1])!
                index = i-1
                while index>=0 && (isNumber(char:str[index])||Character(str[index])=="."){
                    index-=1
                }
                let lower = index+1
                let n2 = Double(str[lower,i])!
                
                let result = String(n2/n1)
                
                
                let tempStr = str[0,lower]+String(result)+str[upper+1,str.characters.count]
                str = tempStr
                
                i=lower+result.characters.count-1
                
            }else if isVariable(char: str[i-1])&&str[i]=="*"&&isNumber(char:str[i+1]){
                var n: Double
                var lower : Int = i-1
                if isNumber(char: str[i-2]){
                    var index = i-2
                    while index>=0 && (isNumber(char:str[index])||Character(str[index])=="."){
                        index-=1
                    }
                    lower = index+1
                    n = Double(str[lower,i-1])!
                }else{
                    
                    n = 1
                }
                
                var index = i+1
                while index<str.characters.count && (isNumber(char:str[index])||Character(str[index])=="."){
                    index+=1
                }
                let upper = index-1
                let n1 = Double(str[i+1,upper+1])!
                
                let result = n*n1
                
                let tempStr = str[0,lower]+String(result)+str[i-1]+str[upper+1,str.characters.count]
                str = tempStr
                
                i=lower+String(result).characters.count-1
            }
            
            
            i+=1
        }
        
        return str
        
    }
    
    /*
     opens brackets and applies multi outside to each element inside
     */
    func openBrackets(ori: String) -> String{
        
        var str = ori
        
        //if md inside && after/before md,
        //remove brackets
        
        //if as inside && after/before md,
        //apply individually
        
        for i in 1..<str.characters.count-1{
            var changed = false
            if str[i]=="*"&&str[i+1]=="("{
                var index = i //loc of )
                while !(str[index]==")"){
                    index+=1
                }
                
                
            }else if str[i]=="/"&&str[i+1]=="("{
                
            }
            if changed{
                openBrackets(ori: str)
            }
        }
        
        for i in 4..<str.characters.count-2{
            var changed = false
            if str[i]==")"&&str[i+1]=="*"{
                
            }else if str[i]==")"&&str[i+1]=="/"{
                
            }
            if changed{
                openBrackets(ori: str)
            }
        }
        
        //if md inside && after/before as
        //remove brackets
        
        //if as inside && after/before as
        //remove brackets
        
        return str
        
        
    }
    
    func mathCalc(ori: String) -> String{
        
        var str = ori
        str = removeBrackets(ori: str)
        str = exponent(str: str)
        str = removeBrackets(ori: str)
        str = calcMD(ori: str)
        str = removeBrackets(ori: str)
        str = calcAS(ori: str)
        str = removeBrackets(ori: str)
        
        if !(ori==str){
            mathCalc(ori: str)
        }
        
        return str
        
    }

    
    func addSub (){
        
        // still need to deal with brackets
        var characterCount = editLeft.characters.count-1
        var i = 0
        while i<characterCount{
            if editLeft[i]=="+" && isNumber(char: editLeft[i+1]){
                editRight.append("-")
                editLeft.remove(at: editLeft.index(editLeft.startIndex, offsetBy: i))
                characterCount-=1
                while i<characterCount+1&&isNumber(char: editLeft[i]){
                    let s = editLeft[i] as String
                    editRight.append(s)
                    editLeft.remove(at: editLeft.index(editLeft.startIndex, offsetBy: i))
                    characterCount-=1
                }
                i-=1
            }
            else if editLeft[i]=="-" && isNumber(char: editLeft[i+1]){
                editRight.append("+")
                editLeft.remove(at: editLeft.index(editLeft.startIndex, offsetBy: i))
                characterCount-=1
                while i<characterCount+1&&isNumber(char: editLeft[i]){
                    let s = editLeft[i] as String
                    editRight.append(s)
                    editLeft.remove(at: editLeft.index(editLeft.startIndex, offsetBy: i))
                    characterCount-=1
                }
                i-=1
            }
            i+=1
        }
        
        characterCount = editRight.characters.count
        i = 1
        while i<characterCount{
            if editRight[i]==goalText{
                var count = i-1
                var continu = true
                while count >= 0 && continu{
                    if editRight[count]=="+"{
                        editLeft.append("-")
                        editRight.remove(at: editRight.index(editRight.startIndex, offsetBy: count))
                        characterCount-=1
                        i-=1
                        for u in count...i{
                            let s = editRight[count] as String
                            editLeft.append(s)
                            editRight.remove(at: editRight.index(editRight.startIndex, offsetBy: count))
                            characterCount-=1
                            i-=1
                        }
                        continu = false
                    }else if editRight[count]=="-"{
                        editLeft.append("+")
                        editRight.remove(at: editRight.index(editRight.startIndex, offsetBy: count))
                        characterCount-=1
                        i-=1
                        for u in count...i{
                            let s = editRight[count] as String
                            editLeft.append(s)
                            editRight.remove(at: editRight.index(editRight.startIndex, offsetBy: count))
                            characterCount-=1
                            i-=1
                        }
                        continu = false
                    }
                    count-=1
                }
            }
            
            i+=1
        }
        
    }
    
    /*
     places multiplying/dividing number to the right
     places multiplying/dividing variable to the left
     */
    func mulDiv (){
        
        editRight = "("+editRight+")"
        var characterCount = editLeft.characters.count-1
        var i = 0
        while i<characterCount{
            if editLeft[i]=="*" && isNumber(char: editLeft[i+1]){
                editRight.append("/")
                editLeft.remove(at: editLeft.index(editLeft.startIndex, offsetBy: i))
                characterCount-=1
                while i<characterCount+1&&isNumber(char: editLeft[i]){
                    let s = editLeft[i] as String
                    editRight.append(s)
                    editLeft.remove(at: editLeft.index(editLeft.startIndex, offsetBy: i))
                    characterCount-=1
                }
                i-=1
            }
            else if editLeft[i]=="/" && isNumber(char: editLeft[i+1]){
                editRight.append("*")
                editLeft.remove(at: editLeft.index(editLeft.startIndex, offsetBy: i))
                characterCount-=1
                while i<characterCount+1&&isNumber(char: editLeft[i]){
                    let s = editLeft[i] as String
                    editRight.append(s)
                    editLeft.remove(at: editLeft.index(editLeft.startIndex, offsetBy: i))
                    characterCount-=1
                }
                i-=1
            }
            i+=1
        }
        
        editRight = "("+editRight+")"
        characterCount = editRight.characters.count
        i = 1
        while i<characterCount{
            if editRight[i]==goalText{
                var count = i-1
                var continu = true
                while count >= 0 && continu{
                    if editRight[count]=="*"{
                        editLeft.append("/")
                        editRight.remove(at: editRight.index(editRight.startIndex, offsetBy: count))
                        characterCount-=1
                        i-=1
                        for u in count...i{
                            let s = editRight[count] as String
                            editLeft.append(s)
                            editRight.remove(at: editRight.index(editRight.startIndex, offsetBy: count))
                            characterCount-=1
                            i-=1
                        }
                        continu = false
                    }else if editRight[count]=="/"{
                        editLeft.append("*")
                        editRight.remove(at: editRight.index(editRight.startIndex, offsetBy: count))
                        characterCount-=1
                        i-=1
                        for u in count...i{
                            let s = editRight[count] as String
                            editLeft.append(s)
                            editRight.remove(at: editRight.index(editRight.startIndex, offsetBy: count))
                            characterCount-=1
                            i-=1
                        }
                        continu = false
                    }
                    count-=1
                }
            }
            
            i+=1
        }
        
        
    }
    
    func subInValue(){
        
        
        var index = 0
        for char in leftText.characters{
            if isLetter(char: char){
                if char != goalText{
                    
                    for i in 0..<arrayLbl.count{
                        let variable = makeChar(str: arrayLbl[i].text!)
                        if variable == char{
                            editLeft += arrayTxt[i].text!
                            break
                        }
                    }
                    
                    
                }else{
                    editLeft.append(char)
                }
                
            }else{
                editLeft.characters.append(char)
            }
            
            index += 1
        }
        
        index = 0
        for char in rightText.characters{
            if isLetter(char: char){
                if char != goalText{
                    
                    for i in 0..<arrayLbl.count{
                        let variable = makeChar(str: arrayLbl[i].text!)
                        if variable == char{
                            editRight += arrayTxt[i].text!
                            break
                        }
                    }
                    
                }else{
                    
                    editRight.append(char)
                    
                }
                
            }else{
                editRight.characters.append(char)
            }
            
            index += 1
        }
        
        resultLbl.text = editLeft + " = " + editRight
        
    }
    
    //MARK: Support Functions
    
    func isNumber (char: Character) -> Bool{
        if char >= "0" && char <= "9"{
            return true
        }
        return false
    }
    
    func isLetter (char: Character) -> Bool{
        if char >= "a" && char <= "z"{
            return true
        }
        if char >= "A" && char <= "Z"{
            return true
        }
        return false
    }
    
    func isVariable (char: Character) -> Bool{
        if char >= "a" && char <= "z"{
            return true
        }
        if char >= "A" && char <= "Z"{
            return true
        }
        return false
    }
    
    func makeChar (str: String) -> Character{
        return str.characters.first!
    }
    
    func makeStr (char: Character) -> String{
        var s = ""
        s.insert(char, at: s.index(s.startIndex, offsetBy: 0))
        return s
    }
    
    func insert (ori: String, inserted: String, index: Int) -> String{
        
        var res = ori
        for i in 0..<inserted.characters.count{
            res.insert(inserted[i], at: res.index(res.startIndex, offsetBy: index+i))
        }
        return res
    }

}
