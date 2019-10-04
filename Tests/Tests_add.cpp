#include "pch.h"
#include "CppUnitTest.h"

using namespace Microsoft::VisualStudio::CppUnitTestFramework;

extern "C" 
{
#include "../UtilitairesLib/utilitaires.h"
}

namespace Tests
{
	TEST_CLASS(Tests_add)
	{	

	public:
		
		TEST_METHOD(Tester_add)
		{
			Assert::AreEqual(0, add(0,0));
			Assert::AreEqual(4, add(2, 2));
			Assert::AreEqual(-4, add(4, -8));
			Assert::AreEqual(-4, add(-8, 4));
		}
	};
}
