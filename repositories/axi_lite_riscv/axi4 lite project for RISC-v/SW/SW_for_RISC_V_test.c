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
#define reg_num_4   4
#define reg_num_5   5
#define reg_num_6   6

//slv_reg0 <- done, running, idle
//slv_reg1 -> i_num_cycle
//slv_reg2 -> i_run

//slv_reg3 -> mem_reset_n
//slv_reg4 -> instruction_write
//slv_reg5 -> instruction_data
//slv_reg6 -> instruction_addr

int main() {
    int data;
    int inst_reg_addr;
    unsigned int instruction;
    int num_cycle;
    char binary_input[33];
    char run_core;

    while (1) {
        printf("==========Hello RISC-V 32bit Single Cycle core=========\n");   
        printf("please input mode number\n");
        printf("1. Reset RISC-V core memory\n");
        printf("2. Write instruction\n");
        printf("3. Run RISC-V core\n");
        scanf("%d" ,&data);


        if (data == Reset){
            Xil_Out32((XPAR_RISC_V_LAB_0_BASEADDR) + (reg_num_3*AXI_DATA_BYTE), (u32)(1));
            printf("reseting...\n");
            Xil_Out32((XPAR_RISC_V_LAB_0_BASEADDR) + (reg_num_3*AXI_DATA_BYTE), (u32)(0));
            printf("reset complete!\n");
        }
        else if(data == Write){
            printf("input the instruction address you want to write(0~255):\n");
            scanf("%d", &inst_reg_addr);
            while (inst_reg_addr < 0 || inst_reg_addr > 255){
                printf("error! input valid address:\n");
                scanf("%d", &inst_reg_addr);
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
            Xil_Out32((XPAR_RISC_V_LAB_0_BASEADDR) + (reg_num_5*AXI_DATA_BYTE), (u32)(instruction));
            Xil_Out32((XPAR_RISC_V_LAB_0_BASEADDR) + (reg_num_6*AXI_DATA_BYTE), (u32)(inst_reg_addr));
            Xil_Out32((XPAR_RISC_V_LAB_0_BASEADDR) + (reg_num_1*AXI_DATA_BYTE), (u32)(4));
            printf("write complete!\n");
        }
        else if(data == Run) {
            printf("input the number of cycle you want to run the RISC-V core:\n");
            scanf("%d", &num_cycle);
            
            Xil_Out32((XPAR_RISC_V_LAB_0_BASEADDR) + (reg_num_1*AXI_DATA_BYTE), (u32)(num_cycle));
            
            printf("Do you want to run %d cycle for the core?(y/n):",num_cycle);
            scanf(" %c", &run_core);
            while(1){
                if(run_core == 'y'){
                    Xil_Out32((XPAR_RISC_V_LAB_0_BASEADDR) + (reg_num_2*AXI_DATA_BYTE), (u32)(1));
                    printf("Core currently running\n");
                    break;
                }
                else if(run_core == 'n'){
                    Xil_Out32((XPAR_RISC_V_LAB_0_BASEADDR) + (reg_num_2*AXI_DATA_BYTE), (u32)(0));
                    break;
                }
                else {
                    printf("Invalid input. Please enter 'y' or 'n'.\n");
                    scanf(" %c", &run_core);
                }
            }
            //reading the status
            while (1) {
            u32 read_status = Xil_In32((XPAR_RISC_V_LAB_0_BASEADDR) + (reg_num_0*AXI_DATA_BYTE));
                if(read_status == 2){
                    // slv_reg0[1] <- running
                    printf("Core status is 'running'");
                }
                else if(read_status == 4){
                    //slv_reg0[2] <- done
                    printf("Core status is 'done'");
                }
                else if(read_status == 5){
                    //slv_reg0[0] <- idle
                    printf("Core status is 'idle' after 'done' ");
                    break
                }
            }
            /*printf("press 1 to read status :/n");
            if(status_confirm == 1){
                u32 read_status = Xil_In32((XPAR_RISC_V_LAB_0_BASEADDR) + (reg_num_0*AXI_DATA_BYTE));


            }*/
        }
    }
    
    return 0;
}

