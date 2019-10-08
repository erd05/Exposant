#include "utilitaires.h"
#include <string.h>
#include <stdlib.h>

int add(int a, int b)
{
	return a + b;
}

bool strToBool(const char* str, bool* bool__out)
{
	if (_stricmp(str, "true") == 0)
		* bool__out = true;
	else if (_stricmp(str, "false") == 0)
		* bool__out = false;
	else
		return false;
	return true;
}

bool strToInt(const char* str, int* int_out)
{
	if (_stricmp(str, "+0") == 0 || _stricmp(str, "0") == 0 || _stricmp(str, "-0") == 0) {
		* int_out = 0;
		return true;
	}
	*int_out = (int)strtol(str, (char**)NULL, 10);
	if (*int_out == 0) {
		return false;
	}
	else
		return true;

}

bool strToFloat(const char* str, float* float_out)
{
	if (_stricmp(str, "+0") == 0 || _stricmp(str, "0") == 0 || _stricmp(str, "-0") == 0 || _stricmp(str, "0.0") == 0 ||
		_stricmp(str, "-0.0") == 0 || _stricmp(str, "+0.0") == 0) {
		*float_out = 0.0;
		return true;
	}
	*float_out = (float)strtod(str, (char**)NULL);
	if (*float_out == 0.0) {
		return false;
	}
	else
		return true;
}


void unsignedToBinStr(unsigned u, char buffer[], int nbits)
{
	int i;
	unsigned int mask = 1 << (nbits - 1);
	buffer[nbits] = '\0';
	for (i = 0; i < nbits; i++, mask >>= 1)
	{
		buffer[i] = ((u & mask) != 0) + '0';
	}
}

