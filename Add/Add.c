#include <stdio.h>
#include "../UtilitairesLib/utilitaires.h"

int main()
{
	int a = 20;
	int b = 30;
	int somme = add(a, b);
	printf("%i + %i = %i", a, b, somme);
	return 0;
}