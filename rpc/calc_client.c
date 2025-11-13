#include "calc.h"
#include <stdio.h>
#include <stdlib.h>

void calc_prog_1(char *host) {
    CLIENT *clnt;
    float *result;
    inputs arg;
    int choice;
    
    clnt = clnt_create(host, CALC_PROG, CALC_VER, "tcp");
    if (clnt == NULL) {
        clnt_pcreateerror(host);
        exit(1);
    }
    
    printf("Enter first number: ");
    scanf("%f", &arg.num1);
    printf("Enter second number: ");
    scanf("%f", &arg.num2);
    printf("Choose operation:\n1. Add\n2. Subtract\n3. Multiply\n4. Divide\n");
    scanf("%d", &choice);
    
    switch(choice) {
        case 1:
            result = add_1(&arg, clnt);
            if (result == NULL) {
                clnt_perror(clnt, host);
                clnt_destroy(clnt);
                exit(1);
            }
            printf("Result: %f + %f = %f\n", arg.num1, arg.num2, *result);
            break;
        case 2:
            result = sub_1(&arg, clnt);
            if (result == NULL) {
                clnt_perror(clnt, host);
                clnt_destroy(clnt);
                exit(1);
            }
            printf("Result: %f - %f = %f\n", arg.num1, arg.num2, *result);
            break;
        case 3:
            result = mul_1(&arg, clnt);
            if (result == NULL) {
                clnt_perror(clnt, host);
                clnt_destroy(clnt);
                exit(1);
            }
            printf("Result: %f * %f = %f\n", arg.num1, arg.num2, *result);
            break;
        case 4:
            result = div_1(&arg, clnt);
            if (result == NULL) {
                clnt_perror(clnt, host);
                clnt_destroy(clnt);
                exit(1);
            }
            printf("Result: %f / %f = %f\n", arg.num1, arg.num2, *result);
            break;
        default:
            printf("Invalid choice\n");
            clnt_destroy(clnt);
            exit(1);
    }
    
    clnt_destroy(clnt);
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <hostname>\n", argv[0]);
        exit(1);
    }
    calc_prog_1(argv[1]);
    return 0;
}

