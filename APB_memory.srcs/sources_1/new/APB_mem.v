`timescale 1ns / 1ps

module APB_mem(Pclk, Prst,Paddr, Pselx,Penable, Pwrite, Pwdata, Pready, Pslverr, Prdata, temp);

input Pclk;
input Prst;
input [5:0] Paddr;
input Pselx;
input Penable;
input Pwrite;
input [31:0] Pwdata;

output reg Pready;
output reg Pslverr;
output reg [31:0] Prdata;
output reg [31:0] temp;

reg [31:0] mem[31:0];
parameter [1:0] idle =2'b00; 
parameter [1:0]setup = 2'b01;
parameter [1:0] access=2'b10;

reg [1:0] present_state, next_state;

always@(posedge Pclk or negedge Prst)//asynchronous
begin
if(Prst ==0) begin//active low
present_state <= idle;
//next_state <= present_state;
end
else 
present_state <= next_state;
end

always @(*) begin
next_state = present_state;

case(present_state)

idle:begin
    //if(Pselx & !Penable)
    next_state = setup;
    end
setup:begin
    if( Pselx) begin
    //Pready = 1;
    next_state = access;
    end
    else
    next_state = idle;
    end
    
access: begin
    Pready = 1;
    if(Penable & Pwrite)
    begin
        if(Paddr>31) Pslverr =1;
        else begin
            mem[Paddr] = Pwdata;
            temp = mem[Paddr];
    
            Pslverr = 0;
             end
    end
    else if (Penable & Pwrite ==0) begin
    Prdata = mem[Paddr];
   // temp =mem[Paddr];
    
    //Pslverr = 0;
        end
        
     if(!Penable) begin
     next_state = setup;
     //Pready = 0;
     end
     end
endcase 
end

endmodule
