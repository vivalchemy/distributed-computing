#include "calc.h"

float *add_1_svc(inputs *argp, struct svc_req *rqstp) {
    static float result;
    result = argp->num1 + argp->num2;
    printf("Server: Adding %f + %f = %f\n", argp->num1, argp->num2, result);
    return &result;
}

float *sub_1_svc(inputs *argp, struct svc_req *rqstp) {
    static float result;
    result = argp->num1 - argp->num2;
    printf("Server: Subtracting %f - %f = %f\n", argp->num1, argp->num2, result);
    return &result;
}

float *mul_1_svc(inputs *argp, struct svc_req *rqstp) {
    static float result;
    result = argp->num1 * argp->num2;
    printf("Server: Multiplying %f * %f = %f\n", argp->num1, argp->num2, result);
    return &result;
}

float *div_1_svc(inputs *argp, struct svc_req *rqstp) {
    static float result;
    if (argp->num2 == 0) {
        printf("Server: Division by zero attempted!\n");
        result = 0;
    } else {
        result = argp->num1 / argp->num2;
        printf("Server: Dividing %f / %f = %f\n", argp->num1, argp->num2, result);
    }
    return &result;
}

