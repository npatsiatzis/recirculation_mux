`default_nettype none

module toggle_synchronizer
    #
    (
        parameter int G_STAGES = 2
    )

    (
        input logic  i_clk_A,
        input logic  i_rst_A,
        input logic  i_pulse_A,

        input logic i_clk_B,
        input logic i_rst_B,
        output logic o_pulse_B
    );

    logic r_pulse_A;
    logic [G_STAGES - 1 : 0] r_syncB_pulse_A;
    logic r_edge_detect_ff;

    always_ff @(posedge i_clk_A) begin : pulse_to_level
        if(i_rst_A) begin
            r_pulse_A <= 0;
        end else begin
            if (i_pulse_A)
                r_pulse_A <= ~r_pulse_A;
        end
    end

    always_ff @(posedge i_clk_B) begin : sync_domain_B
        if(i_rst_B) begin
            r_syncB_pulse_A <= '0;
            r_edge_detect_ff <= 1'b0;
        end else begin
            r_syncB_pulse_A <= {r_syncB_pulse_A[G_STAGES - 2 : 0], r_pulse_A};
            r_edge_detect_ff <= r_syncB_pulse_A[G_STAGES - 1];
        end
    end

    assign o_pulse_B = r_edge_detect_ff ^ r_syncB_pulse_A[G_STAGES - 1];

endmodule : toggle_synchronizer
