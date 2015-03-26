//
//  ViewController.h
//  iPad App
//
//  Created by Beth Tyler on 02/02/2015.
//  Copyright (c) 2015 Beth Tyler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>

#import "CorePlot-CocoaTouch.h"

//Define DSYEV function which calculates eigenvalues
extern int dsyev (char *jobz, char *uplo, int *n, double *A, int *lda, double *w, double *work, int *lwork, int *info);

int n=2; //Number of rows and columns(same for a square matrix)
int lwork; //Length of workspace array
double *work; //Workspace array
int i,j;
int info; //"Exit information"
double lambda;

@interface ViewController : UIViewController
<CPTPlotDataSource>

{

    IBOutlet UITextField *myTextField;
    IBOutlet UITextView *output;
    IBOutlet UILabel *Aequals;
    IBOutlet UIView *line;
    
}

//Go button
- (IBAction)Go:(id)sender;

@property(nonatomic, strong) NSMutableArray *lambdaValues;
@property(nonatomic, strong) NSMutableArray *eigenvalues1;
@property(nonatomic, strong) NSMutableArray *eigenvalues2;

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index;

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plotnumberOfRecords;

@end



