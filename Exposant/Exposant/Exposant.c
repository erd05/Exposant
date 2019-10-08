#include <stdio.h>
#include "../../UtilitairesLib/utilitaires.h"

int main(int argc, char* argv[])
{
    // Valider le nombre d'arguments
	if (argc > 3 || argc < 2)
	{
		fprintf(stderr, "Un ou deux arguments attendus, pas %i.\n", argc - 1);
		fprintf(stderr, "USAGE: Exposant.exe <float> [<modif>]\n");
		return 1;
	}

	// Convertir le premier argument en un float
	char* strarg1 = argv[1];
	float arg1;
	if (! strToFloat(strarg1, &arg1))
	{
		fprintf(stderr, "L'argument 1 n'est pas un nombre flottant valide: %s\n", strarg1);
		return 1;
	}
	printf("flottant: %.5g\n", arg1);

	// Convertir le premier argument en unsigned int
	unsigned u1 = asUnsigned(arg1);
	printf("hex: %08X (%d)\n", u1, u1);
	int nbits = 32;
	char binStr[32 + 1];
	unsignedToBinStr(u1, binStr, nbits);
	printf("bin: %s\n", binStr);

	// Affiche les 23 caractères de la sous-chaine (de binStr) qui commence au neuvième caractère
	printf("mantisse: %.23s\n", &binStr[9]);

	printf("exposant brut: %.8s\n", &binStr[1]);
	unsigned exposant = (u1 << 1) >> 24;
	printf("exposant reel: %d - 127 = %d", exposant, exposant - 127);


	
	return 0;
}