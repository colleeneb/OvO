#include <iostream>
#include <cstdlib>
#ifdef _OPENMP
#include <omp.h>
#else
int omp_get_num_teams()   {return 1;}
int omp_get_num_threads() {return 1;}
#endif
bool almost_equal(float x, float gold, float tol) {
        return gold * (1-tol) <= x && x <= gold * (1 + tol);
}
void test_target__teams(){
 float counter{};
#pragma omp target map(tofrom: counter) 
#pragma omp teams
    {
const int num_teams = omp_get_num_teams();
#pragma omp atomic update
counter += float { 1.0f/num_teams } ;
    }
if ( !almost_equal(counter,float { 1 }, 0.1)  ) {
    std::cerr << "Expected: " << 1 << " Got: " << counter << std::endl;
    std::exit(112);
}
}
int main()
{
    test_target__teams();
}