// Online C++ compiler to run C++ program online
#include <iostream>
#include <math.h>
using namespace std;

double f(double x , double n){   
    if (n==1){
       return sqrt(1+x);
    }
    return sqrt(n+f(x,n-1));
}   
    int main(){
        double x=0;
        double n=0;   
        cin >> x >> n; 
        double num=f(x,n);   
        printf("%.2f\n", num);
    }
