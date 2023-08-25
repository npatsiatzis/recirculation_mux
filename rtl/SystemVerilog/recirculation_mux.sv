`default_nettype none

module recirculation_mux
    #
    (
        parameter int G_STAGES = 2,
        parameter int G_WIDTH /*verilator public*/ = 4
    )

    (
        input logic i_clk_A,
        input logic i_rst_A,
        input logic i_pulse_A,
        input logic [G_WIDTH - 1 : 0] i_data_A,

        input logic i_clk_B,
        input logic i_rst_B,
        output logic [G_WIDTH - 1 : 0] o_data_B,

        output logic f_pulse_B,
        output logic f_pulse_B_prev
    );

    logic w_pulse_B;

    toggle_synchronizer #(.G_STAGES(G_STAGES)) sync (.*,.o_pulse_B(w_pulse_B));

    always_ff @(posedge i_clk_B) begin : mux_recirculation
        if(i_rst_B) begin
            o_data_B <= 0;
        end else begin
            if (w_pulse_B)
                o_data_B <= i_data_A;
        end
    end

    assign f_pulse_B = w_pulse_B;
    always_ff @(posedge i_clk_B) begin : pulse_B_past
        if(i_rst_B) begin
            f_pulse_B_prev <= 0;
        end else begin
            f_pulse_B_prev <= f_pulse_B;
        end
    end

endmodule : recirculation_mux
