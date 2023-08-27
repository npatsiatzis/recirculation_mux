// Verilator Example
#include <stdlib.h>
#include <iostream>
#include <cstdlib>
#include <memory>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vrecirculation_mux.h"
#include "Vrecirculation_mux_recirculation_mux.h"   //to get parameter values, after they've been made visible in SV


#define POSEDGE(ns, period, phase) \
    ((ns) % (period) == (phase))

#define NEGEDGE(ns, period, phase) \
    ((ns) % (period) == ((phase) + (period)) / 2 % (period))

#define CLK_A_PERIOD 30
#define CLK_A_PHASE 0

#define CLK_B_PERIOD 50
#define CLK_B_PHASE 0



#define MAX_SIM_TIME 300
#define VERIF_START_TIME 7
vluint64_t sim_time = 0;
vluint64_t posedge_cnt = 0;

// input interface transaction item class
class InTx {
    private:
    public:
        unsigned int i_data_A;
};


// output interface transaction item class
class OutTx {
    public:
        unsigned int o_data_B;
};

//in domain Coverage
class InCoverage{
    private:
        std::set <unsigned int> in_cvg;
    
    public:
        void write_coverage(InTx *tx){
            in_cvg.insert(tx->i_data_A);
        }

        bool is_covered(unsigned int A){            
            return in_cvg.find(A) == in_cvg.end();
        }
};

//out domain Coverage
class OutCoverage {
    private:
        std::set <unsigned int> coverage;

    public:
        void write_coverage(OutTx* tx){
            coverage.insert(tx->o_data_B); 
        }

        bool is_full_coverage(){
            return coverage.size() == (1 << (Vrecirculation_mux_recirculation_mux::G_WIDTH));
        }
};


// ALU scoreboard
class Scb {
    private:
        std::deque<InTx*> in_q;
        std::deque<OutTx*> out_q;
        
    public:
        // Input interface monitor port
        void writeIn(InTx *tx){
            // Push the received transaction item into a queue for later
            in_q.push_back(tx);
        }

        // Output interface monitor port
        void writeOut(OutTx *tx){
            // Push the received transaction item into a queue for later
            out_q.push_back(tx);
        }

        void checkPhase(){
            while(out_q.empty() == 0){
                InTx* in;
                in = in_q.front();
                in_q.pop_front(); 

                OutTx* out;
                out = out_q.front();
                out_q.pop_front(); 

                if(in->i_data_A != out->o_data_B){
                    std::cout << "Test Failure!" << std::endl;
                    std::cout << "Expected : " <<  in->i_data_A << std::endl;
                    std::cout << "Got : " << out->o_data_B << std::endl;
                    exit(1);
                } else {
                    std::cout << "Test PASS!" << std::endl;
                    std::cout << "Expected : " <<  in->i_data_A << std::endl;
                    std::cout << "Got : " << out->o_data_B << std::endl;   
                }

                // As the transaction items were allocated on the heap, it's important
                // to free the memory after they have been used
                delete in;    //input monitor transaction
                delete out;    //output monitor transaction
            }
        }
};

// interface driver
class InDrv {
    private:
        // Vrecirculation_mux *dut;
        std::shared_ptr<Vrecirculation_mux> dut;
        int state;
    public:
        InDrv(std::shared_ptr<Vrecirculation_mux> dut){
            this->dut = dut;
            state = 0;
        }

        void drive(InTx *tx, int & new_tx_ready,int is_a_pos,int is_b_pos){

            // Don't drive anything if a transaction item doesn't exist

            switch(state) {
                case 0:
                    if(tx != NULL && is_a_pos == 1){
                        dut->i_pulse_A = 1;
                        dut->i_data_A = tx->i_data_A;

                        new_tx_ready = 0;
                        state = 1;
                        delete tx;
                     }

                    break;
                case 1:
                    if(is_a_pos == 1){
                        dut->i_pulse_A = 0;
                        new_tx_ready = 0;
                        state = 2;
                    }
                    break;
                case 2:
                    if (dut->f_pulse_B == 0 && dut->f_pulse_B_prev ==1 && is_b_pos == 1){
                        state = 0;
                        new_tx_ready = 1;
                    }
                    break;
                default:
                    state = 0;
            }

        }
};

// input interface monitor
class InMon {
    private:
        // Vrecirculation_mux *dut;
        std::shared_ptr<Vrecirculation_mux> dut;
        // Scb *scb;
        std::shared_ptr<Scb>  scb;
        // InCoverage *cvg;
        std::shared_ptr<InCoverage> cvg;
    public:
        InMon(std::shared_ptr<Vrecirculation_mux> dut, std::shared_ptr<Scb>  scb, std::shared_ptr<InCoverage> cvg){
            this->dut = dut;
            this->scb = scb;
            this->cvg = cvg;
        }

        void monitor(int is_b_pos){
            // if(dut->i_valid == 1){
            if(is_b_pos ==1 && dut->f_pulse_B == 1 && dut->f_pulse_B_prev ==0) {
                InTx *tx = new InTx();
                tx->i_data_A = dut->i_data_A;
                // then pass the transaction item to the scoreboard
                scb->writeIn(tx);
                cvg->write_coverage(tx);
            }
        }
};

// ALU output interface monitor
class OutMon {
    private:
        // Vrecirculation_mux *dut;
        std::shared_ptr<Vrecirculation_mux> dut;
        // Scb *scb;
        std::shared_ptr<Scb> scb;
        // OutCoverage *cvg;
        std::shared_ptr<OutCoverage> cvg;
    public:
        OutMon(std::shared_ptr<Vrecirculation_mux> dut, std::shared_ptr<Scb> scb, std::shared_ptr<OutCoverage> cvg){
            this->dut = dut;
            this->scb = scb;
            this->cvg = cvg;
        }

