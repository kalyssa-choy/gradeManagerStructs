//
//  main.swift
//  gradeManagement
//
//  Created by StudentAM on 1/23/24.
//

import Foundation
import CSV

//variable that keeps track of the user's main choice
var choice: String = "0"

//the struct that will hold all of the data for a single student
struct Student{
    var gradeAverage: Double
    var allGrades: [String]
    let name: String
}

//a 1D array that holds all of the information of all of the students in the grade book
var gradeBook: [Student] = []

//reading the csv file to add elements to gradeBook array
do{
    let stream = InputStream(fileAtPath:"/Users/studentam/Desktop/gradeManager/gradeManagerStructs/grades2.csv")
    
    let csv = try CSVReader(stream: stream!)
    
    while var row = csv.next(){
        
        //creating the tempStudent and putting the name in the Student
        let tempName: String = row[0]
        var tempStudent: Student = Student(gradeAverage: 0.0, allGrades: [], name: tempName)
        
        //putting allGrades for the student in tempStudent
        row.removeFirst()
        tempStudent.allGrades = row
        
        //putting the gradeAverage for the student in tempStudent
        var sum: Double = 0
        for i in 0...(row.count - 1){
            sum += Double(row[i])!
        }
        var tempGPA: Double = round(100*sum/10)/100
        tempStudent.gradeAverage = tempGPA
        
        //adding the tempStudent to the gradeBook
        gradeBook.append(tempStudent)
    }
}
catch{
    print("There was an error trying to read the file!")
}

//function for checking if the student exists in the gradeBook array and returns a boolean
func nameInBook(_ name:String) -> Bool{
    for i in 0...(gradeBook.count - 1){
        if name.lowercased() == gradeBook[i].name.lowercased(){
            return true
        }
    }
    return false
}


//function that checks if a string can be converted into a integer/double and returns a boolean
func isNumber(_ input:String) -> Bool{
    let allNums = ".0123456789"
    
    for char in input{
        if !allNums.contains(char){
            return false
        }
    }
    return true
}

//function for getting the indices of a certain student and returns an integer
func getIndices(_ studentName: String) -> Int{
    for i in 0...(gradeBook.count - 1){
        if gradeBook[i].name.lowercased() == studentName.lowercased(){
            return i
        }
    }
    return -1
}

//function for returning all of the student's grades at an indices of the gradeBook array in a string
func getStudentAllGrades(_ studentName: String) -> String{

    var theString = ""
    
    var index: Int = getIndices(studentName)
    for i in 0...(gradeBook[index].allGrades.count - 1){
        if i == 0{
            theString += "\(gradeBook[index].allGrades[i])"
        }
        else{
            theString += ", \(gradeBook[index].allGrades[i])"
        }
    }
    return theString
}

//function for returning the student's name as it appears in the gradebook (for formatting)
func getName(_ studentName: String) -> String{
    var theName: String = ""
    
    for i in 0...(gradeBook.count - 1){
        if studentName.lowercased() == gradeBook[i].name.lowercased(){
            theName = gradeBook[i].name
        }
    }
    return theName
}

//function for getting the student's average grade returned as a double
func getGPA(_ studentName: String) -> Double{
    var gpa: Double = 0.0
    
    for i in 0...(gradeBook.count - 1){
        if studentName.lowercased() == gradeBook[i].name.lowercased(){
            gpa = gradeBook[i].gradeAverage
        }
    }
    return gpa
}

