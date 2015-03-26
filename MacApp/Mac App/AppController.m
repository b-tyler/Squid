//
//  AppController.m
//  Mac App
//
//  Created by Beth Tyler on 22/02/2015.
//  Copyright (c) 2015 Beth Tyler. All rights reserved.
//

#import "AppController.h"

@interface AppController ()

@end

@implementation AppController

@synthesize lambdaValues;
@synthesize eigenvalues1;
@synthesize eigenvalues2;

/*
//Ensure that only characters '0-9' and '.' can be entered
- (BOOL)textField: (NSTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString: (NSString *)string
{
    if ([string length] == 0 && range.length > 0)
    {
        myTextField = [myTextField stringByReplacingCharactersInRange:range withString:string];
        return NO;
    }
    
    NSCharacterSet *nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    if ([string stringByTrimmingCharactersInSet:nonNumberSet].length > 0)return YES;
    
    return NO;
    
}
*/

-(void)initPlot
{
    
    
    //Define and set size of graph frame
    CGRect frame = [plotView frame];
    
    frame.size.height = 700;
    frame.size.width = 1097;
    CPTGraphHostingView *chartView = [[CPTGraphHostingView alloc] initWithFrame: frame];
    [plotView addSubview:chartView];
    
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    CPTXYGraph *graph = (CPTXYGraph *)[theme newGraph];
    chartView.hostedGraph = graph;
    
    NSString *title = @"Plot of Eigenvalues against Lambda";
    graph.title = title;
    
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor blackColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0f;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, 25.0f);
    
    graph.paddingLeft = 25.0;
    graph.paddingTop = 30.0;
    graph.paddingRight = 25.0;
    graph.paddingBottom = 25.0;
    graph.plotAreaFrame.paddingLeft = 55.0f;
    graph.plotAreaFrame.paddingRight = 30.f;
    graph.plotAreaFrame.paddingTop = 30.f;
    graph.plotAreaFrame.paddingBottom = 30.f;
    
    //Allocate the plot space on the graph
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    
    //Define the two different plots
    CPTScatterPlot *plot1 = [[CPTScatterPlot alloc] init];
    plot1.dataSource = self;
    plot1.identifier = @"plot1";
    [graph addPlot:plot1 toPlotSpace:plotSpace];
    CPTScatterPlot *plot2 = [[CPTScatterPlot alloc] init];
    plot2.dataSource = self;
    plot2.identifier = @"plot2";
    [graph addPlot:plot2 toPlotSpace:plotSpace];
    CPTColor *plotColor = [CPTColor blackColor];
    
    //Define the ranges of the x and y axis
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(1.1)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-100) length:CPTDecimalFromFloat(200)];
    
    CPTMutableLineStyle *plot1LineStyle = [plot1.dataLineStyle mutableCopy];
    CPTMutableLineStyle *plot2LineStyle = [plot2.dataLineStyle mutableCopy];
    plot1LineStyle.lineWidth = 2.5;
    plot1LineStyle.lineColor = plotColor;
    plot2LineStyle.lineWidth = 2.5;
    plot2LineStyle.lineColor = plotColor;
    plot1.dataLineStyle = plot1LineStyle;
    plot2.dataLineStyle = plot2LineStyle;
    //CPTPlotSymbol *plot1Symbol = [CPTPlotSymbol starPlotSymbol];
    //CPTPlotSymbol *plot2Symbol = [CPTPlotSymbol starPlotSymbol];
    //plot1Symbol.fill = [CPTFill fillWithColor:plotColor];
    //plot1Symbol.lineStyle = plot1LineStyle;
    //plot1Symbol.size = CGSizeMake(6.0f, 6.0f);
    //plot2Symbol.fill = [CPTFill fillWithColor:plotColor];
    //plot2Symbol.lineStyle = plot2LineStyle;
    //plot2Symbol.size = CGSizeMake(6.0f, 6.0f);
    //plot1.plotSymbol = plot1Symbol;
    //plot2.plotSymbol = plot2Symbol;
    
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor blackColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize =12.0f;
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 2.0f;
    axisLineStyle.lineColor = [CPTColor blackColor];
    CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
    axisTextStyle.color = [CPTColor blackColor];
    axisTextStyle.fontName = @"Helvetica-Bold";
    axisTextStyle.fontSize = 11.0f;
    CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor blackColor];
    tickLineStyle.lineWidth = 2.0f;
    CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
    gridLineStyle.lineColor = [CPTColor blackColor];
    gridLineStyle.lineWidth = 1.0f;
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    
    CPTAxis *x = axisSet.xAxis;
    x.title = @"Lambda";
    x.titleTextStyle = axisTitleStyle;
    x.titleOffset = 20.0f;
    x.axisLineStyle = axisLineStyle;
    x.labelTextStyle = axisTextStyle;
    x.majorTickLineStyle = axisLineStyle;
    x.majorTickLength = 4.0f;
    x.minorTickLength = 2.0f;
    x.tickDirection = CPTSignNegative;
    
    x.majorIntervalLength = CPTDecimalFromFloat(0.1);
    x.minorTicksPerInterval = 4;
    
    CPTAxis *y = axisSet.yAxis;
    y.title = @"Eigenvalues";
    y.titleTextStyle = axisTitleStyle;
    y.titleOffset = 35.0f;
    y.axisLineStyle = axisLineStyle;
    y.labelTextStyle = axisTextStyle;
    y.majorTickLineStyle = axisLineStyle;
    y.majorTickLength = 4.0f;
    y.minorTickLength = 2.0f;
    y.tickDirection = CPTSignNegative;
    
    y.majorIntervalLength = CPTDecimalFromFloat(10);
    y.minorTicksPerInterval = 4;
}

