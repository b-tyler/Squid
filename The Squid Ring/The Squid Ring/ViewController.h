//
//  ViewController.h
//  The Squid Ring
//
//  Created by Beth Tyler on 23/02/2015.
//  Copyright (c) 2015 Beth Tyler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
#include <complex.h>

#define P 4
#define LDA P

typedef __CLPK_doublecomplex complexNumber;

//Define CHEEV function which calculates eigenvalues
extern int zheev(char *jobz, char *uplo, int *number_of_rows, complexNumber *value, int *lda, double *w, complexNumber *work, int *lwork, double *rwork, int *info);

//Variables
int N,M,n;
int j;
double hbarw_s = 0.043;
double hbarv = 0.07;
double lowerphi_x, upperphi_x;
double upperphi_0;
int kronecker_delta;
float A_s, A_c, A_simag, A_cimag, A_csum, A_ssum, squidHamiltonianReal, squidHamiltonianImag;

double z, f;
double remain;

double numberOfObjectsInSquidHamiltonianMatrix;

int Nfactorial;
int Mfactorial;
int Nminusnfactorial;
int Mminusnfactorial;
int nfactorial;

int number_of_rows;
int lda;
int lwork; //Length of workspace array
complexNumber *work;
int info; //"Exit information"

complexNumber A[P*LDA];

@interface ViewController : UIViewController

@property(nonatomic, strong) NSMutableArray *squidHamiltonianMatrix;

@end

