#include <iostream>
#include <cstdlib>
#ifdef _OPENMP
#include <omp.h>
#else
int omp_get_num_teams()   {return 1;}
int omp_get_num_threads() {return 1;}
#endif
bool almost_equal(double x, double gold, float tol) {
        return gold * (1-tol) <= x && x <= gold * (1 + tol);
}
void test_target__teams__loop__parallel(){
 const int L = 262144;
 double counter{};
#pragma omp target   map(tofrom:counter) 
    {
#pragma omp teams  
    {
#pragma omp loop  
    for (int i = 0 ; i < L ; i++ )
    {
double partial_counter{};
#pragma omp parallel reduction(+: partial_counter)
    {
const int num_threads = omp_get_num_threads();
partial_counter += double { 1.0f/num_threads };
   } 
#pragma omp atomic update
counter += partial_counter;
   } 
   } 
   } 
if ( !almost_equal(counter,double { L }, 0.1)  ) {
    std::cerr << "Expected: " << L << " Got: " << counter << std::endl;
    std::exit(112);
}
}
int main()
{
    test_target__teams__loop__parallel();
}
