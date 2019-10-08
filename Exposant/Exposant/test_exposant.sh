#!/bin/bash ./runTests.sh
# shellcheck disable=SC1091

# Inclusions
source check.sh

# Constantes
exp="${EXP:-./Exposant.exe}"

#
# Série 1: Nombre d'arguments et usage
#

E01() { echo "*Un ou deux arguments attendus, pas $1*USAGE: * <float> \[<modif>\]" ;}

check_nbargs()
{
	check "$exp$1" --erreur "*Un ou deux arguments attendus, pas $2*" --nesting 1
	check "$exp$1" --erreur "**USAGE: * <float> \[<modif>\]" --nesting 1
}

test_e01a_0_arg_et_usage()
{ check_nbargs "" 0; }

test_e01b_3_args_et_usage()
{ check_nbargs ",1,2,3" 3; }

test_e01c_4_args_et_usage()
{ check_nbargs ",1,2,3,4,5" 5; }


#
# Série 2: argument 1 invalide
#

E02(){ echo "=L'argument 1 n'est pas un nombre flottant valide: $1" ;}

test_e02a_erreur_arg1_invalide()
{ check "$exp,r10" --erreur "$(E02 r10)"; }

RINVALIDE=x$((RANDOM + 100000))

test_e02b_erreur_arg2_invalide_random()
{ check "$exp,$RINVALIDE" --erreur "$(E02 $RINVALIDE)"; }


#
# Série 3: Afficher flottant
#

S03() { echo "**flottant: $1*" ;}

test_e03a_afficher_zero()
{ check "$exp,0" "$(S03 0)"; }

test_e03b_afficher_cent()
{ check "$exp,100" "$(S03 100)"; }

test_e03c_afficher_typique()
{ check "$exp,0.15625" "$(S03 0.15625)"; }

test_e03d_afficher_petit_vers_scientifique()
{ check "$exp,0.000000123" "$(S03 1.23e-07)"; }

test_e03e_afficher_scientifique_vers_scientifique()
{ check "$exp,123e-09" "$(S03 1.23e-07)"; }

test_e03f_afficher_nan()
{ check "$exp,nan" "$(S03 nan)"; }

#
# Série 4: réinterprétation (hex)
#

S04(){ echo "**hex: $1 ($2)*"; }

test_e04a_hex_zero()
{ check "$exp,0" "$(S04 00000000 0)"; }

test_e04b_hex_typique()
{ check "$exp,0.15625" "$(S04 3E200000 1042284544)"; }

if [[ -z $NONAN ]]; then
	test_e04c_hex_nan()
	{ check "$exp,nan" "$(S04 7FFFFFFF 2147483647)"; }
fi

#
# Série 5: réinterprétation (bin)
#

S05(){ echo "**bin: $1*"; }

test_e05a_bin_zero()
{ check "$exp,0" "$(S05 00000000000000000000000000000000)"; }

test_e05b_bin_typique()
{ check "$exp,0.15625" "$(S05 00111110001000000000000000000000)"; }

if [[ -z $NONAN ]]; then
	test_e05c_bin_nan()
	{ check "$exp,nan" "$(S05 01111111111111111111111111111111)"; }
fi


#
# Série 6: mantisse
#

S06(){ echo "**mantisse: $1*"; }

test_e06a_mantisse_zero()
{ check "$exp,0" "$(S06 00000000000000000000000)"; }

test_e06b_mantisse_typique()
{ check "$exp,0.15625" "$(S06 01000000000000000000000)"; }

if [[ -z $NONAN ]]; then
	test_e06c_mantisse_nan()
	{ check "$exp,nan" "$(S06 11111111111111111111111)"; }
fi


#
# Série 7: exposant
#

S07(){ echo "**exposant brut: $1*exposant reel: $2 - 127 = $3*"; }

test_e07a_exposant_zero()
{ check "$exp,0" "$(S07 00000000 0 -127)"; }

test_e07b_exposant_typique()
{ check "$exp,0.15625" "$(S07 01111100 124 -3)"; }

test_e07c_exposant_positif()
{ check "$exp,11.1" "$(S07 10000010 130 3)"; }


#
# Série 8: signe
#

S08(){ echo "**signe: $1*"; }
POS=positif
NEG=negatif

test_e08a_signe_zero()
{ check "$exp,0" "$(S08 $POS)"; }

test_e08b_signe_typique()
{ check "$exp,0.15625" "$(S08 $POS)"; }

test_e08c_signe_negtypique()
{ check "$exp,-0.15625" "$(S08 $NEG)"; }

test_e08d_signe_nan()
{ check "$exp,nan" "$(S08 $POS)"; }

