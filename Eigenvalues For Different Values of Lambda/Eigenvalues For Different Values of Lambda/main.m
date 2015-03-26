//
//  main.m
//  Eigenvalues For Different Values of Lambda
//
//  Created by Beth Tyler on 20/11/2014.
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
        
        int n=2; //Number of rows and columns(same for a square matrix)
        double w[n]; //Eigenvalues
        int lwork; //Length of workspace array
        double *work; //Workspace array
        int i,j;
        int info; //"Exit information"
        double lambda;
        NSMutableArray *lambdaAndEigenvalues = [[NSMutableArray alloc] init];
        
        //Loop to change values of lambda
        for (lambda=0; lambda<=1.01; lambda=lambda+0.01)
        {
            double A[4] = {2.0, 4.0*lambda, 4.0*lambda, 2.0}; //Input matrix
            
            //Display matrix A
            NSLog(@"A= \n");
            for (i=0; i<n; i++)
            {
                for (j=0; j<n; j++)
                {
                    NSLog(@"%f ", A[i*n+j]);
                }
                NSLog(@"\n");
            }
            
            //Call DSYEV
            lwork = 3*n-1;
            work  = (double *) calloc (lwork, sizeof(double)); //Set size of workspace
            dsyev("N", "U", &n, A, &n, w, work, &lwork, &info);
            free(work);
            
            //Display eigenvalues
            if (info!=0)
                NSLog(@"Error number %d!\n", info);
            else
            {
                NSLog(@"Eigenvalues:\n");
                for (i=0; i<n; i++)
                {
                    NSLog(@"%f ", w[i]);
                }
                NSLog(@"\n");
            }
        
            //Convert lambda and eigenvalues into NSString
            NSString *lambdaValues = [NSString stringWithFormat:@"%f", lambda];
            NSString *eigenvalue1 = [NSString stringWithFormat:@"%f", w[0]];
            NSString *eigenvalue2 = [NSString stringWithFormat:@"%f", w[1]];
            //NSString *lambdaWithEigenvalues = [NSString stringWithFormat:@"%@\n%@\n%@", lambdaValues, eigenvalue1, eigenvalue2];
            
            //NSString *desktopDirectory = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            //NSString *appFile = [desktopDirectory stringByAppendingPathComponent:@"lambdaWithEigenvalues.csv"];
            //[lambdaWithEigenvalues writeToFile:appFile atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
        
            //Combine all lambda and eigenvalues to form one NSString
            [lambdaAndEigenvalues addObject:lambdaValues];
            //[lambdaAndEigenvalues addObject:@"\n"];
            [lambdaAndEigenvalues addObject:eigenvalue1];
            [lambdaAndEigenvalues addObject:lambdaValues];
            [lambdaAndEigenvalues addObject:eigenvalue2];
            //[lambdaAndEigenvalues addObject:@"\n"];
            
            //Output data to desktop
            NSString *desktopDirectory = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *appFile = [desktopDirectory stringByAppendingPathComponent:@"lambdaAndEigenvalues.csv"];
            BOOL writtenToFile = [lambdaAndEigenvalues writeToFile:appFile atomically:YES];
            NSLog(@"writtenToFile: %d", writtenToFile);
            
        }
        
        NSString *string = @"Beth";
        //NSArray *matrix = @[@1, @2, @3, @4];
        
        //NSString *string = [matrix componentsJoinedByString:@"\n"];
        //NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
        NSString *desktopDirectory = [/*paths*/NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *appFile = [desktopDirectory stringByAppendingPathComponent:@"matrixA.csv"];
        
        [string writeToFile:appFile atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
        
        //BOOL writtenToFile = [matrix writeToFile:appFile atomically:YES];
        //NSLog(@"writtenToFile: %d",writtenToFile);
        
        NSMutableArray *randomSelection = [[NSMutableArray alloc] init];
        [randomSelection addObject:@"string1"];
        NSString *test = [randomSelection objectAtIndex:0];
        NSLog(test);
        
    }
}
