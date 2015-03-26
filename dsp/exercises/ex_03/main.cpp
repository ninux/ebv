#include <stdio.h>

class test
{
	public:
		test(int a, int b): a(a), b(b) {}
		~test(){}

	void foo()
	{
	}

	void foo2();

	int a;
	int b;

	int c;
};

void test::foo2()
{
}

main(const int argc, const char *argv[])
{
	test t(1,2);

	printf("Hello C++ world!\n");
	printf("class members are: a = %d, b = %d\n", t.a, t.b);

	return(0);
}