        void monitor(int is_b_pos){
            if(is_b_pos == 1 && dut->f_pulse_B == 0 && dut->f_pulse_B_prev ==1) {
                OutTx *tx = new OutTx();
                tx->o_data_B = dut->o_data_B;

                // then pass the transaction item to the scoreboard
                scb->writeOut(tx);
                cvg->write_coverage(tx);
            }
        }
};

//sequence (transaction generator)
// coverage-driven random transaction generator
// This will allocate memory for an InTx
// transaction item, randomise the data, until it gets
// input values that have yet to be covered and
// return a pointer to the transaction item object
class Sequence{
    private:
        InTx* in;
        // InCoverage *cvg;
        std::shared_ptr<InCoverage> cvg;
    public:
        Sequence(std::shared_ptr<InCoverage> cvg){
            this->cvg = cvg;
        }

        InTx* genTx(int & new_tx_ready){
            in = new InTx();
            // std::shared_ptr<InTx> in(new InTx());
            if(rand()%5 == 0 && new_tx_ready == 1){
                in->i_data_A = rand() % (1 << Vrecirculation_mux_recirculation_mux::G_WIDTH);   

                while(cvg->is_covered(in->i_data_A) == false){
                    in->i_data_A = rand() % (1 << Vrecirculation_mux_recirculation_mux::G_WIDTH);  

                }
                return in;
            } else {
                return NULL;
            }
        }
};


void dut_reset (std::shared_ptr<Vrecirculation_mux> dut, vluint64_t &sim_time){
    dut->i_rst_A = 0;
    dut->i_rst_B = 0;
    if(sim_time >= 3 && sim_time < 6){
        dut->i_rst_A = 1;
        dut->i_rst_B = 1;
    }
}

void simulation_eval(std::shared_ptr<Vrecirculation_mux> dut,VerilatedVcdC *m_trace, vluint64_t & ns)
{
    dut->eval();
    m_trace->dump(ns);
}

void simulation_tick_posedge(VerilatedVcdC *m_trace,char clk_source,std::shared_ptr<Vrecirculation_mux> dut, vluint64_t &ns)
{   
    if (clk_source == 'A'){
        dut->i_clk_A = 1;
    } else {
        dut->i_clk_B = 1;
    }
}

void simulation_tick_negedge(VerilatedVcdC *m_trace,char clk_source,std::shared_ptr<Vrecirculation_mux> dut, vluint64_t &ns)
{
    if (clk_source == 'A'){
        dut->i_clk_A = 0;
    } else {
        dut->i_clk_B = 0;
    }
}


int main(int argc, char** argv, char** env) {
    srand (time(NULL));
    Verilated::commandArgs(argc, argv);
    // Vrecirculation_mux *dut = new Vrecirculation_mux;
    std::shared_ptr<Vrecirculation_mux> dut(new Vrecirculation_mux);

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open("waveform.vcd");

    InTx   *tx;
    int new_tx_ready = 1;

    // Here we create the driver, scoreboard, input and output monitor and coverage blocks
    std::unique_ptr<InDrv> drv(new InDrv(dut));
    std::shared_ptr<Scb> scb(new Scb());
    std::shared_ptr<InCoverage> inCoverage(new InCoverage());
    std::shared_ptr<OutCoverage> outCoverage(new OutCoverage());
    std::unique_ptr<InMon> inMon(new InMon(dut,scb,inCoverage));
    std::unique_ptr<OutMon> outMon(new OutMon(dut,scb,outCoverage));
    std::unique_ptr<Sequence> sequence(new Sequence(inCoverage));

    while (outCoverage->is_full_coverage() == false) {
    // while(sim_time < MAX_SIM_TIME*20) {

        dut_reset(dut,sim_time);



        if (POSEDGE(sim_time, CLK_A_PERIOD, CLK_A_PHASE)) {
                simulation_tick_posedge(m_trace, 'A',dut,sim_time);
        }
        if (NEGEDGE(sim_time, CLK_A_PERIOD, CLK_A_PHASE)) {
                simulation_tick_negedge(m_trace, 'A',dut,sim_time);
        }
        
        if (POSEDGE(sim_time, CLK_B_PERIOD, CLK_B_PHASE)){
                simulation_tick_posedge(m_trace, 'B',dut,sim_time);
        }
        if (NEGEDGE(sim_time, CLK_B_PERIOD, CLK_B_PHASE)) {
                simulation_tick_negedge(m_trace, 'B',dut,sim_time);
        }
        simulation_eval(dut, m_trace, sim_time);


        if (sim_time >= VERIF_START_TIME) {
            // Generate a randomised transaction item 
            tx = sequence->genTx(new_tx_ready);
            // Pass the generated transaction item in the driver
            //to convert it to pin wiggles
            //operation similar to than of a connection between
            //a sequencer and a driver in a UVM tb
            drv->drive(tx,new_tx_ready,POSEDGE(sim_time, CLK_A_PERIOD, CLK_A_PHASE),POSEDGE(sim_time, CLK_B_PERIOD, CLK_B_PHASE));
            // Monitor the input interface
            // also writes recovered transaction to
            // input coverage and scoreboard
            inMon->monitor(POSEDGE(sim_time, CLK_B_PERIOD, CLK_B_PHASE));
            // Monitor the output interface
            // also writes recovered result (out transaction) to
            // output coverage and scoreboard 
            outMon->monitor(POSEDGE(sim_time, CLK_B_PERIOD, CLK_B_PHASE));
        }
        sim_time++;
    }

    scb->checkPhase();
    m_trace->close();  
    exit(EXIT_SUCCESS);
}
