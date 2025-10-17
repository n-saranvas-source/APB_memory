`timescale 1ns / 1ps
module tb();
reg Pclk;
reg Prst;
reg [5:0] Paddr;
reg Pselx;
reg Penable;
reg Pwrite;
reg [31:0] Pwdata;

wire  Pready;
wire Pslverr;
wire [31:0] Prdata;
wire [31:0] temp;

APB_mem dut(Pclk, Prst,Paddr, Pselx,Penable, Pwrite, Pwdata, Pready, Pslverr, Prdata, temp);

initial Pclk =1;
always #10 Pclk =~Pclk;

task reset_and_initialization;
begin
#5 Prst =0;
@(posedge Pclk);

Prst=1;
Pselx=1'b0;
Penable = 1'bx;
Pwrite = 1'bx;
Paddr = 6'bx;
end
endtask


task write_transfer;
begin
Pselx=1;
Pwrite=1;
Pwdata=$random;
Paddr = $random;
//#10;
@(posedge Pclk);
Penable =1;
//wait (Pready == 1) begin
//Pselx =Pselx;
//Pwrite = Pwrite;
//Penable = Penable;
//Paddr = Paddr;
//Pwdata = Pwdata;
//end
@(posedge Pclk);
Penable = 0;

$strobe ("writong data into memory data =%0d, address =%0d" , Pwdata, Paddr);

end
endtask

task read_transfer;
begin
Pselx =1;
Pwrite = 0;
@(posedge Pclk);
Penable=1;

//wait (Pready ==1) begin
//Pselx =Pselx;
//Pwrite = Pwrite;
//Penable = Penable;
//Paddr = Paddr;
//Pwdata = Pwdata; end

@(posedge Pclk);
Penable = 0;
Pselx =0;

$strobe("reading data from memory data =%0d, address =%0d", Prdata, Paddr);
end
endtask


task read_write_transfer;
begin
@(posedge Pclk);
repeat(3)
begin
write_transfer;
read_transfer;

end
end
endtask

initial begin

reset_and_initialization;
read_write_transfer;

#80; $finish;
end

initial begin
$dumpfile("dump.vcd");
$dumpvars;
 
end

endmodule








