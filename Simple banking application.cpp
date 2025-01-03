#include <iostream>
#include <string>
using namespace std;
class BankAccount {
private:
    string accNum;
    double balance;
public:
    BankAccount(string accNumber, double initialBalance) {
        accNum = accNumber;
        balance = initialBalance;
    }
    void deposit(double amount) {
        if (amount > 0){
            balance += amount;
            cout << "Deposit Done"<< endl;
        }else
            cout << "Invalid deposit amount." << endl;
    }
    void withdraw(double amount) {
        if (amount > 0 && amount <= balance) {
            balance -= amount;
            cout << "Withdrew Done"<< endl;
        } else {
            cout << "insufficient balance" << endl;
        }
    }
    void displayBalance() {
        cout << "You have "<<balance<<" dollars"<< endl;
    }
    void displayAccNum() {
        cout << "Your account number is : "<<accNum<<endl;
    }
};
int main() {
    BankAccount myAccount("123456789", 500.0);
    myAccount.displayBalance();
    myAccount.deposit(200.0);
    myAccount.withdraw(150.0);
    myAccount.withdraw(600.0);
    myAccount.displayBalance();
    myAccount.displayAccNum();
    return 0;
}
