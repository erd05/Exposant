#include <stdbool.h>

// --- MACROS ---

#define asUnsigned(var) (*(unsigned*)&var)
#define asFloat(var) (*(float*)&var)

// --- Prototypes de fonction ---

int add(int a, int b); // fonction bidon pour tester 

int calculerDouble(char signe, int exposant, double mantisse, double* calcul_out);
float composerFloatBrut(unsigned signeBrut, unsigned exposantBrut, unsigned mantisseBrute);
void decomposerFloatBrut(float f, unsigned* signeBrut_out, unsigned* exposantBrut_out, unsigned* mantisseBrute_out);
int composerFloat(char signe, int exposant, float mantisse, float* composition_out);
void decomposerFloat(float f, char* signe_out, int* exposant_out, float* mantisse_out);

bool strToBool(const char* str, bool* bool_p);
bool strToFloat(const char* str, float* float_p);
bool strToInt(const char* str, int* int_p);

/* 
	Pour convertir un entier non sign� en un affichage binaire.

	Arguments:
		u: L'entier � convertir
		buffer: tableau de caract�res devant recevoir la string, 
				de taille bitsize+1 ou plus (pour le caract�re final nul).
		bitsize: nombre de bits � afficher, � partir de ceux de poids faible

	
	Exemple:
		int bitsize = 4;
		char buffer[bitsize+1];
		unsigned u = 7;
		unsignedToBinStr(u, buffer, bitsize);
		
		// R�sultat:
		// buffer == "0111"
 */

void unsignedToBinStr(unsigned u, char buffer[], int nbits);
