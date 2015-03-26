//
//  ViewController.h
//  SquidRingGraph
//
//  Created by Beth Tyler on 19/03/2015.
//  Copyright (c) 2015 Beth Tyler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
#import "CorePlot-CocoaTouch.h"

#define P 4
#define LDA P
#define LDVL P
#define LDVR P

typedef __CLPK_doublecomplex complexNumber;

//Define CHEEV function which calculates eigenvalues
extern int zheev(char *jobz, char *uplo, int *number_of_rows, complexNumber *value, int *lda, double *w, complexNumber *work, int *lwork, double *rwork, int *info);

extern int zgeev(char *jobvl, char *jobvr, int *number_of_rows, complexNumber *value, int *lda, double *w, complexNumber *vl, int *ldvl, complexNumber *vr, int *ldvr, complexNumber *work, int *lwork, double *rwork, int *info);

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
<CPTPlotDataSource>

@property(nonatomic, strong) NSMutableArray *squidHamiltonianMatrix;
@property(nonatomic, strong) NSMutableArray *phi_xValues;
@property(nonatomic, strong) NSMutableArray *eigenvalues1;
@property(nonatomic, strong) NSMutableArray *eigenvalues2;
@property(nonatomic, strong) NSMutableArray *eigenvalues3;
@property(nonatomic, strong) NSMutableArray *eigenvalues4;

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index;

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plotnumberOfRecords;

@end

