#include "pch.h"
#include "CppUnitTest.h"

using namespace Microsoft::VisualStudio::CppUnitTestFramework;

extern "C" 
{
#include "../UtilitairesLib/utilitaires.h"
}

namespace Tests
{
	TEST_CLASS(Tests_strToInt)
	{	

	public:
		
		TEST_METHOD(Tester_strToInt)
		{
			int i;
			Assert::IsTrue(strToInt("1",&i));
			Assert::AreEqual(1, i);
			Assert::IsTrue(strToInt("999999", &i));
			Assert::AreEqual(999999, i);
			Assert::IsTrue(strToInt("-999999", &i));
			Assert::AreEqual(-999999, i);
			Assert::IsTrue(strToInt("+999999", &i));
			Assert::AreEqual(999999, i);
			Assert::IsTrue(strToInt("0", &i));
			Assert::AreEqual(0, i);
			Assert::IsTrue(strToInt("+0", &i));
			Assert::AreEqual(0, i);
			Assert::IsTrue(strToInt("-0", &i));
			Assert::AreEqual(0, i);
			Assert::IsFalse(strToInt("r99", &i));
			Assert::IsFalse(strToInt("", &i));
		}
	};
}
