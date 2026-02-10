#include <iostream>
using namespace std;
class MyClass {
    public:
        int count ;
        MyClass(int x) : count(x) {}
        MyClass(const MyClass &object);
        ~ MyClass(){cout << " My_Class has been cancled ";};
};
MyClass::MyClass(const MyClass &object){
    count = object.count;
}
int main() {
    MyClass a(8);
    MyClass b(a);
    cout << "So doi tuong da tao: " << a.count << endl;
    cout << "So doi tuong moi: " << b.count << endl;
    // cout << ""

    return 0;
}