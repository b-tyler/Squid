// Playground - noun: a place where people can play

import UIKit
import Accelerate

//Define DSYEV function
func dsyev (jobz: UnsafeMutablePointer<Character>, uplo: UnsafeMutablePointer<Character>, n: UnsafeMutablePointer<Int>, A: UnsafeMutablePointer<Double>, lda: UnsafeMutablePointer<Int>, w: UnsafeMutablePointer<Double>, work: UnsafeMutablePointer<Double>, lwork: UnsafeMutablePointer<Int>, info: UnsafeMutablePointer<Int>) -> Int{}

        var n: Int=2; //Number of rows and columns(same for a square matrix)
        var w = [Double](count: n, repeatedValue: 0.0); //Eigenvalues
        var lwork: Int; //Length of workspace array
        var work: UnsafeMutablePointer<Double>; //Workspace array
        var i,j: Int;
        var info: Int; //"Exit information"
        var lambda: Double;
        //var A: [Double];
    
        for (lambda=0; lambda<=1.01; lambda=lambda+0.01)
        {
            let A: [Double] = [2, 4*lambda, 4*lambda, 2]; //Input matrix
            
            //Display matrix A
            println("A= \n");
            for (i=0; i<n; i++)
            {
                for (j=0; j<n; j++)
                {
                    println (A[i*n+j]);
                }
                println("\n");
            }
            
            //Call DSYEV
            lwork = 3*n-1;
            //work  = (double *) calloc (lwork, sizeof(double)); //Set size of workspace
            dsyev("N", "U", &n, A, &n, w, work, &lwork, &info);
            free(work);
            
            //Display eigenvalues
            if (info != 0)
            {
                println("Error number \(info) !\n");
            }
            else
            {
                println("Eigenvalues:\n");
                for (i=0; i<n; i++)
                {
                    println(w[i]);
                }
                println("\n");
            }
            
        }