test_e08e_signe_neginf()
{ check "$exp,-inf" "$(S08 $NEG)"; }

test_e08f_signe_negzero()
{ check "$exp,-0" "$(S08 $NEG)"; }

test_e08g_signe_pluszero()
{ check "$exp,+0" "$(S08 $POS)"; }


#
# Série 9: ordre des rubriques
#

test_e09a_ordre_des_rubriques()
{ check "$exp,0" "**flottant*hex*bin*mantisse*brut*reel*signe*"; }


#
# Série 10: changement de signe
#

S10(){ echo "**demande: signe $1*resultat: $2*"; }

test_e10a_positif_vers_negatif()
{ check "$exp,12.12,neg" "$(S10 negatif -12.12)"; }

test_e10b_negatif_vers_negatif()
{ check "$exp,-12.12,neg" "$(S10 negatif -12.12)"; }

test_e10c_negatif_vers_positif()
{ check "$exp,-12.12,pos" "$(S10 positif 12.12)"; }

test_e10d_positif_vers_positif()
{ check "$exp,12.12,pos" "$(S10 positif 12.12)"; }

test_e10e_trois_premieres_lettres_seulement()
{ 
	for neg in neg negatif negative negociation negamachin; do
		check "$exp,1,$neg" "$(S10 negatif -1)"; 
	done

	for pos in pos positif positive position possession; do
		check "$exp,-1,$pos" "$(S10 positif 1)"; 
	done
}

check_signe()
{
	check --nesting 1 "$exp,$1,neg" "$(S10 negatif -"$1")"
	check --nesting 1 "$exp,-$1,neg" "$(S10 negatif -"$1")"
	check --nesting 1 "$exp,-$1,pos" "$(S10 positif "$1")"
	check --nesting 1 "$exp,$1,pos" "$(S10 positif "$1")"
}

test_e10f_special_zero()
{ check_signe 0; }

test_e10g_special_infini()
{ check_signe inf; }

test_e10h_special_nan()
{ check_signe nan; }


#
# Série 11: changement d'exposant
#

check_exposant()
{
	check --nesting 1 "$exp,$1,$2" \
		"** demande: exposant $2*" \
		"** valeur: $3 ($4)*" \
		"** nbits: 8*" \
		"** offset: 23*" \
		"** masque: $5*" \
		"** masquer-float: $6*" \
		"** shifter-valeur: $7*" \
		"** insertion: $8*" \
		"** resultat: $9*" \
		"**"
}

test_e11a_exposants_typiques()
{ 
	check_exposant 0.15625 3 \
		10000010 130 \
		01111111100000000000000000000000 \
		00000000001000000000000000000000 \
		01000001000000000000000000000000 \
		01000001001000000000000000000000 \
		10
		
	check_exposant 0.15625 0 \
		01111111 127 \
		01111111100000000000000000000000 \
		00000000001000000000000000000000 \
		00111111100000000000000000000000 \
		00111111101000000000000000000000 \
		1.25
		
	check_exposant 0.15625 -3 \
		01111100 124 \
		01111111100000000000000000000000 \
		00000000001000000000000000000000 \
		00111110000000000000000000000000 \
		00111110001000000000000000000000 \
		0.15625
				
	check_exposant 7.7 9 \
		10001000 136                      \
		01111111100000000000000000000000  \
		00000000011101100110011001100110  \
		01000100000000000000000000000000  \
		01000100011101100110011001100110  \
		985.6	
}

test_e11b_exposants_atypiques()
{ 
	if [[ -z $NONAN ]]; then
		check_exposant nan -2 \
			01111101 125                     \
			01111111100000000000000000000000 \
			00000000011111111111111111111111 \
			00111110100000000000000000000000 \
			00111110111111111111111111111111 \
			0.5
	fi
		   
	check_exposant -inf 5 \
		10000100 132                     \
		01111111100000000000000000000000 \
		10000000000000000000000000000000 \
		01000010000000000000000000000000 \
		11000010000000000000000000000000 \
		-32		
}

test_e11d_erreur_exposant_invalide()
{ 
	for expo in -127 128 444 -999; do
		check "$exp,12,$expo" --erreur "=Exposant invalide $expo (doit etre compris entre -126 et +127)" 
	done
}



#
# Série 12: argument 2 invalide
#

test_e12a_arg2_invalide()
{ 
	for arg2 in x24 zzz; do
		check "$exp,12,$arg2" --erreur "=L'argument 2 n'est pas valide: $arg2" 
	done
}



#
# Présence de git
#

test_egit()
{ [[ -d ../.git ]] || fail "Aucun dossier git trouvé"; }
