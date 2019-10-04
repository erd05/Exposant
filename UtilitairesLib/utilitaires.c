#include "utilitaires.h"
#include <string.h>

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