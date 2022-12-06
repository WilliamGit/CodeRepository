// Online C++ compiler to run C++ program online
#include <iostream>
#include <algorithm>
using namespace std;
 int cmp (int x,int y){
        return x >y;
    }
int f(string s){
    int n=s.length();  //get the string length
    int num[n]={0};
    for (int i=0;i<n;i++){
        string s1=s.substr(0,i)+s.substr(i+1);  //merge two sub string
        num[i]=stoi(s1);  //covert the string to integer
        //cout << s1 << " ";
    }
    sort(num,num+n,cmp);  //sort the array
    if (num[0]<10){
        return num[0];
    }
    string s2=to_string(num[0]); //convert the integer to string
    cout<< s2<< " "<< endl;
    return f(s2);
}   
    int main(){
    // Write C++ code here
    string s;
    cin >> s;
    int num=f(s);
    cout << num;
    }
