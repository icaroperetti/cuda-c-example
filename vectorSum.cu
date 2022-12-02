#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include<stdio.h>


__global__ void vectorAdd(int* a, int* b, int* c) {
	//Lista de threads
	int i = threadIdx.x;

	c[i] = a[i] + b[i];

	return;

}

int main() {
	int a[] = { 1,2,3 };
	int b[] = { 4,5,6 };

	int c[sizeof(a) / sizeof(int)] = { 0 };


	// cria ponteiros para GPU
	int* cudaA = 0;
	int* cudaB = 0;
	int* cudaC = 0;

	//aloca memória na GPU
	cudaMalloc(&cudaA, sizeof(a));
	cudaMalloc(&cudaB, sizeof(b));
	cudaMalloc(&cudaC, sizeof(c));

	// cópia os vetores da CPU para GPU
	cudaMemcpy(cudaA, a, sizeof(a), cudaMemcpyHostToDevice);
	cudaMemcpy(cudaB, b, sizeof(b), cudaMemcpyHostToDevice);



	// GRID_SIZE,BLOCK_SIZE 
	vectorAdd << <1, sizeof(a) / sizeof(int) >> > (cudaA, cudaB, cudaC);

	//Copia da GPU para a CPU
	cudaMemcpy(c, cudaC, sizeof(c), cudaMemcpyDeviceToHost);
	
	for (int i = 0; i < sizeof(c) / sizeof(int); ++i)
		printf("c[%d] = %d\n", i, c[i]);

	return;
}
