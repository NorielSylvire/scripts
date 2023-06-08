#!/bin/bash

HELP="Usage: memusage [mode] [options]\n\nmemusage prints information about the current memory usage of the system.\n\nModes:\n\t\tnone\n\t\t\tPrint all the information.\n\t\t--used -u\n\t\t\tPrint the memory that is currently being used by the system.\n\t\t--unused -n\n\t\t\tPrint the memory not currently used by the system.\n\t\t--free -f\n\t\t\tPrint free memory.\n\t\t--total -t\n\t\t\tPrint the total memory of the system.\n\nOptions:\n\t\ŧ --brief -b\n\t\t\tPrint only the number of memory and not the words. Useful for embedding the information into other strings such as the command prompt.\n\t\ŧ--help -h\n\t\t\ŧPrint this message."


if [[ -n $1 ]] && ([[ $1 = "-b" ]] || [[ $1 = "--brief" ]]); then
  BRIEF=1
elif [[ -n $2 ]] && ([[ $2 = "-b" ]] || [[ $2 = "--brief" ]]); then
  BRIEF=2
else
  BRIEF=0
fi


if [[ -n $1 ]] && [[ $BRIEF -eq 2 ]]; then
  MODE=$1
elif [[ -n $2 ]] && [[ $BRIEF -eq 1 ]]; then
  MODE=$2
elif [[ -n $1 ]] && [[ $BRIEF -eq 0 ]]; then
  MODE=$1
elif [[ -z $1 ]] || ([[ $BRIEF -eq 1 ]] && [[ -z $2 ]]); then
  MODE="none"
else
  MODE="invalid"
fi


case $MODE in
  "-u" | "--used")
    if [[ $BRIEF -eq 0 ]]; then
      WORD="Used: "
    else
      WORD=""
    fi
    echo $(free | grep Mem | awk -v word="$WORD" '{ printf("%s%.4f%%",word,$3/$2 * 100) }')
    ;;
  "-n" | "--unused")
    if [[ $BRIEF -eq 0 ]]; then
      WORD="Unused: "
    else
      WORD=""
    fi
    echo $(free | grep Mem | awk -v word="$WORD" '{ printf("%s%.4f%%",word,($4+$6)/$2 * 100) }')
    ;;
  "-f" | "--free")
    if [[ $BRIEF -eq 0 ]]; then
      WORD="Free: "
    else
      WORD=""
    fi
    echo $(free | grep Mem | awk -v word="$WORD" '{ printf("%s%.4f%%",word,$4/$2 * 100) }')
    ;;
  "-t" | "--total")
    if [[ $BRIEF -eq 0 ]]; then
      WORD="Total: "
    else
      WORD=""
    fi
    echo $(free | grep Mem | awk -v word="$WORD" '{ printf("%s%d",word,$2) }')
    ;;
  "none")
    if [[ $BRIEF -eq 0 ]]; then
      echo $(free | grep Mem | awk '{ printf("Total: %d",$2) }')
      echo $(free | grep Mem | awk '{ printf("Used: %.4f%",$3/$2 * 100) }')
      echo $(free | grep Mem | awk '{ printf("Unused: %.4f%",($4+$6)/$2 * 100) }')
      echo $(free | grep Mem | awk '{ printf("Free: %.4f%",$4/$2 * 100) }')
    else
      echo $(free | grep Mem | awk '{ printf("%d",$2) }')
      echo $(free | grep Mem | awk '{ printf("%.4f%",$3/$2 * 100) }')
      echo $(free | grep Mem | awk '{ printf("%.4f%",($4+$6)/$2 * 100) }')
      echo $(free | grep Mem | awk '{ printf("%.4f%",$4/$2 * 100) }')
    fi
    ;;
  "-h" | "--help")
    echo -e $HELP
    ;;
  *)
    echo -e "Subcommand not recognized.\n$HELP"
    ;;
esac
