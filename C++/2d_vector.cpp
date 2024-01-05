#include <iostream>
#include <vector>

int main() {
    // Create a 2D vector
    std::vector<std::vector<int>> my2DVector;

    // Add rows to the 2D vector using push_back
    my2DVector.push_back({1, 2, 3});
    my2DVector.push_back({4, 5, 6});
    my2DVector.push_back({7, 8, 9});
    my2DVector[0][0]=99;
    // Access and print elements of the 2D vector
    for (const auto& row : my2DVector) {
        for (int value : row) {
            std::cout << value << " ";
        }
        std::cout << std::endl;
    }
       my2DVector.pop_back();
     
    
     for (const auto& row : my2DVector) {
        for (int value : row) {
            std::cout << value << " ";
        }
        std::cout << std::endl;
    }
    return 0;
}

