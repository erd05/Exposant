#!/bin/bash
# shellcheck disable=SC2124

ERROR_FILE=/tmp/erreur.txt

assertLike()
{
	# Vérifie que la valeur reçue est conforme au pattern.
	# Si le pattern débute par ~, il s agit d un regex.
	# S'il débute par *, il s'agit d'un glob.
	# S'il débute par = ou autre, il s'agit d'un patron verbatim
	# S'il débute par !, il s'agit d'un match négatif (!=, !*, !~, !)
	#
	# ARGUMENTS
	#	1 pattern attendu
	#	2 valeur reçue
	#	3 message d'erreur
	#	4 ajustement de la profondeur d'appel (0 par défaut)

	if [[ $1 == !* ]]; then
		if [[ $1 == !=* ]]; then
			assertNotEquals "${1:2}" "$2" "$3" $((${4:-0} + 1))
		elif [[ $1 == !~* ]]; then
			assertNotMatches "${1:2}" "$2" "$3" $((${4:-0} + 1))
		elif [[ $1 == !\** ]]; then
			assertNotGlobs "${1:2}" "$2" "$3" $((${4:-0} + 1))
		else
			assertNotEquals "${1:1}" "$2" "$3" $((${4:-0} + 1))
		fi
	else
		if [[ $1 == =* ]]; then
			assertEquals "${1:1}" "$2" "$3" $((${4:-0} + 1))
		elif [[ $1 == ~* ]]; then
			assertMatches "${1:1}" "$2" "$3" $((${4:-0} + 1))
		elif [[ $1 == \** ]]; then
			local glob="${1:1}"
			local given="$2"
			if [[ $glob == \** ]]; then
				# Supprimer tout ce qui vient avant le debut du pattern, 
				# pour ne pas encombrer les messages d'erreur
				local prefix_delimiter=${CHECK_PREFIX_DELIMITER:-':'}
				local debut
				debut="$(echo "${glob:1}" | tr "$prefix_delimiter" '\n' | head -1)$prefix_delimiter"
				if [[ $CHECK_PREFIX_DELIMITER != 0 && ${#debut} -gt 3 ]]; then
					given=${given/#*$debut/$debut}
					# given=$(cut -d"$prefix_delimiter" -f1-3 <<< "$given")
				fi
			fi
			assertGlobs "$glob" "$given" "$3" $((${4:-0} + 1))
		else
			assertEquals "$1" "$2" "$3" $((${4:-0} + 1))
		fi
	fi
}

check()
{
	# Lance une commande et vérifie que cette commande fournie
	# les sorties attendue: stdout, stderr, et exitcode.
	#
	# NB Du aux limitations de bash, la commande doit être fournie
	# 	 en séparant les constituantes par des virgules.
	#	 Elle sera convertie en array et exécutée ainsi.
	#
	# ARGUMENTS
	#	1 commande a tester
	#	2+ patrons de sortie attendue (on peut en mettre plusieurs)
	#
	# OPTIONS
	#	--erreur <erreur>: 
	#		patron d'erreur attendue (aucune erreur par défaut)
	#		NB cette option peut apparaitre plusieurs fois auquel cas tous les
	#		patrons seront validés. 
	#	--exitcode <exitcode>: 
	#		patron exit code attendu (exit code 0 par défaut sauf si erreur attendue alors !0 par défaut)
	#	--nesting <level> 
	#		ajustement de la profondeur d'appel (0 par défaut)
	#
	# GLOBALS
	#	CHECK_PREFIX_DELIMITER:	caractère qui délimite le préfixe 
	#		conservé pour traiter la sortie (par défaut ':')
	#

	local erreurs_attendues=()
	local exitcode_attendu=0
	local sorties_attendues=()
	local nesting=$((0))
	local commande=""

	# Parser les arguments
	while [[ -n $1 ]]; do
		case "$1" in
			--erreur)
				shift
				erreurs_attendues+=("$1")
				;;
			--exitcode)
				shift
				exitcode="$1"
				;;
			--nesting)
				shift
				nesting=$(($1))
				;;
			--*)
				echo "Option invalide: $1" >&2
				exit 2
				;;
			*)
				if [[ -z $commande ]]; then
					commande="$1"
				else
					sorties_attendues+=("$1")
				fi
				;;
		esac
		shift
	done

	# Valider qu'une commande est reçue
	if [[ -z $commande ]]; then
		echo "Commande manquante" >&2
		exit 2
	fi

	# Ajuster l'exit code pour correspondre à l'erreur au besoin
	if [[ ${#erreurs_attendues[@]} -gt 0 && $exitcode_attendu == 0 ]]; then
		exitcode_attendu=!0
	fi

	# Splitter la commande séparé par des virgules ou des points virgules dans un array
	local cmdarr
	if [[ $commande == \;* ]]; then
		IFS=\; read -ra cmdarr <<< "${commande:1}"
	else
		IFS=, read -ra cmdarr <<< "$commande"
	fi

	# Obtenir une présentation sans virgules de la commande
	local commande="${cmdarr[@]}"

	# Exécuter la commande
	local sortie
	sortie=$("${cmdarr[@]}" 2> "$ERROR_FILE")
	local exitcode=$?

	# Pour usage sous DOS/WINDOWS: supprimer les \r des outputs.
	sortie=$(echo -n "$sortie" | tr -d '\r')
	
	local erreur
	erreur=$(tr -d '\r' < "$ERROR_FILE")

	# Valider les erreurs attendues
	if [[ ${#erreurs_attendues[@]} -eq 0 ]]; then
		assertLike "" "$erreur" "$commande -> Aucune erreur attendue!" $((nesting + 1))
	else
		for erreur_attendue in "${erreurs_attendues[@]}"; do
			assertLike "$erreur_attendue" "$erreur" "$commande -> Mauvais message d'erreur (stderr)" $((nesting + 1))
		done
	fi	

	# Valider l'exit code attendue
	assertLike "$exitcode_attendu" "$exitcode" "$commande -> Mauvais exit code" $((nesting + 1))

	# Valider les sorties attendues
	if [[ ${#sorties_attendues[@]} -eq 0 ]]; then
		assertLike "" "$sortie" "$commande -> Aucune sortie attendue!" $((nesting + 1))
	else
		for sortie_attendue in "${sorties_attendues[@]}"; do
			assertLike "$sortie_attendue" "$sortie" "$commande -> Mauvais message (stdout)" $((nesting + 1))
		done
	fi	
}

