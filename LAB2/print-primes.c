/*
 print-prime.c
 By David Broman.
 Last modified: 2015-09-15
 This file is in the public domain.
*/


#include <stdio.h>
#include <stdlib.h>

#define COLUMNS 6
int col=0;


void print_number(int n){
	printf("%10d ", n);
	if(!(++col%COLUMNS)){
		printf("\n");
		col=0;
	}
}

int is_prime(int n){
	for(int j=n-1;j>1;j--)
		if(!(n%j))
			return 0;
	return 1;
}

void print_primes(int n){
  // Should print out all prime numbers less than 'n'
  // with the following formatting. Note that
  // the number of columns is stated in the define
  // COLUMNS
	for(int i=2;i<n+1;i++)
		if(is_prime(i))
			print_number(i);
}


// 'argc' contains the number of program arguments, and
// 'argv' is an array of char pointers, where each
// char pointer points to a null-terminated string.
int main(int argc, char *argv[]){
  if(argc == 2)
    print_primes(atoi(argv[1]));
  else
    printf("Please state an integer number.\n");
  return 0;
}

 
