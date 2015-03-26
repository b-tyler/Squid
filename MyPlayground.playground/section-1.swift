// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var n: Int=2; //Number of rows and columns(same for a square matrix)
var w = [Double](count: n, repeatedValue: 0.0); //Eigenvalues
var lwork: Int; //Length of workspace array
var work: UnsafeMutablePointer<Double>; //Workspace array
var i,j: Int;
var info: Int; //"Exit information"
var lambda: Double;
