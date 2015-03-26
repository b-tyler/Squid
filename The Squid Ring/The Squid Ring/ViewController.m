//
//  ViewController.m
//  The Squid Ring
//
//  Created by Beth Tyler on 23/02/2015.
//  Copyright (c) 2015 Beth Tyler. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize squidHamiltonianMatrix;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self calculateValuesOfSquidRingMatrix];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)calculateValuesOfSquidRingMatrix
{
    squidHamiltonianMatrix = [[NSMutableArray alloc] init];
    
    for (upperphi_x=0; upperphi_x<1.01; upperphi_x=upperphi_x+0.01)
    {
        NSLog(@"upperphi_x = %f", upperphi_x);
        
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
            NSLog(@"value[%i] real = %f", j/2, A[j/2].r);
            NSLog(@"value[%i] imag = %f", j/2, A[j/2].i);
        }

        double w[P];
        double rwork[3*P-2];
        number_of_rows = P;
        lda = LDA;
        
        lwork = 3*P-1;
        work = (complexNumber *) malloc (lwork * sizeof(complexNumber)); //Set size of workspace
        zheev_("N", "U", &number_of_rows, A, &lda, w, work, &lwork, rwork, &info);
        free((void *)work);
        
        //Display eigenvalues
        if (info!=0)
        NSLog(@"Error number %d!\n", info);
        else
        {
            NSLog(@"Eigenvalues:\n");
            for (j=0; j<P; j++)
            {
                NSLog(@"%f ", w[j]);
            }
        NSLog(@"\n");
        }
    }
    
}

@end
