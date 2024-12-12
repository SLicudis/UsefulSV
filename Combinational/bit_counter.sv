module bit_counter #(
    parameter INPUTBITWIDTH = 16,
    parameter OUTPUTBITWIDTH = $clog2(INPUTBITWIDTH) //Don't modify
)(
    input [INPUTBITWIDTH-1:0] data_in,
    output [OUTPUTBITWIDTH-1:0] data_out,
    output carry_out
);
    logic [OUTPUTBITWIDTH:0] intermediate_result;
    int i;
    always_comb begin
        intermediate_result = 0;
        for(i = 0; i < INPUTBITWIDTH; i++) begin
            intermediate_result += {{OUTPUTBITWIDTH{1'b0}}, data_in[i]};
        end
    end

    assign data_out = intermediate_result[OUTPUTBITWIDTH-1:0];
    assign carry_out = intermediate_result[OUTPUTBITWIDTH];

endmodule : bit_counter
