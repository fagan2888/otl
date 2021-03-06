#include "mex.h" 

#include <iostream>
#include "otl.h"
#include "otl_oesgp.h"
#include "ObjectHandle.h"

using namespace OTL;

void mexFunction(int nlhs, mxArray *plhs[],
    int nrhs, const mxArray *prhs[]) {
	double *i_oesgp_object;
    double *i_inputs;

	i_oesgp_object =  mxGetPr(prhs[0]);
	i_inputs = mxGetPr(prhs[1]);
    
    //assign the kernel parameters
	unsigned int m = mxGetM(prhs[1]);
	unsigned int n = mxGetN(prhs[1]);
	
	unsigned int len = (m > n) ? m : n;
    VectorXd inputs(len);
	for (unsigned int i=0; i<len; i++) {
		inputs[i] = i_inputs[i]; 
	}

    ObjectHandle<OESGP>* handle = 
            ObjectHandle<OESGP>::from_mex_handle(prhs[0]);
	handle->get_object().update(inputs);

}