module decoder#(
    parameter INPUTBITWIDTH = 4,
    parameter OUTPUTBITWIDTH = 2**INPUTBITWIDTH //Don't modify
)(
    input [INPUTBITWIDTH-1:0] data_in,
    output logic [OUTPUTBITWIDTH-1:0] data_out
);
    always_comb begin
        data_out = 0;
        data_out[data_in] = 1'b1;
    end

endmodule : decoder

