module priority_encoder #(
    parameter INPUTBITWIDTH = 16,
    parameter OUTPUTBITWIDTH = $clog2(INPUTBITWIDTH) //Don't modify
)(
    input [INPUTBITWIDTH-1:0] data_in,
    output logic [OUTPUTBITWIDTH-1:0] data_out,
    output null_input
);
    wire [INPUTBITWIDTH-1:0] mirrored_data_in;
    wire [INPUTBITWIDTH-1:0] mirrored_isolated_highest_bit = mirrored_data_in & -mirrored_data_in;
    wire [INPUTBITWIDTH-1:0] isolated_highest_bit;
    wire [OUTPUTBITWIDTH-1:0] mask [INPUTBITWIDTH-1:0];
    genvar i;
    generate
        for(i = 0; i < INPUTBITWIDTH; i++) begin : InvertInputPositions //Ex: 1010 -> 0101
            assign mirrored_data_in[i] = data_in[INPUTBITWIDTH-1-i];
        end
        for(i = 0; i < INPUTBITWIDTH; i++) begin : InvertIHBPositions //After this reorganization, you get the isolated highest bit
            assign isolated_highest_bit[i] = mirrored_isolated_highest_bit[INPUTBITWIDTH-1-i];
        end
        for(i = 0; i < INPUTBITWIDTH; i++) begin : GenerateMasks //mask[n] = n if input n = 1, else: mask[n] = 0
            assign mask[i] = i & {OUTPUTBITWIDTH{isolated_highest_bit[i]}};
        end
        assign stage[0] = mask[0];
        for(i = 1; i < INPUTBITWIDTH; i++) begin : OrMasks
            assign stage[i] = stage[i-1] | mask[i]; //All the masks are ORed and the result in data_out
        end
    endgenerate

    wire [OUTPUTBITWIDTH-1:0] stage [INPUTBITWIDTH-1:0];

    assign data_out = stage[INPUTBITWIDTH-1];
    assign null_input = ~(|data_out) & ~data_in[0]; //Output 1 when none of the inputs are 1.

endmodule : priority_encoder

