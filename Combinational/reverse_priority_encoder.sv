module reverse_priority_encoder #(
    parameter INPUTBITWIDTH = 16,
    parameter OUTPUTBITWIDTH = $clog2(INPUTBITWIDTH) //Don't modify
)(
    input [INPUTBITWIDTH-1:0] data_in,
    output logic [OUTPUTBITWIDTH-1:0] data_out,
    output null_input
);
    wire [INPUTBITWIDTH-1:0] isolated_lowest_bit = data_in & -data_in;
    wire [OUTPUTBITWIDTH-1:0] mask [INPUTBITWIDTH-1:0];
    genvar i;
    generate
        for(i = 0; i < INPUTBITWIDTH; i++) begin : GenerateMasks //mask[n] = n if input n = 1, else: mask[n] = 0
            assign mask[i] = i & {OUTPUTBITWIDTH{isolated_lowest_bit[i]}};
        end
    endgenerate

    wire [OUTPUTBITWIDTH-1:0] stage [INPUTBITWIDTH-1:0];

    generate
        for(i = 0; i < INPUTBITWIDTH; i++) begin : OrMasks
            if(i == 0) begin : InitialAssignment
                assign stage[0] = mask[0];
            end else begin : OrElements
                assign stage[i] = stage[i-1] | mask[i]; //All the masks are ORed and the result in data_out
            end
        end
    endgenerate

    assign data_out = stage[INPUTBITWIDTH-1];
    assign null_input = ~(|data_out) & ~data_in[0]; //Output 1 when none of the inputs are 1.

endmodule : reverse_priority_encoder