//the main function
while choice != "9"{
    print("Welcome to the Grade Manager!")
    
    print("What would you like to do?(Enter the number):")
    print("1. Display grade of a single student")
    print("2. Display all grades for a student")
    print("3. Display all grades of ALL students")
    print("4. Find the average grade of the class")
    print("5. Find the average grade of an assignment")
    print("6. Find the lowest grade in the class")
    print("7. Find the highest grade of the class")
    print("8. Filter students by grade range")
    print("9. Quit")
    
    //checks if the next line is valid/exists
    if let userChoice = readLine(){
        //assigns the user input as a string to the variable choice
        choice = userChoice
        
        //for if the user entered "1"//if the user wants to see the overall grade of one student
        if choice == "1"{
            print("Which student would you like to choose?")
            
            if let theStudent = readLine(){
                if nameInBook(theStudent){
                    print("\(getName(theStudent))'s overall grade in the class is \(getGPA(theStudent))")
                }
                else{
                    print("That student is not in the grade book")
                }
            }
        }
        
        //for if the user enetered "2"//if the user wants to see all grades of one student
        else if choice == "2"{
            print("Which student would you like to choose?")
            
            if let theStudent = readLine(){
                if nameInBook(theStudent){
                    print("\(getName(theStudent))'s grades for this class are:")
                    
                    print(getStudentAllGrades(theStudent))
                }
                else{
                    print("That student is not in the grade book")
                }
            }
        }
        
        //for if the user entered "3" // if the user wants to see all grades for all students
        else if choice == "3"{
            for i in 0...(gradeBook.count - 1){
                print("\(gradeBook[i].name)'s grades are: \(getStudentAllGrades(gradeBook[i].name))")
            }
        }
        
        //for if the user entered "4" // if the user wants to see the average grade of the class
        else if choice == "4"{
            var sum: Double = 0;
            
            for i in 0...(gradeBook.count - 1){
                sum += gradeBook[i].gradeAverage
            }
            
            var classAverage: Double = round(100*sum/Double(gradeBook.count))/100
            print("The class average is: \(classAverage)")
        }
        
        //for if the user entered "5" // if the user wants to find the average grade of an assignment
        else if choice == "5"{
            print("Which assignment would you like to get the average of (1-10):")
            
            if let assignment = readLine(){
                if isNumber(assignment){
                    if assignment.contains("."){
                        print("Invalid assignment number")
                    }
                    else{
                        var sum: Double = 0.0
                        var index: Int = Int(assignment)! - 1
                        
                        //if the user entered an assignment number that does not exist in the gradeBook
                        if index > 9 || index < 0{
                            print("Sorry, that assignment is not in the grade book")
                        }
                        //actual functionality
                        else{
                            for i in 0...(gradeBook.count - 1){
                                sum += Double(gradeBook[i].allGrades[index])!
                            }
                            
                            var theAverage: Double = round(100*sum/Double(gradeBook.count))/100
                            print("The average for assignment #\(assignment) is \(theAverage)")
                        }
                    }
                }
                //message for if the input entered is not a number
                else{
                    print("Sorry, that is not a valid answer")
                }
            }
        }
        //for if the user entered "6" // if the user wants to find the student with the lowest grade
        else if choice == "6"{
            var lowestIndex: Int = 0
            
            for i in 1...(gradeBook.count - 1){
                if gradeBook[i].gradeAverage < gradeBook[lowestIndex].gradeAverage{
                    lowestIndex = i
                }
            }
            
            print("\(gradeBook[lowestIndex].name) is the student with the lowest grade: \(gradeBook[lowestIndex].gradeAverage)")
        }
        //for if the user entered "7" // if the user wants to find the student with the highest grade
        else if choice == "7"{
            var highestIndex: Int = 0
            
            for i in 1...(gradeBook.count - 1){
                if gradeBook[i].gradeAverage > gradeBook[highestIndex].gradeAverage{
                    highestIndex = i
                }
            }
            
            print("\(gradeBook[highestIndex].name) is the student with the highest grade: \(gradeBook[highestIndex].gradeAverage)")
        }
        //for if the user entered "8" // if the user wants to get all of the grades in the range of what they entered
        else if choice == "8"{
            print("Enter the lower bound you would like to use: ")
            
            if let lowerBound = readLine(){
                if isNumber(lowerBound){
                    print("Enter the upper bound you would like to use: ")
                    
                    if let upperBound = readLine(){
                        if !isNumber(upperBound) || upperBound <= lowerBound{
                            print("Invalid upper bound")
                        }
                        else{
                            for i in 0...(gradeBook.count - 1){
                                if gradeBook[i].gradeAverage > Double(lowerBound)! && gradeBook[i].gradeAverage < Double(upperBound)!{
                                    print("\(gradeBook[i].name): \(gradeBook[i].gradeAverage)")
                                }
                            }
                        }
                    }
                }
                else{
                    print("Invalid lower bound")
                }
            }
        }
        //for if the user entered "9" // if the user wants to quit the application
        else if choice == "9"{
            print("The Grade Manager has been closed. Have a great rest of your day!")
        }
        else{
            print("Invalid option")
        }
        //extra line for formatting
        print()
    }
    
}
