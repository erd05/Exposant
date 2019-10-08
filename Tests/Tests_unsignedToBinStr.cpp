#include "pch.h"
#include "CppUnitTest.h"
#include <string.h>

using namespace Microsoft::VisualStudio::CppUnitTestFramework;

extern "C" 
{
#include "../UtilitairesLib/utilitaires.h"
}

namespace Tests
{
	TEST_CLASS(Tests_unsignedToBinStr)
	{	

		char buffer[50];
		
		int nbBadCharsInBuffer(int startIndex = 0) {
			int nb = 0;
			for (int i = startIndex; i < 50; i++)
			{
				if (buffer[i] != '\0') nb++;
			}
			return nb;
		}

	public:
		
		TEST_METHOD(Tester_unsignedToBinStr)
		{
			memset(buffer, 0, 50);
			unsignedToBinStr(5, buffer, 4);			
			Assert::AreEqual("0101", buffer);
			Assert::AreEqual(0, nbBadCharsInBuffer(4));
			unsignedToBinStr(5, buffer, 6);
			Assert::AreEqual("000101", buffer);
			unsignedToBinStr(5, buffer, 2);
			Assert::AreEqual("01", buffer);
			unsignedToBinStr(5, buffer, 0);
			Assert::AreEqual("", buffer);
			unsignedToBinStr(0, buffer, 10);
			Assert::AreEqual("0000000000", buffer);
			unsignedToBinStr(255 << 8, buffer, 24);
			Assert::AreEqual("000000001111111100000000", buffer);
			Assert::AreEqual(0, nbBadCharsInBuffer(24));
		}
	};
}
