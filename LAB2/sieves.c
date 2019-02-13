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

void print_sieves(int n){
    int prime[n+1];
    int p;
    for(p=0;p<n+1;p++)
	    prime[p] = 1;	//assume all prime
 
    for (p=2; p*p<=n; p++)
    {
        // If p hasnt been changed then its still a prime 
        if (prime[p] == 1)
        {
            // Update all multiples of p
            for (int i=p*2; i<=n; i += p)
		    prime[i] = 0;
	}
    }
 
    // Print all prime numbers
    for (p=2; p<=n; p++)
    	if (prime[p])
		print_number(p);
        	  
}

// 'argc' contains the number of program arguments, and
// 'argv' is an array of char pointers, where each
// char pointer points to a null-terminated string.
int main(int argc, char *argv[]){
  if(argc == 2)
    print_sieves(atoi(argv[1]));
  else
    printf("Please state an integer number.\n");
  return 0;
}

 
