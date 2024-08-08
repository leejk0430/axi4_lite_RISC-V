module core_cycle_counter #(
    parameter NUM_CYCLE_BIT = 32
) 
(

    input                           clk,
    input                           reset_n,

    input [NUM_CYCLE_BIT-1 : 0]     i_num_cycle,
    input                           i_run,

    output                          o_idle,
    output                          o_running,
    output                          o_done
);


localparam  S_IDLE      = 2'b00;
localparam  S_RUNNING   = 2'b01;
localparam  S_DONE      = 2'b10;


reg [1:0]   c_state;
reg [1:0]   n_state; 

reg [NUM_CYCLE_BIT - 1 : 0]         num_cnt;

reg     [NUM_CYCLE_BIT - 1 : 0]         cnt_always;



assign o_idle       = c_state == S_IDLE;
assign o_running    = c_state == S_RUNNING;
assign o_done       = c_state == S_DONE;


always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        c_state <= S_IDLE;
    end
    else begin
        c_state <= n_state;
    end
end


always @(*) begin
    case(c_state)
    S_IDLE: if(i_run)
        n_state = S_RUNNING;
    S_RUNNING: if(cnt_always == (num_cnt - 1))
        n_state = S_DONE;
    S_DONE: n_state = S_IDLE;
    default: n_state = c_state;
    endcase
end






always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        num_cnt <= 0;
    end
    else if(i_run) begin
        num_cnt <= i_num_cycle;
    end
    else if(cnt_always == num_cnt - 1) begin
        num_cnt <= 0;
    end
end




always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        cnt_always <= 0;
    end
    else if(cnt_always ==  (num_cnt - 1)) begin
        cnt_always <= 0;
    end
    else if(o_running) begin
        cnt_always <= cnt_always + 1;
    end
end

endmodule