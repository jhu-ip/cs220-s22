#include <iostream>
#include <sstream>
#include <string>
#include <cassert>

int main() {
std::string s = "foo bar 123", tok1, tok2;
int n;
std::stringstream in(s);
in >> tok1 >> tok2 >> n;
assert(tok1 == "foo");
assert(tok2 == "bar");
assert(n == 123);

std::stringstream out;
out << "Hello, n=" << n;
std::string s2 = out.str();
assert(s2 == "Hello, n=123");

std::cout << "Good\n";
return 0;
}