-(void)calculateEigenvalues
{
    NSNumber *myNumber = [NSNumber numberWithDouble:[myTextField doubleValue]];
    double A = [myNumber doubleValue];
    
    lambda = 0;
    
    lambdaValues = [[NSMutableArray alloc] init];
    double numberOfObjectsInLambdaArray;
    
    eigenvalues1 = [[NSMutableArray alloc] init];
    double numberOfObjectsInEigenvalues1Array;
    
    eigenvalues2 = [[NSMutableArray alloc] init];
    double numberOfObjectsInEigenvalues2Array;
    
    while (lambda<1.01)
    {
        double X[4] = {A*2.0, A*4.0*lambda, A*4.0*lambda, A*2.0};
        lwork = 3*n-1;
        work  = (double *) calloc (lwork, sizeof(double)); //Set size of workspace
        double w[n]; //Eigenvalues
        dsyev("N", "U", &n, X, &n, w, work, &lwork, &info);
        free(work);
        
        //Convert the double values of lambda into a string
        NSString *lambdaValuesString = [NSString stringWithFormat:@"%f", lambda];
        //Join the strings of lambda values into one array
        numberOfObjectsInLambdaArray = [lambdaValues count];
        [lambdaValues insertObject:lambdaValuesString atIndex:numberOfObjectsInLambdaArray];
        
        //Convert the eigenvalues into strings
        NSString *eigenvalues1String = [NSString stringWithFormat:@"%f", w[0]];
        NSString *eigenvalues1String2 = [NSString stringWithFormat:@"%f", w[1]];
        //Join the strings of eigenvalues to form 2 arrays (each array representing one of the two eigenvalues for each value of lambda)
        numberOfObjectsInEigenvalues1Array = [eigenvalues1 count];
        [eigenvalues1 insertObject:eigenvalues1String atIndex:numberOfObjectsInEigenvalues1Array];
        numberOfObjectsInEigenvalues2Array = [eigenvalues2 count];
        [eigenvalues2 insertObject:eigenvalues1String2 atIndex:numberOfObjectsInEigenvalues2Array ];
        
        lambda = lambda + 0.01;
        
        //If the value of lambda is less than 1.01 return to the top of the loop to repeat
        if (lambda<1.01)
            continue;
    }
}

//Action of go button
- (IBAction)Go:(id)sender
{
    [self initPlot];
    [self calculateEigenvalues];
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plotnumberOfRecords
{
    //Count the number of values in the lambdaValues array and plot this number of points
    return [lambdaValues count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSNumber *num = nil;
    
    switch (fieldEnum)
    {
        case CPTScatterPlotFieldX:
            num = [lambdaValues objectAtIndex:index];
            break;
            
        case CPTScatterPlotFieldY:
            if ([(NSString *)plot.identifier isEqualToString:@"plot1"])
            {
                num = [eigenvalues1 objectAtIndex:index];
            }
            
            if ([(NSString *)plot.identifier isEqualToString:@"plot2"])
            {
                num = [eigenvalues2 objectAtIndex:index];
            }
            
            break;
    }
    return num;
}

@end
