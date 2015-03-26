//
//  main.m
//  Finding Eigenvalues
//
//  Created by Beth Tyler on 19/11/2014.
//  Copyright (c) 2014 Beth Tyler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>

//Define DSYEV function
extern int dsyev (char *jobz, char *uplo, int *n, double *A, int *lda, double *w, double *work, int *lwork, int *info);

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        
        double A[4] = {2,4,4,2}; //Input matrix
        int n=2; //Number of rows and columns(same for a square matrix)
        double w[2]; //Eigenvalues
        int lwork; //Length of workspace array
        double *work; //Workspace array
        int i,j;
        int info; //"Exit information"
        
        //Display matrix A:
        NSLog(@"A= \n");
        for (i=0; i<n; i++)
        {
            for (j=0; j<n; j++)
                NSLog(@"%f ", A[i*n+j]);
                NSLog(@"\n");
        }
        
        //Call DSYEV:
        lwork = 3*n-1;
        work  = (double *) calloc (lwork, sizeof(double)); // set size of workspace
        dsyev("N", "U", &n, A, &n, w, work, &lwork, &info);
        free(work);
        
        //Display eigenvalues
        if (info!=0)
            NSLog(@"error!\n");
        else
        {
            NSLog(@"eigen values:\n");
            for (i=0; i<n; i++)
                NSLog(@"%f ", w[i]);
                NSLog(@"\n");
        }
        
        return info;
    }
}

