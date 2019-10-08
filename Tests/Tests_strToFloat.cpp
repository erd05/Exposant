#include "pch.h"
#include "CppUnitTest.h"

using namespace Microsoft::VisualStudio::CppUnitTestFramework;

extern "C" 
{
#include "../UtilitairesLib/utilitaires.h"
}

namespace Tests
{
	TEST_CLASS(Tests_strToFloat)
	{	

	public:
		
		TEST_METHOD(Tester_strToFloat)
		{
			float fl;
			Assert::IsTrue(strToFloat("1",&fl));
			Assert::AreEqual(1.0F, fl);
			Assert::IsTrue(strToFloat("999", &fl));
			Assert::AreEqual(999.0F, fl);
			Assert::IsTrue(strToFloat("-999", &fl));
			Assert::AreEqual(-999.0F, fl);
			Assert::IsTrue(strToFloat("+999", &fl));
			Assert::AreEqual(999.0F, fl);
			Assert::IsTrue(strToFloat("0", &fl));
			Assert::AreEqual(0.0F, fl);
			Assert::IsTrue(strToFloat("+0", &fl));
			Assert::AreEqual(0.0F, fl);
			Assert::IsTrue(strToFloat("-0", &fl));
			Assert::AreEqual(0.0F, fl);
			Assert::IsTrue(strToFloat("0.0", &fl));
			Assert::AreEqual(0.0F, fl);
			Assert::IsTrue(strToFloat("+0.0", &fl));
			Assert::AreEqual(0.0F, fl);
			Assert::IsTrue(strToFloat("-0.0", &fl));
			Assert::AreEqual(0.0F, fl);
			Assert::IsTrue(strToFloat("999.125", &fl));
			Assert::AreEqual(999.125F, fl);
			Assert::IsFalse(strToFloat("r99", &fl));
			Assert::IsFalse(strToFloat("", &fl));
		}
	};
}
