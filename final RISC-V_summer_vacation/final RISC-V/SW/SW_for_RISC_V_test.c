#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include "xparameters.h"
#include "xil_io.h"


#define Reset 1
#define Write 2
#define Run   3
#define AXI_DATA_BYTE 4

#define reg_num_0   0
#define reg_num_1   1
#define reg_num_2   2
#define reg_num_3   3

//run_pc -> slv_reg_0
//instruction_write -> slv_reg_1
//instruction_addr -> slv_reg_2
//instruction_data -> slv_reg_3


int main() {
    int data;
    int inst_reg_num;
    unsigned int instruction;
    char stop_core [100];
    char binary_input[33];

    while (1) {
        printf("==========Hello RISC-V 32bit Single Cycle core=========\n");   
        printf("please input mode\n");
        printf("1. Reset RISC-V core\n");
        printf("2. Write instruction\n");
        printf("3. Run RISC-V core\n");
        scanf("%d" ,&data);


        if (data == Reset){
            Xil_Out32((XPAR_RISC_V_LAB_0_BASEADDR) + (reg_num_0*AXI_DATA_BYTE), (u32)(2));
            printf("reseting...\n");
            Xil_Out32((XPAR_RISC_V_LAB_0_BASEADDR) + (reg_num_0*AXI_DATA_BYTE), (u32)(0));
            printf("reset complete!\n");
        }
        else if(data == Write){
            printf("input the instruction address you want to write(0~15):\n");
            scanf("%d", &inst_reg_num);
            while (inst_reg_num < 0 || inst_reg_num > 15){
                printf("error! input valid number:\n");
                scanf("%d", &inst_reg_num);
            }
            printf("input the instruction you want to write for that address(32bit):\n");
            scanf("%32s", binary_input);

            // Convert binary string to integer
            instruction = 0;
            for (int i = 0; i < 32; i++) {
                instruction = (instruction << 1) | (binary_input[i] - '0');
            }

 /*           inst_data = strtol(binary_input, NULL, 2);

            while (inst_data >  0xFFFFFFFFu){
                printf("error! input instruction exceeds 32 bits. input valid instruction:\n");
                scanf("%32s", binary_input);
                inst_data = strtol(binary_input, NULL, 2);
            }

            */
            Xil_Out32((XPAR_RISC_V_LAB_0_BASEADDR) + (reg_num_1*AXI_DATA_BYTE), (u32)(1));
            Xil_Out32((XPAR_RISC_V_LAB_0_BASEADDR) + (reg_num_2*AXI_DATA_BYTE), (u32)(inst_reg_num));
            Xil_Out32((XPAR_RISC_V_LAB_0_BASEADDR) + (reg_num_3*AXI_DATA_BYTE), (u32)(instruction));
            Xil_Out32((XPAR_RISC_V_LAB_0_BASEADDR) + (reg_num_1*AXI_DATA_BYTE), (u32)(0));
            printf("write complete!\n");
        }
        else if(data == Run) {
            Xil_Out32((XPAR_RISC_V_LAB_0_BASEADDR) + (reg_num_0*AXI_DATA_BYTE), (u32)(1));
            printf("Core currently running\n");
            printf("enter 'stop' to stop running core\n");
            scanf("%s", stop_core);
            while (strcmp(stop_core, "stop") != 0){
                printf("error! input 'stop' to stop core:\n");
                scanf("%s", stop_core);
            }
            Xil_Out32((XPAR_RISC_V_LAB_0_BASEADDR) + (reg_num_0*AXI_DATA_BYTE), (u32)(0));
            printf("stopped core!\n");
        }
    }
    return 0;
}
