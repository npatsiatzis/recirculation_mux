`default_nettype none

module recirculation_mux
    #
    (
        parameter int g_stages = 2,
        parameter int g_width /*verilator public*/ = 8
    )

    (
        input logic i_clk_A,
        input logic i_rst_A,
        input logic i_pulse_A,
        input logic [g_width - 1 : 0] i_data_A,

        input logic i_clk_B,
        input logic i_rst_B,
        output logic [g_width - 1 : 0] o_data_B,

        output logic f_pulse_B,
        output logic f_pulse_B_prev
    );

    logic w_pulse_B;

    toggle_synchronizer #(.G_STAGES(g_stages)) sync (.*,.o_pulse_B(w_pulse_B));

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

    `ifdef WAVEFORM
        initial begin
            // Dump waves
            $dumpfile("dump.vcd");
            $dumpvars(0, recirculation_mux);
        end
    `endif
                        /*          ######################      */
                        /*          Assertions && Coverage      */
                        /*          ######################      */
    `ifdef USE_VERILATOR
        check_o_data_B : assert property (@(posedge i_clk_B) disable iff (i_rst_B) $rose(w_pulse_B) |=> (o_data_B == $past(i_data_A)))
            else $warning("Test Failure! ASSERTION FAILED!");
        check_o_data_B_negative : assert property (@(posedge i_clk_B) disable iff(i_rst_B) !$rose(w_pulse_B) |=> $stable(o_data_B))
            else $warning("Test Failure! ASSERTION FAILED!");
    `endif        

endmodule : recirculation_mux
