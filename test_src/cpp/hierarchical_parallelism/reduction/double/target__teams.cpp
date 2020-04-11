#include <iostream>
#include <stdexcept>

#include <omp.h>


#include <cmath>
#include <limits>



bool almost_equal(double x, double y, int ulp) {

     return std::fabs(x-y) <= std::numeric_limits<double>::epsilon() * std::fabs(x+y) * ulp ||  std::fabs(x-y) < std::numeric_limits<double>::min();

}



void test_target__teams(){

 // Input and Outputs
 

double counter{};

// Main program

#pragma omp target   map(tofrom:counter) 

{


#pragma omp teams  reduction(  +  :counter)  

{

const int num_teams = omp_get_num_teams();




counter += double { 1.0f/num_teams } ;



}

}


// Validation
if ( !almost_equal(counter,double { 1 }, 10)  ) {
    std::cerr << "Expected: " << 1 << " Get: " << counter << std::endl;
    throw std::runtime_error( "target__teams give incorect value when offloaded");
}

}
int main()
{
    test_target__teams();
}
