
module miter 
    #
    (
	    parameter int g_width = 8
    )

    (

        input logic i_clk_A,
        input logic i_rst_A,
        input logic i_clk_B,
        input logic i_rst_B,

        input logic ref_i_pulse_A,
        input logic [g_width - 1 : 0] ref_i_data_A,
        input logic uut_i_pulse_A,
        input logic [g_width - 1 : 0] uut_i_data_A
	);

    wire [g_width - 1 : 0] ref_o_data_B;
    wire ref_f_pulse_B;
    wire ref_f_pulse_B_prev;

    wire [g_width - 1 : 0] uut_o_data_B;
    wire uut_f_pulse_B;
    wire uut_f_pulse_B_prev;

	reg f_past_valid;

	recirculation_mux  ref
	(
		.mutsel(1'b0),
		.i_clk_A  (i_clk_A),
		.i_rst_A  (i_rst_A),
		.i_clk_B  (i_clk_B),
		.i_rst_B  (i_rst_B),

		.i_pulse_A(ref_i_pulse_A),
		.i_data_A(ref_i_data_A),
		.o_data_B(ref_o_data_B),
		.f_pulse_B(ref_f_pulse_B),
		.f_pulse_B_prev(ref_f_pulse_B_prev)
	);

	recirculation_mux  uut
	(
		.mutsel(1'b1),
		.i_clk_A  (i_clk_A),
		.i_rst_A  (i_rst_A),
		.i_clk_B  (i_clk_B),
		.i_rst_B  (i_rst_B),

		.i_pulse_A(uut_i_pulse_A),
		.i_data_A(uut_i_data_A),
		.o_data_B(uut_o_data_B),
		.f_pulse_B(uut_f_pulse_B),
		.f_pulse_B_prev(uut_f_pulse_B_prev)
	);


	always @* begin
		assume_pulse : assume (ref_i_pulse_A == uut_i_pulse_A);
		assume_A : assume (ref_i_data_A == uut_i_data_A);
	end

	initial begin
		f_past_valid <= 1'b0;
		assume_rst_A : assume (i_rst_A == 1'b1);
		assume_rst_B : assume (i_rst_B == 1'b1);
	end
	
	always @(posedge i_clk_B) begin
		f_past_valid <= 1'b1;
	 	if(!i_rst_B) begin
	 		if(f_past_valid) begin
	 			assert_f_pulse : assert (ref_f_pulse_B == uut_f_pulse_B);
	 			assert_f_pulse_prev : assert (ref_f_pulse_B_prev == uut_f_pulse_B_prev);
	 		end
			if(f_past_valid && $rose(ref_f_pulse_B_prev))
				assert_data : assert (ref_o_data_B == uut_o_data_B);
	 	end
	end
endmodule
