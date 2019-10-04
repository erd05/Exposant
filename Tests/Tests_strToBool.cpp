#include "pch.h"
#include "CppUnitTest.h"

using namespace Microsoft::VisualStudio::CppUnitTestFramework;

extern "C" 
{
#include "../UtilitairesLib/utilitaires.h"
}

namespace Tests
{
	TEST_CLASS(Tests_strToBool)
	{	

	public:
		
		TEST_METHOD(Tester_strToBool)
		{
			bool b;

			Assert::IsTrue(strToBool("true", &b));
			Assert::AreEqual(true, b);

			Assert::IsTrue(strToBool("false", &b));
			Assert::AreEqual(false, b);

			Assert::IsTrue(strToBool("TRUE", &b));
			Assert::AreEqual(true, b);

			Assert::IsTrue(strToBool("FALSE", &b));
			Assert::AreEqual(false, b);

			Assert::IsTrue(strToBool("TrUe", &b));
			Assert::AreEqual(true, b);

			Assert::IsTrue(strToBool("fAlSe", &b));
			Assert::AreEqual(false, b);

			Assert::IsFalse(strToBool("da", &b));
			Assert::IsFalse(strToBool("niet", &b));
		}
	};
}
