//
//  AppController.h
//  Mac App
//
//  Created by Beth Tyler on 22/02/2015.
//  Copyright (c) 2015 Beth Tyler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#import "CorePlot/CorePlot.h"

//Define DSYEV function which calculates eigenvalues
extern int dsyev (char *jobz, char *uplo, int *n, double *A, int *lda, double *w, double *work, int *lwork, int *info);

int n=2; //Number of rows and columns(same for a square matrix)
int lwork; //Length of workspace array
double *work; //Workspace array
int i,j;
int info; //"Exit information"
double lambda;

@interface AppController : NSObject
<CPTPlotDataSource>

{
    IBOutlet NSTextField *myTextField;
    IBOutlet NSTextField *Aequals;
    IBOutlet NSColorWell *line;
    IBOutlet NSView *plotView;
}

- (IBAction)Go:(id)sender;

@property(nonatomic, strong) NSMutableArray *lambdaValues;
@property(nonatomic, strong) NSMutableArray *eigenvalues1;
@property(nonatomic, strong) NSMutableArray *eigenvalues2;

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plotnumberOfRecords;

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index;


@end
