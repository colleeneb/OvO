
#include <cmath>


#include <limits>
#include <iostream>
#include <stdexcept>

using namespace std;

bool almost_equal(bool x, bool y, int ulp) {

    return x == y ; 

}

void test_isnan(){
   
   double x {  0.42 };
   

   bool o_host = isnan( x);

   bool o_gpu ; 
   #pragma omp target map(from:o_gpu)
   {
   o_gpu = isnan( x);
   }

   if ( !almost_equal(o_host,o_gpu,1) ) {
        std::cerr << "Host: " << o_host << " GPU: " << o_gpu << std::endl;
        throw std::runtime_error( "isnan give incorect value when offloaded");
    }
}

int main()
{
    test_isnan();
}