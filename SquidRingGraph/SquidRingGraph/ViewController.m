//
//  ViewController.m
//  SquidRingGraph
//
//  Created by Beth Tyler on 19/03/2015.
//  Copyright (c) 2015 Beth Tyler. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize squidHamiltonianMatrix;
@synthesize phi_xValues;
@synthesize eigenvalues1;
@synthesize eigenvalues2;
@synthesize eigenvalues3;
@synthesize eigenvalues4;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initPlot];
    [self calculateSquidRingValues];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)calculateSquidRingValues
{
    squidHamiltonianMatrix = [[NSMutableArray alloc] init];
    
    phi_xValues = [[NSMutableArray alloc] init];
    double numberOfObjectsInPhixValuesArray;
    
    eigenvalues1 = [[NSMutableArray alloc] init];
    double numberOfObjectsInEigenvalues1Array;
    
    eigenvalues2 = [[NSMutableArray alloc] init];
    double numberOfObjectsInEigenvalues2Array;
    
    eigenvalues3 = [[NSMutableArray alloc] init];
    double numberOfObjectsInEigenvalues3Array;
    
    eigenvalues4 = [[NSMutableArray alloc] init];
    double numberOfObjectsInEigenvalues4Array;
    
    while (upperphi_x<1.01)
    {
        numberOfObjectsInSquidHamiltonianMatrix = 0;
        
        for (N=0; N<P; N++)
        {
            for (M=0; M<P; M++)
            {
                z = 0;
                A_c = 0;
                A_s = 0;
                A_csum = 0;
                A_ssum = 0;
                
                for (n = 0; n<(MIN(N, M)+1); n++)
                {
                    nfactorial = 1;
                    if (n != 0)
                    {
                        for (j = n; j > 0; j--)
                        {
                            nfactorial *= j;
                        }
                    }
                    
                    Nminusnfactorial = 1;
                    if (N != n)
                    {
                        for (j = N - n; j > 0; j--)
                        {
                            Nminusnfactorial *= j;
                        }
                    }
                    
                    Mminusnfactorial = 1;
                    if (M != n)
                    {
                        for (j = M - n; j > 0; j--)
                        {
                            Mminusnfactorial *= j;
                        }
                    }
                    
                    z = N + M - (2 * n);
                    
                    remain = fmod(N-M, 2);
                    if (remain == 0)
                    {
                        A_csum = A_csum + ((pow(f, z) * pow(-1, z/2) * (1 + pow(-1, z))) / (2 * nfactorial * Nminusnfactorial * Mminusnfactorial));
                    }
                    else
                    {
                        A_ssum = A_ssum + ((pow(f, z) * (1 - pow(-1, z))) / (2 * nfactorial * Nminusnfactorial * Mminusnfactorial));
                    }
                    
                }
                
                Nfactorial = 1;
                if (N !=0)
                {
                    for (j = N; j > 0; j--)
                    {
                        Nfactorial *= j;
                    }
                }
                
                Mfactorial = 1;
                if (M !=0)
                {
                    for (j = M; j > 0; j--)
                    {
                        Mfactorial *= j;
                    }
                }
                
                kronecker_delta = 0;
                if (N == M)
                {
                    kronecker_delta = 1;
                }
                
                upperphi_0 = 1.21879739;
                lowerphi_x = upperphi_x / upperphi_0;
                
                f = sqrt(hbarv);
                
                remain = fmod(N-M, 2);
                if (remain == 0)
                {
                    A_c = sqrt(Nfactorial * Mfactorial) * exp(-pow(f, 2) / 2) * A_csum;
                    squidHamiltonianReal = ((hbarw_s * (N + 0.5)) * kronecker_delta) - (hbarv * cos(2 * 3.14 * lowerphi_x) * A_c);
                    squidHamiltonianImag = 0;
                }
                else
                {
                    A_s = sqrt(Nfactorial * Mfactorial) * exp(-pow(f, 2) / 2) * A_ssum;
                    
                    squidHamiltonianReal = 0;
                    squidHamiltonianImag = ((hbarw_s * (N + 0.5)) * kronecker_delta) + (hbarv * sin(2 * 3.141592654 * lowerphi_x) * A_s);
                }
                
                NSString *squidHamiltonianRealMatrixValue = [NSString stringWithFormat:@"%f", squidHamiltonianReal];
                NSString *squidHamiltonianImagMatrixValue = [NSString stringWithFormat:@"%f", squidHamiltonianImag];
                
                [squidHamiltonianMatrix insertObject:squidHamiltonianRealMatrixValue atIndex:numberOfObjectsInSquidHamiltonianMatrix];
                numberOfObjectsInSquidHamiltonianMatrix++;
                
                [squidHamiltonianMatrix insertObject:squidHamiltonianImagMatrixValue atIndex:numberOfObjectsInSquidHamiltonianMatrix];
                numberOfObjectsInSquidHamiltonianMatrix++;
            }
        }
        
        for(j=0; j<2*P*LDA; j=j+2)
        {
            A[j/2].r = [[squidHamiltonianMatrix objectAtIndex:j]doubleValue];
            A[j/2].i = [[squidHamiltonianMatrix objectAtIndex:j+1]doubleValue];
        }
        
        int ldvl = LDVL, ldvr = LDVR;
        
        complexNumber w[P], vl[LDVL * P], vr[LDVR * P];
        //double rwork[3*P-2];
        double rwork[2*N];
        number_of_rows = P;
        lda = LDA;
        
        lwork = 3*P-1;
        work = (complexNumber *) malloc (lwork * sizeof(complexNumber)); //Set size of workspace
        zgeev_("N", "N", &number_of_rows, A, &lda, w, vl, &ldvl, vr, &ldvr, work, &lwork, rwork, &info);
        //zheev_("N", "U", &number_of_rows, A, &lda, w, work, &lwork, rwork, &info);
        free((void *)work);
        
        NSString *phixValuesString = [NSString stringWithFormat:@"%f", upperphi_x];
        numberOfObjectsInPhixValuesArray = [phi_xValues count];
        [phi_xValues insertObject:phixValuesString atIndex:numberOfObjectsInPhixValuesArray];
        
        NSString *eigenvalues1String = [NSString stringWithFormat:@"%f", w[0].r];
        numberOfObjectsInEigenvalues1Array = [eigenvalues1 count];
        [eigenvalues1 insertObject:eigenvalues1String atIndex:numberOfObjectsInEigenvalues1Array];
        
        NSString *eigenvalues2String = [NSString stringWithFormat:@"%f", w[1].r];
        numberOfObjectsInEigenvalues1Array = [eigenvalues2 count];
        [eigenvalues2 insertObject:eigenvalues2String atIndex:numberOfObjectsInEigenvalues2Array];
        
        NSString *eigenvalues3String = [NSString stringWithFormat:@"%f", w[2].r];
        numberOfObjectsInEigenvalues3Array = [eigenvalues3 count];
        [eigenvalues3 insertObject:eigenvalues3String atIndex:numberOfObjectsInEigenvalues3Array];
        
        NSString *eigenvalues4String = [NSString stringWithFormat:@"%f", w[3].r];
        numberOfObjectsInEigenvalues4Array = [eigenvalues4 count];
        [eigenvalues4 insertObject:eigenvalues4String atIndex:numberOfObjectsInEigenvalues4Array];
        
        upperphi_x = upperphi_x + 0.01;
        continue;
    }
}

