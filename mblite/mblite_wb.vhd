----------------------------------------------------------------------------------------------
--
--      Input file         : core_wb.vhd
--      Design name        : core_wb
--      Author             : Tamar Kranenburg
--      Company            : Delft University of Technology
--                         : Faculty EEMCS, Department ME&CE
--                         : Systems and Circuits group
--
--      Description        : Top level module of the MB-Lite microprocessor with connected
--                           wishbone data bus
--
----------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library mblite;
use mblite.config_Pkg.all;
use mblite.core_Pkg.all;
--use mblite.std_Pkg.all;

entity mblite_wb is generic
(
    G_INTERRUPT  : boolean := CFG_INTERRUPT;
    G_USE_HW_MUL : boolean := CFG_USE_HW_MUL;
    G_USE_BARREL : boolean := CFG_USE_BARREL;
    G_DEBUG      : boolean := CFG_DEBUG
);
port
(
    -- system clock and reset
    clk_i : in std_logic;
    rst_i : in std_logic;
    int_i : in std_logic;
    
    -- instruction memory
    imem_ena_o : out std_logic;
    imem_adr_o : out std_logic_vector(CFG_IMEM_SIZE - 1 downto 0);
    imem_dat_i : in std_logic_vector(CFG_IMEM_WIDTH - 1 downto 0);
    
    -- wishbone data bus
    dwb_cyc_o : out std_logic;
    dwb_stb_o : out std_logic;
    dwb_we_o  : out std_logic;
    dwb_sel_o : out std_logic_vector(3 downto 0);
    dwb_adr_o : out std_logic_vector(CFG_DMEM_SIZE - 1 downto 0);
    dwb_dat_i : in std_logic_vector(CFG_DMEM_WIDTH - 1 downto 0);
    dwb_dat_o : out std_logic_vector(CFG_DMEM_WIDTH - 1 downto 0);
    dwb_ack_i : in std_logic
);
end mblite_wb;

architecture arch of mblite_wb is
    signal dmem_i : dmem_in_type;
    signal dmem_o : dmem_out_type;
    ------
    signal imem_i : imem_in_type;
    signal imem_o : imem_out_type;

    signal wb_i   : wb_mst_in_type;
    signal wb_o   : wb_mst_out_type;    
    
begin

    wb_adapter0 : core_wb_adapter port map
    (
        dmem_i => dmem_i,
        wb_o   => wb_o,
        dmem_o => dmem_o,
        wb_i   => wb_i
    );

    mblite0 : mblite_core generic map
    (
        G_INTERRUPT  => G_INTERRUPT,
        G_USE_HW_MUL => G_USE_HW_MUL,
        G_USE_BARREL => G_USE_BARREL,
        G_DEBUG      => G_DEBUG
    )
    port map
    (
        imem_o => imem_o,
        dmem_o => dmem_o,
        imem_i => imem_i,
        dmem_i => dmem_i,
        int_i  => wb_i.int_i,
        rst_i  => wb_i.rst_i,
        clk_i  => wb_i.clk_i
    );
    
    -- ports signal
    wb_i.clk_i <= clk_i;
    wb_i.rst_i <= rst_i;
    wb_i.int_i <= int_i;
    
    imem_ena_o <= imem_o.ena_o;
    imem_adr_o <= imem_o.adr_o;
    imem_i.dat_i <= imem_dat_i;
    
    -- wishbone bus
    dwb_cyc_o <= wb_o.cyc_o;
    dwb_stb_o <= wb_o.stb_o;
    dwb_we_o  <= wb_o.we_o;
    dwb_sel_o <= wb_o.sel_o;
    dwb_adr_o <= wb_o.adr_o;
    wb_i.dat_i <= dwb_dat_i;
    dwb_dat_o <= wb_o.dat_o;
    wb_i.ack_i <= dwb_ack_i;

    
end arch;
