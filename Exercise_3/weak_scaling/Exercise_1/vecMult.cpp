#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <omp.h>
#include <chrono>


/* Constants and Variables visible to all functions */
/** WEAK SCALING - the array size is not constant **/
//const int arraySize = 20000;  // vector size
const short int numOfLoops = 10;        // number of time to average results over

// 3 arrays ("vectors") of size "arraySize":
//int a[arraySize],b[arraySize],c[arraySize];


/* Functions */

/** 
 * Calculate vector multiplication - in parallel
 * This function uses the multiplication of random arrays a,b to define array c. 
*/

void calcVecMult(int &arraySize) {

	int a[arraySize],b[arraySize],c[arraySize];

	//Compiler directives to parallelize the following for loop. Will create 2 random arrays, a task that is divided between all threads and then joined
        #pragma omp parallel for
        for ( int i=0; i < arraySize;i++) {
                a[i] = rand() % arraySize;
                b[i] = rand() % arraySize;
		c[i] = 0;
        }

	//Compiler directives to parallelize the vector multiplication loop. Each thread will take a segment of the arrays and multiply that segment. Then, the master thread will combine all into the final array.
        #pragma omp parallel for
        for (int i=0; i<arraySize;i++) {
		for (int j=0; j<arraySize;j++) {
			c[i] = c[i] + a[i]*b[j];
		}
        }

}

/**
 * The main function calls the function calcVecMult which calculates vector multiplication. 
 * It monitors with a timer how long it takes to execute the function 
 * with "numOfLoops" tries. Then outputs the average processing time.
 */
int main(int argc, char *argv[])
{

	//WEAK SCALING - define the array size as not constant, but a variable defined during runtime:
	int arraySize;

	// A variable that holds the number of threads to use given by the user:
	int numOfThreads;
	// define the time variables to measure execusion times. time_span is the total time, dt is the time difference.
	std::chrono::duration<double, std::deci> time_span, dt;

	//check that the number of argumnets is 2, where the first corresponds to the program name, and the second is the input number of threads:
	if ( argc == 3 ){
		//set variable to the input by user:
		numOfThreads = std::stoi(argv[1]);
		arraySize = std::stoi(argv[2]);
	}else{
		//if wrong number of arguments is given, issue an error message and exit:
		std::cout << "Please provide the numeber of threads to use and the array size. Usage: ./multVec <num_of_threads> <array size>." << "\n";
		return 1;
	}

	//set the number of omp threads:
	omp_set_num_threads(numOfThreads);

	//perform "numOfLoops" trials of the calcVecMult() function: 
        for (int i=0; i<numOfLoops; i++) {
		//t1 - measure the current time before the calculation
                auto t1 = std::chrono::high_resolution_clock::now();
		//perform vector multiplication by the parallel function calcVecMult()
		calcVecMult(arraySize);
		//t2 - measure the current time after the calculation
		auto t2 = std::chrono::high_resolution_clock::now();
                if (i>0) {
			//calculate the execusion time dt:
			dt = t2 - t1;
			//calculate total elapsed time:
			time_span += dt;
			//print out results of the current iteration:
                        std::cout << "Loop " << i << " run time is: " << dt.count() << " seconds\n";
                }
        }

	//print out the total average run time of calcVecMult():
        std::cout << "Average run time for " << numOfThreads << " threads = " << time_span.count()/(numOfLoops-1) << " seconds.\n";
	//print the total elapsed time for calculating "numOfLoops" times:
        std::cout << "Total time = " << time_span.count() << " seconds.\n";

	return 0;

}