-(void)initPlot
{
    //Define and set size of graph frame
    CGRect frame = [[self view] bounds];
    frame.size.height = 768;
    frame.size.width = 808;
    CPTGraphHostingView *chartView = [[CPTGraphHostingView alloc] initWithFrame: frame];
    [[self view] addSubview:chartView];
    
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    CPTXYGraph *graph = (CPTXYGraph *)[theme newGraph];
    chartView.hostedGraph = graph;
    
    NSString *title = @"Plot of Eigenvalues against Phi_x";
    graph.title = title;
    
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor blackColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0f;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, 25.0f);
    
    graph.paddingLeft = 50.0;
    graph.paddingTop = 50.0;
    graph.paddingRight = 50.0;
    graph.paddingBottom = 50.0;
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
    CPTScatterPlot *plot3 = [[CPTScatterPlot alloc] init];
    plot3.dataSource = self;
    plot3.identifier = @"plot3";
    [graph addPlot:plot3 toPlotSpace:plotSpace];
    CPTScatterPlot *plot4 = [[CPTScatterPlot alloc] init];
    plot4.dataSource = self;
    plot4.identifier = @"plot4";
    [graph addPlot:plot4 toPlotSpace:plotSpace];
    CPTColor *plotColor = [CPTColor blackColor];
    
    //Define the ranges of the x and y axis
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(1.1)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.25) length:CPTDecimalFromFloat(0.5)];
    
    CPTMutableLineStyle *plot1LineStyle = [plot1.dataLineStyle mutableCopy];
    CPTMutableLineStyle *plot2LineStyle = [plot2.dataLineStyle mutableCopy];
    CPTMutableLineStyle *plot3LineStyle = [plot3.dataLineStyle mutableCopy];
    CPTMutableLineStyle *plot4LineStyle = [plot4.dataLineStyle mutableCopy];
    plot1LineStyle.lineWidth = 2.5;
    plot1LineStyle.lineColor = plotColor;
    plot2LineStyle.lineWidth = 2.5;
    plot2LineStyle.lineColor = plotColor;
    plot3LineStyle.lineWidth = 2.5;
    plot3LineStyle.lineColor = plotColor;
    plot4LineStyle.lineWidth = 2.5;
    plot4LineStyle.lineColor = plotColor;
    plot1.dataLineStyle = plot1LineStyle;
    plot2.dataLineStyle = plot2LineStyle;
    plot3.dataLineStyle = plot2LineStyle;
    plot4.dataLineStyle = plot2LineStyle;
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
    x.title = @"Phi_x";
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

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plotnumberOfRecords
{
    return [phi_xValues count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSNumber *num = nil;
    
    switch (fieldEnum)
    {
        case CPTScatterPlotFieldX:
            num = [phi_xValues objectAtIndex:index];
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
            
            if ([(NSString *)plot.identifier isEqualToString:@"plot3"])
            {
                num = [eigenvalues3 objectAtIndex:index];
            }
            
            if ([(NSString *)plot.identifier isEqualToString:@"plot4"])
            {
                num = [eigenvalues4 objectAtIndex:index];
            }
            
            break;
    }
    return num;
}

@end
