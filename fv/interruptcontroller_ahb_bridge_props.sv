
module csc_ahb_bridge_prop(
);
//------------------- Includes------------------------------------------------------------------

//-------------------- Macros ------------------------------------------------------------------
//----------------- Global Variables ----------------------------------------------------------




//----------------- Properties ----------------------------------------------------------------

    //The locked transfer is disabled.
    property no_locked_transfer;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HMASTLOCK_i == 0));
    endproperty
//---------------------------------------------------------------------------------------------

    //A new transaction starts as non-sequential.
    property transfer_start_non_seq;
    @(posedge InterruptController.HCLK_i)
        ( $rose((InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HTRANS_i == 2'b10)) 
	|->
	  $past((InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HTRANS_i == 2'b00)));
    endproperty
//---------------------------------------------------------------------------------------------

    //Burst starts after nonseq transfer.
    property burst_after_non_seq;
    @(posedge InterruptController.HCLK_i)
        (( (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HSEL_i == 1) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HREADY_i == 1) && 
	 ( $rose((InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HTRANS_i == 2'b01)) ||  $rose((InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HTRANS_i == 2'b11))) ) 
	|->
	  $past(( (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HSEL_i == 1) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HREADY_i == 1) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HTRANS_i == 2'b10) )));
    endproperty
//---------------------------------------------------------------------------------------------

    //Burst transfer occurs only if HSEL was high in the previous cycle.
    property hsel_high_during_burst;
    @(posedge InterruptController.HCLK_i)
        (( (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HSEL_i == 1) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HREADY_i == 1) && 
	 ((InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HTRANS_i == 2'b01) || (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HTRANS_i == 2'b11)) ) 
	|->
	  $past((InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HSEL_i == 1)));
    endproperty
//---------------------------------------------------------------------------------------------

    //Bus must be idle immediately after reset..
    property idle_after_reset;
    @(posedge InterruptController.HCLK_i)
        ( $past(( ~InterruptController.HRESET_n_i)) 
	|->
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HTRANS_i == 2'b00));
    endproperty
//---------------------------------------------------------------------------------------------

    //The csc must not signal a CSC error when no access enable is asserted.
    property no_csc_error_when_no_access_en;
    @(posedge InterruptController.HCLK_i)
    disable iff(!InterruptController.HRESET_n_i)
        ((InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.rai_per_acc_en_o == 0) 
	|->
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.rai_per_err_i == 0));
    endproperty
//---------------------------------------------------------------------------------------------

    //HREADYIN must follow HREADYOUT after a transaction.
    property hreadyin_hreadyout_data_phase;
    @(posedge InterruptController.HCLK_i)
    disable iff(!InterruptController.HRESET_n_i)
        (( (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HSEL_i == 1) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HREADY_i == 1) && 
	 ( ~(InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HTRANS_i == 2'b00)) ) 
	|->
	  ##1
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HREADY_i == InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HREADYOUT_o) );
    endproperty
//---------------------------------------------------------------------------------------------

    //The slave must put high after reset.
    property ready_after_reset;
    @(posedge InterruptController.HCLK_i)
    disable iff(!InterruptController.HRESET_n_i)
        ( $past(( ~InterruptController.HRESET_n_i)) 
	|->
	 InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HREADYOUT_o);
    endproperty
//---------------------------------------------------------------------------------------------

    //hresp is low after reset.
    property hresp_after_reset;
    @(posedge InterruptController.HCLK_i)
    disable iff(!InterruptController.HRESET_n_i)
        ( $past(( ~InterruptController.HRESET_n_i)) 
	|->
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HRESP_o == 0));
    endproperty
//---------------------------------------------------------------------------------------------

    //acc_en is low after reset.
    property acc_en_after_reset;
    @(posedge InterruptController.HCLK_i)
    disable iff(!InterruptController.HRESET_n_i)
        ( $past(( ~InterruptController.HRESET_n_i)) 
	|->
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.rai_per_acc_en_o == 0));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Top_CSC data_in connectivity from bridge write data.
    property bridge_csc_data_in_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.comp_Top_CSC.DefaultInterface_data_in == InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.rai_per_wdata_o));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Top_CSC addr connectivity from bridge address.
    property bridge_csc_addr_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.comp_Top_CSC.DefaultInterface_addr == (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.bridge_fsm_haddr_reg_Outp_out_out[15:0])));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Top_CSC AccessSize connectivity from bridge csc_access_size_o.
    property bridge_csc_access_size_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.comp_Top_CSC.DefaultInterface_AccessSize == InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.csc_access_size_o));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Top_CSC wr_en boolean connectivity from bridge acc_en and wr_en.
    property bridge_csc_wr_en_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.comp_Top_CSC.DefaultInterface_wr_en == ( InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.rai_per_acc_en_o && 
	 InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.rai_per_wr_en_o )));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Top_CSC rd_en boolean connectivity from bridge acc_en and wr_en.
    property bridge_csc_rd_en_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.comp_Top_CSC.DefaultInterface_rd_en == ( InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.rai_per_acc_en_o && 
	 ( ~InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.rai_per_wr_en_o) )));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check bridge rai_per_rdata_i connectivity from Top_CSC data_out.
    property bridge_csc_rdata_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.rai_per_rdata_i == InterruptController.comp_Reg_IF.comp_Top_CSC.DefaultInterface_data_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check bridge rai_per_ack_i connectivity for always high.
    property bridge_rai_ack_i_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.rai_per_ack_i == 1));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check bridge rai_per_err_i connectivity for always low.
    property bridge_rai_err_i_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.rai_per_err_i == InterruptController.comp_Reg_IF.comp_Top_CSC.DefaultInterface_error));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Top_CSC reset connectivity from Inverter_s.
    property bridge_csc_reset_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.comp_Top_CSC.HRESET_n_i == InterruptController.HRESET_n_i));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check bridge HADDR_i connectivity from Register Interface AHB haddr.
    property bridge_regif_haddr_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HADDR_i == InterruptController.comp_Reg_IF. SX_AHB_HADDR));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check bridge HWDATA_i connectivity from Register Interface AHB hwdata.
    property bridge_regif_hwdata_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HWDATA_i == InterruptController.comp_Reg_IF.SX_AHB_HWDATA));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check bridge HBURST_i connectivity from Register Interface AHB hburst.
    property bridge_regif_hburst_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HBURST_i == InterruptController.comp_Reg_IF.SX_AHB_HBURST));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check bridge HMASTLOCK_i connectivity from Register Interface  AHB hmastlock.
    property bridge_regif_hmastlock_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HMASTLOCK_i == InterruptController.comp_Reg_IF.SX_AHB_HMASTLOCK));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check bridge HPROT_i connectivity from Register Interface AHB hprot.
    property bridge_regif_hprot_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HPROT_i == InterruptController.comp_Reg_IF.SX_AHB_HPROT));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check bridge HSIZE_i connectivity from Register Interface  AHB hsize.
    property bridge_regif_hsize_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HSIZE_i == InterruptController.comp_Reg_IF.SX_AHB_HSIZE));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check bridge HTRANS_i connectivity from Register Interface  AHB htrans.
    property bridge_regif_htrans_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HTRANS_i == InterruptController.comp_Reg_IF.SX_AHB_HTRANS));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check bridge HWRITE_i connectivity from Register Interface  AHB hwrite.
    property bridge_regif_hwrite_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HWRITE_i == InterruptController.comp_Reg_IF.SX_AHB_HWRITE));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check bridge HSEL_i connectivity from Register Interface  AHB hsel.
    property bridge_regif_hsel_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HSEL_i == InterruptController.comp_Reg_IF.SX_AHB_HSEL));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check bridge HREADY_i connectivity from Register Interface AHB hready.
    property bridge_regif_hready_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HREADY_i == InterruptController.comp_Reg_IF.SX_AHB_HREADY));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check bridge HRDATA_o connectivity to Register Interface AHB hrdata.
    property bridge_regif_hrdata_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HRDATA_o == InterruptController.comp_Reg_IF.SX_AHB_HRDATA));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check bridge HREADYOUT_o connectivity to Register Interface AHB hreadyout.
    property bridge_regif_hreadyout_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HREADYOUT_o == InterruptController.comp_Reg_IF.SX_AHB_HREADYOUT));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check bridge HRESP_o connectivity to Register Interface AHB hresp.
    property bridge_regif_hresp_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HRESP_o == InterruptController.comp_Reg_IF.SX_AHB_HRESP));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_0_o is wired from Top_CSC BF enable_enable_int_0_out.
    property reg_if_hw_out_enable_enable_int_0_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_0_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_enable_int_0_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_1_o is wired from Top_CSC BF enable_enable_int_1_out.
    property reg_if_hw_out_enable_enable_int_1_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_1_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_enable_int_1_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_2_o is wired from Top_CSC BF enable_enable_int_2_out.
    property reg_if_hw_out_enable_enable_int_2_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_2_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_enable_int_2_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_3_o is wired from Top_CSC BF enable_enable_int_3_out.
    property reg_if_hw_out_enable_enable_int_3_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_3_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_enable_int_3_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_4_o is wired from Top_CSC BF enable_enable_int_4_out.
    property reg_if_hw_out_enable_enable_int_4_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_4_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_enable_int_4_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_5_o is wired from Top_CSC BF enable_enable_int_5_out.
    property reg_if_hw_out_enable_enable_int_5_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_5_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_enable_int_5_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_6_o is wired from Top_CSC BF enable_enable_int_6_out.
    property reg_if_hw_out_enable_enable_int_6_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_6_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_enable_int_6_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_7_o is wired from Top_CSC BF enable_enable_int_7_out.
    property reg_if_hw_out_enable_enable_int_7_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_7_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_enable_int_7_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_8_o is wired from Top_CSC BF enable_enable_int_8_out.
    property reg_if_hw_out_enable_enable_int_8_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_8_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_enable_int_8_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_9_o is wired from Top_CSC BF enable_enable_int_9_out.
    property reg_if_hw_out_enable_enable_int_9_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_9_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_enable_int_9_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_10_o is wired from Top_CSC BF enable_enable_int_10_out.
    property reg_if_hw_out_enable_enable_int_10_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_10_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_enable_int_10_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_11_o is wired from Top_CSC BF enable_enable_int_11_out.
    property reg_if_hw_out_enable_enable_int_11_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_11_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_enable_int_11_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_12_o is wired from Top_CSC BF enable_enable_int_12_out.
    property reg_if_hw_out_enable_enable_int_12_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_12_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_enable_int_12_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_13_o is wired from Top_CSC BF enable_enable_int_13_out.
    property reg_if_hw_out_enable_enable_int_13_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_13_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_enable_int_13_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_14_o is wired from Top_CSC BF enable_enable_int_14_out.
    property reg_if_hw_out_enable_enable_int_14_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_14_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_enable_int_14_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_15_o is wired from Top_CSC BF enable_enable_int_15_out.
    property reg_if_hw_out_enable_enable_int_15_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_15_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_enable_int_15_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_16_o is wired from Top_CSC BF enable_enable_int_16_out.
    property reg_if_hw_out_enable_enable_int_16_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_16_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_enable_int_16_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_17_o is wired from Top_CSC BF enable_enable_int_17_out.
    property reg_if_hw_out_enable_enable_int_17_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_17_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_enable_int_17_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_18_o is wired from Top_CSC BF enable_enable_int_18_out.
    property reg_if_hw_out_enable_enable_int_18_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_18_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_enable_int_18_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_19_o is wired from Top_CSC BF enable_enable_int_19_out.
    property reg_if_hw_out_enable_enable_int_19_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_19_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_enable_int_19_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_20_o is wired from Top_CSC BF enable_enable_int_20_out.
    property reg_if_hw_out_enable_enable_int_20_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_20_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_enable_int_20_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_21_o is wired from Top_CSC BF enable_enable_int_21_out.
    property reg_if_hw_out_enable_enable_int_21_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_21_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_enable_int_21_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_22_o is wired from Top_CSC BF enable_enable_int_22_out.
    property reg_if_hw_out_enable_enable_int_22_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_22_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_enable_int_22_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_23_o is wired from Top_CSC BF enable_enable_int_23_out.
    property reg_if_hw_out_enable_enable_int_23_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_23_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_enable_int_23_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_24_o is wired from Top_CSC BF enable_enable_int_24_out.
    property reg_if_hw_out_enable_enable_int_24_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_24_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_enable_int_24_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_25_o is wired from Top_CSC BF enable_enable_int_25_out.
    property reg_if_hw_out_enable_enable_int_25_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_25_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_enable_int_25_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_26_o is wired from Top_CSC BF enable_enable_int_26_out.
    property reg_if_hw_out_enable_enable_int_26_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_26_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_enable_int_26_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_27_o is wired from Top_CSC BF enable_enable_int_27_out.
    property reg_if_hw_out_enable_enable_int_27_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_27_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_enable_int_27_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_28_o is wired from Top_CSC BF enable_enable_int_28_out.
    property reg_if_hw_out_enable_enable_int_28_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_28_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_enable_int_28_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_29_o is wired from Top_CSC BF enable_enable_int_29_out.
    property reg_if_hw_out_enable_enable_int_29_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_29_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_enable_int_29_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_30_o is wired from Top_CSC BF enable_enable_int_30_out.
    property reg_if_hw_out_enable_enable_int_30_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_30_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_enable_int_30_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_31_o is wired from Top_CSC BF enable_enable_int_31_out.
    property reg_if_hw_out_enable_enable_int_31_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_31_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_enable_int_31_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_0_o is wired from Top_CSC BF unmask_unmask_int_0_out.
    property reg_if_hw_out_unmask_unmask_int_0_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_0_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_unmask_int_0_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_1_o is wired from Top_CSC BF unmask_unmask_int_1_out.
    property reg_if_hw_out_unmask_unmask_int_1_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_1_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_unmask_int_1_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_2_o is wired from Top_CSC BF unmask_unmask_int_2_out.
    property reg_if_hw_out_unmask_unmask_int_2_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_2_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_unmask_int_2_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_3_o is wired from Top_CSC BF unmask_unmask_int_3_out.
    property reg_if_hw_out_unmask_unmask_int_3_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_3_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_unmask_int_3_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_4_o is wired from Top_CSC BF unmask_unmask_int_4_out.
    property reg_if_hw_out_unmask_unmask_int_4_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_4_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_unmask_int_4_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_5_o is wired from Top_CSC BF unmask_unmask_int_5_out.
    property reg_if_hw_out_unmask_unmask_int_5_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_5_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_unmask_int_5_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_6_o is wired from Top_CSC BF unmask_unmask_int_6_out.
    property reg_if_hw_out_unmask_unmask_int_6_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_6_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_unmask_int_6_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_7_o is wired from Top_CSC BF unmask_unmask_int_7_out.
    property reg_if_hw_out_unmask_unmask_int_7_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_7_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_unmask_int_7_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_8_o is wired from Top_CSC BF unmask_unmask_int_8_out.
    property reg_if_hw_out_unmask_unmask_int_8_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_8_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_unmask_int_8_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_9_o is wired from Top_CSC BF unmask_unmask_int_9_out.
    property reg_if_hw_out_unmask_unmask_int_9_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_9_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_unmask_int_9_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_10_o is wired from Top_CSC BF unmask_unmask_int_10_out.
    property reg_if_hw_out_unmask_unmask_int_10_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_10_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_unmask_int_10_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_11_o is wired from Top_CSC BF unmask_unmask_int_11_out.
    property reg_if_hw_out_unmask_unmask_int_11_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_11_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_unmask_int_11_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_12_o is wired from Top_CSC BF unmask_unmask_int_12_out.
    property reg_if_hw_out_unmask_unmask_int_12_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_12_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_unmask_int_12_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_13_o is wired from Top_CSC BF unmask_unmask_int_13_out.
    property reg_if_hw_out_unmask_unmask_int_13_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_13_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_unmask_int_13_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_14_o is wired from Top_CSC BF unmask_unmask_int_14_out.
    property reg_if_hw_out_unmask_unmask_int_14_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_14_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_unmask_int_14_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_15_o is wired from Top_CSC BF unmask_unmask_int_15_out.
    property reg_if_hw_out_unmask_unmask_int_15_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_15_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_unmask_int_15_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_16_o is wired from Top_CSC BF unmask_unmask_int_16_out.
    property reg_if_hw_out_unmask_unmask_int_16_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_16_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_unmask_int_16_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_17_o is wired from Top_CSC BF unmask_unmask_int_17_out.
    property reg_if_hw_out_unmask_unmask_int_17_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_17_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_unmask_int_17_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_18_o is wired from Top_CSC BF unmask_unmask_int_18_out.
    property reg_if_hw_out_unmask_unmask_int_18_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_18_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_unmask_int_18_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_19_o is wired from Top_CSC BF unmask_unmask_int_19_out.
    property reg_if_hw_out_unmask_unmask_int_19_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_19_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_unmask_int_19_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_20_o is wired from Top_CSC BF unmask_unmask_int_20_out.
    property reg_if_hw_out_unmask_unmask_int_20_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_20_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_unmask_int_20_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_21_o is wired from Top_CSC BF unmask_unmask_int_21_out.
    property reg_if_hw_out_unmask_unmask_int_21_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_21_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_unmask_int_21_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_22_o is wired from Top_CSC BF unmask_unmask_int_22_out.
    property reg_if_hw_out_unmask_unmask_int_22_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_22_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_unmask_int_22_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_23_o is wired from Top_CSC BF unmask_unmask_int_23_out.
    property reg_if_hw_out_unmask_unmask_int_23_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_23_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_unmask_int_23_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_24_o is wired from Top_CSC BF unmask_unmask_int_24_out.
    property reg_if_hw_out_unmask_unmask_int_24_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_24_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_unmask_int_24_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_25_o is wired from Top_CSC BF unmask_unmask_int_25_out.
    property reg_if_hw_out_unmask_unmask_int_25_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_25_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_unmask_int_25_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_26_o is wired from Top_CSC BF unmask_unmask_int_26_out.
    property reg_if_hw_out_unmask_unmask_int_26_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_26_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_unmask_int_26_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_27_o is wired from Top_CSC BF unmask_unmask_int_27_out.
    property reg_if_hw_out_unmask_unmask_int_27_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_27_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_unmask_int_27_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_28_o is wired from Top_CSC BF unmask_unmask_int_28_out.
    property reg_if_hw_out_unmask_unmask_int_28_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_28_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_unmask_int_28_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_29_o is wired from Top_CSC BF unmask_unmask_int_29_out.
    property reg_if_hw_out_unmask_unmask_int_29_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_29_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_unmask_int_29_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_30_o is wired from Top_CSC BF unmask_unmask_int_30_out.
    property reg_if_hw_out_unmask_unmask_int_30_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_30_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_unmask_int_30_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_31_o is wired from Top_CSC BF unmask_unmask_int_31_out.
    property reg_if_hw_out_unmask_unmask_int_31_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_31_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_unmask_int_31_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_0_i is wired to Top_CSC BF pending_pending_int_0_in.
    property reg_if_hw_in_pending_pending_int_0_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_0_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_0_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_0_en_i is wired to Top_CSC BF pending_pending_int_0_peripheral_wr_en.
    property reg_if_hw_en_pending_pending_int_0_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_0_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_0_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_0_o is wired from Top_CSC BF pending_pending_int_0_out.
    property reg_if_hw_out_pending_pending_int_0_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_0_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_0_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_1_i is wired to Top_CSC BF pending_pending_int_1_in.
    property reg_if_hw_in_pending_pending_int_1_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_1_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_1_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_1_en_i is wired to Top_CSC BF pending_pending_int_1_peripheral_wr_en.
    property reg_if_hw_en_pending_pending_int_1_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_1_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_1_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_1_o is wired from Top_CSC BF pending_pending_int_1_out.
    property reg_if_hw_out_pending_pending_int_1_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_1_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_1_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_2_i is wired to Top_CSC BF pending_pending_int_2_in.
    property reg_if_hw_in_pending_pending_int_2_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_2_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_2_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_2_en_i is wired to Top_CSC BF pending_pending_int_2_peripheral_wr_en.
    property reg_if_hw_en_pending_pending_int_2_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_2_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_2_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_2_o is wired from Top_CSC BF pending_pending_int_2_out.
    property reg_if_hw_out_pending_pending_int_2_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_2_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_2_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_3_i is wired to Top_CSC BF pending_pending_int_3_in.
    property reg_if_hw_in_pending_pending_int_3_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_3_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_3_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_3_en_i is wired to Top_CSC BF pending_pending_int_3_peripheral_wr_en.
    property reg_if_hw_en_pending_pending_int_3_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_3_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_3_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_3_o is wired from Top_CSC BF pending_pending_int_3_out.
    property reg_if_hw_out_pending_pending_int_3_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_3_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_3_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_4_i is wired to Top_CSC BF pending_pending_int_4_in.
    property reg_if_hw_in_pending_pending_int_4_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_4_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_4_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_4_en_i is wired to Top_CSC BF pending_pending_int_4_peripheral_wr_en.
    property reg_if_hw_en_pending_pending_int_4_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_4_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_4_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_4_o is wired from Top_CSC BF pending_pending_int_4_out.
    property reg_if_hw_out_pending_pending_int_4_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_4_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_4_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_5_i is wired to Top_CSC BF pending_pending_int_5_in.
    property reg_if_hw_in_pending_pending_int_5_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_5_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_5_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_5_en_i is wired to Top_CSC BF pending_pending_int_5_peripheral_wr_en.
    property reg_if_hw_en_pending_pending_int_5_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_5_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_5_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_5_o is wired from Top_CSC BF pending_pending_int_5_out.
    property reg_if_hw_out_pending_pending_int_5_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_5_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_5_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_6_i is wired to Top_CSC BF pending_pending_int_6_in.
    property reg_if_hw_in_pending_pending_int_6_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_6_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_6_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_6_en_i is wired to Top_CSC BF pending_pending_int_6_peripheral_wr_en.
    property reg_if_hw_en_pending_pending_int_6_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_6_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_6_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_6_o is wired from Top_CSC BF pending_pending_int_6_out.
    property reg_if_hw_out_pending_pending_int_6_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_6_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_6_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_7_i is wired to Top_CSC BF pending_pending_int_7_in.
    property reg_if_hw_in_pending_pending_int_7_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_7_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_7_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_7_en_i is wired to Top_CSC BF pending_pending_int_7_peripheral_wr_en.
    property reg_if_hw_en_pending_pending_int_7_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_7_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_7_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_7_o is wired from Top_CSC BF pending_pending_int_7_out.
    property reg_if_hw_out_pending_pending_int_7_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_7_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_7_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_8_i is wired to Top_CSC BF pending_pending_int_8_in.
    property reg_if_hw_in_pending_pending_int_8_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_8_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_8_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_8_en_i is wired to Top_CSC BF pending_pending_int_8_peripheral_wr_en.
    property reg_if_hw_en_pending_pending_int_8_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_8_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_8_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_8_o is wired from Top_CSC BF pending_pending_int_8_out.
    property reg_if_hw_out_pending_pending_int_8_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_8_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_8_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_9_i is wired to Top_CSC BF pending_pending_int_9_in.
    property reg_if_hw_in_pending_pending_int_9_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_9_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_9_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_9_en_i is wired to Top_CSC BF pending_pending_int_9_peripheral_wr_en.
    property reg_if_hw_en_pending_pending_int_9_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_9_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_9_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_9_o is wired from Top_CSC BF pending_pending_int_9_out.
    property reg_if_hw_out_pending_pending_int_9_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_9_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_9_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_10_i is wired to Top_CSC BF pending_pending_int_10_in.
    property reg_if_hw_in_pending_pending_int_10_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_10_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_10_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_10_en_i is wired to Top_CSC BF pending_pending_int_10_peripheral_wr_en.
    property reg_if_hw_en_pending_pending_int_10_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_10_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_10_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_10_o is wired from Top_CSC BF pending_pending_int_10_out.
    property reg_if_hw_out_pending_pending_int_10_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_10_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_10_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_11_i is wired to Top_CSC BF pending_pending_int_11_in.
    property reg_if_hw_in_pending_pending_int_11_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_11_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_11_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_11_en_i is wired to Top_CSC BF pending_pending_int_11_peripheral_wr_en.
    property reg_if_hw_en_pending_pending_int_11_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_11_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_11_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_11_o is wired from Top_CSC BF pending_pending_int_11_out.
    property reg_if_hw_out_pending_pending_int_11_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_11_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_11_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_12_i is wired to Top_CSC BF pending_pending_int_12_in.
    property reg_if_hw_in_pending_pending_int_12_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_12_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_12_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_12_en_i is wired to Top_CSC BF pending_pending_int_12_peripheral_wr_en.
    property reg_if_hw_en_pending_pending_int_12_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_12_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_12_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_12_o is wired from Top_CSC BF pending_pending_int_12_out.
    property reg_if_hw_out_pending_pending_int_12_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_12_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_12_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_13_i is wired to Top_CSC BF pending_pending_int_13_in.
    property reg_if_hw_in_pending_pending_int_13_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_13_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_13_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_13_en_i is wired to Top_CSC BF pending_pending_int_13_peripheral_wr_en.
    property reg_if_hw_en_pending_pending_int_13_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_13_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_13_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_13_o is wired from Top_CSC BF pending_pending_int_13_out.
    property reg_if_hw_out_pending_pending_int_13_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_13_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_13_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_14_i is wired to Top_CSC BF pending_pending_int_14_in.
    property reg_if_hw_in_pending_pending_int_14_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_14_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_14_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_14_en_i is wired to Top_CSC BF pending_pending_int_14_peripheral_wr_en.
    property reg_if_hw_en_pending_pending_int_14_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_14_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_14_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_14_o is wired from Top_CSC BF pending_pending_int_14_out.
    property reg_if_hw_out_pending_pending_int_14_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_14_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_14_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_15_i is wired to Top_CSC BF pending_pending_int_15_in.
    property reg_if_hw_in_pending_pending_int_15_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_15_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_15_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_15_en_i is wired to Top_CSC BF pending_pending_int_15_peripheral_wr_en.
    property reg_if_hw_en_pending_pending_int_15_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_15_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_15_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_15_o is wired from Top_CSC BF pending_pending_int_15_out.
    property reg_if_hw_out_pending_pending_int_15_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_15_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_15_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_16_i is wired to Top_CSC BF pending_pending_int_16_in.
    property reg_if_hw_in_pending_pending_int_16_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_16_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_16_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_16_en_i is wired to Top_CSC BF pending_pending_int_16_peripheral_wr_en.
    property reg_if_hw_en_pending_pending_int_16_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_16_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_16_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_16_o is wired from Top_CSC BF pending_pending_int_16_out.
    property reg_if_hw_out_pending_pending_int_16_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_16_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_16_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_17_i is wired to Top_CSC BF pending_pending_int_17_in.
    property reg_if_hw_in_pending_pending_int_17_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_17_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_17_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_17_en_i is wired to Top_CSC BF pending_pending_int_17_peripheral_wr_en.
    property reg_if_hw_en_pending_pending_int_17_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_17_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_17_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_17_o is wired from Top_CSC BF pending_pending_int_17_out.
    property reg_if_hw_out_pending_pending_int_17_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_17_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_17_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_18_i is wired to Top_CSC BF pending_pending_int_18_in.
    property reg_if_hw_in_pending_pending_int_18_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_18_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_18_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_18_en_i is wired to Top_CSC BF pending_pending_int_18_peripheral_wr_en.
    property reg_if_hw_en_pending_pending_int_18_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_18_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_18_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_18_o is wired from Top_CSC BF pending_pending_int_18_out.
    property reg_if_hw_out_pending_pending_int_18_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_18_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_18_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_19_i is wired to Top_CSC BF pending_pending_int_19_in.
    property reg_if_hw_in_pending_pending_int_19_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_19_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_19_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_19_en_i is wired to Top_CSC BF pending_pending_int_19_peripheral_wr_en.
    property reg_if_hw_en_pending_pending_int_19_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_19_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_19_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_19_o is wired from Top_CSC BF pending_pending_int_19_out.
    property reg_if_hw_out_pending_pending_int_19_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_19_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_19_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_20_i is wired to Top_CSC BF pending_pending_int_20_in.
    property reg_if_hw_in_pending_pending_int_20_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_20_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_20_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_20_en_i is wired to Top_CSC BF pending_pending_int_20_peripheral_wr_en.
    property reg_if_hw_en_pending_pending_int_20_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_20_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_20_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_20_o is wired from Top_CSC BF pending_pending_int_20_out.
    property reg_if_hw_out_pending_pending_int_20_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_20_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_20_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_21_i is wired to Top_CSC BF pending_pending_int_21_in.
    property reg_if_hw_in_pending_pending_int_21_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_21_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_21_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_21_en_i is wired to Top_CSC BF pending_pending_int_21_peripheral_wr_en.
    property reg_if_hw_en_pending_pending_int_21_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_21_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_21_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_21_o is wired from Top_CSC BF pending_pending_int_21_out.
    property reg_if_hw_out_pending_pending_int_21_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_21_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_21_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_22_i is wired to Top_CSC BF pending_pending_int_22_in.
    property reg_if_hw_in_pending_pending_int_22_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_22_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_22_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_22_en_i is wired to Top_CSC BF pending_pending_int_22_peripheral_wr_en.
    property reg_if_hw_en_pending_pending_int_22_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_22_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_22_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_22_o is wired from Top_CSC BF pending_pending_int_22_out.
    property reg_if_hw_out_pending_pending_int_22_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_22_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_22_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_23_i is wired to Top_CSC BF pending_pending_int_23_in.
    property reg_if_hw_in_pending_pending_int_23_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_23_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_23_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_23_en_i is wired to Top_CSC BF pending_pending_int_23_peripheral_wr_en.
    property reg_if_hw_en_pending_pending_int_23_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_23_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_23_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_23_o is wired from Top_CSC BF pending_pending_int_23_out.
    property reg_if_hw_out_pending_pending_int_23_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_23_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_23_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_24_i is wired to Top_CSC BF pending_pending_int_24_in.
    property reg_if_hw_in_pending_pending_int_24_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_24_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_24_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_24_en_i is wired to Top_CSC BF pending_pending_int_24_peripheral_wr_en.
    property reg_if_hw_en_pending_pending_int_24_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_24_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_24_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_24_o is wired from Top_CSC BF pending_pending_int_24_out.
    property reg_if_hw_out_pending_pending_int_24_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_24_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_24_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_25_i is wired to Top_CSC BF pending_pending_int_25_in.
    property reg_if_hw_in_pending_pending_int_25_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_25_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_25_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_25_en_i is wired to Top_CSC BF pending_pending_int_25_peripheral_wr_en.
    property reg_if_hw_en_pending_pending_int_25_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_25_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_25_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_25_o is wired from Top_CSC BF pending_pending_int_25_out.
    property reg_if_hw_out_pending_pending_int_25_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_25_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_25_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_26_i is wired to Top_CSC BF pending_pending_int_26_in.
    property reg_if_hw_in_pending_pending_int_26_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_26_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_26_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_26_en_i is wired to Top_CSC BF pending_pending_int_26_peripheral_wr_en.
    property reg_if_hw_en_pending_pending_int_26_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_26_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_26_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_26_o is wired from Top_CSC BF pending_pending_int_26_out.
    property reg_if_hw_out_pending_pending_int_26_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_26_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_26_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_27_i is wired to Top_CSC BF pending_pending_int_27_in.
    property reg_if_hw_in_pending_pending_int_27_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_27_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_27_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_27_en_i is wired to Top_CSC BF pending_pending_int_27_peripheral_wr_en.
    property reg_if_hw_en_pending_pending_int_27_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_27_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_27_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_27_o is wired from Top_CSC BF pending_pending_int_27_out.
    property reg_if_hw_out_pending_pending_int_27_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_27_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_27_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_28_i is wired to Top_CSC BF pending_pending_int_28_in.
    property reg_if_hw_in_pending_pending_int_28_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_28_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_28_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_28_en_i is wired to Top_CSC BF pending_pending_int_28_peripheral_wr_en.
    property reg_if_hw_en_pending_pending_int_28_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_28_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_28_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_28_o is wired from Top_CSC BF pending_pending_int_28_out.
    property reg_if_hw_out_pending_pending_int_28_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_28_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_28_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_29_i is wired to Top_CSC BF pending_pending_int_29_in.
    property reg_if_hw_in_pending_pending_int_29_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_29_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_29_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_29_en_i is wired to Top_CSC BF pending_pending_int_29_peripheral_wr_en.
    property reg_if_hw_en_pending_pending_int_29_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_29_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_29_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_29_o is wired from Top_CSC BF pending_pending_int_29_out.
    property reg_if_hw_out_pending_pending_int_29_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_29_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_29_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_30_i is wired to Top_CSC BF pending_pending_int_30_in.
    property reg_if_hw_in_pending_pending_int_30_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_30_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_30_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_30_en_i is wired to Top_CSC BF pending_pending_int_30_peripheral_wr_en.
    property reg_if_hw_en_pending_pending_int_30_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_30_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_30_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_30_o is wired from Top_CSC BF pending_pending_int_30_out.
    property reg_if_hw_out_pending_pending_int_30_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_30_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_30_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_31_i is wired to Top_CSC BF pending_pending_int_31_in.
    property reg_if_hw_in_pending_pending_int_31_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_31_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_31_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_31_en_i is wired to Top_CSC BF pending_pending_int_31_peripheral_wr_en.
    property reg_if_hw_en_pending_pending_int_31_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_31_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_31_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_31_o is wired from Top_CSC BF pending_pending_int_31_out.
    property reg_if_hw_out_pending_pending_int_31_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_31_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_int_31_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_1_pending_NMI_i is wired to Top_CSC BF pending_1_pending_NMI_in.
    property reg_if_hw_in_pending_1_pending_NMI_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_NMI_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_NMI_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_1_pending_NMI_en_i is wired to Top_CSC BF pending_1_pending_NMI_peripheral_wr_en.
    property reg_if_hw_en_pending_1_pending_NMI_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_NMI_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_NMI_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_1_pending_NMI_o is wired from Top_CSC BF pending_1_pending_NMI_out.
    property reg_if_hw_out_pending_1_pending_NMI_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_NMI_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_pending_NMI_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_0_i is wired to Top_CSC BF active_active_int_0_in.
    property reg_if_hw_in_active_active_int_0_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_0_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_0_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_0_en_i is wired to Top_CSC BF active_active_int_0_peripheral_wr_en.
    property reg_if_hw_en_active_active_int_0_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_0_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_0_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_0_o is wired from Top_CSC BF active_active_int_0_out.
    property reg_if_hw_out_active_active_int_0_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_0_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_0_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_1_i is wired to Top_CSC BF active_active_int_1_in.
    property reg_if_hw_in_active_active_int_1_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_1_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_1_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_1_en_i is wired to Top_CSC BF active_active_int_1_peripheral_wr_en.
    property reg_if_hw_en_active_active_int_1_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_1_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_1_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_1_o is wired from Top_CSC BF active_active_int_1_out.
    property reg_if_hw_out_active_active_int_1_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_1_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_1_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_2_i is wired to Top_CSC BF active_active_int_2_in.
    property reg_if_hw_in_active_active_int_2_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_2_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_2_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_2_en_i is wired to Top_CSC BF active_active_int_2_peripheral_wr_en.
    property reg_if_hw_en_active_active_int_2_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_2_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_2_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_2_o is wired from Top_CSC BF active_active_int_2_out.
    property reg_if_hw_out_active_active_int_2_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_2_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_2_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_3_i is wired to Top_CSC BF active_active_int_3_in.
    property reg_if_hw_in_active_active_int_3_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_3_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_3_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_3_en_i is wired to Top_CSC BF active_active_int_3_peripheral_wr_en.
    property reg_if_hw_en_active_active_int_3_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_3_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_3_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_3_o is wired from Top_CSC BF active_active_int_3_out.
    property reg_if_hw_out_active_active_int_3_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_3_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_3_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_4_i is wired to Top_CSC BF active_active_int_4_in.
    property reg_if_hw_in_active_active_int_4_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_4_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_4_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_4_en_i is wired to Top_CSC BF active_active_int_4_peripheral_wr_en.
    property reg_if_hw_en_active_active_int_4_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_4_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_4_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_4_o is wired from Top_CSC BF active_active_int_4_out.
    property reg_if_hw_out_active_active_int_4_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_4_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_4_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_5_i is wired to Top_CSC BF active_active_int_5_in.
    property reg_if_hw_in_active_active_int_5_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_5_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_5_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_5_en_i is wired to Top_CSC BF active_active_int_5_peripheral_wr_en.
    property reg_if_hw_en_active_active_int_5_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_5_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_5_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_5_o is wired from Top_CSC BF active_active_int_5_out.
    property reg_if_hw_out_active_active_int_5_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_5_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_5_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_6_i is wired to Top_CSC BF active_active_int_6_in.
    property reg_if_hw_in_active_active_int_6_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_6_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_6_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_6_en_i is wired to Top_CSC BF active_active_int_6_peripheral_wr_en.
    property reg_if_hw_en_active_active_int_6_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_6_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_6_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_6_o is wired from Top_CSC BF active_active_int_6_out.
    property reg_if_hw_out_active_active_int_6_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_6_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_6_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_7_i is wired to Top_CSC BF active_active_int_7_in.
    property reg_if_hw_in_active_active_int_7_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_7_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_7_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_7_en_i is wired to Top_CSC BF active_active_int_7_peripheral_wr_en.
    property reg_if_hw_en_active_active_int_7_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_7_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_7_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_7_o is wired from Top_CSC BF active_active_int_7_out.
    property reg_if_hw_out_active_active_int_7_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_7_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_7_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_8_i is wired to Top_CSC BF active_active_int_8_in.
    property reg_if_hw_in_active_active_int_8_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_8_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_8_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_8_en_i is wired to Top_CSC BF active_active_int_8_peripheral_wr_en.
    property reg_if_hw_en_active_active_int_8_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_8_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_8_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_8_o is wired from Top_CSC BF active_active_int_8_out.
    property reg_if_hw_out_active_active_int_8_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_8_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_8_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_9_i is wired to Top_CSC BF active_active_int_9_in.
    property reg_if_hw_in_active_active_int_9_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_9_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_9_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_9_en_i is wired to Top_CSC BF active_active_int_9_peripheral_wr_en.
    property reg_if_hw_en_active_active_int_9_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_9_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_9_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_9_o is wired from Top_CSC BF active_active_int_9_out.
    property reg_if_hw_out_active_active_int_9_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_9_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_9_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_10_i is wired to Top_CSC BF active_active_int_10_in.
    property reg_if_hw_in_active_active_int_10_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_10_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_10_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_10_en_i is wired to Top_CSC BF active_active_int_10_peripheral_wr_en.
    property reg_if_hw_en_active_active_int_10_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_10_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_10_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_10_o is wired from Top_CSC BF active_active_int_10_out.
    property reg_if_hw_out_active_active_int_10_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_10_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_10_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_11_i is wired to Top_CSC BF active_active_int_11_in.
    property reg_if_hw_in_active_active_int_11_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_11_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_11_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_11_en_i is wired to Top_CSC BF active_active_int_11_peripheral_wr_en.
    property reg_if_hw_en_active_active_int_11_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_11_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_11_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_11_o is wired from Top_CSC BF active_active_int_11_out.
    property reg_if_hw_out_active_active_int_11_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_11_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_11_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_12_i is wired to Top_CSC BF active_active_int_12_in.
    property reg_if_hw_in_active_active_int_12_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_12_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_12_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_12_en_i is wired to Top_CSC BF active_active_int_12_peripheral_wr_en.
    property reg_if_hw_en_active_active_int_12_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_12_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_12_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_12_o is wired from Top_CSC BF active_active_int_12_out.
    property reg_if_hw_out_active_active_int_12_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_12_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_12_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_13_i is wired to Top_CSC BF active_active_int_13_in.
    property reg_if_hw_in_active_active_int_13_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_13_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_13_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_13_en_i is wired to Top_CSC BF active_active_int_13_peripheral_wr_en.
    property reg_if_hw_en_active_active_int_13_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_13_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_13_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_13_o is wired from Top_CSC BF active_active_int_13_out.
    property reg_if_hw_out_active_active_int_13_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_13_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_13_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_14_i is wired to Top_CSC BF active_active_int_14_in.
    property reg_if_hw_in_active_active_int_14_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_14_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_14_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_14_en_i is wired to Top_CSC BF active_active_int_14_peripheral_wr_en.
    property reg_if_hw_en_active_active_int_14_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_14_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_14_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_14_o is wired from Top_CSC BF active_active_int_14_out.
    property reg_if_hw_out_active_active_int_14_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_14_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_14_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_15_i is wired to Top_CSC BF active_active_int_15_in.
    property reg_if_hw_in_active_active_int_15_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_15_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_15_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_15_en_i is wired to Top_CSC BF active_active_int_15_peripheral_wr_en.
    property reg_if_hw_en_active_active_int_15_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_15_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_15_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_15_o is wired from Top_CSC BF active_active_int_15_out.
    property reg_if_hw_out_active_active_int_15_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_15_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_15_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_16_i is wired to Top_CSC BF active_active_int_16_in.
    property reg_if_hw_in_active_active_int_16_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_16_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_16_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_16_en_i is wired to Top_CSC BF active_active_int_16_peripheral_wr_en.
    property reg_if_hw_en_active_active_int_16_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_16_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_16_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_16_o is wired from Top_CSC BF active_active_int_16_out.
    property reg_if_hw_out_active_active_int_16_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_16_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_16_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_17_i is wired to Top_CSC BF active_active_int_17_in.
    property reg_if_hw_in_active_active_int_17_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_17_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_17_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_17_en_i is wired to Top_CSC BF active_active_int_17_peripheral_wr_en.
    property reg_if_hw_en_active_active_int_17_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_17_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_17_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_17_o is wired from Top_CSC BF active_active_int_17_out.
    property reg_if_hw_out_active_active_int_17_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_17_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_17_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_18_i is wired to Top_CSC BF active_active_int_18_in.
    property reg_if_hw_in_active_active_int_18_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_18_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_18_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_18_en_i is wired to Top_CSC BF active_active_int_18_peripheral_wr_en.
    property reg_if_hw_en_active_active_int_18_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_18_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_18_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_18_o is wired from Top_CSC BF active_active_int_18_out.
    property reg_if_hw_out_active_active_int_18_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_18_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_18_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_19_i is wired to Top_CSC BF active_active_int_19_in.
    property reg_if_hw_in_active_active_int_19_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_19_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_19_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_19_en_i is wired to Top_CSC BF active_active_int_19_peripheral_wr_en.
    property reg_if_hw_en_active_active_int_19_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_19_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_19_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_19_o is wired from Top_CSC BF active_active_int_19_out.
    property reg_if_hw_out_active_active_int_19_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_19_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_19_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_20_i is wired to Top_CSC BF active_active_int_20_in.
    property reg_if_hw_in_active_active_int_20_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_20_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_20_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_20_en_i is wired to Top_CSC BF active_active_int_20_peripheral_wr_en.
    property reg_if_hw_en_active_active_int_20_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_20_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_20_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_20_o is wired from Top_CSC BF active_active_int_20_out.
    property reg_if_hw_out_active_active_int_20_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_20_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_20_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_21_i is wired to Top_CSC BF active_active_int_21_in.
    property reg_if_hw_in_active_active_int_21_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_21_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_21_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_21_en_i is wired to Top_CSC BF active_active_int_21_peripheral_wr_en.
    property reg_if_hw_en_active_active_int_21_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_21_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_21_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_21_o is wired from Top_CSC BF active_active_int_21_out.
    property reg_if_hw_out_active_active_int_21_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_21_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_21_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_22_i is wired to Top_CSC BF active_active_int_22_in.
    property reg_if_hw_in_active_active_int_22_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_22_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_22_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_22_en_i is wired to Top_CSC BF active_active_int_22_peripheral_wr_en.
    property reg_if_hw_en_active_active_int_22_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_22_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_22_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_22_o is wired from Top_CSC BF active_active_int_22_out.
    property reg_if_hw_out_active_active_int_22_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_22_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_22_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_23_i is wired to Top_CSC BF active_active_int_23_in.
    property reg_if_hw_in_active_active_int_23_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_23_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_23_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_23_en_i is wired to Top_CSC BF active_active_int_23_peripheral_wr_en.
    property reg_if_hw_en_active_active_int_23_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_23_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_23_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_23_o is wired from Top_CSC BF active_active_int_23_out.
    property reg_if_hw_out_active_active_int_23_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_23_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_23_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_24_i is wired to Top_CSC BF active_active_int_24_in.
    property reg_if_hw_in_active_active_int_24_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_24_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_24_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_24_en_i is wired to Top_CSC BF active_active_int_24_peripheral_wr_en.
    property reg_if_hw_en_active_active_int_24_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_24_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_24_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_24_o is wired from Top_CSC BF active_active_int_24_out.
    property reg_if_hw_out_active_active_int_24_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_24_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_24_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_25_i is wired to Top_CSC BF active_active_int_25_in.
    property reg_if_hw_in_active_active_int_25_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_25_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_25_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_25_en_i is wired to Top_CSC BF active_active_int_25_peripheral_wr_en.
    property reg_if_hw_en_active_active_int_25_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_25_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_25_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_25_o is wired from Top_CSC BF active_active_int_25_out.
    property reg_if_hw_out_active_active_int_25_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_25_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_25_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_26_i is wired to Top_CSC BF active_active_int_26_in.
    property reg_if_hw_in_active_active_int_26_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_26_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_26_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_26_en_i is wired to Top_CSC BF active_active_int_26_peripheral_wr_en.
    property reg_if_hw_en_active_active_int_26_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_26_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_26_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_26_o is wired from Top_CSC BF active_active_int_26_out.
    property reg_if_hw_out_active_active_int_26_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_26_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_26_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_27_i is wired to Top_CSC BF active_active_int_27_in.
    property reg_if_hw_in_active_active_int_27_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_27_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_27_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_27_en_i is wired to Top_CSC BF active_active_int_27_peripheral_wr_en.
    property reg_if_hw_en_active_active_int_27_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_27_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_27_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_27_o is wired from Top_CSC BF active_active_int_27_out.
    property reg_if_hw_out_active_active_int_27_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_27_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_27_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_28_i is wired to Top_CSC BF active_active_int_28_in.
    property reg_if_hw_in_active_active_int_28_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_28_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_28_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_28_en_i is wired to Top_CSC BF active_active_int_28_peripheral_wr_en.
    property reg_if_hw_en_active_active_int_28_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_28_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_28_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_28_o is wired from Top_CSC BF active_active_int_28_out.
    property reg_if_hw_out_active_active_int_28_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_28_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_28_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_29_i is wired to Top_CSC BF active_active_int_29_in.
    property reg_if_hw_in_active_active_int_29_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_29_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_29_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_29_en_i is wired to Top_CSC BF active_active_int_29_peripheral_wr_en.
    property reg_if_hw_en_active_active_int_29_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_29_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_29_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_29_o is wired from Top_CSC BF active_active_int_29_out.
    property reg_if_hw_out_active_active_int_29_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_29_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_29_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_30_i is wired to Top_CSC BF active_active_int_30_in.
    property reg_if_hw_in_active_active_int_30_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_30_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_30_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_30_en_i is wired to Top_CSC BF active_active_int_30_peripheral_wr_en.
    property reg_if_hw_en_active_active_int_30_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_30_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_30_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_30_o is wired from Top_CSC BF active_active_int_30_out.
    property reg_if_hw_out_active_active_int_30_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_30_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_30_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_31_i is wired to Top_CSC BF active_active_int_31_in.
    property reg_if_hw_in_active_active_int_31_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_31_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_31_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_31_en_i is wired to Top_CSC BF active_active_int_31_peripheral_wr_en.
    property reg_if_hw_en_active_active_int_31_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_31_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_31_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_31_o is wired from Top_CSC BF active_active_int_31_out.
    property reg_if_hw_out_active_active_int_31_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_31_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_int_31_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_1_active_NMI_i is wired to Top_CSC BF active_1_active_NMI_in.
    property reg_if_hw_in_active_1_active_NMI_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_NMI_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_NMI_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_1_active_NMI_en_i is wired to Top_CSC BF active_1_active_NMI_peripheral_wr_en.
    property reg_if_hw_en_active_1_active_NMI_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_NMI_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_NMI_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_1_active_NMI_o is wired from Top_CSC BF active_1_active_NMI_out.
    property reg_if_hw_out_active_1_active_NMI_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_NMI_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_active_NMI_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_priority_int_0_o is wired from Top_CSC BF priority_priority_int_0_out.
    property reg_if_hw_out_priority_priority_int_0_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_0_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_priority_int_0_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_priority_int_1_o is wired from Top_CSC BF priority_priority_int_1_out.
    property reg_if_hw_out_priority_priority_int_1_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_1_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_priority_int_1_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_priority_int_2_o is wired from Top_CSC BF priority_priority_int_2_out.
    property reg_if_hw_out_priority_priority_int_2_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_2_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_priority_int_2_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_priority_int_3_o is wired from Top_CSC BF priority_priority_int_3_out.
    property reg_if_hw_out_priority_priority_int_3_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_3_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_priority_int_3_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_priority_int_4_o is wired from Top_CSC BF priority_priority_int_4_out.
    property reg_if_hw_out_priority_priority_int_4_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_4_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_priority_int_4_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_priority_int_5_o is wired from Top_CSC BF priority_priority_int_5_out.
    property reg_if_hw_out_priority_priority_int_5_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_5_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_priority_int_5_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_priority_int_6_o is wired from Top_CSC BF priority_priority_int_6_out.
    property reg_if_hw_out_priority_priority_int_6_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_6_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_priority_int_6_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_priority_int_7_o is wired from Top_CSC BF priority_priority_int_7_out.
    property reg_if_hw_out_priority_priority_int_7_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_7_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_priority_int_7_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_priority_int_8_o is wired from Top_CSC BF priority_priority_int_8_out.
    property reg_if_hw_out_priority_priority_int_8_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_8_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_priority_int_8_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_priority_int_9_o is wired from Top_CSC BF priority_priority_int_9_out.
    property reg_if_hw_out_priority_priority_int_9_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_9_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_priority_int_9_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_1_priority_int_10_o is wired from Top_CSC BF priority_1_priority_int_10_out.
    property reg_if_hw_out_priority_1_priority_int_10_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_10_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_priority_int_10_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_1_priority_int_11_o is wired from Top_CSC BF priority_1_priority_int_11_out.
    property reg_if_hw_out_priority_1_priority_int_11_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_11_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_priority_int_11_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_1_priority_int_12_o is wired from Top_CSC BF priority_1_priority_int_12_out.
    property reg_if_hw_out_priority_1_priority_int_12_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_12_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_priority_int_12_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_1_priority_int_13_o is wired from Top_CSC BF priority_1_priority_int_13_out.
    property reg_if_hw_out_priority_1_priority_int_13_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_13_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_priority_int_13_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_1_priority_int_14_o is wired from Top_CSC BF priority_1_priority_int_14_out.
    property reg_if_hw_out_priority_1_priority_int_14_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_14_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_priority_int_14_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_1_priority_int_15_o is wired from Top_CSC BF priority_1_priority_int_15_out.
    property reg_if_hw_out_priority_1_priority_int_15_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_15_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_priority_int_15_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_1_priority_int_16_o is wired from Top_CSC BF priority_1_priority_int_16_out.
    property reg_if_hw_out_priority_1_priority_int_16_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_16_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_priority_int_16_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_1_priority_int_17_o is wired from Top_CSC BF priority_1_priority_int_17_out.
    property reg_if_hw_out_priority_1_priority_int_17_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_17_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_priority_int_17_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_1_priority_int_18_o is wired from Top_CSC BF priority_1_priority_int_18_out.
    property reg_if_hw_out_priority_1_priority_int_18_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_18_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_priority_int_18_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_1_priority_int_19_o is wired from Top_CSC BF priority_1_priority_int_19_out.
    property reg_if_hw_out_priority_1_priority_int_19_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_19_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_priority_int_19_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_2_priority_int_20_o is wired from Top_CSC BF priority_2_priority_int_20_out.
    property reg_if_hw_out_priority_2_priority_int_20_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_20_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_priority_int_20_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_2_priority_int_21_o is wired from Top_CSC BF priority_2_priority_int_21_out.
    property reg_if_hw_out_priority_2_priority_int_21_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_21_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_priority_int_21_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_2_priority_int_22_o is wired from Top_CSC BF priority_2_priority_int_22_out.
    property reg_if_hw_out_priority_2_priority_int_22_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_22_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_priority_int_22_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_2_priority_int_23_o is wired from Top_CSC BF priority_2_priority_int_23_out.
    property reg_if_hw_out_priority_2_priority_int_23_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_23_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_priority_int_23_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_2_priority_int_24_o is wired from Top_CSC BF priority_2_priority_int_24_out.
    property reg_if_hw_out_priority_2_priority_int_24_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_24_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_priority_int_24_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_2_priority_int_25_o is wired from Top_CSC BF priority_2_priority_int_25_out.
    property reg_if_hw_out_priority_2_priority_int_25_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_25_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_priority_int_25_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_2_priority_int_26_o is wired from Top_CSC BF priority_2_priority_int_26_out.
    property reg_if_hw_out_priority_2_priority_int_26_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_26_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_priority_int_26_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_2_priority_int_27_o is wired from Top_CSC BF priority_2_priority_int_27_out.
    property reg_if_hw_out_priority_2_priority_int_27_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_27_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_priority_int_27_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_2_priority_int_28_o is wired from Top_CSC BF priority_2_priority_int_28_out.
    property reg_if_hw_out_priority_2_priority_int_28_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_28_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_priority_int_28_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_2_priority_int_29_o is wired from Top_CSC BF priority_2_priority_int_29_out.
    property reg_if_hw_out_priority_2_priority_int_29_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_29_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_priority_int_29_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_3_priority_int_30_o is wired from Top_CSC BF priority_3_priority_int_30_out.
    property reg_if_hw_out_priority_3_priority_int_30_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_30_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_priority_int_30_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_3_priority_int_31_o is wired from Top_CSC BF priority_3_priority_int_31_out.
    property reg_if_hw_out_priority_3_priority_int_31_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_31_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_priority_int_31_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_0_i is wired to Top_CSC BF requested_requested_int_0_in.
    property reg_if_hw_in_requested_requested_int_0_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_0_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_0_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_0_en_i is wired to Top_CSC BF requested_requested_int_0_peripheral_wr_en.
    property reg_if_hw_en_requested_requested_int_0_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_0_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_0_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_0_o is wired from Top_CSC BF requested_requested_int_0_out.
    property reg_if_hw_out_requested_requested_int_0_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_0_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_0_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_1_i is wired to Top_CSC BF requested_requested_int_1_in.
    property reg_if_hw_in_requested_requested_int_1_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_1_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_1_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_1_en_i is wired to Top_CSC BF requested_requested_int_1_peripheral_wr_en.
    property reg_if_hw_en_requested_requested_int_1_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_1_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_1_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_1_o is wired from Top_CSC BF requested_requested_int_1_out.
    property reg_if_hw_out_requested_requested_int_1_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_1_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_1_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_2_i is wired to Top_CSC BF requested_requested_int_2_in.
    property reg_if_hw_in_requested_requested_int_2_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_2_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_2_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_2_en_i is wired to Top_CSC BF requested_requested_int_2_peripheral_wr_en.
    property reg_if_hw_en_requested_requested_int_2_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_2_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_2_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_2_o is wired from Top_CSC BF requested_requested_int_2_out.
    property reg_if_hw_out_requested_requested_int_2_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_2_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_2_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_3_i is wired to Top_CSC BF requested_requested_int_3_in.
    property reg_if_hw_in_requested_requested_int_3_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_3_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_3_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_3_en_i is wired to Top_CSC BF requested_requested_int_3_peripheral_wr_en.
    property reg_if_hw_en_requested_requested_int_3_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_3_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_3_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_3_o is wired from Top_CSC BF requested_requested_int_3_out.
    property reg_if_hw_out_requested_requested_int_3_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_3_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_3_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_4_i is wired to Top_CSC BF requested_requested_int_4_in.
    property reg_if_hw_in_requested_requested_int_4_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_4_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_4_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_4_en_i is wired to Top_CSC BF requested_requested_int_4_peripheral_wr_en.
    property reg_if_hw_en_requested_requested_int_4_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_4_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_4_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_4_o is wired from Top_CSC BF requested_requested_int_4_out.
    property reg_if_hw_out_requested_requested_int_4_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_4_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_4_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_5_i is wired to Top_CSC BF requested_requested_int_5_in.
    property reg_if_hw_in_requested_requested_int_5_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_5_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_5_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_5_en_i is wired to Top_CSC BF requested_requested_int_5_peripheral_wr_en.
    property reg_if_hw_en_requested_requested_int_5_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_5_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_5_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_5_o is wired from Top_CSC BF requested_requested_int_5_out.
    property reg_if_hw_out_requested_requested_int_5_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_5_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_5_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_6_i is wired to Top_CSC BF requested_requested_int_6_in.
    property reg_if_hw_in_requested_requested_int_6_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_6_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_6_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_6_en_i is wired to Top_CSC BF requested_requested_int_6_peripheral_wr_en.
    property reg_if_hw_en_requested_requested_int_6_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_6_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_6_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_6_o is wired from Top_CSC BF requested_requested_int_6_out.
    property reg_if_hw_out_requested_requested_int_6_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_6_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_6_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_7_i is wired to Top_CSC BF requested_requested_int_7_in.
    property reg_if_hw_in_requested_requested_int_7_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_7_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_7_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_7_en_i is wired to Top_CSC BF requested_requested_int_7_peripheral_wr_en.
    property reg_if_hw_en_requested_requested_int_7_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_7_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_7_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_7_o is wired from Top_CSC BF requested_requested_int_7_out.
    property reg_if_hw_out_requested_requested_int_7_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_7_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_7_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_8_i is wired to Top_CSC BF requested_requested_int_8_in.
    property reg_if_hw_in_requested_requested_int_8_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_8_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_8_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_8_en_i is wired to Top_CSC BF requested_requested_int_8_peripheral_wr_en.
    property reg_if_hw_en_requested_requested_int_8_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_8_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_8_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_8_o is wired from Top_CSC BF requested_requested_int_8_out.
    property reg_if_hw_out_requested_requested_int_8_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_8_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_8_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_9_i is wired to Top_CSC BF requested_requested_int_9_in.
    property reg_if_hw_in_requested_requested_int_9_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_9_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_9_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_9_en_i is wired to Top_CSC BF requested_requested_int_9_peripheral_wr_en.
    property reg_if_hw_en_requested_requested_int_9_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_9_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_9_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_9_o is wired from Top_CSC BF requested_requested_int_9_out.
    property reg_if_hw_out_requested_requested_int_9_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_9_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_9_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_10_i is wired to Top_CSC BF requested_requested_int_10_in.
    property reg_if_hw_in_requested_requested_int_10_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_10_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_10_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_10_en_i is wired to Top_CSC BF requested_requested_int_10_peripheral_wr_en.
    property reg_if_hw_en_requested_requested_int_10_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_10_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_10_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_10_o is wired from Top_CSC BF requested_requested_int_10_out.
    property reg_if_hw_out_requested_requested_int_10_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_10_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_10_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_11_i is wired to Top_CSC BF requested_requested_int_11_in.
    property reg_if_hw_in_requested_requested_int_11_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_11_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_11_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_11_en_i is wired to Top_CSC BF requested_requested_int_11_peripheral_wr_en.
    property reg_if_hw_en_requested_requested_int_11_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_11_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_11_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_11_o is wired from Top_CSC BF requested_requested_int_11_out.
    property reg_if_hw_out_requested_requested_int_11_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_11_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_11_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_12_i is wired to Top_CSC BF requested_requested_int_12_in.
    property reg_if_hw_in_requested_requested_int_12_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_12_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_12_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_12_en_i is wired to Top_CSC BF requested_requested_int_12_peripheral_wr_en.
    property reg_if_hw_en_requested_requested_int_12_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_12_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_12_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_12_o is wired from Top_CSC BF requested_requested_int_12_out.
    property reg_if_hw_out_requested_requested_int_12_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_12_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_12_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_13_i is wired to Top_CSC BF requested_requested_int_13_in.
    property reg_if_hw_in_requested_requested_int_13_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_13_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_13_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_13_en_i is wired to Top_CSC BF requested_requested_int_13_peripheral_wr_en.
    property reg_if_hw_en_requested_requested_int_13_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_13_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_13_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_13_o is wired from Top_CSC BF requested_requested_int_13_out.
    property reg_if_hw_out_requested_requested_int_13_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_13_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_13_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_14_i is wired to Top_CSC BF requested_requested_int_14_in.
    property reg_if_hw_in_requested_requested_int_14_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_14_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_14_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_14_en_i is wired to Top_CSC BF requested_requested_int_14_peripheral_wr_en.
    property reg_if_hw_en_requested_requested_int_14_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_14_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_14_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_14_o is wired from Top_CSC BF requested_requested_int_14_out.
    property reg_if_hw_out_requested_requested_int_14_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_14_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_14_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_15_i is wired to Top_CSC BF requested_requested_int_15_in.
    property reg_if_hw_in_requested_requested_int_15_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_15_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_15_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_15_en_i is wired to Top_CSC BF requested_requested_int_15_peripheral_wr_en.
    property reg_if_hw_en_requested_requested_int_15_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_15_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_15_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_15_o is wired from Top_CSC BF requested_requested_int_15_out.
    property reg_if_hw_out_requested_requested_int_15_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_15_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_15_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_16_i is wired to Top_CSC BF requested_requested_int_16_in.
    property reg_if_hw_in_requested_requested_int_16_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_16_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_16_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_16_en_i is wired to Top_CSC BF requested_requested_int_16_peripheral_wr_en.
    property reg_if_hw_en_requested_requested_int_16_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_16_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_16_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_16_o is wired from Top_CSC BF requested_requested_int_16_out.
    property reg_if_hw_out_requested_requested_int_16_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_16_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_16_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_17_i is wired to Top_CSC BF requested_requested_int_17_in.
    property reg_if_hw_in_requested_requested_int_17_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_17_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_17_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_17_en_i is wired to Top_CSC BF requested_requested_int_17_peripheral_wr_en.
    property reg_if_hw_en_requested_requested_int_17_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_17_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_17_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_17_o is wired from Top_CSC BF requested_requested_int_17_out.
    property reg_if_hw_out_requested_requested_int_17_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_17_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_17_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_18_i is wired to Top_CSC BF requested_requested_int_18_in.
    property reg_if_hw_in_requested_requested_int_18_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_18_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_18_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_18_en_i is wired to Top_CSC BF requested_requested_int_18_peripheral_wr_en.
    property reg_if_hw_en_requested_requested_int_18_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_18_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_18_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_18_o is wired from Top_CSC BF requested_requested_int_18_out.
    property reg_if_hw_out_requested_requested_int_18_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_18_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_18_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_19_i is wired to Top_CSC BF requested_requested_int_19_in.
    property reg_if_hw_in_requested_requested_int_19_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_19_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_19_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_19_en_i is wired to Top_CSC BF requested_requested_int_19_peripheral_wr_en.
    property reg_if_hw_en_requested_requested_int_19_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_19_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_19_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_19_o is wired from Top_CSC BF requested_requested_int_19_out.
    property reg_if_hw_out_requested_requested_int_19_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_19_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_19_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_20_i is wired to Top_CSC BF requested_requested_int_20_in.
    property reg_if_hw_in_requested_requested_int_20_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_20_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_20_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_20_en_i is wired to Top_CSC BF requested_requested_int_20_peripheral_wr_en.
    property reg_if_hw_en_requested_requested_int_20_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_20_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_20_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_20_o is wired from Top_CSC BF requested_requested_int_20_out.
    property reg_if_hw_out_requested_requested_int_20_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_20_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_20_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_21_i is wired to Top_CSC BF requested_requested_int_21_in.
    property reg_if_hw_in_requested_requested_int_21_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_21_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_21_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_21_en_i is wired to Top_CSC BF requested_requested_int_21_peripheral_wr_en.
    property reg_if_hw_en_requested_requested_int_21_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_21_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_21_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_21_o is wired from Top_CSC BF requested_requested_int_21_out.
    property reg_if_hw_out_requested_requested_int_21_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_21_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_21_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_22_i is wired to Top_CSC BF requested_requested_int_22_in.
    property reg_if_hw_in_requested_requested_int_22_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_22_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_22_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_22_en_i is wired to Top_CSC BF requested_requested_int_22_peripheral_wr_en.
    property reg_if_hw_en_requested_requested_int_22_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_22_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_22_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_22_o is wired from Top_CSC BF requested_requested_int_22_out.
    property reg_if_hw_out_requested_requested_int_22_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_22_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_22_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_23_i is wired to Top_CSC BF requested_requested_int_23_in.
    property reg_if_hw_in_requested_requested_int_23_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_23_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_23_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_23_en_i is wired to Top_CSC BF requested_requested_int_23_peripheral_wr_en.
    property reg_if_hw_en_requested_requested_int_23_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_23_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_23_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_23_o is wired from Top_CSC BF requested_requested_int_23_out.
    property reg_if_hw_out_requested_requested_int_23_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_23_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_23_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_24_i is wired to Top_CSC BF requested_requested_int_24_in.
    property reg_if_hw_in_requested_requested_int_24_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_24_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_24_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_24_en_i is wired to Top_CSC BF requested_requested_int_24_peripheral_wr_en.
    property reg_if_hw_en_requested_requested_int_24_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_24_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_24_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_24_o is wired from Top_CSC BF requested_requested_int_24_out.
    property reg_if_hw_out_requested_requested_int_24_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_24_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_24_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_25_i is wired to Top_CSC BF requested_requested_int_25_in.
    property reg_if_hw_in_requested_requested_int_25_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_25_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_25_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_25_en_i is wired to Top_CSC BF requested_requested_int_25_peripheral_wr_en.
    property reg_if_hw_en_requested_requested_int_25_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_25_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_25_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_25_o is wired from Top_CSC BF requested_requested_int_25_out.
    property reg_if_hw_out_requested_requested_int_25_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_25_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_25_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_26_i is wired to Top_CSC BF requested_requested_int_26_in.
    property reg_if_hw_in_requested_requested_int_26_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_26_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_26_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_26_en_i is wired to Top_CSC BF requested_requested_int_26_peripheral_wr_en.
    property reg_if_hw_en_requested_requested_int_26_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_26_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_26_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_26_o is wired from Top_CSC BF requested_requested_int_26_out.
    property reg_if_hw_out_requested_requested_int_26_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_26_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_26_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_27_i is wired to Top_CSC BF requested_requested_int_27_in.
    property reg_if_hw_in_requested_requested_int_27_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_27_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_27_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_27_en_i is wired to Top_CSC BF requested_requested_int_27_peripheral_wr_en.
    property reg_if_hw_en_requested_requested_int_27_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_27_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_27_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_27_o is wired from Top_CSC BF requested_requested_int_27_out.
    property reg_if_hw_out_requested_requested_int_27_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_27_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_27_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_28_i is wired to Top_CSC BF requested_requested_int_28_in.
    property reg_if_hw_in_requested_requested_int_28_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_28_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_28_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_28_en_i is wired to Top_CSC BF requested_requested_int_28_peripheral_wr_en.
    property reg_if_hw_en_requested_requested_int_28_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_28_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_28_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_28_o is wired from Top_CSC BF requested_requested_int_28_out.
    property reg_if_hw_out_requested_requested_int_28_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_28_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_28_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_29_i is wired to Top_CSC BF requested_requested_int_29_in.
    property reg_if_hw_in_requested_requested_int_29_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_29_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_29_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_29_en_i is wired to Top_CSC BF requested_requested_int_29_peripheral_wr_en.
    property reg_if_hw_en_requested_requested_int_29_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_29_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_29_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_29_o is wired from Top_CSC BF requested_requested_int_29_out.
    property reg_if_hw_out_requested_requested_int_29_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_29_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_29_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_30_i is wired to Top_CSC BF requested_requested_int_30_in.
    property reg_if_hw_in_requested_requested_int_30_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_30_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_30_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_30_en_i is wired to Top_CSC BF requested_requested_int_30_peripheral_wr_en.
    property reg_if_hw_en_requested_requested_int_30_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_30_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_30_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_30_o is wired from Top_CSC BF requested_requested_int_30_out.
    property reg_if_hw_out_requested_requested_int_30_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_30_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_30_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_31_i is wired to Top_CSC BF requested_requested_int_31_in.
    property reg_if_hw_in_requested_requested_int_31_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_31_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_31_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_31_en_i is wired to Top_CSC BF requested_requested_int_31_peripheral_wr_en.
    property reg_if_hw_en_requested_requested_int_31_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_31_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_31_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_31_o is wired from Top_CSC BF requested_requested_int_31_out.
    property reg_if_hw_out_requested_requested_int_31_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_31_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_int_31_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_1_requested_NMI_i is wired to Top_CSC BF requested_1_requested_NMI_in.
    property reg_if_hw_in_requested_1_requested_NMI_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_NMI_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_NMI_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_1_requested_NMI_en_i is wired to Top_CSC BF requested_1_requested_NMI_peripheral_wr_en.
    property reg_if_hw_en_requested_1_requested_NMI_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_NMI_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_NMI_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_1_requested_NMI_o is wired from Top_CSC BF requested_1_requested_NMI_out.
    property reg_if_hw_out_requested_1_requested_NMI_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_NMI_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_requested_NMI_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_0_i is wired to Top_CSC BF paused_paused_int_0_in.
    property reg_if_hw_in_paused_paused_int_0_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_0_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_0_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_0_en_i is wired to Top_CSC BF paused_paused_int_0_peripheral_wr_en.
    property reg_if_hw_en_paused_paused_int_0_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_0_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_0_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_0_o is wired from Top_CSC BF paused_paused_int_0_out.
    property reg_if_hw_out_paused_paused_int_0_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_0_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_0_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_1_i is wired to Top_CSC BF paused_paused_int_1_in.
    property reg_if_hw_in_paused_paused_int_1_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_1_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_1_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_1_en_i is wired to Top_CSC BF paused_paused_int_1_peripheral_wr_en.
    property reg_if_hw_en_paused_paused_int_1_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_1_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_1_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_1_o is wired from Top_CSC BF paused_paused_int_1_out.
    property reg_if_hw_out_paused_paused_int_1_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_1_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_1_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_2_i is wired to Top_CSC BF paused_paused_int_2_in.
    property reg_if_hw_in_paused_paused_int_2_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_2_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_2_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_2_en_i is wired to Top_CSC BF paused_paused_int_2_peripheral_wr_en.
    property reg_if_hw_en_paused_paused_int_2_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_2_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_2_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_2_o is wired from Top_CSC BF paused_paused_int_2_out.
    property reg_if_hw_out_paused_paused_int_2_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_2_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_2_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_3_i is wired to Top_CSC BF paused_paused_int_3_in.
    property reg_if_hw_in_paused_paused_int_3_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_3_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_3_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_3_en_i is wired to Top_CSC BF paused_paused_int_3_peripheral_wr_en.
    property reg_if_hw_en_paused_paused_int_3_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_3_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_3_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_3_o is wired from Top_CSC BF paused_paused_int_3_out.
    property reg_if_hw_out_paused_paused_int_3_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_3_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_3_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_4_i is wired to Top_CSC BF paused_paused_int_4_in.
    property reg_if_hw_in_paused_paused_int_4_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_4_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_4_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_4_en_i is wired to Top_CSC BF paused_paused_int_4_peripheral_wr_en.
    property reg_if_hw_en_paused_paused_int_4_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_4_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_4_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_4_o is wired from Top_CSC BF paused_paused_int_4_out.
    property reg_if_hw_out_paused_paused_int_4_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_4_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_4_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_5_i is wired to Top_CSC BF paused_paused_int_5_in.
    property reg_if_hw_in_paused_paused_int_5_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_5_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_5_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_5_en_i is wired to Top_CSC BF paused_paused_int_5_peripheral_wr_en.
    property reg_if_hw_en_paused_paused_int_5_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_5_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_5_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_5_o is wired from Top_CSC BF paused_paused_int_5_out.
    property reg_if_hw_out_paused_paused_int_5_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_5_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_5_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_6_i is wired to Top_CSC BF paused_paused_int_6_in.
    property reg_if_hw_in_paused_paused_int_6_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_6_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_6_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_6_en_i is wired to Top_CSC BF paused_paused_int_6_peripheral_wr_en.
    property reg_if_hw_en_paused_paused_int_6_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_6_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_6_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_6_o is wired from Top_CSC BF paused_paused_int_6_out.
    property reg_if_hw_out_paused_paused_int_6_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_6_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_6_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_7_i is wired to Top_CSC BF paused_paused_int_7_in.
    property reg_if_hw_in_paused_paused_int_7_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_7_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_7_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_7_en_i is wired to Top_CSC BF paused_paused_int_7_peripheral_wr_en.
    property reg_if_hw_en_paused_paused_int_7_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_7_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_7_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_7_o is wired from Top_CSC BF paused_paused_int_7_out.
    property reg_if_hw_out_paused_paused_int_7_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_7_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_7_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_8_i is wired to Top_CSC BF paused_paused_int_8_in.
    property reg_if_hw_in_paused_paused_int_8_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_8_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_8_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_8_en_i is wired to Top_CSC BF paused_paused_int_8_peripheral_wr_en.
    property reg_if_hw_en_paused_paused_int_8_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_8_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_8_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_8_o is wired from Top_CSC BF paused_paused_int_8_out.
    property reg_if_hw_out_paused_paused_int_8_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_8_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_8_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_9_i is wired to Top_CSC BF paused_paused_int_9_in.
    property reg_if_hw_in_paused_paused_int_9_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_9_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_9_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_9_en_i is wired to Top_CSC BF paused_paused_int_9_peripheral_wr_en.
    property reg_if_hw_en_paused_paused_int_9_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_9_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_9_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_9_o is wired from Top_CSC BF paused_paused_int_9_out.
    property reg_if_hw_out_paused_paused_int_9_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_9_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_9_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_10_i is wired to Top_CSC BF paused_paused_int_10_in.
    property reg_if_hw_in_paused_paused_int_10_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_10_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_10_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_10_en_i is wired to Top_CSC BF paused_paused_int_10_peripheral_wr_en.
    property reg_if_hw_en_paused_paused_int_10_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_10_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_10_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_10_o is wired from Top_CSC BF paused_paused_int_10_out.
    property reg_if_hw_out_paused_paused_int_10_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_10_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_10_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_11_i is wired to Top_CSC BF paused_paused_int_11_in.
    property reg_if_hw_in_paused_paused_int_11_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_11_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_11_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_11_en_i is wired to Top_CSC BF paused_paused_int_11_peripheral_wr_en.
    property reg_if_hw_en_paused_paused_int_11_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_11_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_11_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_11_o is wired from Top_CSC BF paused_paused_int_11_out.
    property reg_if_hw_out_paused_paused_int_11_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_11_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_11_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_12_i is wired to Top_CSC BF paused_paused_int_12_in.
    property reg_if_hw_in_paused_paused_int_12_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_12_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_12_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_12_en_i is wired to Top_CSC BF paused_paused_int_12_peripheral_wr_en.
    property reg_if_hw_en_paused_paused_int_12_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_12_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_12_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_12_o is wired from Top_CSC BF paused_paused_int_12_out.
    property reg_if_hw_out_paused_paused_int_12_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_12_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_12_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_13_i is wired to Top_CSC BF paused_paused_int_13_in.
    property reg_if_hw_in_paused_paused_int_13_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_13_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_13_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_13_en_i is wired to Top_CSC BF paused_paused_int_13_peripheral_wr_en.
    property reg_if_hw_en_paused_paused_int_13_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_13_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_13_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_13_o is wired from Top_CSC BF paused_paused_int_13_out.
    property reg_if_hw_out_paused_paused_int_13_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_13_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_13_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_14_i is wired to Top_CSC BF paused_paused_int_14_in.
    property reg_if_hw_in_paused_paused_int_14_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_14_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_14_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_14_en_i is wired to Top_CSC BF paused_paused_int_14_peripheral_wr_en.
    property reg_if_hw_en_paused_paused_int_14_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_14_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_14_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_14_o is wired from Top_CSC BF paused_paused_int_14_out.
    property reg_if_hw_out_paused_paused_int_14_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_14_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_14_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_15_i is wired to Top_CSC BF paused_paused_int_15_in.
    property reg_if_hw_in_paused_paused_int_15_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_15_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_15_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_15_en_i is wired to Top_CSC BF paused_paused_int_15_peripheral_wr_en.
    property reg_if_hw_en_paused_paused_int_15_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_15_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_15_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_15_o is wired from Top_CSC BF paused_paused_int_15_out.
    property reg_if_hw_out_paused_paused_int_15_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_15_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_15_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_16_i is wired to Top_CSC BF paused_paused_int_16_in.
    property reg_if_hw_in_paused_paused_int_16_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_16_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_16_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_16_en_i is wired to Top_CSC BF paused_paused_int_16_peripheral_wr_en.
    property reg_if_hw_en_paused_paused_int_16_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_16_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_16_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_16_o is wired from Top_CSC BF paused_paused_int_16_out.
    property reg_if_hw_out_paused_paused_int_16_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_16_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_16_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_17_i is wired to Top_CSC BF paused_paused_int_17_in.
    property reg_if_hw_in_paused_paused_int_17_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_17_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_17_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_17_en_i is wired to Top_CSC BF paused_paused_int_17_peripheral_wr_en.
    property reg_if_hw_en_paused_paused_int_17_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_17_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_17_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_17_o is wired from Top_CSC BF paused_paused_int_17_out.
    property reg_if_hw_out_paused_paused_int_17_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_17_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_17_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_18_i is wired to Top_CSC BF paused_paused_int_18_in.
    property reg_if_hw_in_paused_paused_int_18_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_18_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_18_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_18_en_i is wired to Top_CSC BF paused_paused_int_18_peripheral_wr_en.
    property reg_if_hw_en_paused_paused_int_18_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_18_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_18_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_18_o is wired from Top_CSC BF paused_paused_int_18_out.
    property reg_if_hw_out_paused_paused_int_18_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_18_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_18_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_19_i is wired to Top_CSC BF paused_paused_int_19_in.
    property reg_if_hw_in_paused_paused_int_19_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_19_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_19_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_19_en_i is wired to Top_CSC BF paused_paused_int_19_peripheral_wr_en.
    property reg_if_hw_en_paused_paused_int_19_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_19_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_19_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_19_o is wired from Top_CSC BF paused_paused_int_19_out.
    property reg_if_hw_out_paused_paused_int_19_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_19_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_19_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_20_i is wired to Top_CSC BF paused_paused_int_20_in.
    property reg_if_hw_in_paused_paused_int_20_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_20_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_20_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_20_en_i is wired to Top_CSC BF paused_paused_int_20_peripheral_wr_en.
    property reg_if_hw_en_paused_paused_int_20_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_20_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_20_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_20_o is wired from Top_CSC BF paused_paused_int_20_out.
    property reg_if_hw_out_paused_paused_int_20_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_20_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_20_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_21_i is wired to Top_CSC BF paused_paused_int_21_in.
    property reg_if_hw_in_paused_paused_int_21_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_21_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_21_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_21_en_i is wired to Top_CSC BF paused_paused_int_21_peripheral_wr_en.
    property reg_if_hw_en_paused_paused_int_21_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_21_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_21_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_21_o is wired from Top_CSC BF paused_paused_int_21_out.
    property reg_if_hw_out_paused_paused_int_21_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_21_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_21_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_22_i is wired to Top_CSC BF paused_paused_int_22_in.
    property reg_if_hw_in_paused_paused_int_22_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_22_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_22_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_22_en_i is wired to Top_CSC BF paused_paused_int_22_peripheral_wr_en.
    property reg_if_hw_en_paused_paused_int_22_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_22_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_22_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_22_o is wired from Top_CSC BF paused_paused_int_22_out.
    property reg_if_hw_out_paused_paused_int_22_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_22_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_22_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_23_i is wired to Top_CSC BF paused_paused_int_23_in.
    property reg_if_hw_in_paused_paused_int_23_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_23_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_23_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_23_en_i is wired to Top_CSC BF paused_paused_int_23_peripheral_wr_en.
    property reg_if_hw_en_paused_paused_int_23_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_23_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_23_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_23_o is wired from Top_CSC BF paused_paused_int_23_out.
    property reg_if_hw_out_paused_paused_int_23_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_23_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_23_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_24_i is wired to Top_CSC BF paused_paused_int_24_in.
    property reg_if_hw_in_paused_paused_int_24_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_24_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_24_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_24_en_i is wired to Top_CSC BF paused_paused_int_24_peripheral_wr_en.
    property reg_if_hw_en_paused_paused_int_24_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_24_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_24_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_24_o is wired from Top_CSC BF paused_paused_int_24_out.
    property reg_if_hw_out_paused_paused_int_24_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_24_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_24_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_25_i is wired to Top_CSC BF paused_paused_int_25_in.
    property reg_if_hw_in_paused_paused_int_25_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_25_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_25_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_25_en_i is wired to Top_CSC BF paused_paused_int_25_peripheral_wr_en.
    property reg_if_hw_en_paused_paused_int_25_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_25_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_25_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_25_o is wired from Top_CSC BF paused_paused_int_25_out.
    property reg_if_hw_out_paused_paused_int_25_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_25_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_25_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_26_i is wired to Top_CSC BF paused_paused_int_26_in.
    property reg_if_hw_in_paused_paused_int_26_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_26_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_26_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_26_en_i is wired to Top_CSC BF paused_paused_int_26_peripheral_wr_en.
    property reg_if_hw_en_paused_paused_int_26_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_26_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_26_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_26_o is wired from Top_CSC BF paused_paused_int_26_out.
    property reg_if_hw_out_paused_paused_int_26_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_26_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_26_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_27_i is wired to Top_CSC BF paused_paused_int_27_in.
    property reg_if_hw_in_paused_paused_int_27_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_27_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_27_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_27_en_i is wired to Top_CSC BF paused_paused_int_27_peripheral_wr_en.
    property reg_if_hw_en_paused_paused_int_27_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_27_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_27_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_27_o is wired from Top_CSC BF paused_paused_int_27_out.
    property reg_if_hw_out_paused_paused_int_27_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_27_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_27_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_28_i is wired to Top_CSC BF paused_paused_int_28_in.
    property reg_if_hw_in_paused_paused_int_28_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_28_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_28_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_28_en_i is wired to Top_CSC BF paused_paused_int_28_peripheral_wr_en.
    property reg_if_hw_en_paused_paused_int_28_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_28_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_28_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_28_o is wired from Top_CSC BF paused_paused_int_28_out.
    property reg_if_hw_out_paused_paused_int_28_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_28_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_28_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_29_i is wired to Top_CSC BF paused_paused_int_29_in.
    property reg_if_hw_in_paused_paused_int_29_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_29_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_29_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_29_en_i is wired to Top_CSC BF paused_paused_int_29_peripheral_wr_en.
    property reg_if_hw_en_paused_paused_int_29_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_29_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_29_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_29_o is wired from Top_CSC BF paused_paused_int_29_out.
    property reg_if_hw_out_paused_paused_int_29_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_29_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_29_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_30_i is wired to Top_CSC BF paused_paused_int_30_in.
    property reg_if_hw_in_paused_paused_int_30_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_30_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_30_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_30_en_i is wired to Top_CSC BF paused_paused_int_30_peripheral_wr_en.
    property reg_if_hw_en_paused_paused_int_30_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_30_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_30_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_30_o is wired from Top_CSC BF paused_paused_int_30_out.
    property reg_if_hw_out_paused_paused_int_30_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_30_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_30_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_31_i is wired to Top_CSC BF paused_paused_int_31_in.
    property reg_if_hw_in_paused_paused_int_31_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_31_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_31_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_31_en_i is wired to Top_CSC BF paused_paused_int_31_peripheral_wr_en.
    property reg_if_hw_en_paused_paused_int_31_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_31_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_31_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_31_o is wired from Top_CSC BF paused_paused_int_31_out.
    property reg_if_hw_out_paused_paused_int_31_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_31_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_int_31_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_1_paused_NMI_i is wired to Top_CSC BF paused_1_paused_NMI_in.
    property reg_if_hw_in_paused_1_paused_NMI_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_NMI_in == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_NMI_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_1_paused_NMI_en_i is wired to Top_CSC BF paused_1_paused_NMI_peripheral_wr_en.
    property reg_if_hw_en_paused_1_paused_NMI_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_NMI_peripheral_wr_en == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_NMI_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_1_paused_NMI_o is wired from Top_CSC BF paused_1_paused_NMI_out.
    property reg_if_hw_out_paused_1_paused_NMI_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_NMI_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_paused_NMI_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output group_priority_group_priority_Group1_o is wired from Top_CSC BF group_priority_group_priority_Group1_out.
    property reg_if_hw_out_group_priority_group_priority_Group1_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_group_priority_Group1_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_group_priority_Group1_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output group_priority_group_priority_Group2_o is wired from Top_CSC BF group_priority_group_priority_Group2_out.
    property reg_if_hw_out_group_priority_group_priority_Group2_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_group_priority_Group2_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_group_priority_Group2_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output group_priority_group_priority_Group3_o is wired from Top_CSC BF group_priority_group_priority_Group3_out.
    property reg_if_hw_out_group_priority_group_priority_Group3_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_group_priority_Group3_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_group_priority_Group3_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output group_priority_group_priority_Group4_o is wired from Top_CSC BF group_priority_group_priority_Group4_out.
    property reg_if_hw_out_group_priority_group_priority_Group4_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_group_priority_Group4_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_group_priority_Group4_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_0_addr_addr_int_0_o is wired from Top_CSC BF int_0_addr_addr_int_0_out.
    property reg_if_hw_out_int_0_addr_addr_int_0_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_0_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_addr_int_0_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_1_addr_addr_int_1_o is wired from Top_CSC BF int_1_addr_addr_int_1_out.
    property reg_if_hw_out_int_1_addr_addr_int_1_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_1_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_addr_int_1_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_2_addr_addr_int_2_o is wired from Top_CSC BF int_2_addr_addr_int_2_out.
    property reg_if_hw_out_int_2_addr_addr_int_2_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_2_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_addr_int_2_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_3_addr_addr_int_3_o is wired from Top_CSC BF int_3_addr_addr_int_3_out.
    property reg_if_hw_out_int_3_addr_addr_int_3_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_3_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_addr_int_3_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_4_addr_addr_int_4_o is wired from Top_CSC BF int_4_addr_addr_int_4_out.
    property reg_if_hw_out_int_4_addr_addr_int_4_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_4_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_addr_int_4_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_5_addr_addr_int_5_o is wired from Top_CSC BF int_5_addr_addr_int_5_out.
    property reg_if_hw_out_int_5_addr_addr_int_5_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_5_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_addr_int_5_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_6_addr_addr_int_6_o is wired from Top_CSC BF int_6_addr_addr_int_6_out.
    property reg_if_hw_out_int_6_addr_addr_int_6_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_6_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_addr_int_6_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_7_addr_addr_int_7_o is wired from Top_CSC BF int_7_addr_addr_int_7_out.
    property reg_if_hw_out_int_7_addr_addr_int_7_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_7_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_addr_int_7_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_8_addr_addr_int_8_o is wired from Top_CSC BF int_8_addr_addr_int_8_out.
    property reg_if_hw_out_int_8_addr_addr_int_8_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_8_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_addr_int_8_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_9_addr_addr_int_9_o is wired from Top_CSC BF int_9_addr_addr_int_9_out.
    property reg_if_hw_out_int_9_addr_addr_int_9_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_9_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_addr_int_9_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_10_addr_addr_int_10_o is wired from Top_CSC BF int_10_addr_addr_int_10_out.
    property reg_if_hw_out_int_10_addr_addr_int_10_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_10_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_addr_int_10_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_11_addr_addr_int_11_o is wired from Top_CSC BF int_11_addr_addr_int_11_out.
    property reg_if_hw_out_int_11_addr_addr_int_11_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_11_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_addr_int_11_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_12_addr_addr_int_12_o is wired from Top_CSC BF int_12_addr_addr_int_12_out.
    property reg_if_hw_out_int_12_addr_addr_int_12_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_12_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_addr_int_12_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_13_addr_addr_int_13_o is wired from Top_CSC BF int_13_addr_addr_int_13_out.
    property reg_if_hw_out_int_13_addr_addr_int_13_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_13_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_addr_int_13_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_14_addr_addr_int_14_o is wired from Top_CSC BF int_14_addr_addr_int_14_out.
    property reg_if_hw_out_int_14_addr_addr_int_14_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_14_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_addr_int_14_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_15_addr_addr_int_15_o is wired from Top_CSC BF int_15_addr_addr_int_15_out.
    property reg_if_hw_out_int_15_addr_addr_int_15_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_15_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_addr_int_15_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_16_addr_addr_int_16_o is wired from Top_CSC BF int_16_addr_addr_int_16_out.
    property reg_if_hw_out_int_16_addr_addr_int_16_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_16_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_addr_int_16_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_17_addr_addr_int_17_o is wired from Top_CSC BF int_17_addr_addr_int_17_out.
    property reg_if_hw_out_int_17_addr_addr_int_17_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_17_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_addr_int_17_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_18_addr_addr_int_18_o is wired from Top_CSC BF int_18_addr_addr_int_18_out.
    property reg_if_hw_out_int_18_addr_addr_int_18_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_18_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_addr_int_18_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_19_addr_addr_int_19_o is wired from Top_CSC BF int_19_addr_addr_int_19_out.
    property reg_if_hw_out_int_19_addr_addr_int_19_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_19_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_addr_int_19_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_20_addr_addr_int_20_o is wired from Top_CSC BF int_20_addr_addr_int_20_out.
    property reg_if_hw_out_int_20_addr_addr_int_20_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_20_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_addr_int_20_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_21_addr_addr_int_21_o is wired from Top_CSC BF int_21_addr_addr_int_21_out.
    property reg_if_hw_out_int_21_addr_addr_int_21_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_21_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_addr_int_21_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_22_addr_addr_int_22_o is wired from Top_CSC BF int_22_addr_addr_int_22_out.
    property reg_if_hw_out_int_22_addr_addr_int_22_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_22_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_addr_int_22_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_23_addr_addr_int_23_o is wired from Top_CSC BF int_23_addr_addr_int_23_out.
    property reg_if_hw_out_int_23_addr_addr_int_23_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_23_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_addr_int_23_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_24_addr_addr_int_24_o is wired from Top_CSC BF int_24_addr_addr_int_24_out.
    property reg_if_hw_out_int_24_addr_addr_int_24_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_24_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_addr_int_24_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_25_addr_addr_int_25_o is wired from Top_CSC BF int_25_addr_addr_int_25_out.
    property reg_if_hw_out_int_25_addr_addr_int_25_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_25_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_addr_int_25_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_26_addr_addr_int_26_o is wired from Top_CSC BF int_26_addr_addr_int_26_out.
    property reg_if_hw_out_int_26_addr_addr_int_26_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_26_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_addr_int_26_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_27_addr_addr_int_27_o is wired from Top_CSC BF int_27_addr_addr_int_27_out.
    property reg_if_hw_out_int_27_addr_addr_int_27_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_27_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_addr_int_27_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_28_addr_addr_int_28_o is wired from Top_CSC BF int_28_addr_addr_int_28_out.
    property reg_if_hw_out_int_28_addr_addr_int_28_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_28_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_addr_int_28_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_29_addr_addr_int_29_o is wired from Top_CSC BF int_29_addr_addr_int_29_out.
    property reg_if_hw_out_int_29_addr_addr_int_29_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_29_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_addr_int_29_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_30_addr_addr_int_30_o is wired from Top_CSC BF int_30_addr_addr_int_30_out.
    property reg_if_hw_out_int_30_addr_addr_int_30_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_30_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_addr_int_30_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_31_addr_addr_int_31_o is wired from Top_CSC BF int_31_addr_addr_int_31_out.
    property reg_if_hw_out_int_31_addr_addr_int_31_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_31_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_addr_int_31_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output NMI_addr_addr_NMI_o is wired from Top_CSC BF NMI_addr_addr_NMI_out.
    property reg_if_hw_out_NMI_addr_addr_NMI_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_NMI_out == InterruptController.comp_Reg_IF.comp_Top_CSC.InterruptControllerCSC_BF_addr_NMI_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface AHB haddr connectivity to Top AHB haddr.
    property regif_top_ahb_haddr_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF. SX_AHB_HADDR == InterruptController. SX_AHB_HADDR));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface AHB hwdata connectivity to Top AHB hwdata.
    property regif_top_ahb_hwdata_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.SX_AHB_HWDATA == InterruptController.SX_AHB_HWDATA));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface AHB hburst connectivity to Top AHB hburst.
    property regif_top_ahb_hburst_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.SX_AHB_HBURST == InterruptController.SX_AHB_HBURST));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface AHB hmastlock connectivity to Top AHB hmastlock.
    property regif_top_ahb_hmastlock_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.SX_AHB_HMASTLOCK == InterruptController.SX_AHB_HMASTLOCK));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface AHB hprot connectivity to Top AHB hprot.
    property regif_top_ahb_hprot_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.SX_AHB_HPROT == InterruptController.SX_AHB_HPROT));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface AHB hsize connectivity to Top AHB hsize.
    property regif_top_ahb_hsize_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.SX_AHB_HSIZE == InterruptController.SX_AHB_HSIZE));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface AHB htrans connectivity to Top AHB htrans.
    property regif_top_ahb_htrans_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.SX_AHB_HTRANS == InterruptController.SX_AHB_HTRANS));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface AHB hwrite connectivity to Top AHB hwrite.
    property regif_top_ahb_hwrite_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.SX_AHB_HWRITE == InterruptController.SX_AHB_HWRITE));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface AHB hsel connectivity to Top AHB hsel.
    property regif_top_ahb_hsel_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.SX_AHB_HSEL == InterruptController.SX_AHB_HSEL));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface AHB hready connectivity to Top AHB hready.
    property regif_top_ahb_hready_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.SX_AHB_HREADY == InterruptController.SX_AHB_HREADY));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface AHB hrdata connectivity to Top AHB hrdata.
    property regif_top_ahb_hrdata_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.SX_AHB_HRDATA == InterruptController.SX_AHB_HRDATA));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface AHB hreadyout connectivity to Top AHB hreadyout.
    property regif_top_ahb_hreadyout_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.SX_AHB_HREADYOUT == InterruptController.SX_AHB_HREADYOUT));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface AHB hresp connectivity to Top AHB hresp.
    property regif_top_ahb_hresp_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.SX_AHB_HRESP == InterruptController.SX_AHB_HRESP));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_0_o is wired from Top BF enable_enable_int_0_out.
    property regif_peripheral_hw_out_enable_enable_int_0_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_0_out == InterruptController.comp_ICcomponent.enable_int_0_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_1_o is wired from Top BF enable_enable_int_1_out.
    property regif_peripheral_hw_out_enable_enable_int_1_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_1_out == InterruptController.comp_ICcomponent.enable_int_1_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_2_o is wired from Top BF enable_enable_int_2_out.
    property regif_peripheral_hw_out_enable_enable_int_2_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_2_out == InterruptController.comp_ICcomponent.enable_int_2_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_3_o is wired from Top BF enable_enable_int_3_out.
    property regif_peripheral_hw_out_enable_enable_int_3_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_3_out == InterruptController.comp_ICcomponent.enable_int_3_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_4_o is wired from Top BF enable_enable_int_4_out.
    property regif_peripheral_hw_out_enable_enable_int_4_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_4_out == InterruptController.comp_ICcomponent.enable_int_4_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_5_o is wired from Top BF enable_enable_int_5_out.
    property regif_peripheral_hw_out_enable_enable_int_5_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_5_out == InterruptController.comp_ICcomponent.enable_int_5_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_6_o is wired from Top BF enable_enable_int_6_out.
    property regif_peripheral_hw_out_enable_enable_int_6_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_6_out == InterruptController.comp_ICcomponent.enable_int_6_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_7_o is wired from Top BF enable_enable_int_7_out.
    property regif_peripheral_hw_out_enable_enable_int_7_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_7_out == InterruptController.comp_ICcomponent.enable_int_7_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_8_o is wired from Top BF enable_enable_int_8_out.
    property regif_peripheral_hw_out_enable_enable_int_8_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_8_out == InterruptController.comp_ICcomponent.enable_int_8_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_9_o is wired from Top BF enable_enable_int_9_out.
    property regif_peripheral_hw_out_enable_enable_int_9_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_9_out == InterruptController.comp_ICcomponent.enable_int_9_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_10_o is wired from Top BF enable_enable_int_10_out.
    property regif_peripheral_hw_out_enable_enable_int_10_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_10_out == InterruptController.comp_ICcomponent.enable_int_10_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_11_o is wired from Top BF enable_enable_int_11_out.
    property regif_peripheral_hw_out_enable_enable_int_11_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_11_out == InterruptController.comp_ICcomponent.enable_int_11_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_12_o is wired from Top BF enable_enable_int_12_out.
    property regif_peripheral_hw_out_enable_enable_int_12_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_12_out == InterruptController.comp_ICcomponent.enable_int_12_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_13_o is wired from Top BF enable_enable_int_13_out.
    property regif_peripheral_hw_out_enable_enable_int_13_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_13_out == InterruptController.comp_ICcomponent.enable_int_13_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_14_o is wired from Top BF enable_enable_int_14_out.
    property regif_peripheral_hw_out_enable_enable_int_14_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_14_out == InterruptController.comp_ICcomponent.enable_int_14_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_15_o is wired from Top BF enable_enable_int_15_out.
    property regif_peripheral_hw_out_enable_enable_int_15_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_15_out == InterruptController.comp_ICcomponent.enable_int_15_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_16_o is wired from Top BF enable_enable_int_16_out.
    property regif_peripheral_hw_out_enable_enable_int_16_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_16_out == InterruptController.comp_ICcomponent.enable_int_16_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_17_o is wired from Top BF enable_enable_int_17_out.
    property regif_peripheral_hw_out_enable_enable_int_17_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_17_out == InterruptController.comp_ICcomponent.enable_int_17_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_18_o is wired from Top BF enable_enable_int_18_out.
    property regif_peripheral_hw_out_enable_enable_int_18_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_18_out == InterruptController.comp_ICcomponent.enable_int_18_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_19_o is wired from Top BF enable_enable_int_19_out.
    property regif_peripheral_hw_out_enable_enable_int_19_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_19_out == InterruptController.comp_ICcomponent.enable_int_19_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_20_o is wired from Top BF enable_enable_int_20_out.
    property regif_peripheral_hw_out_enable_enable_int_20_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_20_out == InterruptController.comp_ICcomponent.enable_int_20_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_21_o is wired from Top BF enable_enable_int_21_out.
    property regif_peripheral_hw_out_enable_enable_int_21_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_21_out == InterruptController.comp_ICcomponent.enable_int_21_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_22_o is wired from Top BF enable_enable_int_22_out.
    property regif_peripheral_hw_out_enable_enable_int_22_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_22_out == InterruptController.comp_ICcomponent.enable_int_22_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_23_o is wired from Top BF enable_enable_int_23_out.
    property regif_peripheral_hw_out_enable_enable_int_23_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_23_out == InterruptController.comp_ICcomponent.enable_int_23_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_24_o is wired from Top BF enable_enable_int_24_out.
    property regif_peripheral_hw_out_enable_enable_int_24_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_24_out == InterruptController.comp_ICcomponent.enable_int_24_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_25_o is wired from Top BF enable_enable_int_25_out.
    property regif_peripheral_hw_out_enable_enable_int_25_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_25_out == InterruptController.comp_ICcomponent.enable_int_25_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_26_o is wired from Top BF enable_enable_int_26_out.
    property regif_peripheral_hw_out_enable_enable_int_26_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_26_out == InterruptController.comp_ICcomponent.enable_int_26_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_27_o is wired from Top BF enable_enable_int_27_out.
    property regif_peripheral_hw_out_enable_enable_int_27_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_27_out == InterruptController.comp_ICcomponent.enable_int_27_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_28_o is wired from Top BF enable_enable_int_28_out.
    property regif_peripheral_hw_out_enable_enable_int_28_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_28_out == InterruptController.comp_ICcomponent.enable_int_28_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_29_o is wired from Top BF enable_enable_int_29_out.
    property regif_peripheral_hw_out_enable_enable_int_29_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_29_out == InterruptController.comp_ICcomponent.enable_int_29_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_30_o is wired from Top BF enable_enable_int_30_out.
    property regif_peripheral_hw_out_enable_enable_int_30_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_30_out == InterruptController.comp_ICcomponent.enable_int_30_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output enable_enable_int_31_o is wired from Top BF enable_enable_int_31_out.
    property regif_peripheral_hw_out_enable_enable_int_31_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_enable_int_31_out == InterruptController.comp_ICcomponent.enable_int_31_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_0_o is wired from Top BF unmask_unmask_int_0_out.
    property regif_peripheral_hw_out_unmask_unmask_int_0_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_0_out == InterruptController.comp_ICcomponent.unmask_int_0_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_1_o is wired from Top BF unmask_unmask_int_1_out.
    property regif_peripheral_hw_out_unmask_unmask_int_1_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_1_out == InterruptController.comp_ICcomponent.unmask_int_1_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_2_o is wired from Top BF unmask_unmask_int_2_out.
    property regif_peripheral_hw_out_unmask_unmask_int_2_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_2_out == InterruptController.comp_ICcomponent.unmask_int_2_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_3_o is wired from Top BF unmask_unmask_int_3_out.
    property regif_peripheral_hw_out_unmask_unmask_int_3_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_3_out == InterruptController.comp_ICcomponent.unmask_int_3_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_4_o is wired from Top BF unmask_unmask_int_4_out.
    property regif_peripheral_hw_out_unmask_unmask_int_4_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_4_out == InterruptController.comp_ICcomponent.unmask_int_4_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_5_o is wired from Top BF unmask_unmask_int_5_out.
    property regif_peripheral_hw_out_unmask_unmask_int_5_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_5_out == InterruptController.comp_ICcomponent.unmask_int_5_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_6_o is wired from Top BF unmask_unmask_int_6_out.
    property regif_peripheral_hw_out_unmask_unmask_int_6_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_6_out == InterruptController.comp_ICcomponent.unmask_int_6_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_7_o is wired from Top BF unmask_unmask_int_7_out.
    property regif_peripheral_hw_out_unmask_unmask_int_7_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_7_out == InterruptController.comp_ICcomponent.unmask_int_7_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_8_o is wired from Top BF unmask_unmask_int_8_out.
    property regif_peripheral_hw_out_unmask_unmask_int_8_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_8_out == InterruptController.comp_ICcomponent.unmask_int_8_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_9_o is wired from Top BF unmask_unmask_int_9_out.
    property regif_peripheral_hw_out_unmask_unmask_int_9_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_9_out == InterruptController.comp_ICcomponent.unmask_int_9_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_10_o is wired from Top BF unmask_unmask_int_10_out.
    property regif_peripheral_hw_out_unmask_unmask_int_10_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_10_out == InterruptController.comp_ICcomponent.unmask_int_10_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_11_o is wired from Top BF unmask_unmask_int_11_out.
    property regif_peripheral_hw_out_unmask_unmask_int_11_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_11_out == InterruptController.comp_ICcomponent.unmask_int_11_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_12_o is wired from Top BF unmask_unmask_int_12_out.
    property regif_peripheral_hw_out_unmask_unmask_int_12_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_12_out == InterruptController.comp_ICcomponent.unmask_int_12_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_13_o is wired from Top BF unmask_unmask_int_13_out.
    property regif_peripheral_hw_out_unmask_unmask_int_13_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_13_out == InterruptController.comp_ICcomponent.unmask_int_13_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_14_o is wired from Top BF unmask_unmask_int_14_out.
    property regif_peripheral_hw_out_unmask_unmask_int_14_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_14_out == InterruptController.comp_ICcomponent.unmask_int_14_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_15_o is wired from Top BF unmask_unmask_int_15_out.
    property regif_peripheral_hw_out_unmask_unmask_int_15_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_15_out == InterruptController.comp_ICcomponent.unmask_int_15_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_16_o is wired from Top BF unmask_unmask_int_16_out.
    property regif_peripheral_hw_out_unmask_unmask_int_16_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_16_out == InterruptController.comp_ICcomponent.unmask_int_16_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_17_o is wired from Top BF unmask_unmask_int_17_out.
    property regif_peripheral_hw_out_unmask_unmask_int_17_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_17_out == InterruptController.comp_ICcomponent.unmask_int_17_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_18_o is wired from Top BF unmask_unmask_int_18_out.
    property regif_peripheral_hw_out_unmask_unmask_int_18_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_18_out == InterruptController.comp_ICcomponent.unmask_int_18_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_19_o is wired from Top BF unmask_unmask_int_19_out.
    property regif_peripheral_hw_out_unmask_unmask_int_19_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_19_out == InterruptController.comp_ICcomponent.unmask_int_19_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_20_o is wired from Top BF unmask_unmask_int_20_out.
    property regif_peripheral_hw_out_unmask_unmask_int_20_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_20_out == InterruptController.comp_ICcomponent.unmask_int_20_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_21_o is wired from Top BF unmask_unmask_int_21_out.
    property regif_peripheral_hw_out_unmask_unmask_int_21_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_21_out == InterruptController.comp_ICcomponent.unmask_int_21_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_22_o is wired from Top BF unmask_unmask_int_22_out.
    property regif_peripheral_hw_out_unmask_unmask_int_22_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_22_out == InterruptController.comp_ICcomponent.unmask_int_22_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_23_o is wired from Top BF unmask_unmask_int_23_out.
    property regif_peripheral_hw_out_unmask_unmask_int_23_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_23_out == InterruptController.comp_ICcomponent.unmask_int_23_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_24_o is wired from Top BF unmask_unmask_int_24_out.
    property regif_peripheral_hw_out_unmask_unmask_int_24_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_24_out == InterruptController.comp_ICcomponent.unmask_int_24_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_25_o is wired from Top BF unmask_unmask_int_25_out.
    property regif_peripheral_hw_out_unmask_unmask_int_25_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_25_out == InterruptController.comp_ICcomponent.unmask_int_25_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_26_o is wired from Top BF unmask_unmask_int_26_out.
    property regif_peripheral_hw_out_unmask_unmask_int_26_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_26_out == InterruptController.comp_ICcomponent.unmask_int_26_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_27_o is wired from Top BF unmask_unmask_int_27_out.
    property regif_peripheral_hw_out_unmask_unmask_int_27_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_27_out == InterruptController.comp_ICcomponent.unmask_int_27_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_28_o is wired from Top BF unmask_unmask_int_28_out.
    property regif_peripheral_hw_out_unmask_unmask_int_28_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_28_out == InterruptController.comp_ICcomponent.unmask_int_28_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_29_o is wired from Top BF unmask_unmask_int_29_out.
    property regif_peripheral_hw_out_unmask_unmask_int_29_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_29_out == InterruptController.comp_ICcomponent.unmask_int_29_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_30_o is wired from Top BF unmask_unmask_int_30_out.
    property regif_peripheral_hw_out_unmask_unmask_int_30_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_30_out == InterruptController.comp_ICcomponent.unmask_int_30_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output unmask_unmask_int_31_o is wired from Top BF unmask_unmask_int_31_out.
    property regif_peripheral_hw_out_unmask_unmask_int_31_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_unmask_int_31_out == InterruptController.comp_ICcomponent.unmask_int_31_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_0_i is wired to Top BF pending_pending_int_0_in.
    property regif_peripheral_hw_in_pending_pending_int_0_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_0_in == InterruptController.comp_ICcomponent.pending_int_0_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_0_en_i is wired to Top BF pending_pending_int_0_peripheral_wr_en.
    property regif_peripheral_hw_en_pending_pending_int_0_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_0_peripheral_wr_en == InterruptController.comp_ICcomponent.pending_int_0_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_0_o is wired from Top BF pending_pending_int_0_out.
    property regif_peripheral_hw_out_pending_pending_int_0_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_0_out == InterruptController.comp_ICcomponent.pending_int_0_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_1_i is wired to Top BF pending_pending_int_1_in.
    property regif_peripheral_hw_in_pending_pending_int_1_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_1_in == InterruptController.comp_ICcomponent.pending_int_1_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_1_en_i is wired to Top BF pending_pending_int_1_peripheral_wr_en.
    property regif_peripheral_hw_en_pending_pending_int_1_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_1_peripheral_wr_en == InterruptController.comp_ICcomponent.pending_int_1_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_1_o is wired from Top BF pending_pending_int_1_out.
    property regif_peripheral_hw_out_pending_pending_int_1_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_1_out == InterruptController.comp_ICcomponent.pending_int_1_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_2_i is wired to Top BF pending_pending_int_2_in.
    property regif_peripheral_hw_in_pending_pending_int_2_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_2_in == InterruptController.comp_ICcomponent.pending_int_2_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_2_en_i is wired to Top BF pending_pending_int_2_peripheral_wr_en.
    property regif_peripheral_hw_en_pending_pending_int_2_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_2_peripheral_wr_en == InterruptController.comp_ICcomponent.pending_int_2_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_2_o is wired from Top BF pending_pending_int_2_out.
    property regif_peripheral_hw_out_pending_pending_int_2_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_2_out == InterruptController.comp_ICcomponent.pending_int_2_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_3_i is wired to Top BF pending_pending_int_3_in.
    property regif_peripheral_hw_in_pending_pending_int_3_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_3_in == InterruptController.comp_ICcomponent.pending_int_3_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_3_en_i is wired to Top BF pending_pending_int_3_peripheral_wr_en.
    property regif_peripheral_hw_en_pending_pending_int_3_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_3_peripheral_wr_en == InterruptController.comp_ICcomponent.pending_int_3_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_3_o is wired from Top BF pending_pending_int_3_out.
    property regif_peripheral_hw_out_pending_pending_int_3_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_3_out == InterruptController.comp_ICcomponent.pending_int_3_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_4_i is wired to Top BF pending_pending_int_4_in.
    property regif_peripheral_hw_in_pending_pending_int_4_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_4_in == InterruptController.comp_ICcomponent.pending_int_4_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_4_en_i is wired to Top BF pending_pending_int_4_peripheral_wr_en.
    property regif_peripheral_hw_en_pending_pending_int_4_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_4_peripheral_wr_en == InterruptController.comp_ICcomponent.pending_int_4_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_4_o is wired from Top BF pending_pending_int_4_out.
    property regif_peripheral_hw_out_pending_pending_int_4_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_4_out == InterruptController.comp_ICcomponent.pending_int_4_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_5_i is wired to Top BF pending_pending_int_5_in.
    property regif_peripheral_hw_in_pending_pending_int_5_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_5_in == InterruptController.comp_ICcomponent.pending_int_5_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_5_en_i is wired to Top BF pending_pending_int_5_peripheral_wr_en.
    property regif_peripheral_hw_en_pending_pending_int_5_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_5_peripheral_wr_en == InterruptController.comp_ICcomponent.pending_int_5_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_5_o is wired from Top BF pending_pending_int_5_out.
    property regif_peripheral_hw_out_pending_pending_int_5_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_5_out == InterruptController.comp_ICcomponent.pending_int_5_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_6_i is wired to Top BF pending_pending_int_6_in.
    property regif_peripheral_hw_in_pending_pending_int_6_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_6_in == InterruptController.comp_ICcomponent.pending_int_6_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_6_en_i is wired to Top BF pending_pending_int_6_peripheral_wr_en.
    property regif_peripheral_hw_en_pending_pending_int_6_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_6_peripheral_wr_en == InterruptController.comp_ICcomponent.pending_int_6_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_6_o is wired from Top BF pending_pending_int_6_out.
    property regif_peripheral_hw_out_pending_pending_int_6_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_6_out == InterruptController.comp_ICcomponent.pending_int_6_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_7_i is wired to Top BF pending_pending_int_7_in.
    property regif_peripheral_hw_in_pending_pending_int_7_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_7_in == InterruptController.comp_ICcomponent.pending_int_7_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_7_en_i is wired to Top BF pending_pending_int_7_peripheral_wr_en.
    property regif_peripheral_hw_en_pending_pending_int_7_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_7_peripheral_wr_en == InterruptController.comp_ICcomponent.pending_int_7_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_7_o is wired from Top BF pending_pending_int_7_out.
    property regif_peripheral_hw_out_pending_pending_int_7_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_7_out == InterruptController.comp_ICcomponent.pending_int_7_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_8_i is wired to Top BF pending_pending_int_8_in.
    property regif_peripheral_hw_in_pending_pending_int_8_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_8_in == InterruptController.comp_ICcomponent.pending_int_8_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_8_en_i is wired to Top BF pending_pending_int_8_peripheral_wr_en.
    property regif_peripheral_hw_en_pending_pending_int_8_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_8_peripheral_wr_en == InterruptController.comp_ICcomponent.pending_int_8_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_8_o is wired from Top BF pending_pending_int_8_out.
    property regif_peripheral_hw_out_pending_pending_int_8_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_8_out == InterruptController.comp_ICcomponent.pending_int_8_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_9_i is wired to Top BF pending_pending_int_9_in.
    property regif_peripheral_hw_in_pending_pending_int_9_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_9_in == InterruptController.comp_ICcomponent.pending_int_9_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_9_en_i is wired to Top BF pending_pending_int_9_peripheral_wr_en.
    property regif_peripheral_hw_en_pending_pending_int_9_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_9_peripheral_wr_en == InterruptController.comp_ICcomponent.pending_int_9_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_9_o is wired from Top BF pending_pending_int_9_out.
    property regif_peripheral_hw_out_pending_pending_int_9_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_9_out == InterruptController.comp_ICcomponent.pending_int_9_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_10_i is wired to Top BF pending_pending_int_10_in.
    property regif_peripheral_hw_in_pending_pending_int_10_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_10_in == InterruptController.comp_ICcomponent.pending_int_10_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_10_en_i is wired to Top BF pending_pending_int_10_peripheral_wr_en.
    property regif_peripheral_hw_en_pending_pending_int_10_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_10_peripheral_wr_en == InterruptController.comp_ICcomponent.pending_int_10_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_10_o is wired from Top BF pending_pending_int_10_out.
    property regif_peripheral_hw_out_pending_pending_int_10_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_10_out == InterruptController.comp_ICcomponent.pending_int_10_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_11_i is wired to Top BF pending_pending_int_11_in.
    property regif_peripheral_hw_in_pending_pending_int_11_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_11_in == InterruptController.comp_ICcomponent.pending_int_11_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_11_en_i is wired to Top BF pending_pending_int_11_peripheral_wr_en.
    property regif_peripheral_hw_en_pending_pending_int_11_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_11_peripheral_wr_en == InterruptController.comp_ICcomponent.pending_int_11_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_11_o is wired from Top BF pending_pending_int_11_out.
    property regif_peripheral_hw_out_pending_pending_int_11_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_11_out == InterruptController.comp_ICcomponent.pending_int_11_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_12_i is wired to Top BF pending_pending_int_12_in.
    property regif_peripheral_hw_in_pending_pending_int_12_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_12_in == InterruptController.comp_ICcomponent.pending_int_12_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_12_en_i is wired to Top BF pending_pending_int_12_peripheral_wr_en.
    property regif_peripheral_hw_en_pending_pending_int_12_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_12_peripheral_wr_en == InterruptController.comp_ICcomponent.pending_int_12_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_12_o is wired from Top BF pending_pending_int_12_out.
    property regif_peripheral_hw_out_pending_pending_int_12_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_12_out == InterruptController.comp_ICcomponent.pending_int_12_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_13_i is wired to Top BF pending_pending_int_13_in.
    property regif_peripheral_hw_in_pending_pending_int_13_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_13_in == InterruptController.comp_ICcomponent.pending_int_13_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_13_en_i is wired to Top BF pending_pending_int_13_peripheral_wr_en.
    property regif_peripheral_hw_en_pending_pending_int_13_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_13_peripheral_wr_en == InterruptController.comp_ICcomponent.pending_int_13_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_13_o is wired from Top BF pending_pending_int_13_out.
    property regif_peripheral_hw_out_pending_pending_int_13_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_13_out == InterruptController.comp_ICcomponent.pending_int_13_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_14_i is wired to Top BF pending_pending_int_14_in.
    property regif_peripheral_hw_in_pending_pending_int_14_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_14_in == InterruptController.comp_ICcomponent.pending_int_14_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_14_en_i is wired to Top BF pending_pending_int_14_peripheral_wr_en.
    property regif_peripheral_hw_en_pending_pending_int_14_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_14_peripheral_wr_en == InterruptController.comp_ICcomponent.pending_int_14_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_14_o is wired from Top BF pending_pending_int_14_out.
    property regif_peripheral_hw_out_pending_pending_int_14_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_14_out == InterruptController.comp_ICcomponent.pending_int_14_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_15_i is wired to Top BF pending_pending_int_15_in.
    property regif_peripheral_hw_in_pending_pending_int_15_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_15_in == InterruptController.comp_ICcomponent.pending_int_15_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_15_en_i is wired to Top BF pending_pending_int_15_peripheral_wr_en.
    property regif_peripheral_hw_en_pending_pending_int_15_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_15_peripheral_wr_en == InterruptController.comp_ICcomponent.pending_int_15_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_15_o is wired from Top BF pending_pending_int_15_out.
    property regif_peripheral_hw_out_pending_pending_int_15_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_15_out == InterruptController.comp_ICcomponent.pending_int_15_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_16_i is wired to Top BF pending_pending_int_16_in.
    property regif_peripheral_hw_in_pending_pending_int_16_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_16_in == InterruptController.comp_ICcomponent.pending_int_16_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_16_en_i is wired to Top BF pending_pending_int_16_peripheral_wr_en.
    property regif_peripheral_hw_en_pending_pending_int_16_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_16_peripheral_wr_en == InterruptController.comp_ICcomponent.pending_int_16_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_16_o is wired from Top BF pending_pending_int_16_out.
    property regif_peripheral_hw_out_pending_pending_int_16_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_16_out == InterruptController.comp_ICcomponent.pending_int_16_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_17_i is wired to Top BF pending_pending_int_17_in.
    property regif_peripheral_hw_in_pending_pending_int_17_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_17_in == InterruptController.comp_ICcomponent.pending_int_17_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_17_en_i is wired to Top BF pending_pending_int_17_peripheral_wr_en.
    property regif_peripheral_hw_en_pending_pending_int_17_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_17_peripheral_wr_en == InterruptController.comp_ICcomponent.pending_int_17_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_17_o is wired from Top BF pending_pending_int_17_out.
    property regif_peripheral_hw_out_pending_pending_int_17_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_17_out == InterruptController.comp_ICcomponent.pending_int_17_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_18_i is wired to Top BF pending_pending_int_18_in.
    property regif_peripheral_hw_in_pending_pending_int_18_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_18_in == InterruptController.comp_ICcomponent.pending_int_18_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_18_en_i is wired to Top BF pending_pending_int_18_peripheral_wr_en.
    property regif_peripheral_hw_en_pending_pending_int_18_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_18_peripheral_wr_en == InterruptController.comp_ICcomponent.pending_int_18_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_18_o is wired from Top BF pending_pending_int_18_out.
    property regif_peripheral_hw_out_pending_pending_int_18_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_18_out == InterruptController.comp_ICcomponent.pending_int_18_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_19_i is wired to Top BF pending_pending_int_19_in.
    property regif_peripheral_hw_in_pending_pending_int_19_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_19_in == InterruptController.comp_ICcomponent.pending_int_19_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_19_en_i is wired to Top BF pending_pending_int_19_peripheral_wr_en.
    property regif_peripheral_hw_en_pending_pending_int_19_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_19_peripheral_wr_en == InterruptController.comp_ICcomponent.pending_int_19_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_19_o is wired from Top BF pending_pending_int_19_out.
    property regif_peripheral_hw_out_pending_pending_int_19_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_19_out == InterruptController.comp_ICcomponent.pending_int_19_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_20_i is wired to Top BF pending_pending_int_20_in.
    property regif_peripheral_hw_in_pending_pending_int_20_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_20_in == InterruptController.comp_ICcomponent.pending_int_20_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_20_en_i is wired to Top BF pending_pending_int_20_peripheral_wr_en.
    property regif_peripheral_hw_en_pending_pending_int_20_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_20_peripheral_wr_en == InterruptController.comp_ICcomponent.pending_int_20_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_20_o is wired from Top BF pending_pending_int_20_out.
    property regif_peripheral_hw_out_pending_pending_int_20_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_20_out == InterruptController.comp_ICcomponent.pending_int_20_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_21_i is wired to Top BF pending_pending_int_21_in.
    property regif_peripheral_hw_in_pending_pending_int_21_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_21_in == InterruptController.comp_ICcomponent.pending_int_21_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_21_en_i is wired to Top BF pending_pending_int_21_peripheral_wr_en.
    property regif_peripheral_hw_en_pending_pending_int_21_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_21_peripheral_wr_en == InterruptController.comp_ICcomponent.pending_int_21_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_21_o is wired from Top BF pending_pending_int_21_out.
    property regif_peripheral_hw_out_pending_pending_int_21_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_21_out == InterruptController.comp_ICcomponent.pending_int_21_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_22_i is wired to Top BF pending_pending_int_22_in.
    property regif_peripheral_hw_in_pending_pending_int_22_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_22_in == InterruptController.comp_ICcomponent.pending_int_22_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_22_en_i is wired to Top BF pending_pending_int_22_peripheral_wr_en.
    property regif_peripheral_hw_en_pending_pending_int_22_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_22_peripheral_wr_en == InterruptController.comp_ICcomponent.pending_int_22_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_22_o is wired from Top BF pending_pending_int_22_out.
    property regif_peripheral_hw_out_pending_pending_int_22_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_22_out == InterruptController.comp_ICcomponent.pending_int_22_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_23_i is wired to Top BF pending_pending_int_23_in.
    property regif_peripheral_hw_in_pending_pending_int_23_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_23_in == InterruptController.comp_ICcomponent.pending_int_23_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_23_en_i is wired to Top BF pending_pending_int_23_peripheral_wr_en.
    property regif_peripheral_hw_en_pending_pending_int_23_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_23_peripheral_wr_en == InterruptController.comp_ICcomponent.pending_int_23_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_23_o is wired from Top BF pending_pending_int_23_out.
    property regif_peripheral_hw_out_pending_pending_int_23_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_23_out == InterruptController.comp_ICcomponent.pending_int_23_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_24_i is wired to Top BF pending_pending_int_24_in.
    property regif_peripheral_hw_in_pending_pending_int_24_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_24_in == InterruptController.comp_ICcomponent.pending_int_24_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_24_en_i is wired to Top BF pending_pending_int_24_peripheral_wr_en.
    property regif_peripheral_hw_en_pending_pending_int_24_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_24_peripheral_wr_en == InterruptController.comp_ICcomponent.pending_int_24_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_24_o is wired from Top BF pending_pending_int_24_out.
    property regif_peripheral_hw_out_pending_pending_int_24_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_24_out == InterruptController.comp_ICcomponent.pending_int_24_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_25_i is wired to Top BF pending_pending_int_25_in.
    property regif_peripheral_hw_in_pending_pending_int_25_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_25_in == InterruptController.comp_ICcomponent.pending_int_25_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_25_en_i is wired to Top BF pending_pending_int_25_peripheral_wr_en.
    property regif_peripheral_hw_en_pending_pending_int_25_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_25_peripheral_wr_en == InterruptController.comp_ICcomponent.pending_int_25_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_25_o is wired from Top BF pending_pending_int_25_out.
    property regif_peripheral_hw_out_pending_pending_int_25_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_25_out == InterruptController.comp_ICcomponent.pending_int_25_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_26_i is wired to Top BF pending_pending_int_26_in.
    property regif_peripheral_hw_in_pending_pending_int_26_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_26_in == InterruptController.comp_ICcomponent.pending_int_26_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_26_en_i is wired to Top BF pending_pending_int_26_peripheral_wr_en.
    property regif_peripheral_hw_en_pending_pending_int_26_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_26_peripheral_wr_en == InterruptController.comp_ICcomponent.pending_int_26_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_26_o is wired from Top BF pending_pending_int_26_out.
    property regif_peripheral_hw_out_pending_pending_int_26_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_26_out == InterruptController.comp_ICcomponent.pending_int_26_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_27_i is wired to Top BF pending_pending_int_27_in.
    property regif_peripheral_hw_in_pending_pending_int_27_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_27_in == InterruptController.comp_ICcomponent.pending_int_27_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_27_en_i is wired to Top BF pending_pending_int_27_peripheral_wr_en.
    property regif_peripheral_hw_en_pending_pending_int_27_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_27_peripheral_wr_en == InterruptController.comp_ICcomponent.pending_int_27_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_27_o is wired from Top BF pending_pending_int_27_out.
    property regif_peripheral_hw_out_pending_pending_int_27_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_27_out == InterruptController.comp_ICcomponent.pending_int_27_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_28_i is wired to Top BF pending_pending_int_28_in.
    property regif_peripheral_hw_in_pending_pending_int_28_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_28_in == InterruptController.comp_ICcomponent.pending_int_28_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_28_en_i is wired to Top BF pending_pending_int_28_peripheral_wr_en.
    property regif_peripheral_hw_en_pending_pending_int_28_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_28_peripheral_wr_en == InterruptController.comp_ICcomponent.pending_int_28_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_28_o is wired from Top BF pending_pending_int_28_out.
    property regif_peripheral_hw_out_pending_pending_int_28_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_28_out == InterruptController.comp_ICcomponent.pending_int_28_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_29_i is wired to Top BF pending_pending_int_29_in.
    property regif_peripheral_hw_in_pending_pending_int_29_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_29_in == InterruptController.comp_ICcomponent.pending_int_29_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_29_en_i is wired to Top BF pending_pending_int_29_peripheral_wr_en.
    property regif_peripheral_hw_en_pending_pending_int_29_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_29_peripheral_wr_en == InterruptController.comp_ICcomponent.pending_int_29_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_29_o is wired from Top BF pending_pending_int_29_out.
    property regif_peripheral_hw_out_pending_pending_int_29_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_29_out == InterruptController.comp_ICcomponent.pending_int_29_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_30_i is wired to Top BF pending_pending_int_30_in.
    property regif_peripheral_hw_in_pending_pending_int_30_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_30_in == InterruptController.comp_ICcomponent.pending_int_30_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_30_en_i is wired to Top BF pending_pending_int_30_peripheral_wr_en.
    property regif_peripheral_hw_en_pending_pending_int_30_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_30_peripheral_wr_en == InterruptController.comp_ICcomponent.pending_int_30_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_30_o is wired from Top BF pending_pending_int_30_out.
    property regif_peripheral_hw_out_pending_pending_int_30_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_30_out == InterruptController.comp_ICcomponent.pending_int_30_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_pending_int_31_i is wired to Top BF pending_pending_int_31_in.
    property regif_peripheral_hw_in_pending_pending_int_31_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_31_in == InterruptController.comp_ICcomponent.pending_int_31_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_pending_int_31_en_i is wired to Top BF pending_pending_int_31_peripheral_wr_en.
    property regif_peripheral_hw_en_pending_pending_int_31_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_31_peripheral_wr_en == InterruptController.comp_ICcomponent.pending_int_31_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_pending_int_31_o is wired from Top BF pending_pending_int_31_out.
    property regif_peripheral_hw_out_pending_pending_int_31_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_int_31_out == InterruptController.comp_ICcomponent.pending_int_31_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input pending_1_pending_NMI_i is wired to Top BF pending_1_pending_NMI_in.
    property regif_peripheral_hw_in_pending_1_pending_NMI_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_NMI_in == InterruptController.comp_ICcomponent.pending_NMI_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable pending_1_pending_NMI_en_i is wired to Top BF pending_1_pending_NMI_peripheral_wr_en.
    property regif_peripheral_hw_en_pending_1_pending_NMI_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_NMI_peripheral_wr_en == InterruptController.comp_ICcomponent.pending_NMI_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output pending_1_pending_NMI_o is wired from Top BF pending_1_pending_NMI_out.
    property regif_peripheral_hw_out_pending_1_pending_NMI_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_pending_NMI_out == InterruptController.comp_ICcomponent.pending_NMI_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_0_i is wired to Top BF active_active_int_0_in.
    property regif_peripheral_hw_in_active_active_int_0_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_0_in == InterruptController.comp_ICcomponent.active_int_0_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_0_en_i is wired to Top BF active_active_int_0_peripheral_wr_en.
    property regif_peripheral_hw_en_active_active_int_0_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_0_peripheral_wr_en == InterruptController.comp_ICcomponent.active_int_0_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_0_o is wired from Top BF active_active_int_0_out.
    property regif_peripheral_hw_out_active_active_int_0_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_0_out == InterruptController.comp_ICcomponent.active_int_0_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_1_i is wired to Top BF active_active_int_1_in.
    property regif_peripheral_hw_in_active_active_int_1_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_1_in == InterruptController.comp_ICcomponent.active_int_1_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_1_en_i is wired to Top BF active_active_int_1_peripheral_wr_en.
    property regif_peripheral_hw_en_active_active_int_1_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_1_peripheral_wr_en == InterruptController.comp_ICcomponent.active_int_1_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_1_o is wired from Top BF active_active_int_1_out.
    property regif_peripheral_hw_out_active_active_int_1_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_1_out == InterruptController.comp_ICcomponent.active_int_1_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_2_i is wired to Top BF active_active_int_2_in.
    property regif_peripheral_hw_in_active_active_int_2_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_2_in == InterruptController.comp_ICcomponent.active_int_2_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_2_en_i is wired to Top BF active_active_int_2_peripheral_wr_en.
    property regif_peripheral_hw_en_active_active_int_2_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_2_peripheral_wr_en == InterruptController.comp_ICcomponent.active_int_2_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_2_o is wired from Top BF active_active_int_2_out.
    property regif_peripheral_hw_out_active_active_int_2_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_2_out == InterruptController.comp_ICcomponent.active_int_2_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_3_i is wired to Top BF active_active_int_3_in.
    property regif_peripheral_hw_in_active_active_int_3_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_3_in == InterruptController.comp_ICcomponent.active_int_3_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_3_en_i is wired to Top BF active_active_int_3_peripheral_wr_en.
    property regif_peripheral_hw_en_active_active_int_3_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_3_peripheral_wr_en == InterruptController.comp_ICcomponent.active_int_3_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_3_o is wired from Top BF active_active_int_3_out.
    property regif_peripheral_hw_out_active_active_int_3_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_3_out == InterruptController.comp_ICcomponent.active_int_3_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_4_i is wired to Top BF active_active_int_4_in.
    property regif_peripheral_hw_in_active_active_int_4_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_4_in == InterruptController.comp_ICcomponent.active_int_4_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_4_en_i is wired to Top BF active_active_int_4_peripheral_wr_en.
    property regif_peripheral_hw_en_active_active_int_4_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_4_peripheral_wr_en == InterruptController.comp_ICcomponent.active_int_4_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_4_o is wired from Top BF active_active_int_4_out.
    property regif_peripheral_hw_out_active_active_int_4_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_4_out == InterruptController.comp_ICcomponent.active_int_4_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_5_i is wired to Top BF active_active_int_5_in.
    property regif_peripheral_hw_in_active_active_int_5_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_5_in == InterruptController.comp_ICcomponent.active_int_5_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_5_en_i is wired to Top BF active_active_int_5_peripheral_wr_en.
    property regif_peripheral_hw_en_active_active_int_5_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_5_peripheral_wr_en == InterruptController.comp_ICcomponent.active_int_5_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_5_o is wired from Top BF active_active_int_5_out.
    property regif_peripheral_hw_out_active_active_int_5_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_5_out == InterruptController.comp_ICcomponent.active_int_5_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_6_i is wired to Top BF active_active_int_6_in.
    property regif_peripheral_hw_in_active_active_int_6_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_6_in == InterruptController.comp_ICcomponent.active_int_6_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_6_en_i is wired to Top BF active_active_int_6_peripheral_wr_en.
    property regif_peripheral_hw_en_active_active_int_6_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_6_peripheral_wr_en == InterruptController.comp_ICcomponent.active_int_6_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_6_o is wired from Top BF active_active_int_6_out.
    property regif_peripheral_hw_out_active_active_int_6_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_6_out == InterruptController.comp_ICcomponent.active_int_6_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_7_i is wired to Top BF active_active_int_7_in.
    property regif_peripheral_hw_in_active_active_int_7_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_7_in == InterruptController.comp_ICcomponent.active_int_7_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_7_en_i is wired to Top BF active_active_int_7_peripheral_wr_en.
    property regif_peripheral_hw_en_active_active_int_7_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_7_peripheral_wr_en == InterruptController.comp_ICcomponent.active_int_7_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_7_o is wired from Top BF active_active_int_7_out.
    property regif_peripheral_hw_out_active_active_int_7_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_7_out == InterruptController.comp_ICcomponent.active_int_7_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_8_i is wired to Top BF active_active_int_8_in.
    property regif_peripheral_hw_in_active_active_int_8_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_8_in == InterruptController.comp_ICcomponent.active_int_8_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_8_en_i is wired to Top BF active_active_int_8_peripheral_wr_en.
    property regif_peripheral_hw_en_active_active_int_8_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_8_peripheral_wr_en == InterruptController.comp_ICcomponent.active_int_8_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_8_o is wired from Top BF active_active_int_8_out.
    property regif_peripheral_hw_out_active_active_int_8_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_8_out == InterruptController.comp_ICcomponent.active_int_8_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_9_i is wired to Top BF active_active_int_9_in.
    property regif_peripheral_hw_in_active_active_int_9_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_9_in == InterruptController.comp_ICcomponent.active_int_9_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_9_en_i is wired to Top BF active_active_int_9_peripheral_wr_en.
    property regif_peripheral_hw_en_active_active_int_9_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_9_peripheral_wr_en == InterruptController.comp_ICcomponent.active_int_9_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_9_o is wired from Top BF active_active_int_9_out.
    property regif_peripheral_hw_out_active_active_int_9_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_9_out == InterruptController.comp_ICcomponent.active_int_9_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_10_i is wired to Top BF active_active_int_10_in.
    property regif_peripheral_hw_in_active_active_int_10_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_10_in == InterruptController.comp_ICcomponent.active_int_10_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_10_en_i is wired to Top BF active_active_int_10_peripheral_wr_en.
    property regif_peripheral_hw_en_active_active_int_10_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_10_peripheral_wr_en == InterruptController.comp_ICcomponent.active_int_10_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_10_o is wired from Top BF active_active_int_10_out.
    property regif_peripheral_hw_out_active_active_int_10_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_10_out == InterruptController.comp_ICcomponent.active_int_10_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_11_i is wired to Top BF active_active_int_11_in.
    property regif_peripheral_hw_in_active_active_int_11_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_11_in == InterruptController.comp_ICcomponent.active_int_11_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_11_en_i is wired to Top BF active_active_int_11_peripheral_wr_en.
    property regif_peripheral_hw_en_active_active_int_11_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_11_peripheral_wr_en == InterruptController.comp_ICcomponent.active_int_11_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_11_o is wired from Top BF active_active_int_11_out.
    property regif_peripheral_hw_out_active_active_int_11_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_11_out == InterruptController.comp_ICcomponent.active_int_11_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_12_i is wired to Top BF active_active_int_12_in.
    property regif_peripheral_hw_in_active_active_int_12_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_12_in == InterruptController.comp_ICcomponent.active_int_12_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_12_en_i is wired to Top BF active_active_int_12_peripheral_wr_en.
    property regif_peripheral_hw_en_active_active_int_12_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_12_peripheral_wr_en == InterruptController.comp_ICcomponent.active_int_12_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_12_o is wired from Top BF active_active_int_12_out.
    property regif_peripheral_hw_out_active_active_int_12_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_12_out == InterruptController.comp_ICcomponent.active_int_12_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_13_i is wired to Top BF active_active_int_13_in.
    property regif_peripheral_hw_in_active_active_int_13_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_13_in == InterruptController.comp_ICcomponent.active_int_13_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_13_en_i is wired to Top BF active_active_int_13_peripheral_wr_en.
    property regif_peripheral_hw_en_active_active_int_13_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_13_peripheral_wr_en == InterruptController.comp_ICcomponent.active_int_13_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_13_o is wired from Top BF active_active_int_13_out.
    property regif_peripheral_hw_out_active_active_int_13_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_13_out == InterruptController.comp_ICcomponent.active_int_13_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_14_i is wired to Top BF active_active_int_14_in.
    property regif_peripheral_hw_in_active_active_int_14_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_14_in == InterruptController.comp_ICcomponent.active_int_14_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_14_en_i is wired to Top BF active_active_int_14_peripheral_wr_en.
    property regif_peripheral_hw_en_active_active_int_14_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_14_peripheral_wr_en == InterruptController.comp_ICcomponent.active_int_14_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_14_o is wired from Top BF active_active_int_14_out.
    property regif_peripheral_hw_out_active_active_int_14_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_14_out == InterruptController.comp_ICcomponent.active_int_14_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_15_i is wired to Top BF active_active_int_15_in.
    property regif_peripheral_hw_in_active_active_int_15_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_15_in == InterruptController.comp_ICcomponent.active_int_15_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_15_en_i is wired to Top BF active_active_int_15_peripheral_wr_en.
    property regif_peripheral_hw_en_active_active_int_15_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_15_peripheral_wr_en == InterruptController.comp_ICcomponent.active_int_15_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_15_o is wired from Top BF active_active_int_15_out.
    property regif_peripheral_hw_out_active_active_int_15_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_15_out == InterruptController.comp_ICcomponent.active_int_15_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_16_i is wired to Top BF active_active_int_16_in.
    property regif_peripheral_hw_in_active_active_int_16_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_16_in == InterruptController.comp_ICcomponent.active_int_16_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_16_en_i is wired to Top BF active_active_int_16_peripheral_wr_en.
    property regif_peripheral_hw_en_active_active_int_16_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_16_peripheral_wr_en == InterruptController.comp_ICcomponent.active_int_16_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_16_o is wired from Top BF active_active_int_16_out.
    property regif_peripheral_hw_out_active_active_int_16_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_16_out == InterruptController.comp_ICcomponent.active_int_16_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_17_i is wired to Top BF active_active_int_17_in.
    property regif_peripheral_hw_in_active_active_int_17_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_17_in == InterruptController.comp_ICcomponent.active_int_17_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_17_en_i is wired to Top BF active_active_int_17_peripheral_wr_en.
    property regif_peripheral_hw_en_active_active_int_17_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_17_peripheral_wr_en == InterruptController.comp_ICcomponent.active_int_17_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_17_o is wired from Top BF active_active_int_17_out.
    property regif_peripheral_hw_out_active_active_int_17_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_17_out == InterruptController.comp_ICcomponent.active_int_17_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_18_i is wired to Top BF active_active_int_18_in.
    property regif_peripheral_hw_in_active_active_int_18_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_18_in == InterruptController.comp_ICcomponent.active_int_18_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_18_en_i is wired to Top BF active_active_int_18_peripheral_wr_en.
    property regif_peripheral_hw_en_active_active_int_18_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_18_peripheral_wr_en == InterruptController.comp_ICcomponent.active_int_18_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_18_o is wired from Top BF active_active_int_18_out.
    property regif_peripheral_hw_out_active_active_int_18_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_18_out == InterruptController.comp_ICcomponent.active_int_18_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_19_i is wired to Top BF active_active_int_19_in.
    property regif_peripheral_hw_in_active_active_int_19_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_19_in == InterruptController.comp_ICcomponent.active_int_19_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_19_en_i is wired to Top BF active_active_int_19_peripheral_wr_en.
    property regif_peripheral_hw_en_active_active_int_19_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_19_peripheral_wr_en == InterruptController.comp_ICcomponent.active_int_19_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_19_o is wired from Top BF active_active_int_19_out.
    property regif_peripheral_hw_out_active_active_int_19_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_19_out == InterruptController.comp_ICcomponent.active_int_19_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_20_i is wired to Top BF active_active_int_20_in.
    property regif_peripheral_hw_in_active_active_int_20_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_20_in == InterruptController.comp_ICcomponent.active_int_20_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_20_en_i is wired to Top BF active_active_int_20_peripheral_wr_en.
    property regif_peripheral_hw_en_active_active_int_20_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_20_peripheral_wr_en == InterruptController.comp_ICcomponent.active_int_20_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_20_o is wired from Top BF active_active_int_20_out.
    property regif_peripheral_hw_out_active_active_int_20_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_20_out == InterruptController.comp_ICcomponent.active_int_20_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_21_i is wired to Top BF active_active_int_21_in.
    property regif_peripheral_hw_in_active_active_int_21_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_21_in == InterruptController.comp_ICcomponent.active_int_21_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_21_en_i is wired to Top BF active_active_int_21_peripheral_wr_en.
    property regif_peripheral_hw_en_active_active_int_21_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_21_peripheral_wr_en == InterruptController.comp_ICcomponent.active_int_21_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_21_o is wired from Top BF active_active_int_21_out.
    property regif_peripheral_hw_out_active_active_int_21_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_21_out == InterruptController.comp_ICcomponent.active_int_21_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_22_i is wired to Top BF active_active_int_22_in.
    property regif_peripheral_hw_in_active_active_int_22_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_22_in == InterruptController.comp_ICcomponent.active_int_22_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_22_en_i is wired to Top BF active_active_int_22_peripheral_wr_en.
    property regif_peripheral_hw_en_active_active_int_22_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_22_peripheral_wr_en == InterruptController.comp_ICcomponent.active_int_22_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_22_o is wired from Top BF active_active_int_22_out.
    property regif_peripheral_hw_out_active_active_int_22_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_22_out == InterruptController.comp_ICcomponent.active_int_22_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_23_i is wired to Top BF active_active_int_23_in.
    property regif_peripheral_hw_in_active_active_int_23_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_23_in == InterruptController.comp_ICcomponent.active_int_23_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_23_en_i is wired to Top BF active_active_int_23_peripheral_wr_en.
    property regif_peripheral_hw_en_active_active_int_23_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_23_peripheral_wr_en == InterruptController.comp_ICcomponent.active_int_23_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_23_o is wired from Top BF active_active_int_23_out.
    property regif_peripheral_hw_out_active_active_int_23_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_23_out == InterruptController.comp_ICcomponent.active_int_23_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_24_i is wired to Top BF active_active_int_24_in.
    property regif_peripheral_hw_in_active_active_int_24_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_24_in == InterruptController.comp_ICcomponent.active_int_24_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_24_en_i is wired to Top BF active_active_int_24_peripheral_wr_en.
    property regif_peripheral_hw_en_active_active_int_24_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_24_peripheral_wr_en == InterruptController.comp_ICcomponent.active_int_24_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_24_o is wired from Top BF active_active_int_24_out.
    property regif_peripheral_hw_out_active_active_int_24_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_24_out == InterruptController.comp_ICcomponent.active_int_24_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_25_i is wired to Top BF active_active_int_25_in.
    property regif_peripheral_hw_in_active_active_int_25_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_25_in == InterruptController.comp_ICcomponent.active_int_25_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_25_en_i is wired to Top BF active_active_int_25_peripheral_wr_en.
    property regif_peripheral_hw_en_active_active_int_25_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_25_peripheral_wr_en == InterruptController.comp_ICcomponent.active_int_25_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_25_o is wired from Top BF active_active_int_25_out.
    property regif_peripheral_hw_out_active_active_int_25_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_25_out == InterruptController.comp_ICcomponent.active_int_25_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_26_i is wired to Top BF active_active_int_26_in.
    property regif_peripheral_hw_in_active_active_int_26_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_26_in == InterruptController.comp_ICcomponent.active_int_26_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_26_en_i is wired to Top BF active_active_int_26_peripheral_wr_en.
    property regif_peripheral_hw_en_active_active_int_26_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_26_peripheral_wr_en == InterruptController.comp_ICcomponent.active_int_26_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_26_o is wired from Top BF active_active_int_26_out.
    property regif_peripheral_hw_out_active_active_int_26_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_26_out == InterruptController.comp_ICcomponent.active_int_26_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_27_i is wired to Top BF active_active_int_27_in.
    property regif_peripheral_hw_in_active_active_int_27_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_27_in == InterruptController.comp_ICcomponent.active_int_27_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_27_en_i is wired to Top BF active_active_int_27_peripheral_wr_en.
    property regif_peripheral_hw_en_active_active_int_27_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_27_peripheral_wr_en == InterruptController.comp_ICcomponent.active_int_27_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_27_o is wired from Top BF active_active_int_27_out.
    property regif_peripheral_hw_out_active_active_int_27_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_27_out == InterruptController.comp_ICcomponent.active_int_27_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_28_i is wired to Top BF active_active_int_28_in.
    property regif_peripheral_hw_in_active_active_int_28_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_28_in == InterruptController.comp_ICcomponent.active_int_28_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_28_en_i is wired to Top BF active_active_int_28_peripheral_wr_en.
    property regif_peripheral_hw_en_active_active_int_28_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_28_peripheral_wr_en == InterruptController.comp_ICcomponent.active_int_28_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_28_o is wired from Top BF active_active_int_28_out.
    property regif_peripheral_hw_out_active_active_int_28_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_28_out == InterruptController.comp_ICcomponent.active_int_28_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_29_i is wired to Top BF active_active_int_29_in.
    property regif_peripheral_hw_in_active_active_int_29_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_29_in == InterruptController.comp_ICcomponent.active_int_29_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_29_en_i is wired to Top BF active_active_int_29_peripheral_wr_en.
    property regif_peripheral_hw_en_active_active_int_29_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_29_peripheral_wr_en == InterruptController.comp_ICcomponent.active_int_29_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_29_o is wired from Top BF active_active_int_29_out.
    property regif_peripheral_hw_out_active_active_int_29_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_29_out == InterruptController.comp_ICcomponent.active_int_29_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_30_i is wired to Top BF active_active_int_30_in.
    property regif_peripheral_hw_in_active_active_int_30_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_30_in == InterruptController.comp_ICcomponent.active_int_30_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_30_en_i is wired to Top BF active_active_int_30_peripheral_wr_en.
    property regif_peripheral_hw_en_active_active_int_30_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_30_peripheral_wr_en == InterruptController.comp_ICcomponent.active_int_30_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_30_o is wired from Top BF active_active_int_30_out.
    property regif_peripheral_hw_out_active_active_int_30_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_30_out == InterruptController.comp_ICcomponent.active_int_30_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_active_int_31_i is wired to Top BF active_active_int_31_in.
    property regif_peripheral_hw_in_active_active_int_31_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_31_in == InterruptController.comp_ICcomponent.active_int_31_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_active_int_31_en_i is wired to Top BF active_active_int_31_peripheral_wr_en.
    property regif_peripheral_hw_en_active_active_int_31_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_31_peripheral_wr_en == InterruptController.comp_ICcomponent.active_int_31_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_active_int_31_o is wired from Top BF active_active_int_31_out.
    property regif_peripheral_hw_out_active_active_int_31_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_int_31_out == InterruptController.comp_ICcomponent.active_int_31_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input active_1_active_NMI_i is wired to Top BF active_1_active_NMI_in.
    property regif_peripheral_hw_in_active_1_active_NMI_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_NMI_in == InterruptController.comp_ICcomponent.active_NMI_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable active_1_active_NMI_en_i is wired to Top BF active_1_active_NMI_peripheral_wr_en.
    property regif_peripheral_hw_en_active_1_active_NMI_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_NMI_peripheral_wr_en == InterruptController.comp_ICcomponent.active_NMI_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output active_1_active_NMI_o is wired from Top BF active_1_active_NMI_out.
    property regif_peripheral_hw_out_active_1_active_NMI_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_active_NMI_out == InterruptController.comp_ICcomponent.active_NMI_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_priority_int_0_o is wired from Top BF priority_priority_int_0_out.
    property regif_peripheral_hw_out_priority_priority_int_0_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_0_out == InterruptController.comp_ICcomponent.priority_int_0_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_priority_int_1_o is wired from Top BF priority_priority_int_1_out.
    property regif_peripheral_hw_out_priority_priority_int_1_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_1_out == InterruptController.comp_ICcomponent.priority_int_1_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_priority_int_2_o is wired from Top BF priority_priority_int_2_out.
    property regif_peripheral_hw_out_priority_priority_int_2_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_2_out == InterruptController.comp_ICcomponent.priority_int_2_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_priority_int_3_o is wired from Top BF priority_priority_int_3_out.
    property regif_peripheral_hw_out_priority_priority_int_3_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_3_out == InterruptController.comp_ICcomponent.priority_int_3_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_priority_int_4_o is wired from Top BF priority_priority_int_4_out.
    property regif_peripheral_hw_out_priority_priority_int_4_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_4_out == InterruptController.comp_ICcomponent.priority_int_4_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_priority_int_5_o is wired from Top BF priority_priority_int_5_out.
    property regif_peripheral_hw_out_priority_priority_int_5_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_5_out == InterruptController.comp_ICcomponent.priority_int_5_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_priority_int_6_o is wired from Top BF priority_priority_int_6_out.
    property regif_peripheral_hw_out_priority_priority_int_6_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_6_out == InterruptController.comp_ICcomponent.priority_int_6_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_priority_int_7_o is wired from Top BF priority_priority_int_7_out.
    property regif_peripheral_hw_out_priority_priority_int_7_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_7_out == InterruptController.comp_ICcomponent.priority_int_7_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_priority_int_8_o is wired from Top BF priority_priority_int_8_out.
    property regif_peripheral_hw_out_priority_priority_int_8_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_8_out == InterruptController.comp_ICcomponent.priority_int_8_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_priority_int_9_o is wired from Top BF priority_priority_int_9_out.
    property regif_peripheral_hw_out_priority_priority_int_9_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_9_out == InterruptController.comp_ICcomponent.priority_int_9_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_1_priority_int_10_o is wired from Top BF priority_1_priority_int_10_out.
    property regif_peripheral_hw_out_priority_1_priority_int_10_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_10_out == InterruptController.comp_ICcomponent.priority_int_10_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_1_priority_int_11_o is wired from Top BF priority_1_priority_int_11_out.
    property regif_peripheral_hw_out_priority_1_priority_int_11_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_11_out == InterruptController.comp_ICcomponent.priority_int_11_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_1_priority_int_12_o is wired from Top BF priority_1_priority_int_12_out.
    property regif_peripheral_hw_out_priority_1_priority_int_12_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_12_out == InterruptController.comp_ICcomponent.priority_int_12_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_1_priority_int_13_o is wired from Top BF priority_1_priority_int_13_out.
    property regif_peripheral_hw_out_priority_1_priority_int_13_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_13_out == InterruptController.comp_ICcomponent.priority_int_13_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_1_priority_int_14_o is wired from Top BF priority_1_priority_int_14_out.
    property regif_peripheral_hw_out_priority_1_priority_int_14_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_14_out == InterruptController.comp_ICcomponent.priority_int_14_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_1_priority_int_15_o is wired from Top BF priority_1_priority_int_15_out.
    property regif_peripheral_hw_out_priority_1_priority_int_15_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_15_out == InterruptController.comp_ICcomponent.priority_int_15_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_1_priority_int_16_o is wired from Top BF priority_1_priority_int_16_out.
    property regif_peripheral_hw_out_priority_1_priority_int_16_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_16_out == InterruptController.comp_ICcomponent.priority_int_16_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_1_priority_int_17_o is wired from Top BF priority_1_priority_int_17_out.
    property regif_peripheral_hw_out_priority_1_priority_int_17_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_17_out == InterruptController.comp_ICcomponent.priority_int_17_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_1_priority_int_18_o is wired from Top BF priority_1_priority_int_18_out.
    property regif_peripheral_hw_out_priority_1_priority_int_18_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_18_out == InterruptController.comp_ICcomponent.priority_int_18_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_1_priority_int_19_o is wired from Top BF priority_1_priority_int_19_out.
    property regif_peripheral_hw_out_priority_1_priority_int_19_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_19_out == InterruptController.comp_ICcomponent.priority_int_19_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_2_priority_int_20_o is wired from Top BF priority_2_priority_int_20_out.
    property regif_peripheral_hw_out_priority_2_priority_int_20_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_20_out == InterruptController.comp_ICcomponent.priority_int_20_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_2_priority_int_21_o is wired from Top BF priority_2_priority_int_21_out.
    property regif_peripheral_hw_out_priority_2_priority_int_21_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_21_out == InterruptController.comp_ICcomponent.priority_int_21_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_2_priority_int_22_o is wired from Top BF priority_2_priority_int_22_out.
    property regif_peripheral_hw_out_priority_2_priority_int_22_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_22_out == InterruptController.comp_ICcomponent.priority_int_22_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_2_priority_int_23_o is wired from Top BF priority_2_priority_int_23_out.
    property regif_peripheral_hw_out_priority_2_priority_int_23_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_23_out == InterruptController.comp_ICcomponent.priority_int_23_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_2_priority_int_24_o is wired from Top BF priority_2_priority_int_24_out.
    property regif_peripheral_hw_out_priority_2_priority_int_24_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_24_out == InterruptController.comp_ICcomponent.priority_int_24_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_2_priority_int_25_o is wired from Top BF priority_2_priority_int_25_out.
    property regif_peripheral_hw_out_priority_2_priority_int_25_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_25_out == InterruptController.comp_ICcomponent.priority_int_25_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_2_priority_int_26_o is wired from Top BF priority_2_priority_int_26_out.
    property regif_peripheral_hw_out_priority_2_priority_int_26_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_26_out == InterruptController.comp_ICcomponent.priority_int_26_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_2_priority_int_27_o is wired from Top BF priority_2_priority_int_27_out.
    property regif_peripheral_hw_out_priority_2_priority_int_27_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_27_out == InterruptController.comp_ICcomponent.priority_int_27_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_2_priority_int_28_o is wired from Top BF priority_2_priority_int_28_out.
    property regif_peripheral_hw_out_priority_2_priority_int_28_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_28_out == InterruptController.comp_ICcomponent.priority_int_28_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_2_priority_int_29_o is wired from Top BF priority_2_priority_int_29_out.
    property regif_peripheral_hw_out_priority_2_priority_int_29_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_29_out == InterruptController.comp_ICcomponent.priority_int_29_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_3_priority_int_30_o is wired from Top BF priority_3_priority_int_30_out.
    property regif_peripheral_hw_out_priority_3_priority_int_30_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_30_out == InterruptController.comp_ICcomponent.priority_int_30_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output priority_3_priority_int_31_o is wired from Top BF priority_3_priority_int_31_out.
    property regif_peripheral_hw_out_priority_3_priority_int_31_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_priority_int_31_out == InterruptController.comp_ICcomponent.priority_int_31_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_0_i is wired to Top BF requested_requested_int_0_in.
    property regif_peripheral_hw_in_requested_requested_int_0_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_0_in == InterruptController.comp_ICcomponent.requested_int_0_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_0_en_i is wired to Top BF requested_requested_int_0_peripheral_wr_en.
    property regif_peripheral_hw_en_requested_requested_int_0_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_0_peripheral_wr_en == InterruptController.comp_ICcomponent.requested_int_0_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_0_o is wired from Top BF requested_requested_int_0_out.
    property regif_peripheral_hw_out_requested_requested_int_0_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_0_out == InterruptController.comp_ICcomponent.requested_int_0_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_1_i is wired to Top BF requested_requested_int_1_in.
    property regif_peripheral_hw_in_requested_requested_int_1_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_1_in == InterruptController.comp_ICcomponent.requested_int_1_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_1_en_i is wired to Top BF requested_requested_int_1_peripheral_wr_en.
    property regif_peripheral_hw_en_requested_requested_int_1_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_1_peripheral_wr_en == InterruptController.comp_ICcomponent.requested_int_1_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_1_o is wired from Top BF requested_requested_int_1_out.
    property regif_peripheral_hw_out_requested_requested_int_1_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_1_out == InterruptController.comp_ICcomponent.requested_int_1_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_2_i is wired to Top BF requested_requested_int_2_in.
    property regif_peripheral_hw_in_requested_requested_int_2_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_2_in == InterruptController.comp_ICcomponent.requested_int_2_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_2_en_i is wired to Top BF requested_requested_int_2_peripheral_wr_en.
    property regif_peripheral_hw_en_requested_requested_int_2_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_2_peripheral_wr_en == InterruptController.comp_ICcomponent.requested_int_2_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_2_o is wired from Top BF requested_requested_int_2_out.
    property regif_peripheral_hw_out_requested_requested_int_2_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_2_out == InterruptController.comp_ICcomponent.requested_int_2_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_3_i is wired to Top BF requested_requested_int_3_in.
    property regif_peripheral_hw_in_requested_requested_int_3_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_3_in == InterruptController.comp_ICcomponent.requested_int_3_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_3_en_i is wired to Top BF requested_requested_int_3_peripheral_wr_en.
    property regif_peripheral_hw_en_requested_requested_int_3_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_3_peripheral_wr_en == InterruptController.comp_ICcomponent.requested_int_3_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_3_o is wired from Top BF requested_requested_int_3_out.
    property regif_peripheral_hw_out_requested_requested_int_3_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_3_out == InterruptController.comp_ICcomponent.requested_int_3_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_4_i is wired to Top BF requested_requested_int_4_in.
    property regif_peripheral_hw_in_requested_requested_int_4_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_4_in == InterruptController.comp_ICcomponent.requested_int_4_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_4_en_i is wired to Top BF requested_requested_int_4_peripheral_wr_en.
    property regif_peripheral_hw_en_requested_requested_int_4_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_4_peripheral_wr_en == InterruptController.comp_ICcomponent.requested_int_4_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_4_o is wired from Top BF requested_requested_int_4_out.
    property regif_peripheral_hw_out_requested_requested_int_4_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_4_out == InterruptController.comp_ICcomponent.requested_int_4_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_5_i is wired to Top BF requested_requested_int_5_in.
    property regif_peripheral_hw_in_requested_requested_int_5_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_5_in == InterruptController.comp_ICcomponent.requested_int_5_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_5_en_i is wired to Top BF requested_requested_int_5_peripheral_wr_en.
    property regif_peripheral_hw_en_requested_requested_int_5_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_5_peripheral_wr_en == InterruptController.comp_ICcomponent.requested_int_5_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_5_o is wired from Top BF requested_requested_int_5_out.
    property regif_peripheral_hw_out_requested_requested_int_5_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_5_out == InterruptController.comp_ICcomponent.requested_int_5_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_6_i is wired to Top BF requested_requested_int_6_in.
    property regif_peripheral_hw_in_requested_requested_int_6_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_6_in == InterruptController.comp_ICcomponent.requested_int_6_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_6_en_i is wired to Top BF requested_requested_int_6_peripheral_wr_en.
    property regif_peripheral_hw_en_requested_requested_int_6_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_6_peripheral_wr_en == InterruptController.comp_ICcomponent.requested_int_6_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_6_o is wired from Top BF requested_requested_int_6_out.
    property regif_peripheral_hw_out_requested_requested_int_6_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_6_out == InterruptController.comp_ICcomponent.requested_int_6_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_7_i is wired to Top BF requested_requested_int_7_in.
    property regif_peripheral_hw_in_requested_requested_int_7_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_7_in == InterruptController.comp_ICcomponent.requested_int_7_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_7_en_i is wired to Top BF requested_requested_int_7_peripheral_wr_en.
    property regif_peripheral_hw_en_requested_requested_int_7_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_7_peripheral_wr_en == InterruptController.comp_ICcomponent.requested_int_7_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_7_o is wired from Top BF requested_requested_int_7_out.
    property regif_peripheral_hw_out_requested_requested_int_7_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_7_out == InterruptController.comp_ICcomponent.requested_int_7_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_8_i is wired to Top BF requested_requested_int_8_in.
    property regif_peripheral_hw_in_requested_requested_int_8_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_8_in == InterruptController.comp_ICcomponent.requested_int_8_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_8_en_i is wired to Top BF requested_requested_int_8_peripheral_wr_en.
    property regif_peripheral_hw_en_requested_requested_int_8_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_8_peripheral_wr_en == InterruptController.comp_ICcomponent.requested_int_8_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_8_o is wired from Top BF requested_requested_int_8_out.
    property regif_peripheral_hw_out_requested_requested_int_8_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_8_out == InterruptController.comp_ICcomponent.requested_int_8_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_9_i is wired to Top BF requested_requested_int_9_in.
    property regif_peripheral_hw_in_requested_requested_int_9_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_9_in == InterruptController.comp_ICcomponent.requested_int_9_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_9_en_i is wired to Top BF requested_requested_int_9_peripheral_wr_en.
    property regif_peripheral_hw_en_requested_requested_int_9_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_9_peripheral_wr_en == InterruptController.comp_ICcomponent.requested_int_9_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_9_o is wired from Top BF requested_requested_int_9_out.
    property regif_peripheral_hw_out_requested_requested_int_9_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_9_out == InterruptController.comp_ICcomponent.requested_int_9_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_10_i is wired to Top BF requested_requested_int_10_in.
    property regif_peripheral_hw_in_requested_requested_int_10_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_10_in == InterruptController.comp_ICcomponent.requested_int_10_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_10_en_i is wired to Top BF requested_requested_int_10_peripheral_wr_en.
    property regif_peripheral_hw_en_requested_requested_int_10_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_10_peripheral_wr_en == InterruptController.comp_ICcomponent.requested_int_10_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_10_o is wired from Top BF requested_requested_int_10_out.
    property regif_peripheral_hw_out_requested_requested_int_10_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_10_out == InterruptController.comp_ICcomponent.requested_int_10_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_11_i is wired to Top BF requested_requested_int_11_in.
    property regif_peripheral_hw_in_requested_requested_int_11_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_11_in == InterruptController.comp_ICcomponent.requested_int_11_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_11_en_i is wired to Top BF requested_requested_int_11_peripheral_wr_en.
    property regif_peripheral_hw_en_requested_requested_int_11_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_11_peripheral_wr_en == InterruptController.comp_ICcomponent.requested_int_11_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_11_o is wired from Top BF requested_requested_int_11_out.
    property regif_peripheral_hw_out_requested_requested_int_11_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_11_out == InterruptController.comp_ICcomponent.requested_int_11_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_12_i is wired to Top BF requested_requested_int_12_in.
    property regif_peripheral_hw_in_requested_requested_int_12_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_12_in == InterruptController.comp_ICcomponent.requested_int_12_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_12_en_i is wired to Top BF requested_requested_int_12_peripheral_wr_en.
    property regif_peripheral_hw_en_requested_requested_int_12_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_12_peripheral_wr_en == InterruptController.comp_ICcomponent.requested_int_12_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_12_o is wired from Top BF requested_requested_int_12_out.
    property regif_peripheral_hw_out_requested_requested_int_12_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_12_out == InterruptController.comp_ICcomponent.requested_int_12_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_13_i is wired to Top BF requested_requested_int_13_in.
    property regif_peripheral_hw_in_requested_requested_int_13_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_13_in == InterruptController.comp_ICcomponent.requested_int_13_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_13_en_i is wired to Top BF requested_requested_int_13_peripheral_wr_en.
    property regif_peripheral_hw_en_requested_requested_int_13_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_13_peripheral_wr_en == InterruptController.comp_ICcomponent.requested_int_13_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_13_o is wired from Top BF requested_requested_int_13_out.
    property regif_peripheral_hw_out_requested_requested_int_13_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_13_out == InterruptController.comp_ICcomponent.requested_int_13_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_14_i is wired to Top BF requested_requested_int_14_in.
    property regif_peripheral_hw_in_requested_requested_int_14_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_14_in == InterruptController.comp_ICcomponent.requested_int_14_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_14_en_i is wired to Top BF requested_requested_int_14_peripheral_wr_en.
    property regif_peripheral_hw_en_requested_requested_int_14_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_14_peripheral_wr_en == InterruptController.comp_ICcomponent.requested_int_14_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_14_o is wired from Top BF requested_requested_int_14_out.
    property regif_peripheral_hw_out_requested_requested_int_14_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_14_out == InterruptController.comp_ICcomponent.requested_int_14_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_15_i is wired to Top BF requested_requested_int_15_in.
    property regif_peripheral_hw_in_requested_requested_int_15_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_15_in == InterruptController.comp_ICcomponent.requested_int_15_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_15_en_i is wired to Top BF requested_requested_int_15_peripheral_wr_en.
    property regif_peripheral_hw_en_requested_requested_int_15_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_15_peripheral_wr_en == InterruptController.comp_ICcomponent.requested_int_15_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_15_o is wired from Top BF requested_requested_int_15_out.
    property regif_peripheral_hw_out_requested_requested_int_15_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_15_out == InterruptController.comp_ICcomponent.requested_int_15_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_16_i is wired to Top BF requested_requested_int_16_in.
    property regif_peripheral_hw_in_requested_requested_int_16_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_16_in == InterruptController.comp_ICcomponent.requested_int_16_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_16_en_i is wired to Top BF requested_requested_int_16_peripheral_wr_en.
    property regif_peripheral_hw_en_requested_requested_int_16_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_16_peripheral_wr_en == InterruptController.comp_ICcomponent.requested_int_16_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_16_o is wired from Top BF requested_requested_int_16_out.
    property regif_peripheral_hw_out_requested_requested_int_16_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_16_out == InterruptController.comp_ICcomponent.requested_int_16_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_17_i is wired to Top BF requested_requested_int_17_in.
    property regif_peripheral_hw_in_requested_requested_int_17_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_17_in == InterruptController.comp_ICcomponent.requested_int_17_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_17_en_i is wired to Top BF requested_requested_int_17_peripheral_wr_en.
    property regif_peripheral_hw_en_requested_requested_int_17_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_17_peripheral_wr_en == InterruptController.comp_ICcomponent.requested_int_17_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_17_o is wired from Top BF requested_requested_int_17_out.
    property regif_peripheral_hw_out_requested_requested_int_17_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_17_out == InterruptController.comp_ICcomponent.requested_int_17_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_18_i is wired to Top BF requested_requested_int_18_in.
    property regif_peripheral_hw_in_requested_requested_int_18_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_18_in == InterruptController.comp_ICcomponent.requested_int_18_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_18_en_i is wired to Top BF requested_requested_int_18_peripheral_wr_en.
    property regif_peripheral_hw_en_requested_requested_int_18_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_18_peripheral_wr_en == InterruptController.comp_ICcomponent.requested_int_18_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_18_o is wired from Top BF requested_requested_int_18_out.
    property regif_peripheral_hw_out_requested_requested_int_18_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_18_out == InterruptController.comp_ICcomponent.requested_int_18_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_19_i is wired to Top BF requested_requested_int_19_in.
    property regif_peripheral_hw_in_requested_requested_int_19_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_19_in == InterruptController.comp_ICcomponent.requested_int_19_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_19_en_i is wired to Top BF requested_requested_int_19_peripheral_wr_en.
    property regif_peripheral_hw_en_requested_requested_int_19_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_19_peripheral_wr_en == InterruptController.comp_ICcomponent.requested_int_19_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_19_o is wired from Top BF requested_requested_int_19_out.
    property regif_peripheral_hw_out_requested_requested_int_19_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_19_out == InterruptController.comp_ICcomponent.requested_int_19_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_20_i is wired to Top BF requested_requested_int_20_in.
    property regif_peripheral_hw_in_requested_requested_int_20_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_20_in == InterruptController.comp_ICcomponent.requested_int_20_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_20_en_i is wired to Top BF requested_requested_int_20_peripheral_wr_en.
    property regif_peripheral_hw_en_requested_requested_int_20_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_20_peripheral_wr_en == InterruptController.comp_ICcomponent.requested_int_20_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_20_o is wired from Top BF requested_requested_int_20_out.
    property regif_peripheral_hw_out_requested_requested_int_20_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_20_out == InterruptController.comp_ICcomponent.requested_int_20_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_21_i is wired to Top BF requested_requested_int_21_in.
    property regif_peripheral_hw_in_requested_requested_int_21_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_21_in == InterruptController.comp_ICcomponent.requested_int_21_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_21_en_i is wired to Top BF requested_requested_int_21_peripheral_wr_en.
    property regif_peripheral_hw_en_requested_requested_int_21_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_21_peripheral_wr_en == InterruptController.comp_ICcomponent.requested_int_21_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_21_o is wired from Top BF requested_requested_int_21_out.
    property regif_peripheral_hw_out_requested_requested_int_21_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_21_out == InterruptController.comp_ICcomponent.requested_int_21_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_22_i is wired to Top BF requested_requested_int_22_in.
    property regif_peripheral_hw_in_requested_requested_int_22_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_22_in == InterruptController.comp_ICcomponent.requested_int_22_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_22_en_i is wired to Top BF requested_requested_int_22_peripheral_wr_en.
    property regif_peripheral_hw_en_requested_requested_int_22_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_22_peripheral_wr_en == InterruptController.comp_ICcomponent.requested_int_22_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_22_o is wired from Top BF requested_requested_int_22_out.
    property regif_peripheral_hw_out_requested_requested_int_22_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_22_out == InterruptController.comp_ICcomponent.requested_int_22_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_23_i is wired to Top BF requested_requested_int_23_in.
    property regif_peripheral_hw_in_requested_requested_int_23_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_23_in == InterruptController.comp_ICcomponent.requested_int_23_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_23_en_i is wired to Top BF requested_requested_int_23_peripheral_wr_en.
    property regif_peripheral_hw_en_requested_requested_int_23_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_23_peripheral_wr_en == InterruptController.comp_ICcomponent.requested_int_23_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_23_o is wired from Top BF requested_requested_int_23_out.
    property regif_peripheral_hw_out_requested_requested_int_23_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_23_out == InterruptController.comp_ICcomponent.requested_int_23_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_24_i is wired to Top BF requested_requested_int_24_in.
    property regif_peripheral_hw_in_requested_requested_int_24_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_24_in == InterruptController.comp_ICcomponent.requested_int_24_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_24_en_i is wired to Top BF requested_requested_int_24_peripheral_wr_en.
    property regif_peripheral_hw_en_requested_requested_int_24_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_24_peripheral_wr_en == InterruptController.comp_ICcomponent.requested_int_24_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_24_o is wired from Top BF requested_requested_int_24_out.
    property regif_peripheral_hw_out_requested_requested_int_24_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_24_out == InterruptController.comp_ICcomponent.requested_int_24_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_25_i is wired to Top BF requested_requested_int_25_in.
    property regif_peripheral_hw_in_requested_requested_int_25_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_25_in == InterruptController.comp_ICcomponent.requested_int_25_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_25_en_i is wired to Top BF requested_requested_int_25_peripheral_wr_en.
    property regif_peripheral_hw_en_requested_requested_int_25_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_25_peripheral_wr_en == InterruptController.comp_ICcomponent.requested_int_25_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_25_o is wired from Top BF requested_requested_int_25_out.
    property regif_peripheral_hw_out_requested_requested_int_25_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_25_out == InterruptController.comp_ICcomponent.requested_int_25_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_26_i is wired to Top BF requested_requested_int_26_in.
    property regif_peripheral_hw_in_requested_requested_int_26_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_26_in == InterruptController.comp_ICcomponent.requested_int_26_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_26_en_i is wired to Top BF requested_requested_int_26_peripheral_wr_en.
    property regif_peripheral_hw_en_requested_requested_int_26_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_26_peripheral_wr_en == InterruptController.comp_ICcomponent.requested_int_26_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_26_o is wired from Top BF requested_requested_int_26_out.
    property regif_peripheral_hw_out_requested_requested_int_26_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_26_out == InterruptController.comp_ICcomponent.requested_int_26_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_27_i is wired to Top BF requested_requested_int_27_in.
    property regif_peripheral_hw_in_requested_requested_int_27_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_27_in == InterruptController.comp_ICcomponent.requested_int_27_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_27_en_i is wired to Top BF requested_requested_int_27_peripheral_wr_en.
    property regif_peripheral_hw_en_requested_requested_int_27_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_27_peripheral_wr_en == InterruptController.comp_ICcomponent.requested_int_27_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_27_o is wired from Top BF requested_requested_int_27_out.
    property regif_peripheral_hw_out_requested_requested_int_27_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_27_out == InterruptController.comp_ICcomponent.requested_int_27_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_28_i is wired to Top BF requested_requested_int_28_in.
    property regif_peripheral_hw_in_requested_requested_int_28_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_28_in == InterruptController.comp_ICcomponent.requested_int_28_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_28_en_i is wired to Top BF requested_requested_int_28_peripheral_wr_en.
    property regif_peripheral_hw_en_requested_requested_int_28_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_28_peripheral_wr_en == InterruptController.comp_ICcomponent.requested_int_28_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_28_o is wired from Top BF requested_requested_int_28_out.
    property regif_peripheral_hw_out_requested_requested_int_28_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_28_out == InterruptController.comp_ICcomponent.requested_int_28_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_29_i is wired to Top BF requested_requested_int_29_in.
    property regif_peripheral_hw_in_requested_requested_int_29_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_29_in == InterruptController.comp_ICcomponent.requested_int_29_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_29_en_i is wired to Top BF requested_requested_int_29_peripheral_wr_en.
    property regif_peripheral_hw_en_requested_requested_int_29_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_29_peripheral_wr_en == InterruptController.comp_ICcomponent.requested_int_29_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_29_o is wired from Top BF requested_requested_int_29_out.
    property regif_peripheral_hw_out_requested_requested_int_29_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_29_out == InterruptController.comp_ICcomponent.requested_int_29_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_30_i is wired to Top BF requested_requested_int_30_in.
    property regif_peripheral_hw_in_requested_requested_int_30_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_30_in == InterruptController.comp_ICcomponent.requested_int_30_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_30_en_i is wired to Top BF requested_requested_int_30_peripheral_wr_en.
    property regif_peripheral_hw_en_requested_requested_int_30_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_30_peripheral_wr_en == InterruptController.comp_ICcomponent.requested_int_30_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_30_o is wired from Top BF requested_requested_int_30_out.
    property regif_peripheral_hw_out_requested_requested_int_30_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_30_out == InterruptController.comp_ICcomponent.requested_int_30_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_requested_int_31_i is wired to Top BF requested_requested_int_31_in.
    property regif_peripheral_hw_in_requested_requested_int_31_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_31_in == InterruptController.comp_ICcomponent.requested_int_31_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_requested_int_31_en_i is wired to Top BF requested_requested_int_31_peripheral_wr_en.
    property regif_peripheral_hw_en_requested_requested_int_31_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_31_peripheral_wr_en == InterruptController.comp_ICcomponent.requested_int_31_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_requested_int_31_o is wired from Top BF requested_requested_int_31_out.
    property regif_peripheral_hw_out_requested_requested_int_31_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_int_31_out == InterruptController.comp_ICcomponent.requested_int_31_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input requested_1_requested_NMI_i is wired to Top BF requested_1_requested_NMI_in.
    property regif_peripheral_hw_in_requested_1_requested_NMI_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_NMI_in == InterruptController.comp_ICcomponent.requested_NMI_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable requested_1_requested_NMI_en_i is wired to Top BF requested_1_requested_NMI_peripheral_wr_en.
    property regif_peripheral_hw_en_requested_1_requested_NMI_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_NMI_peripheral_wr_en == InterruptController.comp_ICcomponent.requested_NMI_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output requested_1_requested_NMI_o is wired from Top BF requested_1_requested_NMI_out.
    property regif_peripheral_hw_out_requested_1_requested_NMI_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_requested_NMI_out == InterruptController.comp_ICcomponent.requested_NMI_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_0_i is wired to Top BF paused_paused_int_0_in.
    property regif_peripheral_hw_in_paused_paused_int_0_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_0_in == InterruptController.comp_ICcomponent.paused_int_0_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_0_en_i is wired to Top BF paused_paused_int_0_peripheral_wr_en.
    property regif_peripheral_hw_en_paused_paused_int_0_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_0_peripheral_wr_en == InterruptController.comp_ICcomponent.paused_int_0_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_0_o is wired from Top BF paused_paused_int_0_out.
    property regif_peripheral_hw_out_paused_paused_int_0_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_0_out == InterruptController.comp_ICcomponent.paused_int_0_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_1_i is wired to Top BF paused_paused_int_1_in.
    property regif_peripheral_hw_in_paused_paused_int_1_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_1_in == InterruptController.comp_ICcomponent.paused_int_1_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_1_en_i is wired to Top BF paused_paused_int_1_peripheral_wr_en.
    property regif_peripheral_hw_en_paused_paused_int_1_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_1_peripheral_wr_en == InterruptController.comp_ICcomponent.paused_int_1_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_1_o is wired from Top BF paused_paused_int_1_out.
    property regif_peripheral_hw_out_paused_paused_int_1_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_1_out == InterruptController.comp_ICcomponent.paused_int_1_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_2_i is wired to Top BF paused_paused_int_2_in.
    property regif_peripheral_hw_in_paused_paused_int_2_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_2_in == InterruptController.comp_ICcomponent.paused_int_2_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_2_en_i is wired to Top BF paused_paused_int_2_peripheral_wr_en.
    property regif_peripheral_hw_en_paused_paused_int_2_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_2_peripheral_wr_en == InterruptController.comp_ICcomponent.paused_int_2_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_2_o is wired from Top BF paused_paused_int_2_out.
    property regif_peripheral_hw_out_paused_paused_int_2_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_2_out == InterruptController.comp_ICcomponent.paused_int_2_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_3_i is wired to Top BF paused_paused_int_3_in.
    property regif_peripheral_hw_in_paused_paused_int_3_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_3_in == InterruptController.comp_ICcomponent.paused_int_3_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_3_en_i is wired to Top BF paused_paused_int_3_peripheral_wr_en.
    property regif_peripheral_hw_en_paused_paused_int_3_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_3_peripheral_wr_en == InterruptController.comp_ICcomponent.paused_int_3_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_3_o is wired from Top BF paused_paused_int_3_out.
    property regif_peripheral_hw_out_paused_paused_int_3_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_3_out == InterruptController.comp_ICcomponent.paused_int_3_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_4_i is wired to Top BF paused_paused_int_4_in.
    property regif_peripheral_hw_in_paused_paused_int_4_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_4_in == InterruptController.comp_ICcomponent.paused_int_4_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_4_en_i is wired to Top BF paused_paused_int_4_peripheral_wr_en.
    property regif_peripheral_hw_en_paused_paused_int_4_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_4_peripheral_wr_en == InterruptController.comp_ICcomponent.paused_int_4_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_4_o is wired from Top BF paused_paused_int_4_out.
    property regif_peripheral_hw_out_paused_paused_int_4_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_4_out == InterruptController.comp_ICcomponent.paused_int_4_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_5_i is wired to Top BF paused_paused_int_5_in.
    property regif_peripheral_hw_in_paused_paused_int_5_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_5_in == InterruptController.comp_ICcomponent.paused_int_5_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_5_en_i is wired to Top BF paused_paused_int_5_peripheral_wr_en.
    property regif_peripheral_hw_en_paused_paused_int_5_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_5_peripheral_wr_en == InterruptController.comp_ICcomponent.paused_int_5_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_5_o is wired from Top BF paused_paused_int_5_out.
    property regif_peripheral_hw_out_paused_paused_int_5_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_5_out == InterruptController.comp_ICcomponent.paused_int_5_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_6_i is wired to Top BF paused_paused_int_6_in.
    property regif_peripheral_hw_in_paused_paused_int_6_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_6_in == InterruptController.comp_ICcomponent.paused_int_6_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_6_en_i is wired to Top BF paused_paused_int_6_peripheral_wr_en.
    property regif_peripheral_hw_en_paused_paused_int_6_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_6_peripheral_wr_en == InterruptController.comp_ICcomponent.paused_int_6_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_6_o is wired from Top BF paused_paused_int_6_out.
    property regif_peripheral_hw_out_paused_paused_int_6_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_6_out == InterruptController.comp_ICcomponent.paused_int_6_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_7_i is wired to Top BF paused_paused_int_7_in.
    property regif_peripheral_hw_in_paused_paused_int_7_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_7_in == InterruptController.comp_ICcomponent.paused_int_7_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_7_en_i is wired to Top BF paused_paused_int_7_peripheral_wr_en.
    property regif_peripheral_hw_en_paused_paused_int_7_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_7_peripheral_wr_en == InterruptController.comp_ICcomponent.paused_int_7_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_7_o is wired from Top BF paused_paused_int_7_out.
    property regif_peripheral_hw_out_paused_paused_int_7_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_7_out == InterruptController.comp_ICcomponent.paused_int_7_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_8_i is wired to Top BF paused_paused_int_8_in.
    property regif_peripheral_hw_in_paused_paused_int_8_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_8_in == InterruptController.comp_ICcomponent.paused_int_8_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_8_en_i is wired to Top BF paused_paused_int_8_peripheral_wr_en.
    property regif_peripheral_hw_en_paused_paused_int_8_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_8_peripheral_wr_en == InterruptController.comp_ICcomponent.paused_int_8_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_8_o is wired from Top BF paused_paused_int_8_out.
    property regif_peripheral_hw_out_paused_paused_int_8_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_8_out == InterruptController.comp_ICcomponent.paused_int_8_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_9_i is wired to Top BF paused_paused_int_9_in.
    property regif_peripheral_hw_in_paused_paused_int_9_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_9_in == InterruptController.comp_ICcomponent.paused_int_9_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_9_en_i is wired to Top BF paused_paused_int_9_peripheral_wr_en.
    property regif_peripheral_hw_en_paused_paused_int_9_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_9_peripheral_wr_en == InterruptController.comp_ICcomponent.paused_int_9_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_9_o is wired from Top BF paused_paused_int_9_out.
    property regif_peripheral_hw_out_paused_paused_int_9_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_9_out == InterruptController.comp_ICcomponent.paused_int_9_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_10_i is wired to Top BF paused_paused_int_10_in.
    property regif_peripheral_hw_in_paused_paused_int_10_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_10_in == InterruptController.comp_ICcomponent.paused_int_10_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_10_en_i is wired to Top BF paused_paused_int_10_peripheral_wr_en.
    property regif_peripheral_hw_en_paused_paused_int_10_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_10_peripheral_wr_en == InterruptController.comp_ICcomponent.paused_int_10_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_10_o is wired from Top BF paused_paused_int_10_out.
    property regif_peripheral_hw_out_paused_paused_int_10_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_10_out == InterruptController.comp_ICcomponent.paused_int_10_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_11_i is wired to Top BF paused_paused_int_11_in.
    property regif_peripheral_hw_in_paused_paused_int_11_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_11_in == InterruptController.comp_ICcomponent.paused_int_11_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_11_en_i is wired to Top BF paused_paused_int_11_peripheral_wr_en.
    property regif_peripheral_hw_en_paused_paused_int_11_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_11_peripheral_wr_en == InterruptController.comp_ICcomponent.paused_int_11_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_11_o is wired from Top BF paused_paused_int_11_out.
    property regif_peripheral_hw_out_paused_paused_int_11_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_11_out == InterruptController.comp_ICcomponent.paused_int_11_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_12_i is wired to Top BF paused_paused_int_12_in.
    property regif_peripheral_hw_in_paused_paused_int_12_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_12_in == InterruptController.comp_ICcomponent.paused_int_12_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_12_en_i is wired to Top BF paused_paused_int_12_peripheral_wr_en.
    property regif_peripheral_hw_en_paused_paused_int_12_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_12_peripheral_wr_en == InterruptController.comp_ICcomponent.paused_int_12_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_12_o is wired from Top BF paused_paused_int_12_out.
    property regif_peripheral_hw_out_paused_paused_int_12_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_12_out == InterruptController.comp_ICcomponent.paused_int_12_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_13_i is wired to Top BF paused_paused_int_13_in.
    property regif_peripheral_hw_in_paused_paused_int_13_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_13_in == InterruptController.comp_ICcomponent.paused_int_13_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_13_en_i is wired to Top BF paused_paused_int_13_peripheral_wr_en.
    property regif_peripheral_hw_en_paused_paused_int_13_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_13_peripheral_wr_en == InterruptController.comp_ICcomponent.paused_int_13_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_13_o is wired from Top BF paused_paused_int_13_out.
    property regif_peripheral_hw_out_paused_paused_int_13_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_13_out == InterruptController.comp_ICcomponent.paused_int_13_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_14_i is wired to Top BF paused_paused_int_14_in.
    property regif_peripheral_hw_in_paused_paused_int_14_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_14_in == InterruptController.comp_ICcomponent.paused_int_14_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_14_en_i is wired to Top BF paused_paused_int_14_peripheral_wr_en.
    property regif_peripheral_hw_en_paused_paused_int_14_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_14_peripheral_wr_en == InterruptController.comp_ICcomponent.paused_int_14_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_14_o is wired from Top BF paused_paused_int_14_out.
    property regif_peripheral_hw_out_paused_paused_int_14_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_14_out == InterruptController.comp_ICcomponent.paused_int_14_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_15_i is wired to Top BF paused_paused_int_15_in.
    property regif_peripheral_hw_in_paused_paused_int_15_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_15_in == InterruptController.comp_ICcomponent.paused_int_15_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_15_en_i is wired to Top BF paused_paused_int_15_peripheral_wr_en.
    property regif_peripheral_hw_en_paused_paused_int_15_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_15_peripheral_wr_en == InterruptController.comp_ICcomponent.paused_int_15_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_15_o is wired from Top BF paused_paused_int_15_out.
    property regif_peripheral_hw_out_paused_paused_int_15_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_15_out == InterruptController.comp_ICcomponent.paused_int_15_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_16_i is wired to Top BF paused_paused_int_16_in.
    property regif_peripheral_hw_in_paused_paused_int_16_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_16_in == InterruptController.comp_ICcomponent.paused_int_16_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_16_en_i is wired to Top BF paused_paused_int_16_peripheral_wr_en.
    property regif_peripheral_hw_en_paused_paused_int_16_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_16_peripheral_wr_en == InterruptController.comp_ICcomponent.paused_int_16_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_16_o is wired from Top BF paused_paused_int_16_out.
    property regif_peripheral_hw_out_paused_paused_int_16_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_16_out == InterruptController.comp_ICcomponent.paused_int_16_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_17_i is wired to Top BF paused_paused_int_17_in.
    property regif_peripheral_hw_in_paused_paused_int_17_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_17_in == InterruptController.comp_ICcomponent.paused_int_17_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_17_en_i is wired to Top BF paused_paused_int_17_peripheral_wr_en.
    property regif_peripheral_hw_en_paused_paused_int_17_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_17_peripheral_wr_en == InterruptController.comp_ICcomponent.paused_int_17_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_17_o is wired from Top BF paused_paused_int_17_out.
    property regif_peripheral_hw_out_paused_paused_int_17_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_17_out == InterruptController.comp_ICcomponent.paused_int_17_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_18_i is wired to Top BF paused_paused_int_18_in.
    property regif_peripheral_hw_in_paused_paused_int_18_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_18_in == InterruptController.comp_ICcomponent.paused_int_18_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_18_en_i is wired to Top BF paused_paused_int_18_peripheral_wr_en.
    property regif_peripheral_hw_en_paused_paused_int_18_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_18_peripheral_wr_en == InterruptController.comp_ICcomponent.paused_int_18_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_18_o is wired from Top BF paused_paused_int_18_out.
    property regif_peripheral_hw_out_paused_paused_int_18_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_18_out == InterruptController.comp_ICcomponent.paused_int_18_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_19_i is wired to Top BF paused_paused_int_19_in.
    property regif_peripheral_hw_in_paused_paused_int_19_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_19_in == InterruptController.comp_ICcomponent.paused_int_19_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_19_en_i is wired to Top BF paused_paused_int_19_peripheral_wr_en.
    property regif_peripheral_hw_en_paused_paused_int_19_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_19_peripheral_wr_en == InterruptController.comp_ICcomponent.paused_int_19_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_19_o is wired from Top BF paused_paused_int_19_out.
    property regif_peripheral_hw_out_paused_paused_int_19_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_19_out == InterruptController.comp_ICcomponent.paused_int_19_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_20_i is wired to Top BF paused_paused_int_20_in.
    property regif_peripheral_hw_in_paused_paused_int_20_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_20_in == InterruptController.comp_ICcomponent.paused_int_20_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_20_en_i is wired to Top BF paused_paused_int_20_peripheral_wr_en.
    property regif_peripheral_hw_en_paused_paused_int_20_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_20_peripheral_wr_en == InterruptController.comp_ICcomponent.paused_int_20_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_20_o is wired from Top BF paused_paused_int_20_out.
    property regif_peripheral_hw_out_paused_paused_int_20_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_20_out == InterruptController.comp_ICcomponent.paused_int_20_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_21_i is wired to Top BF paused_paused_int_21_in.
    property regif_peripheral_hw_in_paused_paused_int_21_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_21_in == InterruptController.comp_ICcomponent.paused_int_21_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_21_en_i is wired to Top BF paused_paused_int_21_peripheral_wr_en.
    property regif_peripheral_hw_en_paused_paused_int_21_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_21_peripheral_wr_en == InterruptController.comp_ICcomponent.paused_int_21_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_21_o is wired from Top BF paused_paused_int_21_out.
    property regif_peripheral_hw_out_paused_paused_int_21_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_21_out == InterruptController.comp_ICcomponent.paused_int_21_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_22_i is wired to Top BF paused_paused_int_22_in.
    property regif_peripheral_hw_in_paused_paused_int_22_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_22_in == InterruptController.comp_ICcomponent.paused_int_22_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_22_en_i is wired to Top BF paused_paused_int_22_peripheral_wr_en.
    property regif_peripheral_hw_en_paused_paused_int_22_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_22_peripheral_wr_en == InterruptController.comp_ICcomponent.paused_int_22_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_22_o is wired from Top BF paused_paused_int_22_out.
    property regif_peripheral_hw_out_paused_paused_int_22_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_22_out == InterruptController.comp_ICcomponent.paused_int_22_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_23_i is wired to Top BF paused_paused_int_23_in.
    property regif_peripheral_hw_in_paused_paused_int_23_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_23_in == InterruptController.comp_ICcomponent.paused_int_23_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_23_en_i is wired to Top BF paused_paused_int_23_peripheral_wr_en.
    property regif_peripheral_hw_en_paused_paused_int_23_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_23_peripheral_wr_en == InterruptController.comp_ICcomponent.paused_int_23_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_23_o is wired from Top BF paused_paused_int_23_out.
    property regif_peripheral_hw_out_paused_paused_int_23_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_23_out == InterruptController.comp_ICcomponent.paused_int_23_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_24_i is wired to Top BF paused_paused_int_24_in.
    property regif_peripheral_hw_in_paused_paused_int_24_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_24_in == InterruptController.comp_ICcomponent.paused_int_24_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_24_en_i is wired to Top BF paused_paused_int_24_peripheral_wr_en.
    property regif_peripheral_hw_en_paused_paused_int_24_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_24_peripheral_wr_en == InterruptController.comp_ICcomponent.paused_int_24_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_24_o is wired from Top BF paused_paused_int_24_out.
    property regif_peripheral_hw_out_paused_paused_int_24_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_24_out == InterruptController.comp_ICcomponent.paused_int_24_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_25_i is wired to Top BF paused_paused_int_25_in.
    property regif_peripheral_hw_in_paused_paused_int_25_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_25_in == InterruptController.comp_ICcomponent.paused_int_25_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_25_en_i is wired to Top BF paused_paused_int_25_peripheral_wr_en.
    property regif_peripheral_hw_en_paused_paused_int_25_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_25_peripheral_wr_en == InterruptController.comp_ICcomponent.paused_int_25_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_25_o is wired from Top BF paused_paused_int_25_out.
    property regif_peripheral_hw_out_paused_paused_int_25_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_25_out == InterruptController.comp_ICcomponent.paused_int_25_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_26_i is wired to Top BF paused_paused_int_26_in.
    property regif_peripheral_hw_in_paused_paused_int_26_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_26_in == InterruptController.comp_ICcomponent.paused_int_26_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_26_en_i is wired to Top BF paused_paused_int_26_peripheral_wr_en.
    property regif_peripheral_hw_en_paused_paused_int_26_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_26_peripheral_wr_en == InterruptController.comp_ICcomponent.paused_int_26_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_26_o is wired from Top BF paused_paused_int_26_out.
    property regif_peripheral_hw_out_paused_paused_int_26_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_26_out == InterruptController.comp_ICcomponent.paused_int_26_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_27_i is wired to Top BF paused_paused_int_27_in.
    property regif_peripheral_hw_in_paused_paused_int_27_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_27_in == InterruptController.comp_ICcomponent.paused_int_27_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_27_en_i is wired to Top BF paused_paused_int_27_peripheral_wr_en.
    property regif_peripheral_hw_en_paused_paused_int_27_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_27_peripheral_wr_en == InterruptController.comp_ICcomponent.paused_int_27_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_27_o is wired from Top BF paused_paused_int_27_out.
    property regif_peripheral_hw_out_paused_paused_int_27_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_27_out == InterruptController.comp_ICcomponent.paused_int_27_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_28_i is wired to Top BF paused_paused_int_28_in.
    property regif_peripheral_hw_in_paused_paused_int_28_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_28_in == InterruptController.comp_ICcomponent.paused_int_28_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_28_en_i is wired to Top BF paused_paused_int_28_peripheral_wr_en.
    property regif_peripheral_hw_en_paused_paused_int_28_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_28_peripheral_wr_en == InterruptController.comp_ICcomponent.paused_int_28_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_28_o is wired from Top BF paused_paused_int_28_out.
    property regif_peripheral_hw_out_paused_paused_int_28_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_28_out == InterruptController.comp_ICcomponent.paused_int_28_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_29_i is wired to Top BF paused_paused_int_29_in.
    property regif_peripheral_hw_in_paused_paused_int_29_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_29_in == InterruptController.comp_ICcomponent.paused_int_29_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_29_en_i is wired to Top BF paused_paused_int_29_peripheral_wr_en.
    property regif_peripheral_hw_en_paused_paused_int_29_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_29_peripheral_wr_en == InterruptController.comp_ICcomponent.paused_int_29_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_29_o is wired from Top BF paused_paused_int_29_out.
    property regif_peripheral_hw_out_paused_paused_int_29_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_29_out == InterruptController.comp_ICcomponent.paused_int_29_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_30_i is wired to Top BF paused_paused_int_30_in.
    property regif_peripheral_hw_in_paused_paused_int_30_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_30_in == InterruptController.comp_ICcomponent.paused_int_30_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_30_en_i is wired to Top BF paused_paused_int_30_peripheral_wr_en.
    property regif_peripheral_hw_en_paused_paused_int_30_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_30_peripheral_wr_en == InterruptController.comp_ICcomponent.paused_int_30_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_30_o is wired from Top BF paused_paused_int_30_out.
    property regif_peripheral_hw_out_paused_paused_int_30_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_30_out == InterruptController.comp_ICcomponent.paused_int_30_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_paused_int_31_i is wired to Top BF paused_paused_int_31_in.
    property regif_peripheral_hw_in_paused_paused_int_31_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_31_in == InterruptController.comp_ICcomponent.paused_int_31_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_paused_int_31_en_i is wired to Top BF paused_paused_int_31_peripheral_wr_en.
    property regif_peripheral_hw_en_paused_paused_int_31_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_31_peripheral_wr_en == InterruptController.comp_ICcomponent.paused_int_31_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_paused_int_31_o is wired from Top BF paused_paused_int_31_out.
    property regif_peripheral_hw_out_paused_paused_int_31_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_int_31_out == InterruptController.comp_ICcomponent.paused_int_31_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write input paused_1_paused_NMI_i is wired to Top BF paused_1_paused_NMI_in.
    property regif_peripheral_hw_in_paused_1_paused_NMI_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_NMI_in == InterruptController.comp_ICcomponent.paused_NMI_in));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW write enable paused_1_paused_NMI_en_i is wired to Top BF paused_1_paused_NMI_peripheral_wr_en.
    property regif_peripheral_hw_en_paused_1_paused_NMI_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_NMI_peripheral_wr_en == InterruptController.comp_ICcomponent.paused_NMI_peripheral_wr_en));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output paused_1_paused_NMI_o is wired from Top BF paused_1_paused_NMI_out.
    property regif_peripheral_hw_out_paused_1_paused_NMI_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_paused_NMI_out == InterruptController.comp_ICcomponent.paused_NMI_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output group_priority_group_priority_Group1_o is wired from Top BF group_priority_group_priority_Group1_out.
    property regif_peripheral_hw_out_group_priority_group_priority_Group1_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_group_priority_Group1_out == InterruptController.comp_ICcomponent.group_priority_Group1_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output group_priority_group_priority_Group2_o is wired from Top BF group_priority_group_priority_Group2_out.
    property regif_peripheral_hw_out_group_priority_group_priority_Group2_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_group_priority_Group2_out == InterruptController.comp_ICcomponent.group_priority_Group2_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output group_priority_group_priority_Group3_o is wired from Top BF group_priority_group_priority_Group3_out.
    property regif_peripheral_hw_out_group_priority_group_priority_Group3_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_group_priority_Group3_out == InterruptController.comp_ICcomponent.group_priority_Group3_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output group_priority_group_priority_Group4_o is wired from Top BF group_priority_group_priority_Group4_out.
    property regif_peripheral_hw_out_group_priority_group_priority_Group4_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_group_priority_Group4_out == InterruptController.comp_ICcomponent.group_priority_Group4_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_0_addr_addr_int_0_o is wired from Top BF int_0_addr_addr_int_0_out.
    property regif_peripheral_hw_out_int_0_addr_addr_int_0_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_0_out == InterruptController.comp_ICcomponent.addr_int_0_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_1_addr_addr_int_1_o is wired from Top BF int_1_addr_addr_int_1_out.
    property regif_peripheral_hw_out_int_1_addr_addr_int_1_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_1_out == InterruptController.comp_ICcomponent.addr_int_1_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_2_addr_addr_int_2_o is wired from Top BF int_2_addr_addr_int_2_out.
    property regif_peripheral_hw_out_int_2_addr_addr_int_2_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_2_out == InterruptController.comp_ICcomponent.addr_int_2_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_3_addr_addr_int_3_o is wired from Top BF int_3_addr_addr_int_3_out.
    property regif_peripheral_hw_out_int_3_addr_addr_int_3_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_3_out == InterruptController.comp_ICcomponent.addr_int_3_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_4_addr_addr_int_4_o is wired from Top BF int_4_addr_addr_int_4_out.
    property regif_peripheral_hw_out_int_4_addr_addr_int_4_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_4_out == InterruptController.comp_ICcomponent.addr_int_4_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_5_addr_addr_int_5_o is wired from Top BF int_5_addr_addr_int_5_out.
    property regif_peripheral_hw_out_int_5_addr_addr_int_5_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_5_out == InterruptController.comp_ICcomponent.addr_int_5_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_6_addr_addr_int_6_o is wired from Top BF int_6_addr_addr_int_6_out.
    property regif_peripheral_hw_out_int_6_addr_addr_int_6_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_6_out == InterruptController.comp_ICcomponent.addr_int_6_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_7_addr_addr_int_7_o is wired from Top BF int_7_addr_addr_int_7_out.
    property regif_peripheral_hw_out_int_7_addr_addr_int_7_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_7_out == InterruptController.comp_ICcomponent.addr_int_7_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_8_addr_addr_int_8_o is wired from Top BF int_8_addr_addr_int_8_out.
    property regif_peripheral_hw_out_int_8_addr_addr_int_8_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_8_out == InterruptController.comp_ICcomponent.addr_int_8_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_9_addr_addr_int_9_o is wired from Top BF int_9_addr_addr_int_9_out.
    property regif_peripheral_hw_out_int_9_addr_addr_int_9_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_9_out == InterruptController.comp_ICcomponent.addr_int_9_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_10_addr_addr_int_10_o is wired from Top BF int_10_addr_addr_int_10_out.
    property regif_peripheral_hw_out_int_10_addr_addr_int_10_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_10_out == InterruptController.comp_ICcomponent.addr_int_10_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_11_addr_addr_int_11_o is wired from Top BF int_11_addr_addr_int_11_out.
    property regif_peripheral_hw_out_int_11_addr_addr_int_11_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_11_out == InterruptController.comp_ICcomponent.addr_int_11_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_12_addr_addr_int_12_o is wired from Top BF int_12_addr_addr_int_12_out.
    property regif_peripheral_hw_out_int_12_addr_addr_int_12_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_12_out == InterruptController.comp_ICcomponent.addr_int_12_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_13_addr_addr_int_13_o is wired from Top BF int_13_addr_addr_int_13_out.
    property regif_peripheral_hw_out_int_13_addr_addr_int_13_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_13_out == InterruptController.comp_ICcomponent.addr_int_13_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_14_addr_addr_int_14_o is wired from Top BF int_14_addr_addr_int_14_out.
    property regif_peripheral_hw_out_int_14_addr_addr_int_14_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_14_out == InterruptController.comp_ICcomponent.addr_int_14_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_15_addr_addr_int_15_o is wired from Top BF int_15_addr_addr_int_15_out.
    property regif_peripheral_hw_out_int_15_addr_addr_int_15_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_15_out == InterruptController.comp_ICcomponent.addr_int_15_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_16_addr_addr_int_16_o is wired from Top BF int_16_addr_addr_int_16_out.
    property regif_peripheral_hw_out_int_16_addr_addr_int_16_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_16_out == InterruptController.comp_ICcomponent.addr_int_16_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_17_addr_addr_int_17_o is wired from Top BF int_17_addr_addr_int_17_out.
    property regif_peripheral_hw_out_int_17_addr_addr_int_17_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_17_out == InterruptController.comp_ICcomponent.addr_int_17_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_18_addr_addr_int_18_o is wired from Top BF int_18_addr_addr_int_18_out.
    property regif_peripheral_hw_out_int_18_addr_addr_int_18_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_18_out == InterruptController.comp_ICcomponent.addr_int_18_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_19_addr_addr_int_19_o is wired from Top BF int_19_addr_addr_int_19_out.
    property regif_peripheral_hw_out_int_19_addr_addr_int_19_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_19_out == InterruptController.comp_ICcomponent.addr_int_19_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_20_addr_addr_int_20_o is wired from Top BF int_20_addr_addr_int_20_out.
    property regif_peripheral_hw_out_int_20_addr_addr_int_20_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_20_out == InterruptController.comp_ICcomponent.addr_int_20_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_21_addr_addr_int_21_o is wired from Top BF int_21_addr_addr_int_21_out.
    property regif_peripheral_hw_out_int_21_addr_addr_int_21_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_21_out == InterruptController.comp_ICcomponent.addr_int_21_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_22_addr_addr_int_22_o is wired from Top BF int_22_addr_addr_int_22_out.
    property regif_peripheral_hw_out_int_22_addr_addr_int_22_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_22_out == InterruptController.comp_ICcomponent.addr_int_22_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_23_addr_addr_int_23_o is wired from Top BF int_23_addr_addr_int_23_out.
    property regif_peripheral_hw_out_int_23_addr_addr_int_23_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_23_out == InterruptController.comp_ICcomponent.addr_int_23_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_24_addr_addr_int_24_o is wired from Top BF int_24_addr_addr_int_24_out.
    property regif_peripheral_hw_out_int_24_addr_addr_int_24_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_24_out == InterruptController.comp_ICcomponent.addr_int_24_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_25_addr_addr_int_25_o is wired from Top BF int_25_addr_addr_int_25_out.
    property regif_peripheral_hw_out_int_25_addr_addr_int_25_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_25_out == InterruptController.comp_ICcomponent.addr_int_25_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_26_addr_addr_int_26_o is wired from Top BF int_26_addr_addr_int_26_out.
    property regif_peripheral_hw_out_int_26_addr_addr_int_26_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_26_out == InterruptController.comp_ICcomponent.addr_int_26_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_27_addr_addr_int_27_o is wired from Top BF int_27_addr_addr_int_27_out.
    property regif_peripheral_hw_out_int_27_addr_addr_int_27_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_27_out == InterruptController.comp_ICcomponent.addr_int_27_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_28_addr_addr_int_28_o is wired from Top BF int_28_addr_addr_int_28_out.
    property regif_peripheral_hw_out_int_28_addr_addr_int_28_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_28_out == InterruptController.comp_ICcomponent.addr_int_28_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_29_addr_addr_int_29_o is wired from Top BF int_29_addr_addr_int_29_out.
    property regif_peripheral_hw_out_int_29_addr_addr_int_29_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_29_out == InterruptController.comp_ICcomponent.addr_int_29_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_30_addr_addr_int_30_o is wired from Top BF int_30_addr_addr_int_30_out.
    property regif_peripheral_hw_out_int_30_addr_addr_int_30_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_30_out == InterruptController.comp_ICcomponent.addr_int_30_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output int_31_addr_addr_int_31_o is wired from Top BF int_31_addr_addr_int_31_out.
    property regif_peripheral_hw_out_int_31_addr_addr_int_31_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_int_31_out == InterruptController.comp_ICcomponent.addr_int_31_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check Register Interface HW read output NMI_addr_addr_NMI_o is wired from Top BF NMI_addr_addr_NMI_out.
    property regif_peripheral_hw_out_NMI_addr_addr_NMI_connectivity;
    @(posedge InterruptController.HCLK_i)
        (1 
	|->
	 (InterruptController.comp_Reg_IF.InterruptControllerCSC_BF_addr_NMI_out == InterruptController.comp_ICcomponent.addr_NMI_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //The slave must put ready high after the address phase has started.
    property ready_after_address_phase;
    @(posedge InterruptController.HCLK_i)
    disable iff(!InterruptController.HRESET_n_i)
        (( ( (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HSEL_i == 1) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HREADY_i == 1) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HTRANS_i == 2'b10) )  ##1
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.rai_per_err_i == 0)  ) 
	|->
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HREADYOUT_o == 1));
    endproperty
//---------------------------------------------------------------------------------------------

    //The slave must put ready high when no transaction is ongoing.
    property ready_when_no_transaction;
    @(posedge InterruptController.HCLK_i)
    disable iff(!InterruptController.HRESET_n_i)
        (((InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HSEL_i == 0) || (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HREADY_i == 0) || (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HTRANS_i == 2'b00)) 
	|->
	  ##1
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HREADYOUT_o == 1) );
    endproperty
//---------------------------------------------------------------------------------------------

    //HRESP must be low when no error occurs during the transaction.
    property hresp_no_error_check;
    @(posedge InterruptController.HCLK_i)
    disable iff(!InterruptController.HRESET_n_i)
        (( ( (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HSEL_i == 1) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HREADY_i == 1) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HTRANS_i == 2'b10) )  ##1
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.rai_per_err_i == 0)  ) 
	|->
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HRESP_o == 0));
    endproperty
//---------------------------------------------------------------------------------------------

    //HRESP must be low when no transaction is ongoing.
    property hresp_when_no_transaction;
    @(posedge InterruptController.HCLK_i)
    disable iff(!InterruptController.HRESET_n_i)
        (( ((InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HSEL_i == 0) || (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HREADY_i == 0) || (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HTRANS_i == 2'b00)) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HRESP_o == 0) ) 
	|->
	  ##1
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HRESP_o == 0) );
    endproperty
//---------------------------------------------------------------------------------------------

    //Check if acc_en can be high.
    property acc_en_check;
    @(posedge InterruptController.HCLK_i)
    disable iff(!InterruptController.HRESET_n_i)
        (( ( (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HSEL_i == 1) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HREADY_i == 1) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HTRANS_i == 2'b10) )  ##1
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.rai_per_err_i == 0)  ) 
	|->
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.rai_per_acc_en_o == 1));
    endproperty
//---------------------------------------------------------------------------------------------

    //acc_en is low when no transaction.
    property no_acc_en_when_no_transaction;
    @(posedge InterruptController.HCLK_i)
    disable iff(!InterruptController.HRESET_n_i)
        (((InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HSEL_i == 0) || (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HREADY_i == 0) || (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HTRANS_i == 2'b00)) 
	|->
	  ##1
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.rai_per_acc_en_o == 0) );
    endproperty
//---------------------------------------------------------------------------------------------

    //Check if haddr_i can be transformed into rai_per_addr_o.
    property addr_check;
    @(posedge InterruptController.HCLK_i)
    disable iff(!InterruptController.HRESET_n_i)
        (( ( (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HSEL_i == 1) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HREADY_i == 1) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HTRANS_i == 2'b10) )  ##1
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.rai_per_err_i == 0)  ) 
	|->
	 ( $past(InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HADDR_i) == InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.bridge_fsm_haddr_reg_Outp_out_out));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check if hrdata_o equals to rai_per_rdata_i.
    property rdata_check;
    @(posedge InterruptController.HCLK_i)
    disable iff(!InterruptController.HRESET_n_i)
        (( ( (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HSEL_i == 1) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HREADY_i == 1) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HTRANS_i == 2'b10) )  ##1
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.rai_per_err_i == 0)  ) 
	|->
	  ##1
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HRDATA_o == InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.rai_per_rdata_i) );
    endproperty
//---------------------------------------------------------------------------------------------

    //Check if hwdata_i equals to rai_per_wdata_o.
    property wdata_check;
    @(posedge InterruptController.HCLK_i)
    disable iff(!InterruptController.HRESET_n_i)
        (( ( (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HSEL_i == 1) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HREADY_i == 1) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HTRANS_i == 2'b10) )  ##1
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.rai_per_err_i == 0)  ) 
	|->
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HWDATA_i == InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.rai_per_wdata_o));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check if rai_per_wr_en_o is low for read transactions.
    property read_enable_check;
    @(posedge InterruptController.HCLK_i)
    disable iff(!InterruptController.HRESET_n_i)
        (( ( ( (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HSEL_i == 1) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HREADY_i == 1) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HTRANS_i == 2'b10) ) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HWRITE_i == 0) )  ##1
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.rai_per_err_i == 0)  ) 
	|->
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.rai_per_wr_en_o == 0));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check if rai_per_wr_en_o is set to high for write transactions.
    property write_enable_check;
    @(posedge InterruptController.HCLK_i)
    disable iff(!InterruptController.HRESET_n_i)
        (( ( ( (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HSEL_i == 1) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HREADY_i == 1) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HTRANS_i == 2'b10) ) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HWRITE_i == 1) )  ##1
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.rai_per_err_i == 0)  ) 
	|->
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.rai_per_wr_en_o == 1));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check if bridge can translate byte access correctly.
    property access_size_byte_check;
    @(posedge InterruptController.HCLK_i)
    disable iff(!InterruptController.HRESET_n_i)
        (( ( ( (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HSEL_i == 1) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HREADY_i == 1) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HTRANS_i == 2'b10) ) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HSIZE_i == 3'b000) )  ##1
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.rai_per_err_i == 0)  ) 
	|->
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.csc_access_size_o == 2'b10));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check if bridge can translate halfword access correctly.
    property access_size_halfword_check;
    @(posedge InterruptController.HCLK_i)
    disable iff(!InterruptController.HRESET_n_i)
        (( ( ( (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HSEL_i == 1) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HREADY_i == 1) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HTRANS_i == 2'b10) ) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HSIZE_i == 3'b001) )  ##1
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.rai_per_err_i == 0)  ) 
	|->
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.csc_access_size_o == 2'b01));
    endproperty
//---------------------------------------------------------------------------------------------

    //Check if bridge can translate word access correctly.
    property access_size_word_check;
    @(posedge InterruptController.HCLK_i)
    disable iff(!InterruptController.HRESET_n_i)
        (( ( ( (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HSEL_i == 1) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HREADY_i == 1) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HTRANS_i == 2'b10) ) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HSIZE_i == 3'b010) )  ##1
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.rai_per_err_i == 0)  ) 
	|->
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.csc_access_size_o == 2'b00));
    endproperty
//---------------------------------------------------------------------------------------------

    //hresp high and hready low during error in data phase.
    property bus_error_data_phase_hreadyout_hresp_check;
    @(posedge InterruptController.HCLK_i)
    disable iff(!InterruptController.HRESET_n_i)
        (( ( (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HSEL_i == 1) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HREADY_i == 1) && 
	 ( ~(InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HTRANS_i == 2'b00)) )  ##1
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.rai_per_err_i == 1)  ) 
	|->
	 ( (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HREADYOUT_o == 0) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HRESP_o == 1) ));
    endproperty
//---------------------------------------------------------------------------------------------

    //No access enable should be asserted when error occurs in address phase
    property no_acc_en_when_error_in_address_phase;
    @(posedge InterruptController.HCLK_i)
    disable iff(!InterruptController.HRESET_n_i)
        (( (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HSEL_i == 1) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HREADY_i == 1) && 
	 ((InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HTRANS_i == 2'b01) || (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HTRANS_i == 2'b11)) ) 
	|->
	  ##1
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.rai_per_acc_en_o == 0) );
    endproperty
//---------------------------------------------------------------------------------------------

    //Check if burst error response can be high.
    property burst_error_response;
    @(posedge InterruptController.HCLK_i)
    disable iff(!InterruptController.HRESET_n_i)
        (( (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HSEL_i == 1) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HREADY_i == 1) && 
	 ((InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HTRANS_i == 2'b01) || (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HTRANS_i == 2'b11)) ) 
	|->
	  ##1
	 ( (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HREADYOUT_o == 0) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HRESP_o == 1) ) );
    endproperty
//---------------------------------------------------------------------------------------------

    //Bus error exists two cycles
    property bus_error_two_cycles;
    @(posedge InterruptController.HCLK_i)
    disable iff(!InterruptController.HRESET_n_i)
        (( (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HREADYOUT_o == 0) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HRESP_o == 1) ) 
	|->
	  ##1
	 ( (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HREADYOUT_o == 1) && 
	 (InterruptController.comp_Reg_IF.comp_AHB_RAI_Bridge.HRESP_o == 1) ) );
    endproperty
//---------------------------------------------------------------------------------------------

    no_locked_transfer_assume: assume property(no_locked_transfer);
    transfer_start_non_seq_assume: assume property(transfer_start_non_seq);
    burst_after_non_seq_assume: assume property(burst_after_non_seq);
    hsel_high_during_burst_assume: assume property(hsel_high_during_burst);
    idle_after_reset_assume: assume property(idle_after_reset);
    no_csc_error_when_no_access_en_assume: assume property(no_csc_error_when_no_access_en);
    hreadyin_hreadyout_data_phase_assume: assume property(hreadyin_hreadyout_data_phase);
    ready_after_reset_assert: assert property(ready_after_reset);
    hresp_after_reset_assert: assert property(hresp_after_reset);
    acc_en_after_reset_assert: assert property(acc_en_after_reset);
    bridge_csc_data_in_connectivity_assert: assert property(bridge_csc_data_in_connectivity);
    bridge_csc_addr_connectivity_assert: assert property(bridge_csc_addr_connectivity);
    bridge_csc_access_size_connectivity_assert: assert property(bridge_csc_access_size_connectivity);
    bridge_csc_wr_en_connectivity_assert: assert property(bridge_csc_wr_en_connectivity);
    bridge_csc_rd_en_connectivity_assert: assert property(bridge_csc_rd_en_connectivity);
    bridge_csc_rdata_connectivity_assert: assert property(bridge_csc_rdata_connectivity);
    bridge_rai_ack_i_connectivity_assert: assert property(bridge_rai_ack_i_connectivity);
    bridge_rai_err_i_connectivity_assert: assert property(bridge_rai_err_i_connectivity);
    bridge_csc_reset_connectivity_assert: assert property(bridge_csc_reset_connectivity);
    bridge_regif_haddr_connectivity_assert: assert property(bridge_regif_haddr_connectivity);
    bridge_regif_hwdata_connectivity_assert: assert property(bridge_regif_hwdata_connectivity);
    bridge_regif_hburst_connectivity_assert: assert property(bridge_regif_hburst_connectivity);
    bridge_regif_hmastlock_connectivity_assert: assert property(bridge_regif_hmastlock_connectivity);
    bridge_regif_hprot_connectivity_assert: assert property(bridge_regif_hprot_connectivity);
    bridge_regif_hsize_connectivity_assert: assert property(bridge_regif_hsize_connectivity);
    bridge_regif_htrans_connectivity_assert: assert property(bridge_regif_htrans_connectivity);
    bridge_regif_hwrite_connectivity_assert: assert property(bridge_regif_hwrite_connectivity);
    bridge_regif_hsel_connectivity_assert: assert property(bridge_regif_hsel_connectivity);
    bridge_regif_hready_connectivity_assert: assert property(bridge_regif_hready_connectivity);
    bridge_regif_hrdata_connectivity_assert: assert property(bridge_regif_hrdata_connectivity);
    bridge_regif_hreadyout_connectivity_assert: assert property(bridge_regif_hreadyout_connectivity);
    bridge_regif_hresp_connectivity_assert: assert property(bridge_regif_hresp_connectivity);
    reg_if_hw_out_enable_enable_int_0_connectivity_assert: assert property(reg_if_hw_out_enable_enable_int_0_connectivity);
    reg_if_hw_out_enable_enable_int_1_connectivity_assert: assert property(reg_if_hw_out_enable_enable_int_1_connectivity);
    reg_if_hw_out_enable_enable_int_2_connectivity_assert: assert property(reg_if_hw_out_enable_enable_int_2_connectivity);
    reg_if_hw_out_enable_enable_int_3_connectivity_assert: assert property(reg_if_hw_out_enable_enable_int_3_connectivity);
    reg_if_hw_out_enable_enable_int_4_connectivity_assert: assert property(reg_if_hw_out_enable_enable_int_4_connectivity);
    reg_if_hw_out_enable_enable_int_5_connectivity_assert: assert property(reg_if_hw_out_enable_enable_int_5_connectivity);
    reg_if_hw_out_enable_enable_int_6_connectivity_assert: assert property(reg_if_hw_out_enable_enable_int_6_connectivity);
    reg_if_hw_out_enable_enable_int_7_connectivity_assert: assert property(reg_if_hw_out_enable_enable_int_7_connectivity);
    reg_if_hw_out_enable_enable_int_8_connectivity_assert: assert property(reg_if_hw_out_enable_enable_int_8_connectivity);
    reg_if_hw_out_enable_enable_int_9_connectivity_assert: assert property(reg_if_hw_out_enable_enable_int_9_connectivity);
    reg_if_hw_out_enable_enable_int_10_connectivity_assert: assert property(reg_if_hw_out_enable_enable_int_10_connectivity);
    reg_if_hw_out_enable_enable_int_11_connectivity_assert: assert property(reg_if_hw_out_enable_enable_int_11_connectivity);
    reg_if_hw_out_enable_enable_int_12_connectivity_assert: assert property(reg_if_hw_out_enable_enable_int_12_connectivity);
    reg_if_hw_out_enable_enable_int_13_connectivity_assert: assert property(reg_if_hw_out_enable_enable_int_13_connectivity);
    reg_if_hw_out_enable_enable_int_14_connectivity_assert: assert property(reg_if_hw_out_enable_enable_int_14_connectivity);
    reg_if_hw_out_enable_enable_int_15_connectivity_assert: assert property(reg_if_hw_out_enable_enable_int_15_connectivity);
    reg_if_hw_out_enable_enable_int_16_connectivity_assert: assert property(reg_if_hw_out_enable_enable_int_16_connectivity);
    reg_if_hw_out_enable_enable_int_17_connectivity_assert: assert property(reg_if_hw_out_enable_enable_int_17_connectivity);
    reg_if_hw_out_enable_enable_int_18_connectivity_assert: assert property(reg_if_hw_out_enable_enable_int_18_connectivity);
    reg_if_hw_out_enable_enable_int_19_connectivity_assert: assert property(reg_if_hw_out_enable_enable_int_19_connectivity);
    reg_if_hw_out_enable_enable_int_20_connectivity_assert: assert property(reg_if_hw_out_enable_enable_int_20_connectivity);
    reg_if_hw_out_enable_enable_int_21_connectivity_assert: assert property(reg_if_hw_out_enable_enable_int_21_connectivity);
    reg_if_hw_out_enable_enable_int_22_connectivity_assert: assert property(reg_if_hw_out_enable_enable_int_22_connectivity);
    reg_if_hw_out_enable_enable_int_23_connectivity_assert: assert property(reg_if_hw_out_enable_enable_int_23_connectivity);
    reg_if_hw_out_enable_enable_int_24_connectivity_assert: assert property(reg_if_hw_out_enable_enable_int_24_connectivity);
    reg_if_hw_out_enable_enable_int_25_connectivity_assert: assert property(reg_if_hw_out_enable_enable_int_25_connectivity);
    reg_if_hw_out_enable_enable_int_26_connectivity_assert: assert property(reg_if_hw_out_enable_enable_int_26_connectivity);
    reg_if_hw_out_enable_enable_int_27_connectivity_assert: assert property(reg_if_hw_out_enable_enable_int_27_connectivity);
    reg_if_hw_out_enable_enable_int_28_connectivity_assert: assert property(reg_if_hw_out_enable_enable_int_28_connectivity);
    reg_if_hw_out_enable_enable_int_29_connectivity_assert: assert property(reg_if_hw_out_enable_enable_int_29_connectivity);
    reg_if_hw_out_enable_enable_int_30_connectivity_assert: assert property(reg_if_hw_out_enable_enable_int_30_connectivity);
    reg_if_hw_out_enable_enable_int_31_connectivity_assert: assert property(reg_if_hw_out_enable_enable_int_31_connectivity);
    reg_if_hw_out_unmask_unmask_int_0_connectivity_assert: assert property(reg_if_hw_out_unmask_unmask_int_0_connectivity);
    reg_if_hw_out_unmask_unmask_int_1_connectivity_assert: assert property(reg_if_hw_out_unmask_unmask_int_1_connectivity);
    reg_if_hw_out_unmask_unmask_int_2_connectivity_assert: assert property(reg_if_hw_out_unmask_unmask_int_2_connectivity);
    reg_if_hw_out_unmask_unmask_int_3_connectivity_assert: assert property(reg_if_hw_out_unmask_unmask_int_3_connectivity);
    reg_if_hw_out_unmask_unmask_int_4_connectivity_assert: assert property(reg_if_hw_out_unmask_unmask_int_4_connectivity);
    reg_if_hw_out_unmask_unmask_int_5_connectivity_assert: assert property(reg_if_hw_out_unmask_unmask_int_5_connectivity);
    reg_if_hw_out_unmask_unmask_int_6_connectivity_assert: assert property(reg_if_hw_out_unmask_unmask_int_6_connectivity);
    reg_if_hw_out_unmask_unmask_int_7_connectivity_assert: assert property(reg_if_hw_out_unmask_unmask_int_7_connectivity);
    reg_if_hw_out_unmask_unmask_int_8_connectivity_assert: assert property(reg_if_hw_out_unmask_unmask_int_8_connectivity);
    reg_if_hw_out_unmask_unmask_int_9_connectivity_assert: assert property(reg_if_hw_out_unmask_unmask_int_9_connectivity);
    reg_if_hw_out_unmask_unmask_int_10_connectivity_assert: assert property(reg_if_hw_out_unmask_unmask_int_10_connectivity);
    reg_if_hw_out_unmask_unmask_int_11_connectivity_assert: assert property(reg_if_hw_out_unmask_unmask_int_11_connectivity);
    reg_if_hw_out_unmask_unmask_int_12_connectivity_assert: assert property(reg_if_hw_out_unmask_unmask_int_12_connectivity);
    reg_if_hw_out_unmask_unmask_int_13_connectivity_assert: assert property(reg_if_hw_out_unmask_unmask_int_13_connectivity);
    reg_if_hw_out_unmask_unmask_int_14_connectivity_assert: assert property(reg_if_hw_out_unmask_unmask_int_14_connectivity);
    reg_if_hw_out_unmask_unmask_int_15_connectivity_assert: assert property(reg_if_hw_out_unmask_unmask_int_15_connectivity);
    reg_if_hw_out_unmask_unmask_int_16_connectivity_assert: assert property(reg_if_hw_out_unmask_unmask_int_16_connectivity);
    reg_if_hw_out_unmask_unmask_int_17_connectivity_assert: assert property(reg_if_hw_out_unmask_unmask_int_17_connectivity);
    reg_if_hw_out_unmask_unmask_int_18_connectivity_assert: assert property(reg_if_hw_out_unmask_unmask_int_18_connectivity);
    reg_if_hw_out_unmask_unmask_int_19_connectivity_assert: assert property(reg_if_hw_out_unmask_unmask_int_19_connectivity);
    reg_if_hw_out_unmask_unmask_int_20_connectivity_assert: assert property(reg_if_hw_out_unmask_unmask_int_20_connectivity);
    reg_if_hw_out_unmask_unmask_int_21_connectivity_assert: assert property(reg_if_hw_out_unmask_unmask_int_21_connectivity);
    reg_if_hw_out_unmask_unmask_int_22_connectivity_assert: assert property(reg_if_hw_out_unmask_unmask_int_22_connectivity);
    reg_if_hw_out_unmask_unmask_int_23_connectivity_assert: assert property(reg_if_hw_out_unmask_unmask_int_23_connectivity);
    reg_if_hw_out_unmask_unmask_int_24_connectivity_assert: assert property(reg_if_hw_out_unmask_unmask_int_24_connectivity);
    reg_if_hw_out_unmask_unmask_int_25_connectivity_assert: assert property(reg_if_hw_out_unmask_unmask_int_25_connectivity);
    reg_if_hw_out_unmask_unmask_int_26_connectivity_assert: assert property(reg_if_hw_out_unmask_unmask_int_26_connectivity);
    reg_if_hw_out_unmask_unmask_int_27_connectivity_assert: assert property(reg_if_hw_out_unmask_unmask_int_27_connectivity);
    reg_if_hw_out_unmask_unmask_int_28_connectivity_assert: assert property(reg_if_hw_out_unmask_unmask_int_28_connectivity);
    reg_if_hw_out_unmask_unmask_int_29_connectivity_assert: assert property(reg_if_hw_out_unmask_unmask_int_29_connectivity);
    reg_if_hw_out_unmask_unmask_int_30_connectivity_assert: assert property(reg_if_hw_out_unmask_unmask_int_30_connectivity);
    reg_if_hw_out_unmask_unmask_int_31_connectivity_assert: assert property(reg_if_hw_out_unmask_unmask_int_31_connectivity);
    reg_if_hw_in_pending_pending_int_0_connectivity_assert: assert property(reg_if_hw_in_pending_pending_int_0_connectivity);
    reg_if_hw_en_pending_pending_int_0_connectivity_assert: assert property(reg_if_hw_en_pending_pending_int_0_connectivity);
    reg_if_hw_out_pending_pending_int_0_connectivity_assert: assert property(reg_if_hw_out_pending_pending_int_0_connectivity);
    reg_if_hw_in_pending_pending_int_1_connectivity_assert: assert property(reg_if_hw_in_pending_pending_int_1_connectivity);
    reg_if_hw_en_pending_pending_int_1_connectivity_assert: assert property(reg_if_hw_en_pending_pending_int_1_connectivity);
    reg_if_hw_out_pending_pending_int_1_connectivity_assert: assert property(reg_if_hw_out_pending_pending_int_1_connectivity);
    reg_if_hw_in_pending_pending_int_2_connectivity_assert: assert property(reg_if_hw_in_pending_pending_int_2_connectivity);
    reg_if_hw_en_pending_pending_int_2_connectivity_assert: assert property(reg_if_hw_en_pending_pending_int_2_connectivity);
    reg_if_hw_out_pending_pending_int_2_connectivity_assert: assert property(reg_if_hw_out_pending_pending_int_2_connectivity);
    reg_if_hw_in_pending_pending_int_3_connectivity_assert: assert property(reg_if_hw_in_pending_pending_int_3_connectivity);
    reg_if_hw_en_pending_pending_int_3_connectivity_assert: assert property(reg_if_hw_en_pending_pending_int_3_connectivity);
    reg_if_hw_out_pending_pending_int_3_connectivity_assert: assert property(reg_if_hw_out_pending_pending_int_3_connectivity);
    reg_if_hw_in_pending_pending_int_4_connectivity_assert: assert property(reg_if_hw_in_pending_pending_int_4_connectivity);
    reg_if_hw_en_pending_pending_int_4_connectivity_assert: assert property(reg_if_hw_en_pending_pending_int_4_connectivity);
    reg_if_hw_out_pending_pending_int_4_connectivity_assert: assert property(reg_if_hw_out_pending_pending_int_4_connectivity);
    reg_if_hw_in_pending_pending_int_5_connectivity_assert: assert property(reg_if_hw_in_pending_pending_int_5_connectivity);
    reg_if_hw_en_pending_pending_int_5_connectivity_assert: assert property(reg_if_hw_en_pending_pending_int_5_connectivity);
    reg_if_hw_out_pending_pending_int_5_connectivity_assert: assert property(reg_if_hw_out_pending_pending_int_5_connectivity);
    reg_if_hw_in_pending_pending_int_6_connectivity_assert: assert property(reg_if_hw_in_pending_pending_int_6_connectivity);
    reg_if_hw_en_pending_pending_int_6_connectivity_assert: assert property(reg_if_hw_en_pending_pending_int_6_connectivity);
    reg_if_hw_out_pending_pending_int_6_connectivity_assert: assert property(reg_if_hw_out_pending_pending_int_6_connectivity);
    reg_if_hw_in_pending_pending_int_7_connectivity_assert: assert property(reg_if_hw_in_pending_pending_int_7_connectivity);
    reg_if_hw_en_pending_pending_int_7_connectivity_assert: assert property(reg_if_hw_en_pending_pending_int_7_connectivity);
    reg_if_hw_out_pending_pending_int_7_connectivity_assert: assert property(reg_if_hw_out_pending_pending_int_7_connectivity);
    reg_if_hw_in_pending_pending_int_8_connectivity_assert: assert property(reg_if_hw_in_pending_pending_int_8_connectivity);
    reg_if_hw_en_pending_pending_int_8_connectivity_assert: assert property(reg_if_hw_en_pending_pending_int_8_connectivity);
    reg_if_hw_out_pending_pending_int_8_connectivity_assert: assert property(reg_if_hw_out_pending_pending_int_8_connectivity);
    reg_if_hw_in_pending_pending_int_9_connectivity_assert: assert property(reg_if_hw_in_pending_pending_int_9_connectivity);
    reg_if_hw_en_pending_pending_int_9_connectivity_assert: assert property(reg_if_hw_en_pending_pending_int_9_connectivity);
    reg_if_hw_out_pending_pending_int_9_connectivity_assert: assert property(reg_if_hw_out_pending_pending_int_9_connectivity);
    reg_if_hw_in_pending_pending_int_10_connectivity_assert: assert property(reg_if_hw_in_pending_pending_int_10_connectivity);
    reg_if_hw_en_pending_pending_int_10_connectivity_assert: assert property(reg_if_hw_en_pending_pending_int_10_connectivity);
    reg_if_hw_out_pending_pending_int_10_connectivity_assert: assert property(reg_if_hw_out_pending_pending_int_10_connectivity);
    reg_if_hw_in_pending_pending_int_11_connectivity_assert: assert property(reg_if_hw_in_pending_pending_int_11_connectivity);
    reg_if_hw_en_pending_pending_int_11_connectivity_assert: assert property(reg_if_hw_en_pending_pending_int_11_connectivity);
    reg_if_hw_out_pending_pending_int_11_connectivity_assert: assert property(reg_if_hw_out_pending_pending_int_11_connectivity);
    reg_if_hw_in_pending_pending_int_12_connectivity_assert: assert property(reg_if_hw_in_pending_pending_int_12_connectivity);
    reg_if_hw_en_pending_pending_int_12_connectivity_assert: assert property(reg_if_hw_en_pending_pending_int_12_connectivity);
    reg_if_hw_out_pending_pending_int_12_connectivity_assert: assert property(reg_if_hw_out_pending_pending_int_12_connectivity);
    reg_if_hw_in_pending_pending_int_13_connectivity_assert: assert property(reg_if_hw_in_pending_pending_int_13_connectivity);
    reg_if_hw_en_pending_pending_int_13_connectivity_assert: assert property(reg_if_hw_en_pending_pending_int_13_connectivity);
    reg_if_hw_out_pending_pending_int_13_connectivity_assert: assert property(reg_if_hw_out_pending_pending_int_13_connectivity);
    reg_if_hw_in_pending_pending_int_14_connectivity_assert: assert property(reg_if_hw_in_pending_pending_int_14_connectivity);
    reg_if_hw_en_pending_pending_int_14_connectivity_assert: assert property(reg_if_hw_en_pending_pending_int_14_connectivity);
    reg_if_hw_out_pending_pending_int_14_connectivity_assert: assert property(reg_if_hw_out_pending_pending_int_14_connectivity);
    reg_if_hw_in_pending_pending_int_15_connectivity_assert: assert property(reg_if_hw_in_pending_pending_int_15_connectivity);
    reg_if_hw_en_pending_pending_int_15_connectivity_assert: assert property(reg_if_hw_en_pending_pending_int_15_connectivity);
    reg_if_hw_out_pending_pending_int_15_connectivity_assert: assert property(reg_if_hw_out_pending_pending_int_15_connectivity);
    reg_if_hw_in_pending_pending_int_16_connectivity_assert: assert property(reg_if_hw_in_pending_pending_int_16_connectivity);
    reg_if_hw_en_pending_pending_int_16_connectivity_assert: assert property(reg_if_hw_en_pending_pending_int_16_connectivity);
    reg_if_hw_out_pending_pending_int_16_connectivity_assert: assert property(reg_if_hw_out_pending_pending_int_16_connectivity);
    reg_if_hw_in_pending_pending_int_17_connectivity_assert: assert property(reg_if_hw_in_pending_pending_int_17_connectivity);
    reg_if_hw_en_pending_pending_int_17_connectivity_assert: assert property(reg_if_hw_en_pending_pending_int_17_connectivity);
    reg_if_hw_out_pending_pending_int_17_connectivity_assert: assert property(reg_if_hw_out_pending_pending_int_17_connectivity);
    reg_if_hw_in_pending_pending_int_18_connectivity_assert: assert property(reg_if_hw_in_pending_pending_int_18_connectivity);
    reg_if_hw_en_pending_pending_int_18_connectivity_assert: assert property(reg_if_hw_en_pending_pending_int_18_connectivity);
    reg_if_hw_out_pending_pending_int_18_connectivity_assert: assert property(reg_if_hw_out_pending_pending_int_18_connectivity);
    reg_if_hw_in_pending_pending_int_19_connectivity_assert: assert property(reg_if_hw_in_pending_pending_int_19_connectivity);
    reg_if_hw_en_pending_pending_int_19_connectivity_assert: assert property(reg_if_hw_en_pending_pending_int_19_connectivity);
    reg_if_hw_out_pending_pending_int_19_connectivity_assert: assert property(reg_if_hw_out_pending_pending_int_19_connectivity);
    reg_if_hw_in_pending_pending_int_20_connectivity_assert: assert property(reg_if_hw_in_pending_pending_int_20_connectivity);
    reg_if_hw_en_pending_pending_int_20_connectivity_assert: assert property(reg_if_hw_en_pending_pending_int_20_connectivity);
    reg_if_hw_out_pending_pending_int_20_connectivity_assert: assert property(reg_if_hw_out_pending_pending_int_20_connectivity);
    reg_if_hw_in_pending_pending_int_21_connectivity_assert: assert property(reg_if_hw_in_pending_pending_int_21_connectivity);
    reg_if_hw_en_pending_pending_int_21_connectivity_assert: assert property(reg_if_hw_en_pending_pending_int_21_connectivity);
    reg_if_hw_out_pending_pending_int_21_connectivity_assert: assert property(reg_if_hw_out_pending_pending_int_21_connectivity);
    reg_if_hw_in_pending_pending_int_22_connectivity_assert: assert property(reg_if_hw_in_pending_pending_int_22_connectivity);
    reg_if_hw_en_pending_pending_int_22_connectivity_assert: assert property(reg_if_hw_en_pending_pending_int_22_connectivity);
    reg_if_hw_out_pending_pending_int_22_connectivity_assert: assert property(reg_if_hw_out_pending_pending_int_22_connectivity);
    reg_if_hw_in_pending_pending_int_23_connectivity_assert: assert property(reg_if_hw_in_pending_pending_int_23_connectivity);
    reg_if_hw_en_pending_pending_int_23_connectivity_assert: assert property(reg_if_hw_en_pending_pending_int_23_connectivity);
    reg_if_hw_out_pending_pending_int_23_connectivity_assert: assert property(reg_if_hw_out_pending_pending_int_23_connectivity);
    reg_if_hw_in_pending_pending_int_24_connectivity_assert: assert property(reg_if_hw_in_pending_pending_int_24_connectivity);
    reg_if_hw_en_pending_pending_int_24_connectivity_assert: assert property(reg_if_hw_en_pending_pending_int_24_connectivity);
    reg_if_hw_out_pending_pending_int_24_connectivity_assert: assert property(reg_if_hw_out_pending_pending_int_24_connectivity);
    reg_if_hw_in_pending_pending_int_25_connectivity_assert: assert property(reg_if_hw_in_pending_pending_int_25_connectivity);
    reg_if_hw_en_pending_pending_int_25_connectivity_assert: assert property(reg_if_hw_en_pending_pending_int_25_connectivity);
    reg_if_hw_out_pending_pending_int_25_connectivity_assert: assert property(reg_if_hw_out_pending_pending_int_25_connectivity);
    reg_if_hw_in_pending_pending_int_26_connectivity_assert: assert property(reg_if_hw_in_pending_pending_int_26_connectivity);
    reg_if_hw_en_pending_pending_int_26_connectivity_assert: assert property(reg_if_hw_en_pending_pending_int_26_connectivity);
    reg_if_hw_out_pending_pending_int_26_connectivity_assert: assert property(reg_if_hw_out_pending_pending_int_26_connectivity);
    reg_if_hw_in_pending_pending_int_27_connectivity_assert: assert property(reg_if_hw_in_pending_pending_int_27_connectivity);
    reg_if_hw_en_pending_pending_int_27_connectivity_assert: assert property(reg_if_hw_en_pending_pending_int_27_connectivity);
    reg_if_hw_out_pending_pending_int_27_connectivity_assert: assert property(reg_if_hw_out_pending_pending_int_27_connectivity);
    reg_if_hw_in_pending_pending_int_28_connectivity_assert: assert property(reg_if_hw_in_pending_pending_int_28_connectivity);
    reg_if_hw_en_pending_pending_int_28_connectivity_assert: assert property(reg_if_hw_en_pending_pending_int_28_connectivity);
    reg_if_hw_out_pending_pending_int_28_connectivity_assert: assert property(reg_if_hw_out_pending_pending_int_28_connectivity);
    reg_if_hw_in_pending_pending_int_29_connectivity_assert: assert property(reg_if_hw_in_pending_pending_int_29_connectivity);
    reg_if_hw_en_pending_pending_int_29_connectivity_assert: assert property(reg_if_hw_en_pending_pending_int_29_connectivity);
    reg_if_hw_out_pending_pending_int_29_connectivity_assert: assert property(reg_if_hw_out_pending_pending_int_29_connectivity);
    reg_if_hw_in_pending_pending_int_30_connectivity_assert: assert property(reg_if_hw_in_pending_pending_int_30_connectivity);
    reg_if_hw_en_pending_pending_int_30_connectivity_assert: assert property(reg_if_hw_en_pending_pending_int_30_connectivity);
    reg_if_hw_out_pending_pending_int_30_connectivity_assert: assert property(reg_if_hw_out_pending_pending_int_30_connectivity);
    reg_if_hw_in_pending_pending_int_31_connectivity_assert: assert property(reg_if_hw_in_pending_pending_int_31_connectivity);
    reg_if_hw_en_pending_pending_int_31_connectivity_assert: assert property(reg_if_hw_en_pending_pending_int_31_connectivity);
    reg_if_hw_out_pending_pending_int_31_connectivity_assert: assert property(reg_if_hw_out_pending_pending_int_31_connectivity);
    reg_if_hw_in_pending_1_pending_NMI_connectivity_assert: assert property(reg_if_hw_in_pending_1_pending_NMI_connectivity);
    reg_if_hw_en_pending_1_pending_NMI_connectivity_assert: assert property(reg_if_hw_en_pending_1_pending_NMI_connectivity);
    reg_if_hw_out_pending_1_pending_NMI_connectivity_assert: assert property(reg_if_hw_out_pending_1_pending_NMI_connectivity);
    reg_if_hw_in_active_active_int_0_connectivity_assert: assert property(reg_if_hw_in_active_active_int_0_connectivity);
    reg_if_hw_en_active_active_int_0_connectivity_assert: assert property(reg_if_hw_en_active_active_int_0_connectivity);
    reg_if_hw_out_active_active_int_0_connectivity_assert: assert property(reg_if_hw_out_active_active_int_0_connectivity);
    reg_if_hw_in_active_active_int_1_connectivity_assert: assert property(reg_if_hw_in_active_active_int_1_connectivity);
    reg_if_hw_en_active_active_int_1_connectivity_assert: assert property(reg_if_hw_en_active_active_int_1_connectivity);
    reg_if_hw_out_active_active_int_1_connectivity_assert: assert property(reg_if_hw_out_active_active_int_1_connectivity);
    reg_if_hw_in_active_active_int_2_connectivity_assert: assert property(reg_if_hw_in_active_active_int_2_connectivity);
    reg_if_hw_en_active_active_int_2_connectivity_assert: assert property(reg_if_hw_en_active_active_int_2_connectivity);
    reg_if_hw_out_active_active_int_2_connectivity_assert: assert property(reg_if_hw_out_active_active_int_2_connectivity);
    reg_if_hw_in_active_active_int_3_connectivity_assert: assert property(reg_if_hw_in_active_active_int_3_connectivity);
    reg_if_hw_en_active_active_int_3_connectivity_assert: assert property(reg_if_hw_en_active_active_int_3_connectivity);
    reg_if_hw_out_active_active_int_3_connectivity_assert: assert property(reg_if_hw_out_active_active_int_3_connectivity);
    reg_if_hw_in_active_active_int_4_connectivity_assert: assert property(reg_if_hw_in_active_active_int_4_connectivity);
    reg_if_hw_en_active_active_int_4_connectivity_assert: assert property(reg_if_hw_en_active_active_int_4_connectivity);
    reg_if_hw_out_active_active_int_4_connectivity_assert: assert property(reg_if_hw_out_active_active_int_4_connectivity);
    reg_if_hw_in_active_active_int_5_connectivity_assert: assert property(reg_if_hw_in_active_active_int_5_connectivity);
    reg_if_hw_en_active_active_int_5_connectivity_assert: assert property(reg_if_hw_en_active_active_int_5_connectivity);
    reg_if_hw_out_active_active_int_5_connectivity_assert: assert property(reg_if_hw_out_active_active_int_5_connectivity);
    reg_if_hw_in_active_active_int_6_connectivity_assert: assert property(reg_if_hw_in_active_active_int_6_connectivity);
    reg_if_hw_en_active_active_int_6_connectivity_assert: assert property(reg_if_hw_en_active_active_int_6_connectivity);
    reg_if_hw_out_active_active_int_6_connectivity_assert: assert property(reg_if_hw_out_active_active_int_6_connectivity);
    reg_if_hw_in_active_active_int_7_connectivity_assert: assert property(reg_if_hw_in_active_active_int_7_connectivity);
    reg_if_hw_en_active_active_int_7_connectivity_assert: assert property(reg_if_hw_en_active_active_int_7_connectivity);
    reg_if_hw_out_active_active_int_7_connectivity_assert: assert property(reg_if_hw_out_active_active_int_7_connectivity);
    reg_if_hw_in_active_active_int_8_connectivity_assert: assert property(reg_if_hw_in_active_active_int_8_connectivity);
    reg_if_hw_en_active_active_int_8_connectivity_assert: assert property(reg_if_hw_en_active_active_int_8_connectivity);
    reg_if_hw_out_active_active_int_8_connectivity_assert: assert property(reg_if_hw_out_active_active_int_8_connectivity);
    reg_if_hw_in_active_active_int_9_connectivity_assert: assert property(reg_if_hw_in_active_active_int_9_connectivity);
    reg_if_hw_en_active_active_int_9_connectivity_assert: assert property(reg_if_hw_en_active_active_int_9_connectivity);
    reg_if_hw_out_active_active_int_9_connectivity_assert: assert property(reg_if_hw_out_active_active_int_9_connectivity);
    reg_if_hw_in_active_active_int_10_connectivity_assert: assert property(reg_if_hw_in_active_active_int_10_connectivity);
    reg_if_hw_en_active_active_int_10_connectivity_assert: assert property(reg_if_hw_en_active_active_int_10_connectivity);
    reg_if_hw_out_active_active_int_10_connectivity_assert: assert property(reg_if_hw_out_active_active_int_10_connectivity);
    reg_if_hw_in_active_active_int_11_connectivity_assert: assert property(reg_if_hw_in_active_active_int_11_connectivity);
    reg_if_hw_en_active_active_int_11_connectivity_assert: assert property(reg_if_hw_en_active_active_int_11_connectivity);
    reg_if_hw_out_active_active_int_11_connectivity_assert: assert property(reg_if_hw_out_active_active_int_11_connectivity);
    reg_if_hw_in_active_active_int_12_connectivity_assert: assert property(reg_if_hw_in_active_active_int_12_connectivity);
    reg_if_hw_en_active_active_int_12_connectivity_assert: assert property(reg_if_hw_en_active_active_int_12_connectivity);
    reg_if_hw_out_active_active_int_12_connectivity_assert: assert property(reg_if_hw_out_active_active_int_12_connectivity);
    reg_if_hw_in_active_active_int_13_connectivity_assert: assert property(reg_if_hw_in_active_active_int_13_connectivity);
    reg_if_hw_en_active_active_int_13_connectivity_assert: assert property(reg_if_hw_en_active_active_int_13_connectivity);
    reg_if_hw_out_active_active_int_13_connectivity_assert: assert property(reg_if_hw_out_active_active_int_13_connectivity);
    reg_if_hw_in_active_active_int_14_connectivity_assert: assert property(reg_if_hw_in_active_active_int_14_connectivity);
    reg_if_hw_en_active_active_int_14_connectivity_assert: assert property(reg_if_hw_en_active_active_int_14_connectivity);
    reg_if_hw_out_active_active_int_14_connectivity_assert: assert property(reg_if_hw_out_active_active_int_14_connectivity);
    reg_if_hw_in_active_active_int_15_connectivity_assert: assert property(reg_if_hw_in_active_active_int_15_connectivity);
    reg_if_hw_en_active_active_int_15_connectivity_assert: assert property(reg_if_hw_en_active_active_int_15_connectivity);
    reg_if_hw_out_active_active_int_15_connectivity_assert: assert property(reg_if_hw_out_active_active_int_15_connectivity);
    reg_if_hw_in_active_active_int_16_connectivity_assert: assert property(reg_if_hw_in_active_active_int_16_connectivity);
    reg_if_hw_en_active_active_int_16_connectivity_assert: assert property(reg_if_hw_en_active_active_int_16_connectivity);
    reg_if_hw_out_active_active_int_16_connectivity_assert: assert property(reg_if_hw_out_active_active_int_16_connectivity);
    reg_if_hw_in_active_active_int_17_connectivity_assert: assert property(reg_if_hw_in_active_active_int_17_connectivity);
    reg_if_hw_en_active_active_int_17_connectivity_assert: assert property(reg_if_hw_en_active_active_int_17_connectivity);
    reg_if_hw_out_active_active_int_17_connectivity_assert: assert property(reg_if_hw_out_active_active_int_17_connectivity);
    reg_if_hw_in_active_active_int_18_connectivity_assert: assert property(reg_if_hw_in_active_active_int_18_connectivity);
    reg_if_hw_en_active_active_int_18_connectivity_assert: assert property(reg_if_hw_en_active_active_int_18_connectivity);
    reg_if_hw_out_active_active_int_18_connectivity_assert: assert property(reg_if_hw_out_active_active_int_18_connectivity);
    reg_if_hw_in_active_active_int_19_connectivity_assert: assert property(reg_if_hw_in_active_active_int_19_connectivity);
    reg_if_hw_en_active_active_int_19_connectivity_assert: assert property(reg_if_hw_en_active_active_int_19_connectivity);
    reg_if_hw_out_active_active_int_19_connectivity_assert: assert property(reg_if_hw_out_active_active_int_19_connectivity);
    reg_if_hw_in_active_active_int_20_connectivity_assert: assert property(reg_if_hw_in_active_active_int_20_connectivity);
    reg_if_hw_en_active_active_int_20_connectivity_assert: assert property(reg_if_hw_en_active_active_int_20_connectivity);
    reg_if_hw_out_active_active_int_20_connectivity_assert: assert property(reg_if_hw_out_active_active_int_20_connectivity);
    reg_if_hw_in_active_active_int_21_connectivity_assert: assert property(reg_if_hw_in_active_active_int_21_connectivity);
    reg_if_hw_en_active_active_int_21_connectivity_assert: assert property(reg_if_hw_en_active_active_int_21_connectivity);
    reg_if_hw_out_active_active_int_21_connectivity_assert: assert property(reg_if_hw_out_active_active_int_21_connectivity);
    reg_if_hw_in_active_active_int_22_connectivity_assert: assert property(reg_if_hw_in_active_active_int_22_connectivity);
    reg_if_hw_en_active_active_int_22_connectivity_assert: assert property(reg_if_hw_en_active_active_int_22_connectivity);
    reg_if_hw_out_active_active_int_22_connectivity_assert: assert property(reg_if_hw_out_active_active_int_22_connectivity);
    reg_if_hw_in_active_active_int_23_connectivity_assert: assert property(reg_if_hw_in_active_active_int_23_connectivity);
    reg_if_hw_en_active_active_int_23_connectivity_assert: assert property(reg_if_hw_en_active_active_int_23_connectivity);
    reg_if_hw_out_active_active_int_23_connectivity_assert: assert property(reg_if_hw_out_active_active_int_23_connectivity);
    reg_if_hw_in_active_active_int_24_connectivity_assert: assert property(reg_if_hw_in_active_active_int_24_connectivity);
    reg_if_hw_en_active_active_int_24_connectivity_assert: assert property(reg_if_hw_en_active_active_int_24_connectivity);
    reg_if_hw_out_active_active_int_24_connectivity_assert: assert property(reg_if_hw_out_active_active_int_24_connectivity);
    reg_if_hw_in_active_active_int_25_connectivity_assert: assert property(reg_if_hw_in_active_active_int_25_connectivity);
    reg_if_hw_en_active_active_int_25_connectivity_assert: assert property(reg_if_hw_en_active_active_int_25_connectivity);
    reg_if_hw_out_active_active_int_25_connectivity_assert: assert property(reg_if_hw_out_active_active_int_25_connectivity);
    reg_if_hw_in_active_active_int_26_connectivity_assert: assert property(reg_if_hw_in_active_active_int_26_connectivity);
    reg_if_hw_en_active_active_int_26_connectivity_assert: assert property(reg_if_hw_en_active_active_int_26_connectivity);
    reg_if_hw_out_active_active_int_26_connectivity_assert: assert property(reg_if_hw_out_active_active_int_26_connectivity);
    reg_if_hw_in_active_active_int_27_connectivity_assert: assert property(reg_if_hw_in_active_active_int_27_connectivity);
    reg_if_hw_en_active_active_int_27_connectivity_assert: assert property(reg_if_hw_en_active_active_int_27_connectivity);
    reg_if_hw_out_active_active_int_27_connectivity_assert: assert property(reg_if_hw_out_active_active_int_27_connectivity);
    reg_if_hw_in_active_active_int_28_connectivity_assert: assert property(reg_if_hw_in_active_active_int_28_connectivity);
    reg_if_hw_en_active_active_int_28_connectivity_assert: assert property(reg_if_hw_en_active_active_int_28_connectivity);
    reg_if_hw_out_active_active_int_28_connectivity_assert: assert property(reg_if_hw_out_active_active_int_28_connectivity);
    reg_if_hw_in_active_active_int_29_connectivity_assert: assert property(reg_if_hw_in_active_active_int_29_connectivity);
    reg_if_hw_en_active_active_int_29_connectivity_assert: assert property(reg_if_hw_en_active_active_int_29_connectivity);
    reg_if_hw_out_active_active_int_29_connectivity_assert: assert property(reg_if_hw_out_active_active_int_29_connectivity);
    reg_if_hw_in_active_active_int_30_connectivity_assert: assert property(reg_if_hw_in_active_active_int_30_connectivity);
    reg_if_hw_en_active_active_int_30_connectivity_assert: assert property(reg_if_hw_en_active_active_int_30_connectivity);
    reg_if_hw_out_active_active_int_30_connectivity_assert: assert property(reg_if_hw_out_active_active_int_30_connectivity);
    reg_if_hw_in_active_active_int_31_connectivity_assert: assert property(reg_if_hw_in_active_active_int_31_connectivity);
    reg_if_hw_en_active_active_int_31_connectivity_assert: assert property(reg_if_hw_en_active_active_int_31_connectivity);
    reg_if_hw_out_active_active_int_31_connectivity_assert: assert property(reg_if_hw_out_active_active_int_31_connectivity);
    reg_if_hw_in_active_1_active_NMI_connectivity_assert: assert property(reg_if_hw_in_active_1_active_NMI_connectivity);
    reg_if_hw_en_active_1_active_NMI_connectivity_assert: assert property(reg_if_hw_en_active_1_active_NMI_connectivity);
    reg_if_hw_out_active_1_active_NMI_connectivity_assert: assert property(reg_if_hw_out_active_1_active_NMI_connectivity);
    reg_if_hw_out_priority_priority_int_0_connectivity_assert: assert property(reg_if_hw_out_priority_priority_int_0_connectivity);
    reg_if_hw_out_priority_priority_int_1_connectivity_assert: assert property(reg_if_hw_out_priority_priority_int_1_connectivity);
    reg_if_hw_out_priority_priority_int_2_connectivity_assert: assert property(reg_if_hw_out_priority_priority_int_2_connectivity);
    reg_if_hw_out_priority_priority_int_3_connectivity_assert: assert property(reg_if_hw_out_priority_priority_int_3_connectivity);
    reg_if_hw_out_priority_priority_int_4_connectivity_assert: assert property(reg_if_hw_out_priority_priority_int_4_connectivity);
    reg_if_hw_out_priority_priority_int_5_connectivity_assert: assert property(reg_if_hw_out_priority_priority_int_5_connectivity);
    reg_if_hw_out_priority_priority_int_6_connectivity_assert: assert property(reg_if_hw_out_priority_priority_int_6_connectivity);
    reg_if_hw_out_priority_priority_int_7_connectivity_assert: assert property(reg_if_hw_out_priority_priority_int_7_connectivity);
    reg_if_hw_out_priority_priority_int_8_connectivity_assert: assert property(reg_if_hw_out_priority_priority_int_8_connectivity);
    reg_if_hw_out_priority_priority_int_9_connectivity_assert: assert property(reg_if_hw_out_priority_priority_int_9_connectivity);
    reg_if_hw_out_priority_1_priority_int_10_connectivity_assert: assert property(reg_if_hw_out_priority_1_priority_int_10_connectivity);
    reg_if_hw_out_priority_1_priority_int_11_connectivity_assert: assert property(reg_if_hw_out_priority_1_priority_int_11_connectivity);
    reg_if_hw_out_priority_1_priority_int_12_connectivity_assert: assert property(reg_if_hw_out_priority_1_priority_int_12_connectivity);
    reg_if_hw_out_priority_1_priority_int_13_connectivity_assert: assert property(reg_if_hw_out_priority_1_priority_int_13_connectivity);
    reg_if_hw_out_priority_1_priority_int_14_connectivity_assert: assert property(reg_if_hw_out_priority_1_priority_int_14_connectivity);
    reg_if_hw_out_priority_1_priority_int_15_connectivity_assert: assert property(reg_if_hw_out_priority_1_priority_int_15_connectivity);
    reg_if_hw_out_priority_1_priority_int_16_connectivity_assert: assert property(reg_if_hw_out_priority_1_priority_int_16_connectivity);
    reg_if_hw_out_priority_1_priority_int_17_connectivity_assert: assert property(reg_if_hw_out_priority_1_priority_int_17_connectivity);
    reg_if_hw_out_priority_1_priority_int_18_connectivity_assert: assert property(reg_if_hw_out_priority_1_priority_int_18_connectivity);
    reg_if_hw_out_priority_1_priority_int_19_connectivity_assert: assert property(reg_if_hw_out_priority_1_priority_int_19_connectivity);
    reg_if_hw_out_priority_2_priority_int_20_connectivity_assert: assert property(reg_if_hw_out_priority_2_priority_int_20_connectivity);
    reg_if_hw_out_priority_2_priority_int_21_connectivity_assert: assert property(reg_if_hw_out_priority_2_priority_int_21_connectivity);
    reg_if_hw_out_priority_2_priority_int_22_connectivity_assert: assert property(reg_if_hw_out_priority_2_priority_int_22_connectivity);
    reg_if_hw_out_priority_2_priority_int_23_connectivity_assert: assert property(reg_if_hw_out_priority_2_priority_int_23_connectivity);
    reg_if_hw_out_priority_2_priority_int_24_connectivity_assert: assert property(reg_if_hw_out_priority_2_priority_int_24_connectivity);
    reg_if_hw_out_priority_2_priority_int_25_connectivity_assert: assert property(reg_if_hw_out_priority_2_priority_int_25_connectivity);
    reg_if_hw_out_priority_2_priority_int_26_connectivity_assert: assert property(reg_if_hw_out_priority_2_priority_int_26_connectivity);
    reg_if_hw_out_priority_2_priority_int_27_connectivity_assert: assert property(reg_if_hw_out_priority_2_priority_int_27_connectivity);
    reg_if_hw_out_priority_2_priority_int_28_connectivity_assert: assert property(reg_if_hw_out_priority_2_priority_int_28_connectivity);
    reg_if_hw_out_priority_2_priority_int_29_connectivity_assert: assert property(reg_if_hw_out_priority_2_priority_int_29_connectivity);
    reg_if_hw_out_priority_3_priority_int_30_connectivity_assert: assert property(reg_if_hw_out_priority_3_priority_int_30_connectivity);
    reg_if_hw_out_priority_3_priority_int_31_connectivity_assert: assert property(reg_if_hw_out_priority_3_priority_int_31_connectivity);
    reg_if_hw_in_requested_requested_int_0_connectivity_assert: assert property(reg_if_hw_in_requested_requested_int_0_connectivity);
    reg_if_hw_en_requested_requested_int_0_connectivity_assert: assert property(reg_if_hw_en_requested_requested_int_0_connectivity);
    reg_if_hw_out_requested_requested_int_0_connectivity_assert: assert property(reg_if_hw_out_requested_requested_int_0_connectivity);
    reg_if_hw_in_requested_requested_int_1_connectivity_assert: assert property(reg_if_hw_in_requested_requested_int_1_connectivity);
    reg_if_hw_en_requested_requested_int_1_connectivity_assert: assert property(reg_if_hw_en_requested_requested_int_1_connectivity);
    reg_if_hw_out_requested_requested_int_1_connectivity_assert: assert property(reg_if_hw_out_requested_requested_int_1_connectivity);
    reg_if_hw_in_requested_requested_int_2_connectivity_assert: assert property(reg_if_hw_in_requested_requested_int_2_connectivity);
    reg_if_hw_en_requested_requested_int_2_connectivity_assert: assert property(reg_if_hw_en_requested_requested_int_2_connectivity);
    reg_if_hw_out_requested_requested_int_2_connectivity_assert: assert property(reg_if_hw_out_requested_requested_int_2_connectivity);
    reg_if_hw_in_requested_requested_int_3_connectivity_assert: assert property(reg_if_hw_in_requested_requested_int_3_connectivity);
    reg_if_hw_en_requested_requested_int_3_connectivity_assert: assert property(reg_if_hw_en_requested_requested_int_3_connectivity);
    reg_if_hw_out_requested_requested_int_3_connectivity_assert: assert property(reg_if_hw_out_requested_requested_int_3_connectivity);
    reg_if_hw_in_requested_requested_int_4_connectivity_assert: assert property(reg_if_hw_in_requested_requested_int_4_connectivity);
    reg_if_hw_en_requested_requested_int_4_connectivity_assert: assert property(reg_if_hw_en_requested_requested_int_4_connectivity);
    reg_if_hw_out_requested_requested_int_4_connectivity_assert: assert property(reg_if_hw_out_requested_requested_int_4_connectivity);
    reg_if_hw_in_requested_requested_int_5_connectivity_assert: assert property(reg_if_hw_in_requested_requested_int_5_connectivity);
    reg_if_hw_en_requested_requested_int_5_connectivity_assert: assert property(reg_if_hw_en_requested_requested_int_5_connectivity);
    reg_if_hw_out_requested_requested_int_5_connectivity_assert: assert property(reg_if_hw_out_requested_requested_int_5_connectivity);
    reg_if_hw_in_requested_requested_int_6_connectivity_assert: assert property(reg_if_hw_in_requested_requested_int_6_connectivity);
    reg_if_hw_en_requested_requested_int_6_connectivity_assert: assert property(reg_if_hw_en_requested_requested_int_6_connectivity);
    reg_if_hw_out_requested_requested_int_6_connectivity_assert: assert property(reg_if_hw_out_requested_requested_int_6_connectivity);
    reg_if_hw_in_requested_requested_int_7_connectivity_assert: assert property(reg_if_hw_in_requested_requested_int_7_connectivity);
    reg_if_hw_en_requested_requested_int_7_connectivity_assert: assert property(reg_if_hw_en_requested_requested_int_7_connectivity);
    reg_if_hw_out_requested_requested_int_7_connectivity_assert: assert property(reg_if_hw_out_requested_requested_int_7_connectivity);
    reg_if_hw_in_requested_requested_int_8_connectivity_assert: assert property(reg_if_hw_in_requested_requested_int_8_connectivity);
    reg_if_hw_en_requested_requested_int_8_connectivity_assert: assert property(reg_if_hw_en_requested_requested_int_8_connectivity);
    reg_if_hw_out_requested_requested_int_8_connectivity_assert: assert property(reg_if_hw_out_requested_requested_int_8_connectivity);
    reg_if_hw_in_requested_requested_int_9_connectivity_assert: assert property(reg_if_hw_in_requested_requested_int_9_connectivity);
    reg_if_hw_en_requested_requested_int_9_connectivity_assert: assert property(reg_if_hw_en_requested_requested_int_9_connectivity);
    reg_if_hw_out_requested_requested_int_9_connectivity_assert: assert property(reg_if_hw_out_requested_requested_int_9_connectivity);
    reg_if_hw_in_requested_requested_int_10_connectivity_assert: assert property(reg_if_hw_in_requested_requested_int_10_connectivity);
    reg_if_hw_en_requested_requested_int_10_connectivity_assert: assert property(reg_if_hw_en_requested_requested_int_10_connectivity);
    reg_if_hw_out_requested_requested_int_10_connectivity_assert: assert property(reg_if_hw_out_requested_requested_int_10_connectivity);
    reg_if_hw_in_requested_requested_int_11_connectivity_assert: assert property(reg_if_hw_in_requested_requested_int_11_connectivity);
    reg_if_hw_en_requested_requested_int_11_connectivity_assert: assert property(reg_if_hw_en_requested_requested_int_11_connectivity);
    reg_if_hw_out_requested_requested_int_11_connectivity_assert: assert property(reg_if_hw_out_requested_requested_int_11_connectivity);
    reg_if_hw_in_requested_requested_int_12_connectivity_assert: assert property(reg_if_hw_in_requested_requested_int_12_connectivity);
    reg_if_hw_en_requested_requested_int_12_connectivity_assert: assert property(reg_if_hw_en_requested_requested_int_12_connectivity);
    reg_if_hw_out_requested_requested_int_12_connectivity_assert: assert property(reg_if_hw_out_requested_requested_int_12_connectivity);
    reg_if_hw_in_requested_requested_int_13_connectivity_assert: assert property(reg_if_hw_in_requested_requested_int_13_connectivity);
    reg_if_hw_en_requested_requested_int_13_connectivity_assert: assert property(reg_if_hw_en_requested_requested_int_13_connectivity);
    reg_if_hw_out_requested_requested_int_13_connectivity_assert: assert property(reg_if_hw_out_requested_requested_int_13_connectivity);
    reg_if_hw_in_requested_requested_int_14_connectivity_assert: assert property(reg_if_hw_in_requested_requested_int_14_connectivity);
    reg_if_hw_en_requested_requested_int_14_connectivity_assert: assert property(reg_if_hw_en_requested_requested_int_14_connectivity);
    reg_if_hw_out_requested_requested_int_14_connectivity_assert: assert property(reg_if_hw_out_requested_requested_int_14_connectivity);
    reg_if_hw_in_requested_requested_int_15_connectivity_assert: assert property(reg_if_hw_in_requested_requested_int_15_connectivity);
    reg_if_hw_en_requested_requested_int_15_connectivity_assert: assert property(reg_if_hw_en_requested_requested_int_15_connectivity);
    reg_if_hw_out_requested_requested_int_15_connectivity_assert: assert property(reg_if_hw_out_requested_requested_int_15_connectivity);
    reg_if_hw_in_requested_requested_int_16_connectivity_assert: assert property(reg_if_hw_in_requested_requested_int_16_connectivity);
    reg_if_hw_en_requested_requested_int_16_connectivity_assert: assert property(reg_if_hw_en_requested_requested_int_16_connectivity);
    reg_if_hw_out_requested_requested_int_16_connectivity_assert: assert property(reg_if_hw_out_requested_requested_int_16_connectivity);
    reg_if_hw_in_requested_requested_int_17_connectivity_assert: assert property(reg_if_hw_in_requested_requested_int_17_connectivity);
    reg_if_hw_en_requested_requested_int_17_connectivity_assert: assert property(reg_if_hw_en_requested_requested_int_17_connectivity);
    reg_if_hw_out_requested_requested_int_17_connectivity_assert: assert property(reg_if_hw_out_requested_requested_int_17_connectivity);
    reg_if_hw_in_requested_requested_int_18_connectivity_assert: assert property(reg_if_hw_in_requested_requested_int_18_connectivity);
    reg_if_hw_en_requested_requested_int_18_connectivity_assert: assert property(reg_if_hw_en_requested_requested_int_18_connectivity);
    reg_if_hw_out_requested_requested_int_18_connectivity_assert: assert property(reg_if_hw_out_requested_requested_int_18_connectivity);
    reg_if_hw_in_requested_requested_int_19_connectivity_assert: assert property(reg_if_hw_in_requested_requested_int_19_connectivity);
    reg_if_hw_en_requested_requested_int_19_connectivity_assert: assert property(reg_if_hw_en_requested_requested_int_19_connectivity);
    reg_if_hw_out_requested_requested_int_19_connectivity_assert: assert property(reg_if_hw_out_requested_requested_int_19_connectivity);
    reg_if_hw_in_requested_requested_int_20_connectivity_assert: assert property(reg_if_hw_in_requested_requested_int_20_connectivity);
    reg_if_hw_en_requested_requested_int_20_connectivity_assert: assert property(reg_if_hw_en_requested_requested_int_20_connectivity);
    reg_if_hw_out_requested_requested_int_20_connectivity_assert: assert property(reg_if_hw_out_requested_requested_int_20_connectivity);
    reg_if_hw_in_requested_requested_int_21_connectivity_assert: assert property(reg_if_hw_in_requested_requested_int_21_connectivity);
    reg_if_hw_en_requested_requested_int_21_connectivity_assert: assert property(reg_if_hw_en_requested_requested_int_21_connectivity);
    reg_if_hw_out_requested_requested_int_21_connectivity_assert: assert property(reg_if_hw_out_requested_requested_int_21_connectivity);
    reg_if_hw_in_requested_requested_int_22_connectivity_assert: assert property(reg_if_hw_in_requested_requested_int_22_connectivity);
    reg_if_hw_en_requested_requested_int_22_connectivity_assert: assert property(reg_if_hw_en_requested_requested_int_22_connectivity);
    reg_if_hw_out_requested_requested_int_22_connectivity_assert: assert property(reg_if_hw_out_requested_requested_int_22_connectivity);
    reg_if_hw_in_requested_requested_int_23_connectivity_assert: assert property(reg_if_hw_in_requested_requested_int_23_connectivity);
    reg_if_hw_en_requested_requested_int_23_connectivity_assert: assert property(reg_if_hw_en_requested_requested_int_23_connectivity);
    reg_if_hw_out_requested_requested_int_23_connectivity_assert: assert property(reg_if_hw_out_requested_requested_int_23_connectivity);
    reg_if_hw_in_requested_requested_int_24_connectivity_assert: assert property(reg_if_hw_in_requested_requested_int_24_connectivity);
    reg_if_hw_en_requested_requested_int_24_connectivity_assert: assert property(reg_if_hw_en_requested_requested_int_24_connectivity);
    reg_if_hw_out_requested_requested_int_24_connectivity_assert: assert property(reg_if_hw_out_requested_requested_int_24_connectivity);
    reg_if_hw_in_requested_requested_int_25_connectivity_assert: assert property(reg_if_hw_in_requested_requested_int_25_connectivity);
    reg_if_hw_en_requested_requested_int_25_connectivity_assert: assert property(reg_if_hw_en_requested_requested_int_25_connectivity);
    reg_if_hw_out_requested_requested_int_25_connectivity_assert: assert property(reg_if_hw_out_requested_requested_int_25_connectivity);
    reg_if_hw_in_requested_requested_int_26_connectivity_assert: assert property(reg_if_hw_in_requested_requested_int_26_connectivity);
    reg_if_hw_en_requested_requested_int_26_connectivity_assert: assert property(reg_if_hw_en_requested_requested_int_26_connectivity);
    reg_if_hw_out_requested_requested_int_26_connectivity_assert: assert property(reg_if_hw_out_requested_requested_int_26_connectivity);
    reg_if_hw_in_requested_requested_int_27_connectivity_assert: assert property(reg_if_hw_in_requested_requested_int_27_connectivity);
    reg_if_hw_en_requested_requested_int_27_connectivity_assert: assert property(reg_if_hw_en_requested_requested_int_27_connectivity);
    reg_if_hw_out_requested_requested_int_27_connectivity_assert: assert property(reg_if_hw_out_requested_requested_int_27_connectivity);
    reg_if_hw_in_requested_requested_int_28_connectivity_assert: assert property(reg_if_hw_in_requested_requested_int_28_connectivity);
    reg_if_hw_en_requested_requested_int_28_connectivity_assert: assert property(reg_if_hw_en_requested_requested_int_28_connectivity);
    reg_if_hw_out_requested_requested_int_28_connectivity_assert: assert property(reg_if_hw_out_requested_requested_int_28_connectivity);
    reg_if_hw_in_requested_requested_int_29_connectivity_assert: assert property(reg_if_hw_in_requested_requested_int_29_connectivity);
    reg_if_hw_en_requested_requested_int_29_connectivity_assert: assert property(reg_if_hw_en_requested_requested_int_29_connectivity);
    reg_if_hw_out_requested_requested_int_29_connectivity_assert: assert property(reg_if_hw_out_requested_requested_int_29_connectivity);
    reg_if_hw_in_requested_requested_int_30_connectivity_assert: assert property(reg_if_hw_in_requested_requested_int_30_connectivity);
    reg_if_hw_en_requested_requested_int_30_connectivity_assert: assert property(reg_if_hw_en_requested_requested_int_30_connectivity);
    reg_if_hw_out_requested_requested_int_30_connectivity_assert: assert property(reg_if_hw_out_requested_requested_int_30_connectivity);
    reg_if_hw_in_requested_requested_int_31_connectivity_assert: assert property(reg_if_hw_in_requested_requested_int_31_connectivity);
    reg_if_hw_en_requested_requested_int_31_connectivity_assert: assert property(reg_if_hw_en_requested_requested_int_31_connectivity);
    reg_if_hw_out_requested_requested_int_31_connectivity_assert: assert property(reg_if_hw_out_requested_requested_int_31_connectivity);
    reg_if_hw_in_requested_1_requested_NMI_connectivity_assert: assert property(reg_if_hw_in_requested_1_requested_NMI_connectivity);
    reg_if_hw_en_requested_1_requested_NMI_connectivity_assert: assert property(reg_if_hw_en_requested_1_requested_NMI_connectivity);
    reg_if_hw_out_requested_1_requested_NMI_connectivity_assert: assert property(reg_if_hw_out_requested_1_requested_NMI_connectivity);
    reg_if_hw_in_paused_paused_int_0_connectivity_assert: assert property(reg_if_hw_in_paused_paused_int_0_connectivity);
    reg_if_hw_en_paused_paused_int_0_connectivity_assert: assert property(reg_if_hw_en_paused_paused_int_0_connectivity);
    reg_if_hw_out_paused_paused_int_0_connectivity_assert: assert property(reg_if_hw_out_paused_paused_int_0_connectivity);
    reg_if_hw_in_paused_paused_int_1_connectivity_assert: assert property(reg_if_hw_in_paused_paused_int_1_connectivity);
    reg_if_hw_en_paused_paused_int_1_connectivity_assert: assert property(reg_if_hw_en_paused_paused_int_1_connectivity);
    reg_if_hw_out_paused_paused_int_1_connectivity_assert: assert property(reg_if_hw_out_paused_paused_int_1_connectivity);
    reg_if_hw_in_paused_paused_int_2_connectivity_assert: assert property(reg_if_hw_in_paused_paused_int_2_connectivity);
    reg_if_hw_en_paused_paused_int_2_connectivity_assert: assert property(reg_if_hw_en_paused_paused_int_2_connectivity);
    reg_if_hw_out_paused_paused_int_2_connectivity_assert: assert property(reg_if_hw_out_paused_paused_int_2_connectivity);
    reg_if_hw_in_paused_paused_int_3_connectivity_assert: assert property(reg_if_hw_in_paused_paused_int_3_connectivity);
    reg_if_hw_en_paused_paused_int_3_connectivity_assert: assert property(reg_if_hw_en_paused_paused_int_3_connectivity);
    reg_if_hw_out_paused_paused_int_3_connectivity_assert: assert property(reg_if_hw_out_paused_paused_int_3_connectivity);
    reg_if_hw_in_paused_paused_int_4_connectivity_assert: assert property(reg_if_hw_in_paused_paused_int_4_connectivity);
    reg_if_hw_en_paused_paused_int_4_connectivity_assert: assert property(reg_if_hw_en_paused_paused_int_4_connectivity);
    reg_if_hw_out_paused_paused_int_4_connectivity_assert: assert property(reg_if_hw_out_paused_paused_int_4_connectivity);
    reg_if_hw_in_paused_paused_int_5_connectivity_assert: assert property(reg_if_hw_in_paused_paused_int_5_connectivity);
    reg_if_hw_en_paused_paused_int_5_connectivity_assert: assert property(reg_if_hw_en_paused_paused_int_5_connectivity);
    reg_if_hw_out_paused_paused_int_5_connectivity_assert: assert property(reg_if_hw_out_paused_paused_int_5_connectivity);
    reg_if_hw_in_paused_paused_int_6_connectivity_assert: assert property(reg_if_hw_in_paused_paused_int_6_connectivity);
    reg_if_hw_en_paused_paused_int_6_connectivity_assert: assert property(reg_if_hw_en_paused_paused_int_6_connectivity);
    reg_if_hw_out_paused_paused_int_6_connectivity_assert: assert property(reg_if_hw_out_paused_paused_int_6_connectivity);
    reg_if_hw_in_paused_paused_int_7_connectivity_assert: assert property(reg_if_hw_in_paused_paused_int_7_connectivity);
    reg_if_hw_en_paused_paused_int_7_connectivity_assert: assert property(reg_if_hw_en_paused_paused_int_7_connectivity);
    reg_if_hw_out_paused_paused_int_7_connectivity_assert: assert property(reg_if_hw_out_paused_paused_int_7_connectivity);
    reg_if_hw_in_paused_paused_int_8_connectivity_assert: assert property(reg_if_hw_in_paused_paused_int_8_connectivity);
    reg_if_hw_en_paused_paused_int_8_connectivity_assert: assert property(reg_if_hw_en_paused_paused_int_8_connectivity);
    reg_if_hw_out_paused_paused_int_8_connectivity_assert: assert property(reg_if_hw_out_paused_paused_int_8_connectivity);
    reg_if_hw_in_paused_paused_int_9_connectivity_assert: assert property(reg_if_hw_in_paused_paused_int_9_connectivity);
    reg_if_hw_en_paused_paused_int_9_connectivity_assert: assert property(reg_if_hw_en_paused_paused_int_9_connectivity);
    reg_if_hw_out_paused_paused_int_9_connectivity_assert: assert property(reg_if_hw_out_paused_paused_int_9_connectivity);
    reg_if_hw_in_paused_paused_int_10_connectivity_assert: assert property(reg_if_hw_in_paused_paused_int_10_connectivity);
    reg_if_hw_en_paused_paused_int_10_connectivity_assert: assert property(reg_if_hw_en_paused_paused_int_10_connectivity);
    reg_if_hw_out_paused_paused_int_10_connectivity_assert: assert property(reg_if_hw_out_paused_paused_int_10_connectivity);
    reg_if_hw_in_paused_paused_int_11_connectivity_assert: assert property(reg_if_hw_in_paused_paused_int_11_connectivity);
    reg_if_hw_en_paused_paused_int_11_connectivity_assert: assert property(reg_if_hw_en_paused_paused_int_11_connectivity);
    reg_if_hw_out_paused_paused_int_11_connectivity_assert: assert property(reg_if_hw_out_paused_paused_int_11_connectivity);
    reg_if_hw_in_paused_paused_int_12_connectivity_assert: assert property(reg_if_hw_in_paused_paused_int_12_connectivity);
    reg_if_hw_en_paused_paused_int_12_connectivity_assert: assert property(reg_if_hw_en_paused_paused_int_12_connectivity);
    reg_if_hw_out_paused_paused_int_12_connectivity_assert: assert property(reg_if_hw_out_paused_paused_int_12_connectivity);
    reg_if_hw_in_paused_paused_int_13_connectivity_assert: assert property(reg_if_hw_in_paused_paused_int_13_connectivity);
    reg_if_hw_en_paused_paused_int_13_connectivity_assert: assert property(reg_if_hw_en_paused_paused_int_13_connectivity);
    reg_if_hw_out_paused_paused_int_13_connectivity_assert: assert property(reg_if_hw_out_paused_paused_int_13_connectivity);
    reg_if_hw_in_paused_paused_int_14_connectivity_assert: assert property(reg_if_hw_in_paused_paused_int_14_connectivity);
    reg_if_hw_en_paused_paused_int_14_connectivity_assert: assert property(reg_if_hw_en_paused_paused_int_14_connectivity);
    reg_if_hw_out_paused_paused_int_14_connectivity_assert: assert property(reg_if_hw_out_paused_paused_int_14_connectivity);
    reg_if_hw_in_paused_paused_int_15_connectivity_assert: assert property(reg_if_hw_in_paused_paused_int_15_connectivity);
    reg_if_hw_en_paused_paused_int_15_connectivity_assert: assert property(reg_if_hw_en_paused_paused_int_15_connectivity);
    reg_if_hw_out_paused_paused_int_15_connectivity_assert: assert property(reg_if_hw_out_paused_paused_int_15_connectivity);
    reg_if_hw_in_paused_paused_int_16_connectivity_assert: assert property(reg_if_hw_in_paused_paused_int_16_connectivity);
    reg_if_hw_en_paused_paused_int_16_connectivity_assert: assert property(reg_if_hw_en_paused_paused_int_16_connectivity);
    reg_if_hw_out_paused_paused_int_16_connectivity_assert: assert property(reg_if_hw_out_paused_paused_int_16_connectivity);
    reg_if_hw_in_paused_paused_int_17_connectivity_assert: assert property(reg_if_hw_in_paused_paused_int_17_connectivity);
    reg_if_hw_en_paused_paused_int_17_connectivity_assert: assert property(reg_if_hw_en_paused_paused_int_17_connectivity);
    reg_if_hw_out_paused_paused_int_17_connectivity_assert: assert property(reg_if_hw_out_paused_paused_int_17_connectivity);
    reg_if_hw_in_paused_paused_int_18_connectivity_assert: assert property(reg_if_hw_in_paused_paused_int_18_connectivity);
    reg_if_hw_en_paused_paused_int_18_connectivity_assert: assert property(reg_if_hw_en_paused_paused_int_18_connectivity);
    reg_if_hw_out_paused_paused_int_18_connectivity_assert: assert property(reg_if_hw_out_paused_paused_int_18_connectivity);
    reg_if_hw_in_paused_paused_int_19_connectivity_assert: assert property(reg_if_hw_in_paused_paused_int_19_connectivity);
    reg_if_hw_en_paused_paused_int_19_connectivity_assert: assert property(reg_if_hw_en_paused_paused_int_19_connectivity);
    reg_if_hw_out_paused_paused_int_19_connectivity_assert: assert property(reg_if_hw_out_paused_paused_int_19_connectivity);
    reg_if_hw_in_paused_paused_int_20_connectivity_assert: assert property(reg_if_hw_in_paused_paused_int_20_connectivity);
    reg_if_hw_en_paused_paused_int_20_connectivity_assert: assert property(reg_if_hw_en_paused_paused_int_20_connectivity);
    reg_if_hw_out_paused_paused_int_20_connectivity_assert: assert property(reg_if_hw_out_paused_paused_int_20_connectivity);
    reg_if_hw_in_paused_paused_int_21_connectivity_assert: assert property(reg_if_hw_in_paused_paused_int_21_connectivity);
    reg_if_hw_en_paused_paused_int_21_connectivity_assert: assert property(reg_if_hw_en_paused_paused_int_21_connectivity);
    reg_if_hw_out_paused_paused_int_21_connectivity_assert: assert property(reg_if_hw_out_paused_paused_int_21_connectivity);
    reg_if_hw_in_paused_paused_int_22_connectivity_assert: assert property(reg_if_hw_in_paused_paused_int_22_connectivity);
    reg_if_hw_en_paused_paused_int_22_connectivity_assert: assert property(reg_if_hw_en_paused_paused_int_22_connectivity);
    reg_if_hw_out_paused_paused_int_22_connectivity_assert: assert property(reg_if_hw_out_paused_paused_int_22_connectivity);
    reg_if_hw_in_paused_paused_int_23_connectivity_assert: assert property(reg_if_hw_in_paused_paused_int_23_connectivity);
    reg_if_hw_en_paused_paused_int_23_connectivity_assert: assert property(reg_if_hw_en_paused_paused_int_23_connectivity);
    reg_if_hw_out_paused_paused_int_23_connectivity_assert: assert property(reg_if_hw_out_paused_paused_int_23_connectivity);
    reg_if_hw_in_paused_paused_int_24_connectivity_assert: assert property(reg_if_hw_in_paused_paused_int_24_connectivity);
    reg_if_hw_en_paused_paused_int_24_connectivity_assert: assert property(reg_if_hw_en_paused_paused_int_24_connectivity);
    reg_if_hw_out_paused_paused_int_24_connectivity_assert: assert property(reg_if_hw_out_paused_paused_int_24_connectivity);
    reg_if_hw_in_paused_paused_int_25_connectivity_assert: assert property(reg_if_hw_in_paused_paused_int_25_connectivity);
    reg_if_hw_en_paused_paused_int_25_connectivity_assert: assert property(reg_if_hw_en_paused_paused_int_25_connectivity);
    reg_if_hw_out_paused_paused_int_25_connectivity_assert: assert property(reg_if_hw_out_paused_paused_int_25_connectivity);
    reg_if_hw_in_paused_paused_int_26_connectivity_assert: assert property(reg_if_hw_in_paused_paused_int_26_connectivity);
    reg_if_hw_en_paused_paused_int_26_connectivity_assert: assert property(reg_if_hw_en_paused_paused_int_26_connectivity);
    reg_if_hw_out_paused_paused_int_26_connectivity_assert: assert property(reg_if_hw_out_paused_paused_int_26_connectivity);
    reg_if_hw_in_paused_paused_int_27_connectivity_assert: assert property(reg_if_hw_in_paused_paused_int_27_connectivity);
    reg_if_hw_en_paused_paused_int_27_connectivity_assert: assert property(reg_if_hw_en_paused_paused_int_27_connectivity);
    reg_if_hw_out_paused_paused_int_27_connectivity_assert: assert property(reg_if_hw_out_paused_paused_int_27_connectivity);
    reg_if_hw_in_paused_paused_int_28_connectivity_assert: assert property(reg_if_hw_in_paused_paused_int_28_connectivity);
    reg_if_hw_en_paused_paused_int_28_connectivity_assert: assert property(reg_if_hw_en_paused_paused_int_28_connectivity);
    reg_if_hw_out_paused_paused_int_28_connectivity_assert: assert property(reg_if_hw_out_paused_paused_int_28_connectivity);
    reg_if_hw_in_paused_paused_int_29_connectivity_assert: assert property(reg_if_hw_in_paused_paused_int_29_connectivity);
    reg_if_hw_en_paused_paused_int_29_connectivity_assert: assert property(reg_if_hw_en_paused_paused_int_29_connectivity);
    reg_if_hw_out_paused_paused_int_29_connectivity_assert: assert property(reg_if_hw_out_paused_paused_int_29_connectivity);
    reg_if_hw_in_paused_paused_int_30_connectivity_assert: assert property(reg_if_hw_in_paused_paused_int_30_connectivity);
    reg_if_hw_en_paused_paused_int_30_connectivity_assert: assert property(reg_if_hw_en_paused_paused_int_30_connectivity);
    reg_if_hw_out_paused_paused_int_30_connectivity_assert: assert property(reg_if_hw_out_paused_paused_int_30_connectivity);
    reg_if_hw_in_paused_paused_int_31_connectivity_assert: assert property(reg_if_hw_in_paused_paused_int_31_connectivity);
    reg_if_hw_en_paused_paused_int_31_connectivity_assert: assert property(reg_if_hw_en_paused_paused_int_31_connectivity);
    reg_if_hw_out_paused_paused_int_31_connectivity_assert: assert property(reg_if_hw_out_paused_paused_int_31_connectivity);
    reg_if_hw_in_paused_1_paused_NMI_connectivity_assert: assert property(reg_if_hw_in_paused_1_paused_NMI_connectivity);
    reg_if_hw_en_paused_1_paused_NMI_connectivity_assert: assert property(reg_if_hw_en_paused_1_paused_NMI_connectivity);
    reg_if_hw_out_paused_1_paused_NMI_connectivity_assert: assert property(reg_if_hw_out_paused_1_paused_NMI_connectivity);
    reg_if_hw_out_group_priority_group_priority_Group1_connectivity_assert: assert property(reg_if_hw_out_group_priority_group_priority_Group1_connectivity);
    reg_if_hw_out_group_priority_group_priority_Group2_connectivity_assert: assert property(reg_if_hw_out_group_priority_group_priority_Group2_connectivity);
    reg_if_hw_out_group_priority_group_priority_Group3_connectivity_assert: assert property(reg_if_hw_out_group_priority_group_priority_Group3_connectivity);
    reg_if_hw_out_group_priority_group_priority_Group4_connectivity_assert: assert property(reg_if_hw_out_group_priority_group_priority_Group4_connectivity);
    reg_if_hw_out_int_0_addr_addr_int_0_connectivity_assert: assert property(reg_if_hw_out_int_0_addr_addr_int_0_connectivity);
    reg_if_hw_out_int_1_addr_addr_int_1_connectivity_assert: assert property(reg_if_hw_out_int_1_addr_addr_int_1_connectivity);
    reg_if_hw_out_int_2_addr_addr_int_2_connectivity_assert: assert property(reg_if_hw_out_int_2_addr_addr_int_2_connectivity);
    reg_if_hw_out_int_3_addr_addr_int_3_connectivity_assert: assert property(reg_if_hw_out_int_3_addr_addr_int_3_connectivity);
    reg_if_hw_out_int_4_addr_addr_int_4_connectivity_assert: assert property(reg_if_hw_out_int_4_addr_addr_int_4_connectivity);
    reg_if_hw_out_int_5_addr_addr_int_5_connectivity_assert: assert property(reg_if_hw_out_int_5_addr_addr_int_5_connectivity);
    reg_if_hw_out_int_6_addr_addr_int_6_connectivity_assert: assert property(reg_if_hw_out_int_6_addr_addr_int_6_connectivity);
    reg_if_hw_out_int_7_addr_addr_int_7_connectivity_assert: assert property(reg_if_hw_out_int_7_addr_addr_int_7_connectivity);
    reg_if_hw_out_int_8_addr_addr_int_8_connectivity_assert: assert property(reg_if_hw_out_int_8_addr_addr_int_8_connectivity);
    reg_if_hw_out_int_9_addr_addr_int_9_connectivity_assert: assert property(reg_if_hw_out_int_9_addr_addr_int_9_connectivity);
    reg_if_hw_out_int_10_addr_addr_int_10_connectivity_assert: assert property(reg_if_hw_out_int_10_addr_addr_int_10_connectivity);
    reg_if_hw_out_int_11_addr_addr_int_11_connectivity_assert: assert property(reg_if_hw_out_int_11_addr_addr_int_11_connectivity);
    reg_if_hw_out_int_12_addr_addr_int_12_connectivity_assert: assert property(reg_if_hw_out_int_12_addr_addr_int_12_connectivity);
    reg_if_hw_out_int_13_addr_addr_int_13_connectivity_assert: assert property(reg_if_hw_out_int_13_addr_addr_int_13_connectivity);
    reg_if_hw_out_int_14_addr_addr_int_14_connectivity_assert: assert property(reg_if_hw_out_int_14_addr_addr_int_14_connectivity);
    reg_if_hw_out_int_15_addr_addr_int_15_connectivity_assert: assert property(reg_if_hw_out_int_15_addr_addr_int_15_connectivity);
    reg_if_hw_out_int_16_addr_addr_int_16_connectivity_assert: assert property(reg_if_hw_out_int_16_addr_addr_int_16_connectivity);
    reg_if_hw_out_int_17_addr_addr_int_17_connectivity_assert: assert property(reg_if_hw_out_int_17_addr_addr_int_17_connectivity);
    reg_if_hw_out_int_18_addr_addr_int_18_connectivity_assert: assert property(reg_if_hw_out_int_18_addr_addr_int_18_connectivity);
    reg_if_hw_out_int_19_addr_addr_int_19_connectivity_assert: assert property(reg_if_hw_out_int_19_addr_addr_int_19_connectivity);
    reg_if_hw_out_int_20_addr_addr_int_20_connectivity_assert: assert property(reg_if_hw_out_int_20_addr_addr_int_20_connectivity);
    reg_if_hw_out_int_21_addr_addr_int_21_connectivity_assert: assert property(reg_if_hw_out_int_21_addr_addr_int_21_connectivity);
    reg_if_hw_out_int_22_addr_addr_int_22_connectivity_assert: assert property(reg_if_hw_out_int_22_addr_addr_int_22_connectivity);
    reg_if_hw_out_int_23_addr_addr_int_23_connectivity_assert: assert property(reg_if_hw_out_int_23_addr_addr_int_23_connectivity);
    reg_if_hw_out_int_24_addr_addr_int_24_connectivity_assert: assert property(reg_if_hw_out_int_24_addr_addr_int_24_connectivity);
    reg_if_hw_out_int_25_addr_addr_int_25_connectivity_assert: assert property(reg_if_hw_out_int_25_addr_addr_int_25_connectivity);
    reg_if_hw_out_int_26_addr_addr_int_26_connectivity_assert: assert property(reg_if_hw_out_int_26_addr_addr_int_26_connectivity);
    reg_if_hw_out_int_27_addr_addr_int_27_connectivity_assert: assert property(reg_if_hw_out_int_27_addr_addr_int_27_connectivity);
    reg_if_hw_out_int_28_addr_addr_int_28_connectivity_assert: assert property(reg_if_hw_out_int_28_addr_addr_int_28_connectivity);
    reg_if_hw_out_int_29_addr_addr_int_29_connectivity_assert: assert property(reg_if_hw_out_int_29_addr_addr_int_29_connectivity);
    reg_if_hw_out_int_30_addr_addr_int_30_connectivity_assert: assert property(reg_if_hw_out_int_30_addr_addr_int_30_connectivity);
    reg_if_hw_out_int_31_addr_addr_int_31_connectivity_assert: assert property(reg_if_hw_out_int_31_addr_addr_int_31_connectivity);
    reg_if_hw_out_NMI_addr_addr_NMI_connectivity_assert: assert property(reg_if_hw_out_NMI_addr_addr_NMI_connectivity);
    regif_top_ahb_haddr_connectivity_assert: assert property(regif_top_ahb_haddr_connectivity);
    regif_top_ahb_hwdata_connectivity_assert: assert property(regif_top_ahb_hwdata_connectivity);
    regif_top_ahb_hburst_connectivity_assert: assert property(regif_top_ahb_hburst_connectivity);
    regif_top_ahb_hmastlock_connectivity_assert: assert property(regif_top_ahb_hmastlock_connectivity);
    regif_top_ahb_hprot_connectivity_assert: assert property(regif_top_ahb_hprot_connectivity);
    regif_top_ahb_hsize_connectivity_assert: assert property(regif_top_ahb_hsize_connectivity);
    regif_top_ahb_htrans_connectivity_assert: assert property(regif_top_ahb_htrans_connectivity);
    regif_top_ahb_hwrite_connectivity_assert: assert property(regif_top_ahb_hwrite_connectivity);
    regif_top_ahb_hsel_connectivity_assert: assert property(regif_top_ahb_hsel_connectivity);
    regif_top_ahb_hready_connectivity_assert: assert property(regif_top_ahb_hready_connectivity);
    regif_top_ahb_hrdata_connectivity_assert: assert property(regif_top_ahb_hrdata_connectivity);
    regif_top_ahb_hreadyout_connectivity_assert: assert property(regif_top_ahb_hreadyout_connectivity);
    regif_top_ahb_hresp_connectivity_assert: assert property(regif_top_ahb_hresp_connectivity);
    regif_peripheral_hw_out_enable_enable_int_0_connectivity_assert: assert property(regif_peripheral_hw_out_enable_enable_int_0_connectivity);
    regif_peripheral_hw_out_enable_enable_int_1_connectivity_assert: assert property(regif_peripheral_hw_out_enable_enable_int_1_connectivity);
    regif_peripheral_hw_out_enable_enable_int_2_connectivity_assert: assert property(regif_peripheral_hw_out_enable_enable_int_2_connectivity);
    regif_peripheral_hw_out_enable_enable_int_3_connectivity_assert: assert property(regif_peripheral_hw_out_enable_enable_int_3_connectivity);
    regif_peripheral_hw_out_enable_enable_int_4_connectivity_assert: assert property(regif_peripheral_hw_out_enable_enable_int_4_connectivity);
    regif_peripheral_hw_out_enable_enable_int_5_connectivity_assert: assert property(regif_peripheral_hw_out_enable_enable_int_5_connectivity);
    regif_peripheral_hw_out_enable_enable_int_6_connectivity_assert: assert property(regif_peripheral_hw_out_enable_enable_int_6_connectivity);
    regif_peripheral_hw_out_enable_enable_int_7_connectivity_assert: assert property(regif_peripheral_hw_out_enable_enable_int_7_connectivity);
    regif_peripheral_hw_out_enable_enable_int_8_connectivity_assert: assert property(regif_peripheral_hw_out_enable_enable_int_8_connectivity);
    regif_peripheral_hw_out_enable_enable_int_9_connectivity_assert: assert property(regif_peripheral_hw_out_enable_enable_int_9_connectivity);
    regif_peripheral_hw_out_enable_enable_int_10_connectivity_assert: assert property(regif_peripheral_hw_out_enable_enable_int_10_connectivity);
    regif_peripheral_hw_out_enable_enable_int_11_connectivity_assert: assert property(regif_peripheral_hw_out_enable_enable_int_11_connectivity);
    regif_peripheral_hw_out_enable_enable_int_12_connectivity_assert: assert property(regif_peripheral_hw_out_enable_enable_int_12_connectivity);
    regif_peripheral_hw_out_enable_enable_int_13_connectivity_assert: assert property(regif_peripheral_hw_out_enable_enable_int_13_connectivity);
    regif_peripheral_hw_out_enable_enable_int_14_connectivity_assert: assert property(regif_peripheral_hw_out_enable_enable_int_14_connectivity);
    regif_peripheral_hw_out_enable_enable_int_15_connectivity_assert: assert property(regif_peripheral_hw_out_enable_enable_int_15_connectivity);
    regif_peripheral_hw_out_enable_enable_int_16_connectivity_assert: assert property(regif_peripheral_hw_out_enable_enable_int_16_connectivity);
    regif_peripheral_hw_out_enable_enable_int_17_connectivity_assert: assert property(regif_peripheral_hw_out_enable_enable_int_17_connectivity);
    regif_peripheral_hw_out_enable_enable_int_18_connectivity_assert: assert property(regif_peripheral_hw_out_enable_enable_int_18_connectivity);
    regif_peripheral_hw_out_enable_enable_int_19_connectivity_assert: assert property(regif_peripheral_hw_out_enable_enable_int_19_connectivity);
    regif_peripheral_hw_out_enable_enable_int_20_connectivity_assert: assert property(regif_peripheral_hw_out_enable_enable_int_20_connectivity);
    regif_peripheral_hw_out_enable_enable_int_21_connectivity_assert: assert property(regif_peripheral_hw_out_enable_enable_int_21_connectivity);
    regif_peripheral_hw_out_enable_enable_int_22_connectivity_assert: assert property(regif_peripheral_hw_out_enable_enable_int_22_connectivity);
    regif_peripheral_hw_out_enable_enable_int_23_connectivity_assert: assert property(regif_peripheral_hw_out_enable_enable_int_23_connectivity);
    regif_peripheral_hw_out_enable_enable_int_24_connectivity_assert: assert property(regif_peripheral_hw_out_enable_enable_int_24_connectivity);
    regif_peripheral_hw_out_enable_enable_int_25_connectivity_assert: assert property(regif_peripheral_hw_out_enable_enable_int_25_connectivity);
    regif_peripheral_hw_out_enable_enable_int_26_connectivity_assert: assert property(regif_peripheral_hw_out_enable_enable_int_26_connectivity);
    regif_peripheral_hw_out_enable_enable_int_27_connectivity_assert: assert property(regif_peripheral_hw_out_enable_enable_int_27_connectivity);
    regif_peripheral_hw_out_enable_enable_int_28_connectivity_assert: assert property(regif_peripheral_hw_out_enable_enable_int_28_connectivity);
    regif_peripheral_hw_out_enable_enable_int_29_connectivity_assert: assert property(regif_peripheral_hw_out_enable_enable_int_29_connectivity);
    regif_peripheral_hw_out_enable_enable_int_30_connectivity_assert: assert property(regif_peripheral_hw_out_enable_enable_int_30_connectivity);
    regif_peripheral_hw_out_enable_enable_int_31_connectivity_assert: assert property(regif_peripheral_hw_out_enable_enable_int_31_connectivity);
    regif_peripheral_hw_out_unmask_unmask_int_0_connectivity_assert: assert property(regif_peripheral_hw_out_unmask_unmask_int_0_connectivity);
    regif_peripheral_hw_out_unmask_unmask_int_1_connectivity_assert: assert property(regif_peripheral_hw_out_unmask_unmask_int_1_connectivity);
    regif_peripheral_hw_out_unmask_unmask_int_2_connectivity_assert: assert property(regif_peripheral_hw_out_unmask_unmask_int_2_connectivity);
    regif_peripheral_hw_out_unmask_unmask_int_3_connectivity_assert: assert property(regif_peripheral_hw_out_unmask_unmask_int_3_connectivity);
    regif_peripheral_hw_out_unmask_unmask_int_4_connectivity_assert: assert property(regif_peripheral_hw_out_unmask_unmask_int_4_connectivity);
    regif_peripheral_hw_out_unmask_unmask_int_5_connectivity_assert: assert property(regif_peripheral_hw_out_unmask_unmask_int_5_connectivity);
    regif_peripheral_hw_out_unmask_unmask_int_6_connectivity_assert: assert property(regif_peripheral_hw_out_unmask_unmask_int_6_connectivity);
    regif_peripheral_hw_out_unmask_unmask_int_7_connectivity_assert: assert property(regif_peripheral_hw_out_unmask_unmask_int_7_connectivity);
    regif_peripheral_hw_out_unmask_unmask_int_8_connectivity_assert: assert property(regif_peripheral_hw_out_unmask_unmask_int_8_connectivity);
    regif_peripheral_hw_out_unmask_unmask_int_9_connectivity_assert: assert property(regif_peripheral_hw_out_unmask_unmask_int_9_connectivity);
    regif_peripheral_hw_out_unmask_unmask_int_10_connectivity_assert: assert property(regif_peripheral_hw_out_unmask_unmask_int_10_connectivity);
    regif_peripheral_hw_out_unmask_unmask_int_11_connectivity_assert: assert property(regif_peripheral_hw_out_unmask_unmask_int_11_connectivity);
    regif_peripheral_hw_out_unmask_unmask_int_12_connectivity_assert: assert property(regif_peripheral_hw_out_unmask_unmask_int_12_connectivity);
    regif_peripheral_hw_out_unmask_unmask_int_13_connectivity_assert: assert property(regif_peripheral_hw_out_unmask_unmask_int_13_connectivity);
    regif_peripheral_hw_out_unmask_unmask_int_14_connectivity_assert: assert property(regif_peripheral_hw_out_unmask_unmask_int_14_connectivity);
    regif_peripheral_hw_out_unmask_unmask_int_15_connectivity_assert: assert property(regif_peripheral_hw_out_unmask_unmask_int_15_connectivity);
    regif_peripheral_hw_out_unmask_unmask_int_16_connectivity_assert: assert property(regif_peripheral_hw_out_unmask_unmask_int_16_connectivity);
    regif_peripheral_hw_out_unmask_unmask_int_17_connectivity_assert: assert property(regif_peripheral_hw_out_unmask_unmask_int_17_connectivity);
    regif_peripheral_hw_out_unmask_unmask_int_18_connectivity_assert: assert property(regif_peripheral_hw_out_unmask_unmask_int_18_connectivity);
    regif_peripheral_hw_out_unmask_unmask_int_19_connectivity_assert: assert property(regif_peripheral_hw_out_unmask_unmask_int_19_connectivity);
    regif_peripheral_hw_out_unmask_unmask_int_20_connectivity_assert: assert property(regif_peripheral_hw_out_unmask_unmask_int_20_connectivity);
    regif_peripheral_hw_out_unmask_unmask_int_21_connectivity_assert: assert property(regif_peripheral_hw_out_unmask_unmask_int_21_connectivity);
    regif_peripheral_hw_out_unmask_unmask_int_22_connectivity_assert: assert property(regif_peripheral_hw_out_unmask_unmask_int_22_connectivity);
    regif_peripheral_hw_out_unmask_unmask_int_23_connectivity_assert: assert property(regif_peripheral_hw_out_unmask_unmask_int_23_connectivity);
    regif_peripheral_hw_out_unmask_unmask_int_24_connectivity_assert: assert property(regif_peripheral_hw_out_unmask_unmask_int_24_connectivity);
    regif_peripheral_hw_out_unmask_unmask_int_25_connectivity_assert: assert property(regif_peripheral_hw_out_unmask_unmask_int_25_connectivity);
    regif_peripheral_hw_out_unmask_unmask_int_26_connectivity_assert: assert property(regif_peripheral_hw_out_unmask_unmask_int_26_connectivity);
    regif_peripheral_hw_out_unmask_unmask_int_27_connectivity_assert: assert property(regif_peripheral_hw_out_unmask_unmask_int_27_connectivity);
    regif_peripheral_hw_out_unmask_unmask_int_28_connectivity_assert: assert property(regif_peripheral_hw_out_unmask_unmask_int_28_connectivity);
    regif_peripheral_hw_out_unmask_unmask_int_29_connectivity_assert: assert property(regif_peripheral_hw_out_unmask_unmask_int_29_connectivity);
    regif_peripheral_hw_out_unmask_unmask_int_30_connectivity_assert: assert property(regif_peripheral_hw_out_unmask_unmask_int_30_connectivity);
    regif_peripheral_hw_out_unmask_unmask_int_31_connectivity_assert: assert property(regif_peripheral_hw_out_unmask_unmask_int_31_connectivity);
    regif_peripheral_hw_in_pending_pending_int_0_connectivity_assert: assert property(regif_peripheral_hw_in_pending_pending_int_0_connectivity);
    regif_peripheral_hw_en_pending_pending_int_0_connectivity_assert: assert property(regif_peripheral_hw_en_pending_pending_int_0_connectivity);
    regif_peripheral_hw_out_pending_pending_int_0_connectivity_assert: assert property(regif_peripheral_hw_out_pending_pending_int_0_connectivity);
    regif_peripheral_hw_in_pending_pending_int_1_connectivity_assert: assert property(regif_peripheral_hw_in_pending_pending_int_1_connectivity);
    regif_peripheral_hw_en_pending_pending_int_1_connectivity_assert: assert property(regif_peripheral_hw_en_pending_pending_int_1_connectivity);
    regif_peripheral_hw_out_pending_pending_int_1_connectivity_assert: assert property(regif_peripheral_hw_out_pending_pending_int_1_connectivity);
    regif_peripheral_hw_in_pending_pending_int_2_connectivity_assert: assert property(regif_peripheral_hw_in_pending_pending_int_2_connectivity);
    regif_peripheral_hw_en_pending_pending_int_2_connectivity_assert: assert property(regif_peripheral_hw_en_pending_pending_int_2_connectivity);
    regif_peripheral_hw_out_pending_pending_int_2_connectivity_assert: assert property(regif_peripheral_hw_out_pending_pending_int_2_connectivity);
    regif_peripheral_hw_in_pending_pending_int_3_connectivity_assert: assert property(regif_peripheral_hw_in_pending_pending_int_3_connectivity);
    regif_peripheral_hw_en_pending_pending_int_3_connectivity_assert: assert property(regif_peripheral_hw_en_pending_pending_int_3_connectivity);
    regif_peripheral_hw_out_pending_pending_int_3_connectivity_assert: assert property(regif_peripheral_hw_out_pending_pending_int_3_connectivity);
    regif_peripheral_hw_in_pending_pending_int_4_connectivity_assert: assert property(regif_peripheral_hw_in_pending_pending_int_4_connectivity);
    regif_peripheral_hw_en_pending_pending_int_4_connectivity_assert: assert property(regif_peripheral_hw_en_pending_pending_int_4_connectivity);
    regif_peripheral_hw_out_pending_pending_int_4_connectivity_assert: assert property(regif_peripheral_hw_out_pending_pending_int_4_connectivity);
    regif_peripheral_hw_in_pending_pending_int_5_connectivity_assert: assert property(regif_peripheral_hw_in_pending_pending_int_5_connectivity);
    regif_peripheral_hw_en_pending_pending_int_5_connectivity_assert: assert property(regif_peripheral_hw_en_pending_pending_int_5_connectivity);
    regif_peripheral_hw_out_pending_pending_int_5_connectivity_assert: assert property(regif_peripheral_hw_out_pending_pending_int_5_connectivity);
    regif_peripheral_hw_in_pending_pending_int_6_connectivity_assert: assert property(regif_peripheral_hw_in_pending_pending_int_6_connectivity);
    regif_peripheral_hw_en_pending_pending_int_6_connectivity_assert: assert property(regif_peripheral_hw_en_pending_pending_int_6_connectivity);
    regif_peripheral_hw_out_pending_pending_int_6_connectivity_assert: assert property(regif_peripheral_hw_out_pending_pending_int_6_connectivity);
    regif_peripheral_hw_in_pending_pending_int_7_connectivity_assert: assert property(regif_peripheral_hw_in_pending_pending_int_7_connectivity);
    regif_peripheral_hw_en_pending_pending_int_7_connectivity_assert: assert property(regif_peripheral_hw_en_pending_pending_int_7_connectivity);
    regif_peripheral_hw_out_pending_pending_int_7_connectivity_assert: assert property(regif_peripheral_hw_out_pending_pending_int_7_connectivity);
    regif_peripheral_hw_in_pending_pending_int_8_connectivity_assert: assert property(regif_peripheral_hw_in_pending_pending_int_8_connectivity);
    regif_peripheral_hw_en_pending_pending_int_8_connectivity_assert: assert property(regif_peripheral_hw_en_pending_pending_int_8_connectivity);
    regif_peripheral_hw_out_pending_pending_int_8_connectivity_assert: assert property(regif_peripheral_hw_out_pending_pending_int_8_connectivity);
    regif_peripheral_hw_in_pending_pending_int_9_connectivity_assert: assert property(regif_peripheral_hw_in_pending_pending_int_9_connectivity);
    regif_peripheral_hw_en_pending_pending_int_9_connectivity_assert: assert property(regif_peripheral_hw_en_pending_pending_int_9_connectivity);
    regif_peripheral_hw_out_pending_pending_int_9_connectivity_assert: assert property(regif_peripheral_hw_out_pending_pending_int_9_connectivity);
    regif_peripheral_hw_in_pending_pending_int_10_connectivity_assert: assert property(regif_peripheral_hw_in_pending_pending_int_10_connectivity);
    regif_peripheral_hw_en_pending_pending_int_10_connectivity_assert: assert property(regif_peripheral_hw_en_pending_pending_int_10_connectivity);
    regif_peripheral_hw_out_pending_pending_int_10_connectivity_assert: assert property(regif_peripheral_hw_out_pending_pending_int_10_connectivity);
    regif_peripheral_hw_in_pending_pending_int_11_connectivity_assert: assert property(regif_peripheral_hw_in_pending_pending_int_11_connectivity);
    regif_peripheral_hw_en_pending_pending_int_11_connectivity_assert: assert property(regif_peripheral_hw_en_pending_pending_int_11_connectivity);
    regif_peripheral_hw_out_pending_pending_int_11_connectivity_assert: assert property(regif_peripheral_hw_out_pending_pending_int_11_connectivity);
    regif_peripheral_hw_in_pending_pending_int_12_connectivity_assert: assert property(regif_peripheral_hw_in_pending_pending_int_12_connectivity);
    regif_peripheral_hw_en_pending_pending_int_12_connectivity_assert: assert property(regif_peripheral_hw_en_pending_pending_int_12_connectivity);
    regif_peripheral_hw_out_pending_pending_int_12_connectivity_assert: assert property(regif_peripheral_hw_out_pending_pending_int_12_connectivity);
    regif_peripheral_hw_in_pending_pending_int_13_connectivity_assert: assert property(regif_peripheral_hw_in_pending_pending_int_13_connectivity);
    regif_peripheral_hw_en_pending_pending_int_13_connectivity_assert: assert property(regif_peripheral_hw_en_pending_pending_int_13_connectivity);
    regif_peripheral_hw_out_pending_pending_int_13_connectivity_assert: assert property(regif_peripheral_hw_out_pending_pending_int_13_connectivity);
    regif_peripheral_hw_in_pending_pending_int_14_connectivity_assert: assert property(regif_peripheral_hw_in_pending_pending_int_14_connectivity);
    regif_peripheral_hw_en_pending_pending_int_14_connectivity_assert: assert property(regif_peripheral_hw_en_pending_pending_int_14_connectivity);
    regif_peripheral_hw_out_pending_pending_int_14_connectivity_assert: assert property(regif_peripheral_hw_out_pending_pending_int_14_connectivity);
    regif_peripheral_hw_in_pending_pending_int_15_connectivity_assert: assert property(regif_peripheral_hw_in_pending_pending_int_15_connectivity);
    regif_peripheral_hw_en_pending_pending_int_15_connectivity_assert: assert property(regif_peripheral_hw_en_pending_pending_int_15_connectivity);
    regif_peripheral_hw_out_pending_pending_int_15_connectivity_assert: assert property(regif_peripheral_hw_out_pending_pending_int_15_connectivity);
    regif_peripheral_hw_in_pending_pending_int_16_connectivity_assert: assert property(regif_peripheral_hw_in_pending_pending_int_16_connectivity);
    regif_peripheral_hw_en_pending_pending_int_16_connectivity_assert: assert property(regif_peripheral_hw_en_pending_pending_int_16_connectivity);
    regif_peripheral_hw_out_pending_pending_int_16_connectivity_assert: assert property(regif_peripheral_hw_out_pending_pending_int_16_connectivity);
    regif_peripheral_hw_in_pending_pending_int_17_connectivity_assert: assert property(regif_peripheral_hw_in_pending_pending_int_17_connectivity);
    regif_peripheral_hw_en_pending_pending_int_17_connectivity_assert: assert property(regif_peripheral_hw_en_pending_pending_int_17_connectivity);
    regif_peripheral_hw_out_pending_pending_int_17_connectivity_assert: assert property(regif_peripheral_hw_out_pending_pending_int_17_connectivity);
    regif_peripheral_hw_in_pending_pending_int_18_connectivity_assert: assert property(regif_peripheral_hw_in_pending_pending_int_18_connectivity);
    regif_peripheral_hw_en_pending_pending_int_18_connectivity_assert: assert property(regif_peripheral_hw_en_pending_pending_int_18_connectivity);
    regif_peripheral_hw_out_pending_pending_int_18_connectivity_assert: assert property(regif_peripheral_hw_out_pending_pending_int_18_connectivity);
    regif_peripheral_hw_in_pending_pending_int_19_connectivity_assert: assert property(regif_peripheral_hw_in_pending_pending_int_19_connectivity);
    regif_peripheral_hw_en_pending_pending_int_19_connectivity_assert: assert property(regif_peripheral_hw_en_pending_pending_int_19_connectivity);
    regif_peripheral_hw_out_pending_pending_int_19_connectivity_assert: assert property(regif_peripheral_hw_out_pending_pending_int_19_connectivity);
    regif_peripheral_hw_in_pending_pending_int_20_connectivity_assert: assert property(regif_peripheral_hw_in_pending_pending_int_20_connectivity);
    regif_peripheral_hw_en_pending_pending_int_20_connectivity_assert: assert property(regif_peripheral_hw_en_pending_pending_int_20_connectivity);
    regif_peripheral_hw_out_pending_pending_int_20_connectivity_assert: assert property(regif_peripheral_hw_out_pending_pending_int_20_connectivity);
    regif_peripheral_hw_in_pending_pending_int_21_connectivity_assert: assert property(regif_peripheral_hw_in_pending_pending_int_21_connectivity);
    regif_peripheral_hw_en_pending_pending_int_21_connectivity_assert: assert property(regif_peripheral_hw_en_pending_pending_int_21_connectivity);
    regif_peripheral_hw_out_pending_pending_int_21_connectivity_assert: assert property(regif_peripheral_hw_out_pending_pending_int_21_connectivity);
    regif_peripheral_hw_in_pending_pending_int_22_connectivity_assert: assert property(regif_peripheral_hw_in_pending_pending_int_22_connectivity);
    regif_peripheral_hw_en_pending_pending_int_22_connectivity_assert: assert property(regif_peripheral_hw_en_pending_pending_int_22_connectivity);
    regif_peripheral_hw_out_pending_pending_int_22_connectivity_assert: assert property(regif_peripheral_hw_out_pending_pending_int_22_connectivity);
    regif_peripheral_hw_in_pending_pending_int_23_connectivity_assert: assert property(regif_peripheral_hw_in_pending_pending_int_23_connectivity);
    regif_peripheral_hw_en_pending_pending_int_23_connectivity_assert: assert property(regif_peripheral_hw_en_pending_pending_int_23_connectivity);
    regif_peripheral_hw_out_pending_pending_int_23_connectivity_assert: assert property(regif_peripheral_hw_out_pending_pending_int_23_connectivity);
    regif_peripheral_hw_in_pending_pending_int_24_connectivity_assert: assert property(regif_peripheral_hw_in_pending_pending_int_24_connectivity);
    regif_peripheral_hw_en_pending_pending_int_24_connectivity_assert: assert property(regif_peripheral_hw_en_pending_pending_int_24_connectivity);
    regif_peripheral_hw_out_pending_pending_int_24_connectivity_assert: assert property(regif_peripheral_hw_out_pending_pending_int_24_connectivity);
    regif_peripheral_hw_in_pending_pending_int_25_connectivity_assert: assert property(regif_peripheral_hw_in_pending_pending_int_25_connectivity);
    regif_peripheral_hw_en_pending_pending_int_25_connectivity_assert: assert property(regif_peripheral_hw_en_pending_pending_int_25_connectivity);
    regif_peripheral_hw_out_pending_pending_int_25_connectivity_assert: assert property(regif_peripheral_hw_out_pending_pending_int_25_connectivity);
    regif_peripheral_hw_in_pending_pending_int_26_connectivity_assert: assert property(regif_peripheral_hw_in_pending_pending_int_26_connectivity);
    regif_peripheral_hw_en_pending_pending_int_26_connectivity_assert: assert property(regif_peripheral_hw_en_pending_pending_int_26_connectivity);
    regif_peripheral_hw_out_pending_pending_int_26_connectivity_assert: assert property(regif_peripheral_hw_out_pending_pending_int_26_connectivity);
    regif_peripheral_hw_in_pending_pending_int_27_connectivity_assert: assert property(regif_peripheral_hw_in_pending_pending_int_27_connectivity);
    regif_peripheral_hw_en_pending_pending_int_27_connectivity_assert: assert property(regif_peripheral_hw_en_pending_pending_int_27_connectivity);
    regif_peripheral_hw_out_pending_pending_int_27_connectivity_assert: assert property(regif_peripheral_hw_out_pending_pending_int_27_connectivity);
    regif_peripheral_hw_in_pending_pending_int_28_connectivity_assert: assert property(regif_peripheral_hw_in_pending_pending_int_28_connectivity);
    regif_peripheral_hw_en_pending_pending_int_28_connectivity_assert: assert property(regif_peripheral_hw_en_pending_pending_int_28_connectivity);
    regif_peripheral_hw_out_pending_pending_int_28_connectivity_assert: assert property(regif_peripheral_hw_out_pending_pending_int_28_connectivity);
    regif_peripheral_hw_in_pending_pending_int_29_connectivity_assert: assert property(regif_peripheral_hw_in_pending_pending_int_29_connectivity);
    regif_peripheral_hw_en_pending_pending_int_29_connectivity_assert: assert property(regif_peripheral_hw_en_pending_pending_int_29_connectivity);
    regif_peripheral_hw_out_pending_pending_int_29_connectivity_assert: assert property(regif_peripheral_hw_out_pending_pending_int_29_connectivity);
    regif_peripheral_hw_in_pending_pending_int_30_connectivity_assert: assert property(regif_peripheral_hw_in_pending_pending_int_30_connectivity);
    regif_peripheral_hw_en_pending_pending_int_30_connectivity_assert: assert property(regif_peripheral_hw_en_pending_pending_int_30_connectivity);
    regif_peripheral_hw_out_pending_pending_int_30_connectivity_assert: assert property(regif_peripheral_hw_out_pending_pending_int_30_connectivity);
    regif_peripheral_hw_in_pending_pending_int_31_connectivity_assert: assert property(regif_peripheral_hw_in_pending_pending_int_31_connectivity);
    regif_peripheral_hw_en_pending_pending_int_31_connectivity_assert: assert property(regif_peripheral_hw_en_pending_pending_int_31_connectivity);
    regif_peripheral_hw_out_pending_pending_int_31_connectivity_assert: assert property(regif_peripheral_hw_out_pending_pending_int_31_connectivity);
    regif_peripheral_hw_in_pending_1_pending_NMI_connectivity_assert: assert property(regif_peripheral_hw_in_pending_1_pending_NMI_connectivity);
    regif_peripheral_hw_en_pending_1_pending_NMI_connectivity_assert: assert property(regif_peripheral_hw_en_pending_1_pending_NMI_connectivity);
    regif_peripheral_hw_out_pending_1_pending_NMI_connectivity_assert: assert property(regif_peripheral_hw_out_pending_1_pending_NMI_connectivity);
    regif_peripheral_hw_in_active_active_int_0_connectivity_assert: assert property(regif_peripheral_hw_in_active_active_int_0_connectivity);
    regif_peripheral_hw_en_active_active_int_0_connectivity_assert: assert property(regif_peripheral_hw_en_active_active_int_0_connectivity);
    regif_peripheral_hw_out_active_active_int_0_connectivity_assert: assert property(regif_peripheral_hw_out_active_active_int_0_connectivity);
    regif_peripheral_hw_in_active_active_int_1_connectivity_assert: assert property(regif_peripheral_hw_in_active_active_int_1_connectivity);
    regif_peripheral_hw_en_active_active_int_1_connectivity_assert: assert property(regif_peripheral_hw_en_active_active_int_1_connectivity);
    regif_peripheral_hw_out_active_active_int_1_connectivity_assert: assert property(regif_peripheral_hw_out_active_active_int_1_connectivity);
    regif_peripheral_hw_in_active_active_int_2_connectivity_assert: assert property(regif_peripheral_hw_in_active_active_int_2_connectivity);
    regif_peripheral_hw_en_active_active_int_2_connectivity_assert: assert property(regif_peripheral_hw_en_active_active_int_2_connectivity);
    regif_peripheral_hw_out_active_active_int_2_connectivity_assert: assert property(regif_peripheral_hw_out_active_active_int_2_connectivity);
    regif_peripheral_hw_in_active_active_int_3_connectivity_assert: assert property(regif_peripheral_hw_in_active_active_int_3_connectivity);
    regif_peripheral_hw_en_active_active_int_3_connectivity_assert: assert property(regif_peripheral_hw_en_active_active_int_3_connectivity);
    regif_peripheral_hw_out_active_active_int_3_connectivity_assert: assert property(regif_peripheral_hw_out_active_active_int_3_connectivity);
    regif_peripheral_hw_in_active_active_int_4_connectivity_assert: assert property(regif_peripheral_hw_in_active_active_int_4_connectivity);
    regif_peripheral_hw_en_active_active_int_4_connectivity_assert: assert property(regif_peripheral_hw_en_active_active_int_4_connectivity);
    regif_peripheral_hw_out_active_active_int_4_connectivity_assert: assert property(regif_peripheral_hw_out_active_active_int_4_connectivity);
    regif_peripheral_hw_in_active_active_int_5_connectivity_assert: assert property(regif_peripheral_hw_in_active_active_int_5_connectivity);
    regif_peripheral_hw_en_active_active_int_5_connectivity_assert: assert property(regif_peripheral_hw_en_active_active_int_5_connectivity);
    regif_peripheral_hw_out_active_active_int_5_connectivity_assert: assert property(regif_peripheral_hw_out_active_active_int_5_connectivity);
    regif_peripheral_hw_in_active_active_int_6_connectivity_assert: assert property(regif_peripheral_hw_in_active_active_int_6_connectivity);
    regif_peripheral_hw_en_active_active_int_6_connectivity_assert: assert property(regif_peripheral_hw_en_active_active_int_6_connectivity);
    regif_peripheral_hw_out_active_active_int_6_connectivity_assert: assert property(regif_peripheral_hw_out_active_active_int_6_connectivity);
    regif_peripheral_hw_in_active_active_int_7_connectivity_assert: assert property(regif_peripheral_hw_in_active_active_int_7_connectivity);
    regif_peripheral_hw_en_active_active_int_7_connectivity_assert: assert property(regif_peripheral_hw_en_active_active_int_7_connectivity);
    regif_peripheral_hw_out_active_active_int_7_connectivity_assert: assert property(regif_peripheral_hw_out_active_active_int_7_connectivity);
    regif_peripheral_hw_in_active_active_int_8_connectivity_assert: assert property(regif_peripheral_hw_in_active_active_int_8_connectivity);
    regif_peripheral_hw_en_active_active_int_8_connectivity_assert: assert property(regif_peripheral_hw_en_active_active_int_8_connectivity);
    regif_peripheral_hw_out_active_active_int_8_connectivity_assert: assert property(regif_peripheral_hw_out_active_active_int_8_connectivity);
    regif_peripheral_hw_in_active_active_int_9_connectivity_assert: assert property(regif_peripheral_hw_in_active_active_int_9_connectivity);
    regif_peripheral_hw_en_active_active_int_9_connectivity_assert: assert property(regif_peripheral_hw_en_active_active_int_9_connectivity);
    regif_peripheral_hw_out_active_active_int_9_connectivity_assert: assert property(regif_peripheral_hw_out_active_active_int_9_connectivity);
    regif_peripheral_hw_in_active_active_int_10_connectivity_assert: assert property(regif_peripheral_hw_in_active_active_int_10_connectivity);
    regif_peripheral_hw_en_active_active_int_10_connectivity_assert: assert property(regif_peripheral_hw_en_active_active_int_10_connectivity);
    regif_peripheral_hw_out_active_active_int_10_connectivity_assert: assert property(regif_peripheral_hw_out_active_active_int_10_connectivity);
    regif_peripheral_hw_in_active_active_int_11_connectivity_assert: assert property(regif_peripheral_hw_in_active_active_int_11_connectivity);
    regif_peripheral_hw_en_active_active_int_11_connectivity_assert: assert property(regif_peripheral_hw_en_active_active_int_11_connectivity);
    regif_peripheral_hw_out_active_active_int_11_connectivity_assert: assert property(regif_peripheral_hw_out_active_active_int_11_connectivity);
    regif_peripheral_hw_in_active_active_int_12_connectivity_assert: assert property(regif_peripheral_hw_in_active_active_int_12_connectivity);
    regif_peripheral_hw_en_active_active_int_12_connectivity_assert: assert property(regif_peripheral_hw_en_active_active_int_12_connectivity);
    regif_peripheral_hw_out_active_active_int_12_connectivity_assert: assert property(regif_peripheral_hw_out_active_active_int_12_connectivity);
    regif_peripheral_hw_in_active_active_int_13_connectivity_assert: assert property(regif_peripheral_hw_in_active_active_int_13_connectivity);
    regif_peripheral_hw_en_active_active_int_13_connectivity_assert: assert property(regif_peripheral_hw_en_active_active_int_13_connectivity);
    regif_peripheral_hw_out_active_active_int_13_connectivity_assert: assert property(regif_peripheral_hw_out_active_active_int_13_connectivity);
    regif_peripheral_hw_in_active_active_int_14_connectivity_assert: assert property(regif_peripheral_hw_in_active_active_int_14_connectivity);
    regif_peripheral_hw_en_active_active_int_14_connectivity_assert: assert property(regif_peripheral_hw_en_active_active_int_14_connectivity);
    regif_peripheral_hw_out_active_active_int_14_connectivity_assert: assert property(regif_peripheral_hw_out_active_active_int_14_connectivity);
    regif_peripheral_hw_in_active_active_int_15_connectivity_assert: assert property(regif_peripheral_hw_in_active_active_int_15_connectivity);
    regif_peripheral_hw_en_active_active_int_15_connectivity_assert: assert property(regif_peripheral_hw_en_active_active_int_15_connectivity);
    regif_peripheral_hw_out_active_active_int_15_connectivity_assert: assert property(regif_peripheral_hw_out_active_active_int_15_connectivity);
    regif_peripheral_hw_in_active_active_int_16_connectivity_assert: assert property(regif_peripheral_hw_in_active_active_int_16_connectivity);
    regif_peripheral_hw_en_active_active_int_16_connectivity_assert: assert property(regif_peripheral_hw_en_active_active_int_16_connectivity);
    regif_peripheral_hw_out_active_active_int_16_connectivity_assert: assert property(regif_peripheral_hw_out_active_active_int_16_connectivity);
    regif_peripheral_hw_in_active_active_int_17_connectivity_assert: assert property(regif_peripheral_hw_in_active_active_int_17_connectivity);
    regif_peripheral_hw_en_active_active_int_17_connectivity_assert: assert property(regif_peripheral_hw_en_active_active_int_17_connectivity);
    regif_peripheral_hw_out_active_active_int_17_connectivity_assert: assert property(regif_peripheral_hw_out_active_active_int_17_connectivity);
    regif_peripheral_hw_in_active_active_int_18_connectivity_assert: assert property(regif_peripheral_hw_in_active_active_int_18_connectivity);
    regif_peripheral_hw_en_active_active_int_18_connectivity_assert: assert property(regif_peripheral_hw_en_active_active_int_18_connectivity);
    regif_peripheral_hw_out_active_active_int_18_connectivity_assert: assert property(regif_peripheral_hw_out_active_active_int_18_connectivity);
    regif_peripheral_hw_in_active_active_int_19_connectivity_assert: assert property(regif_peripheral_hw_in_active_active_int_19_connectivity);
    regif_peripheral_hw_en_active_active_int_19_connectivity_assert: assert property(regif_peripheral_hw_en_active_active_int_19_connectivity);
    regif_peripheral_hw_out_active_active_int_19_connectivity_assert: assert property(regif_peripheral_hw_out_active_active_int_19_connectivity);
    regif_peripheral_hw_in_active_active_int_20_connectivity_assert: assert property(regif_peripheral_hw_in_active_active_int_20_connectivity);
    regif_peripheral_hw_en_active_active_int_20_connectivity_assert: assert property(regif_peripheral_hw_en_active_active_int_20_connectivity);
    regif_peripheral_hw_out_active_active_int_20_connectivity_assert: assert property(regif_peripheral_hw_out_active_active_int_20_connectivity);
    regif_peripheral_hw_in_active_active_int_21_connectivity_assert: assert property(regif_peripheral_hw_in_active_active_int_21_connectivity);
    regif_peripheral_hw_en_active_active_int_21_connectivity_assert: assert property(regif_peripheral_hw_en_active_active_int_21_connectivity);
    regif_peripheral_hw_out_active_active_int_21_connectivity_assert: assert property(regif_peripheral_hw_out_active_active_int_21_connectivity);
    regif_peripheral_hw_in_active_active_int_22_connectivity_assert: assert property(regif_peripheral_hw_in_active_active_int_22_connectivity);
    regif_peripheral_hw_en_active_active_int_22_connectivity_assert: assert property(regif_peripheral_hw_en_active_active_int_22_connectivity);
    regif_peripheral_hw_out_active_active_int_22_connectivity_assert: assert property(regif_peripheral_hw_out_active_active_int_22_connectivity);
    regif_peripheral_hw_in_active_active_int_23_connectivity_assert: assert property(regif_peripheral_hw_in_active_active_int_23_connectivity);
    regif_peripheral_hw_en_active_active_int_23_connectivity_assert: assert property(regif_peripheral_hw_en_active_active_int_23_connectivity);
    regif_peripheral_hw_out_active_active_int_23_connectivity_assert: assert property(regif_peripheral_hw_out_active_active_int_23_connectivity);
    regif_peripheral_hw_in_active_active_int_24_connectivity_assert: assert property(regif_peripheral_hw_in_active_active_int_24_connectivity);
    regif_peripheral_hw_en_active_active_int_24_connectivity_assert: assert property(regif_peripheral_hw_en_active_active_int_24_connectivity);
    regif_peripheral_hw_out_active_active_int_24_connectivity_assert: assert property(regif_peripheral_hw_out_active_active_int_24_connectivity);
    regif_peripheral_hw_in_active_active_int_25_connectivity_assert: assert property(regif_peripheral_hw_in_active_active_int_25_connectivity);
    regif_peripheral_hw_en_active_active_int_25_connectivity_assert: assert property(regif_peripheral_hw_en_active_active_int_25_connectivity);
    regif_peripheral_hw_out_active_active_int_25_connectivity_assert: assert property(regif_peripheral_hw_out_active_active_int_25_connectivity);
    regif_peripheral_hw_in_active_active_int_26_connectivity_assert: assert property(regif_peripheral_hw_in_active_active_int_26_connectivity);
    regif_peripheral_hw_en_active_active_int_26_connectivity_assert: assert property(regif_peripheral_hw_en_active_active_int_26_connectivity);
    regif_peripheral_hw_out_active_active_int_26_connectivity_assert: assert property(regif_peripheral_hw_out_active_active_int_26_connectivity);
    regif_peripheral_hw_in_active_active_int_27_connectivity_assert: assert property(regif_peripheral_hw_in_active_active_int_27_connectivity);
    regif_peripheral_hw_en_active_active_int_27_connectivity_assert: assert property(regif_peripheral_hw_en_active_active_int_27_connectivity);
    regif_peripheral_hw_out_active_active_int_27_connectivity_assert: assert property(regif_peripheral_hw_out_active_active_int_27_connectivity);
    regif_peripheral_hw_in_active_active_int_28_connectivity_assert: assert property(regif_peripheral_hw_in_active_active_int_28_connectivity);
    regif_peripheral_hw_en_active_active_int_28_connectivity_assert: assert property(regif_peripheral_hw_en_active_active_int_28_connectivity);
    regif_peripheral_hw_out_active_active_int_28_connectivity_assert: assert property(regif_peripheral_hw_out_active_active_int_28_connectivity);
    regif_peripheral_hw_in_active_active_int_29_connectivity_assert: assert property(regif_peripheral_hw_in_active_active_int_29_connectivity);
    regif_peripheral_hw_en_active_active_int_29_connectivity_assert: assert property(regif_peripheral_hw_en_active_active_int_29_connectivity);
    regif_peripheral_hw_out_active_active_int_29_connectivity_assert: assert property(regif_peripheral_hw_out_active_active_int_29_connectivity);
    regif_peripheral_hw_in_active_active_int_30_connectivity_assert: assert property(regif_peripheral_hw_in_active_active_int_30_connectivity);
    regif_peripheral_hw_en_active_active_int_30_connectivity_assert: assert property(regif_peripheral_hw_en_active_active_int_30_connectivity);
    regif_peripheral_hw_out_active_active_int_30_connectivity_assert: assert property(regif_peripheral_hw_out_active_active_int_30_connectivity);
    regif_peripheral_hw_in_active_active_int_31_connectivity_assert: assert property(regif_peripheral_hw_in_active_active_int_31_connectivity);
    regif_peripheral_hw_en_active_active_int_31_connectivity_assert: assert property(regif_peripheral_hw_en_active_active_int_31_connectivity);
    regif_peripheral_hw_out_active_active_int_31_connectivity_assert: assert property(regif_peripheral_hw_out_active_active_int_31_connectivity);
    regif_peripheral_hw_in_active_1_active_NMI_connectivity_assert: assert property(regif_peripheral_hw_in_active_1_active_NMI_connectivity);
    regif_peripheral_hw_en_active_1_active_NMI_connectivity_assert: assert property(regif_peripheral_hw_en_active_1_active_NMI_connectivity);
    regif_peripheral_hw_out_active_1_active_NMI_connectivity_assert: assert property(regif_peripheral_hw_out_active_1_active_NMI_connectivity);
    regif_peripheral_hw_out_priority_priority_int_0_connectivity_assert: assert property(regif_peripheral_hw_out_priority_priority_int_0_connectivity);
    regif_peripheral_hw_out_priority_priority_int_1_connectivity_assert: assert property(regif_peripheral_hw_out_priority_priority_int_1_connectivity);
    regif_peripheral_hw_out_priority_priority_int_2_connectivity_assert: assert property(regif_peripheral_hw_out_priority_priority_int_2_connectivity);
    regif_peripheral_hw_out_priority_priority_int_3_connectivity_assert: assert property(regif_peripheral_hw_out_priority_priority_int_3_connectivity);
    regif_peripheral_hw_out_priority_priority_int_4_connectivity_assert: assert property(regif_peripheral_hw_out_priority_priority_int_4_connectivity);
    regif_peripheral_hw_out_priority_priority_int_5_connectivity_assert: assert property(regif_peripheral_hw_out_priority_priority_int_5_connectivity);
    regif_peripheral_hw_out_priority_priority_int_6_connectivity_assert: assert property(regif_peripheral_hw_out_priority_priority_int_6_connectivity);
    regif_peripheral_hw_out_priority_priority_int_7_connectivity_assert: assert property(regif_peripheral_hw_out_priority_priority_int_7_connectivity);
    regif_peripheral_hw_out_priority_priority_int_8_connectivity_assert: assert property(regif_peripheral_hw_out_priority_priority_int_8_connectivity);
    regif_peripheral_hw_out_priority_priority_int_9_connectivity_assert: assert property(regif_peripheral_hw_out_priority_priority_int_9_connectivity);
    regif_peripheral_hw_out_priority_1_priority_int_10_connectivity_assert: assert property(regif_peripheral_hw_out_priority_1_priority_int_10_connectivity);
    regif_peripheral_hw_out_priority_1_priority_int_11_connectivity_assert: assert property(regif_peripheral_hw_out_priority_1_priority_int_11_connectivity);
    regif_peripheral_hw_out_priority_1_priority_int_12_connectivity_assert: assert property(regif_peripheral_hw_out_priority_1_priority_int_12_connectivity);
    regif_peripheral_hw_out_priority_1_priority_int_13_connectivity_assert: assert property(regif_peripheral_hw_out_priority_1_priority_int_13_connectivity);
    regif_peripheral_hw_out_priority_1_priority_int_14_connectivity_assert: assert property(regif_peripheral_hw_out_priority_1_priority_int_14_connectivity);
    regif_peripheral_hw_out_priority_1_priority_int_15_connectivity_assert: assert property(regif_peripheral_hw_out_priority_1_priority_int_15_connectivity);
    regif_peripheral_hw_out_priority_1_priority_int_16_connectivity_assert: assert property(regif_peripheral_hw_out_priority_1_priority_int_16_connectivity);
    regif_peripheral_hw_out_priority_1_priority_int_17_connectivity_assert: assert property(regif_peripheral_hw_out_priority_1_priority_int_17_connectivity);
    regif_peripheral_hw_out_priority_1_priority_int_18_connectivity_assert: assert property(regif_peripheral_hw_out_priority_1_priority_int_18_connectivity);
    regif_peripheral_hw_out_priority_1_priority_int_19_connectivity_assert: assert property(regif_peripheral_hw_out_priority_1_priority_int_19_connectivity);
    regif_peripheral_hw_out_priority_2_priority_int_20_connectivity_assert: assert property(regif_peripheral_hw_out_priority_2_priority_int_20_connectivity);
    regif_peripheral_hw_out_priority_2_priority_int_21_connectivity_assert: assert property(regif_peripheral_hw_out_priority_2_priority_int_21_connectivity);
    regif_peripheral_hw_out_priority_2_priority_int_22_connectivity_assert: assert property(regif_peripheral_hw_out_priority_2_priority_int_22_connectivity);
    regif_peripheral_hw_out_priority_2_priority_int_23_connectivity_assert: assert property(regif_peripheral_hw_out_priority_2_priority_int_23_connectivity);
    regif_peripheral_hw_out_priority_2_priority_int_24_connectivity_assert: assert property(regif_peripheral_hw_out_priority_2_priority_int_24_connectivity);
    regif_peripheral_hw_out_priority_2_priority_int_25_connectivity_assert: assert property(regif_peripheral_hw_out_priority_2_priority_int_25_connectivity);
    regif_peripheral_hw_out_priority_2_priority_int_26_connectivity_assert: assert property(regif_peripheral_hw_out_priority_2_priority_int_26_connectivity);
    regif_peripheral_hw_out_priority_2_priority_int_27_connectivity_assert: assert property(regif_peripheral_hw_out_priority_2_priority_int_27_connectivity);
    regif_peripheral_hw_out_priority_2_priority_int_28_connectivity_assert: assert property(regif_peripheral_hw_out_priority_2_priority_int_28_connectivity);
    regif_peripheral_hw_out_priority_2_priority_int_29_connectivity_assert: assert property(regif_peripheral_hw_out_priority_2_priority_int_29_connectivity);
    regif_peripheral_hw_out_priority_3_priority_int_30_connectivity_assert: assert property(regif_peripheral_hw_out_priority_3_priority_int_30_connectivity);
    regif_peripheral_hw_out_priority_3_priority_int_31_connectivity_assert: assert property(regif_peripheral_hw_out_priority_3_priority_int_31_connectivity);
    regif_peripheral_hw_in_requested_requested_int_0_connectivity_assert: assert property(regif_peripheral_hw_in_requested_requested_int_0_connectivity);
    regif_peripheral_hw_en_requested_requested_int_0_connectivity_assert: assert property(regif_peripheral_hw_en_requested_requested_int_0_connectivity);
    regif_peripheral_hw_out_requested_requested_int_0_connectivity_assert: assert property(regif_peripheral_hw_out_requested_requested_int_0_connectivity);
    regif_peripheral_hw_in_requested_requested_int_1_connectivity_assert: assert property(regif_peripheral_hw_in_requested_requested_int_1_connectivity);
    regif_peripheral_hw_en_requested_requested_int_1_connectivity_assert: assert property(regif_peripheral_hw_en_requested_requested_int_1_connectivity);
    regif_peripheral_hw_out_requested_requested_int_1_connectivity_assert: assert property(regif_peripheral_hw_out_requested_requested_int_1_connectivity);
    regif_peripheral_hw_in_requested_requested_int_2_connectivity_assert: assert property(regif_peripheral_hw_in_requested_requested_int_2_connectivity);
    regif_peripheral_hw_en_requested_requested_int_2_connectivity_assert: assert property(regif_peripheral_hw_en_requested_requested_int_2_connectivity);
    regif_peripheral_hw_out_requested_requested_int_2_connectivity_assert: assert property(regif_peripheral_hw_out_requested_requested_int_2_connectivity);
    regif_peripheral_hw_in_requested_requested_int_3_connectivity_assert: assert property(regif_peripheral_hw_in_requested_requested_int_3_connectivity);
    regif_peripheral_hw_en_requested_requested_int_3_connectivity_assert: assert property(regif_peripheral_hw_en_requested_requested_int_3_connectivity);
    regif_peripheral_hw_out_requested_requested_int_3_connectivity_assert: assert property(regif_peripheral_hw_out_requested_requested_int_3_connectivity);
    regif_peripheral_hw_in_requested_requested_int_4_connectivity_assert: assert property(regif_peripheral_hw_in_requested_requested_int_4_connectivity);
    regif_peripheral_hw_en_requested_requested_int_4_connectivity_assert: assert property(regif_peripheral_hw_en_requested_requested_int_4_connectivity);
    regif_peripheral_hw_out_requested_requested_int_4_connectivity_assert: assert property(regif_peripheral_hw_out_requested_requested_int_4_connectivity);
    regif_peripheral_hw_in_requested_requested_int_5_connectivity_assert: assert property(regif_peripheral_hw_in_requested_requested_int_5_connectivity);
    regif_peripheral_hw_en_requested_requested_int_5_connectivity_assert: assert property(regif_peripheral_hw_en_requested_requested_int_5_connectivity);
    regif_peripheral_hw_out_requested_requested_int_5_connectivity_assert: assert property(regif_peripheral_hw_out_requested_requested_int_5_connectivity);
    regif_peripheral_hw_in_requested_requested_int_6_connectivity_assert: assert property(regif_peripheral_hw_in_requested_requested_int_6_connectivity);
    regif_peripheral_hw_en_requested_requested_int_6_connectivity_assert: assert property(regif_peripheral_hw_en_requested_requested_int_6_connectivity);
    regif_peripheral_hw_out_requested_requested_int_6_connectivity_assert: assert property(regif_peripheral_hw_out_requested_requested_int_6_connectivity);
    regif_peripheral_hw_in_requested_requested_int_7_connectivity_assert: assert property(regif_peripheral_hw_in_requested_requested_int_7_connectivity);
    regif_peripheral_hw_en_requested_requested_int_7_connectivity_assert: assert property(regif_peripheral_hw_en_requested_requested_int_7_connectivity);
    regif_peripheral_hw_out_requested_requested_int_7_connectivity_assert: assert property(regif_peripheral_hw_out_requested_requested_int_7_connectivity);
    regif_peripheral_hw_in_requested_requested_int_8_connectivity_assert: assert property(regif_peripheral_hw_in_requested_requested_int_8_connectivity);
    regif_peripheral_hw_en_requested_requested_int_8_connectivity_assert: assert property(regif_peripheral_hw_en_requested_requested_int_8_connectivity);
    regif_peripheral_hw_out_requested_requested_int_8_connectivity_assert: assert property(regif_peripheral_hw_out_requested_requested_int_8_connectivity);
    regif_peripheral_hw_in_requested_requested_int_9_connectivity_assert: assert property(regif_peripheral_hw_in_requested_requested_int_9_connectivity);
    regif_peripheral_hw_en_requested_requested_int_9_connectivity_assert: assert property(regif_peripheral_hw_en_requested_requested_int_9_connectivity);
    regif_peripheral_hw_out_requested_requested_int_9_connectivity_assert: assert property(regif_peripheral_hw_out_requested_requested_int_9_connectivity);
    regif_peripheral_hw_in_requested_requested_int_10_connectivity_assert: assert property(regif_peripheral_hw_in_requested_requested_int_10_connectivity);
    regif_peripheral_hw_en_requested_requested_int_10_connectivity_assert: assert property(regif_peripheral_hw_en_requested_requested_int_10_connectivity);
    regif_peripheral_hw_out_requested_requested_int_10_connectivity_assert: assert property(regif_peripheral_hw_out_requested_requested_int_10_connectivity);
    regif_peripheral_hw_in_requested_requested_int_11_connectivity_assert: assert property(regif_peripheral_hw_in_requested_requested_int_11_connectivity);
    regif_peripheral_hw_en_requested_requested_int_11_connectivity_assert: assert property(regif_peripheral_hw_en_requested_requested_int_11_connectivity);
    regif_peripheral_hw_out_requested_requested_int_11_connectivity_assert: assert property(regif_peripheral_hw_out_requested_requested_int_11_connectivity);
    regif_peripheral_hw_in_requested_requested_int_12_connectivity_assert: assert property(regif_peripheral_hw_in_requested_requested_int_12_connectivity);
    regif_peripheral_hw_en_requested_requested_int_12_connectivity_assert: assert property(regif_peripheral_hw_en_requested_requested_int_12_connectivity);
    regif_peripheral_hw_out_requested_requested_int_12_connectivity_assert: assert property(regif_peripheral_hw_out_requested_requested_int_12_connectivity);
    regif_peripheral_hw_in_requested_requested_int_13_connectivity_assert: assert property(regif_peripheral_hw_in_requested_requested_int_13_connectivity);
    regif_peripheral_hw_en_requested_requested_int_13_connectivity_assert: assert property(regif_peripheral_hw_en_requested_requested_int_13_connectivity);
    regif_peripheral_hw_out_requested_requested_int_13_connectivity_assert: assert property(regif_peripheral_hw_out_requested_requested_int_13_connectivity);
    regif_peripheral_hw_in_requested_requested_int_14_connectivity_assert: assert property(regif_peripheral_hw_in_requested_requested_int_14_connectivity);
    regif_peripheral_hw_en_requested_requested_int_14_connectivity_assert: assert property(regif_peripheral_hw_en_requested_requested_int_14_connectivity);
    regif_peripheral_hw_out_requested_requested_int_14_connectivity_assert: assert property(regif_peripheral_hw_out_requested_requested_int_14_connectivity);
    regif_peripheral_hw_in_requested_requested_int_15_connectivity_assert: assert property(regif_peripheral_hw_in_requested_requested_int_15_connectivity);
    regif_peripheral_hw_en_requested_requested_int_15_connectivity_assert: assert property(regif_peripheral_hw_en_requested_requested_int_15_connectivity);
    regif_peripheral_hw_out_requested_requested_int_15_connectivity_assert: assert property(regif_peripheral_hw_out_requested_requested_int_15_connectivity);
    regif_peripheral_hw_in_requested_requested_int_16_connectivity_assert: assert property(regif_peripheral_hw_in_requested_requested_int_16_connectivity);
    regif_peripheral_hw_en_requested_requested_int_16_connectivity_assert: assert property(regif_peripheral_hw_en_requested_requested_int_16_connectivity);
    regif_peripheral_hw_out_requested_requested_int_16_connectivity_assert: assert property(regif_peripheral_hw_out_requested_requested_int_16_connectivity);
    regif_peripheral_hw_in_requested_requested_int_17_connectivity_assert: assert property(regif_peripheral_hw_in_requested_requested_int_17_connectivity);
    regif_peripheral_hw_en_requested_requested_int_17_connectivity_assert: assert property(regif_peripheral_hw_en_requested_requested_int_17_connectivity);
    regif_peripheral_hw_out_requested_requested_int_17_connectivity_assert: assert property(regif_peripheral_hw_out_requested_requested_int_17_connectivity);
    regif_peripheral_hw_in_requested_requested_int_18_connectivity_assert: assert property(regif_peripheral_hw_in_requested_requested_int_18_connectivity);
    regif_peripheral_hw_en_requested_requested_int_18_connectivity_assert: assert property(regif_peripheral_hw_en_requested_requested_int_18_connectivity);
    regif_peripheral_hw_out_requested_requested_int_18_connectivity_assert: assert property(regif_peripheral_hw_out_requested_requested_int_18_connectivity);
    regif_peripheral_hw_in_requested_requested_int_19_connectivity_assert: assert property(regif_peripheral_hw_in_requested_requested_int_19_connectivity);
    regif_peripheral_hw_en_requested_requested_int_19_connectivity_assert: assert property(regif_peripheral_hw_en_requested_requested_int_19_connectivity);
    regif_peripheral_hw_out_requested_requested_int_19_connectivity_assert: assert property(regif_peripheral_hw_out_requested_requested_int_19_connectivity);
    regif_peripheral_hw_in_requested_requested_int_20_connectivity_assert: assert property(regif_peripheral_hw_in_requested_requested_int_20_connectivity);
    regif_peripheral_hw_en_requested_requested_int_20_connectivity_assert: assert property(regif_peripheral_hw_en_requested_requested_int_20_connectivity);
    regif_peripheral_hw_out_requested_requested_int_20_connectivity_assert: assert property(regif_peripheral_hw_out_requested_requested_int_20_connectivity);
    regif_peripheral_hw_in_requested_requested_int_21_connectivity_assert: assert property(regif_peripheral_hw_in_requested_requested_int_21_connectivity);
    regif_peripheral_hw_en_requested_requested_int_21_connectivity_assert: assert property(regif_peripheral_hw_en_requested_requested_int_21_connectivity);
    regif_peripheral_hw_out_requested_requested_int_21_connectivity_assert: assert property(regif_peripheral_hw_out_requested_requested_int_21_connectivity);
    regif_peripheral_hw_in_requested_requested_int_22_connectivity_assert: assert property(regif_peripheral_hw_in_requested_requested_int_22_connectivity);
    regif_peripheral_hw_en_requested_requested_int_22_connectivity_assert: assert property(regif_peripheral_hw_en_requested_requested_int_22_connectivity);
    regif_peripheral_hw_out_requested_requested_int_22_connectivity_assert: assert property(regif_peripheral_hw_out_requested_requested_int_22_connectivity);
    regif_peripheral_hw_in_requested_requested_int_23_connectivity_assert: assert property(regif_peripheral_hw_in_requested_requested_int_23_connectivity);
    regif_peripheral_hw_en_requested_requested_int_23_connectivity_assert: assert property(regif_peripheral_hw_en_requested_requested_int_23_connectivity);
    regif_peripheral_hw_out_requested_requested_int_23_connectivity_assert: assert property(regif_peripheral_hw_out_requested_requested_int_23_connectivity);
    regif_peripheral_hw_in_requested_requested_int_24_connectivity_assert: assert property(regif_peripheral_hw_in_requested_requested_int_24_connectivity);
    regif_peripheral_hw_en_requested_requested_int_24_connectivity_assert: assert property(regif_peripheral_hw_en_requested_requested_int_24_connectivity);
    regif_peripheral_hw_out_requested_requested_int_24_connectivity_assert: assert property(regif_peripheral_hw_out_requested_requested_int_24_connectivity);
    regif_peripheral_hw_in_requested_requested_int_25_connectivity_assert: assert property(regif_peripheral_hw_in_requested_requested_int_25_connectivity);
    regif_peripheral_hw_en_requested_requested_int_25_connectivity_assert: assert property(regif_peripheral_hw_en_requested_requested_int_25_connectivity);
    regif_peripheral_hw_out_requested_requested_int_25_connectivity_assert: assert property(regif_peripheral_hw_out_requested_requested_int_25_connectivity);
    regif_peripheral_hw_in_requested_requested_int_26_connectivity_assert: assert property(regif_peripheral_hw_in_requested_requested_int_26_connectivity);
    regif_peripheral_hw_en_requested_requested_int_26_connectivity_assert: assert property(regif_peripheral_hw_en_requested_requested_int_26_connectivity);
    regif_peripheral_hw_out_requested_requested_int_26_connectivity_assert: assert property(regif_peripheral_hw_out_requested_requested_int_26_connectivity);
    regif_peripheral_hw_in_requested_requested_int_27_connectivity_assert: assert property(regif_peripheral_hw_in_requested_requested_int_27_connectivity);
    regif_peripheral_hw_en_requested_requested_int_27_connectivity_assert: assert property(regif_peripheral_hw_en_requested_requested_int_27_connectivity);
    regif_peripheral_hw_out_requested_requested_int_27_connectivity_assert: assert property(regif_peripheral_hw_out_requested_requested_int_27_connectivity);
    regif_peripheral_hw_in_requested_requested_int_28_connectivity_assert: assert property(regif_peripheral_hw_in_requested_requested_int_28_connectivity);
    regif_peripheral_hw_en_requested_requested_int_28_connectivity_assert: assert property(regif_peripheral_hw_en_requested_requested_int_28_connectivity);
    regif_peripheral_hw_out_requested_requested_int_28_connectivity_assert: assert property(regif_peripheral_hw_out_requested_requested_int_28_connectivity);
    regif_peripheral_hw_in_requested_requested_int_29_connectivity_assert: assert property(regif_peripheral_hw_in_requested_requested_int_29_connectivity);
    regif_peripheral_hw_en_requested_requested_int_29_connectivity_assert: assert property(regif_peripheral_hw_en_requested_requested_int_29_connectivity);
    regif_peripheral_hw_out_requested_requested_int_29_connectivity_assert: assert property(regif_peripheral_hw_out_requested_requested_int_29_connectivity);
    regif_peripheral_hw_in_requested_requested_int_30_connectivity_assert: assert property(regif_peripheral_hw_in_requested_requested_int_30_connectivity);
    regif_peripheral_hw_en_requested_requested_int_30_connectivity_assert: assert property(regif_peripheral_hw_en_requested_requested_int_30_connectivity);
    regif_peripheral_hw_out_requested_requested_int_30_connectivity_assert: assert property(regif_peripheral_hw_out_requested_requested_int_30_connectivity);
    regif_peripheral_hw_in_requested_requested_int_31_connectivity_assert: assert property(regif_peripheral_hw_in_requested_requested_int_31_connectivity);
    regif_peripheral_hw_en_requested_requested_int_31_connectivity_assert: assert property(regif_peripheral_hw_en_requested_requested_int_31_connectivity);
    regif_peripheral_hw_out_requested_requested_int_31_connectivity_assert: assert property(regif_peripheral_hw_out_requested_requested_int_31_connectivity);
    regif_peripheral_hw_in_requested_1_requested_NMI_connectivity_assert: assert property(regif_peripheral_hw_in_requested_1_requested_NMI_connectivity);
    regif_peripheral_hw_en_requested_1_requested_NMI_connectivity_assert: assert property(regif_peripheral_hw_en_requested_1_requested_NMI_connectivity);
    regif_peripheral_hw_out_requested_1_requested_NMI_connectivity_assert: assert property(regif_peripheral_hw_out_requested_1_requested_NMI_connectivity);
    regif_peripheral_hw_in_paused_paused_int_0_connectivity_assert: assert property(regif_peripheral_hw_in_paused_paused_int_0_connectivity);
    regif_peripheral_hw_en_paused_paused_int_0_connectivity_assert: assert property(regif_peripheral_hw_en_paused_paused_int_0_connectivity);
    regif_peripheral_hw_out_paused_paused_int_0_connectivity_assert: assert property(regif_peripheral_hw_out_paused_paused_int_0_connectivity);
    regif_peripheral_hw_in_paused_paused_int_1_connectivity_assert: assert property(regif_peripheral_hw_in_paused_paused_int_1_connectivity);
    regif_peripheral_hw_en_paused_paused_int_1_connectivity_assert: assert property(regif_peripheral_hw_en_paused_paused_int_1_connectivity);
    regif_peripheral_hw_out_paused_paused_int_1_connectivity_assert: assert property(regif_peripheral_hw_out_paused_paused_int_1_connectivity);
    regif_peripheral_hw_in_paused_paused_int_2_connectivity_assert: assert property(regif_peripheral_hw_in_paused_paused_int_2_connectivity);
    regif_peripheral_hw_en_paused_paused_int_2_connectivity_assert: assert property(regif_peripheral_hw_en_paused_paused_int_2_connectivity);
    regif_peripheral_hw_out_paused_paused_int_2_connectivity_assert: assert property(regif_peripheral_hw_out_paused_paused_int_2_connectivity);
    regif_peripheral_hw_in_paused_paused_int_3_connectivity_assert: assert property(regif_peripheral_hw_in_paused_paused_int_3_connectivity);
    regif_peripheral_hw_en_paused_paused_int_3_connectivity_assert: assert property(regif_peripheral_hw_en_paused_paused_int_3_connectivity);
    regif_peripheral_hw_out_paused_paused_int_3_connectivity_assert: assert property(regif_peripheral_hw_out_paused_paused_int_3_connectivity);
    regif_peripheral_hw_in_paused_paused_int_4_connectivity_assert: assert property(regif_peripheral_hw_in_paused_paused_int_4_connectivity);
    regif_peripheral_hw_en_paused_paused_int_4_connectivity_assert: assert property(regif_peripheral_hw_en_paused_paused_int_4_connectivity);
    regif_peripheral_hw_out_paused_paused_int_4_connectivity_assert: assert property(regif_peripheral_hw_out_paused_paused_int_4_connectivity);
    regif_peripheral_hw_in_paused_paused_int_5_connectivity_assert: assert property(regif_peripheral_hw_in_paused_paused_int_5_connectivity);
    regif_peripheral_hw_en_paused_paused_int_5_connectivity_assert: assert property(regif_peripheral_hw_en_paused_paused_int_5_connectivity);
    regif_peripheral_hw_out_paused_paused_int_5_connectivity_assert: assert property(regif_peripheral_hw_out_paused_paused_int_5_connectivity);
    regif_peripheral_hw_in_paused_paused_int_6_connectivity_assert: assert property(regif_peripheral_hw_in_paused_paused_int_6_connectivity);
    regif_peripheral_hw_en_paused_paused_int_6_connectivity_assert: assert property(regif_peripheral_hw_en_paused_paused_int_6_connectivity);
    regif_peripheral_hw_out_paused_paused_int_6_connectivity_assert: assert property(regif_peripheral_hw_out_paused_paused_int_6_connectivity);
    regif_peripheral_hw_in_paused_paused_int_7_connectivity_assert: assert property(regif_peripheral_hw_in_paused_paused_int_7_connectivity);
    regif_peripheral_hw_en_paused_paused_int_7_connectivity_assert: assert property(regif_peripheral_hw_en_paused_paused_int_7_connectivity);
    regif_peripheral_hw_out_paused_paused_int_7_connectivity_assert: assert property(regif_peripheral_hw_out_paused_paused_int_7_connectivity);
    regif_peripheral_hw_in_paused_paused_int_8_connectivity_assert: assert property(regif_peripheral_hw_in_paused_paused_int_8_connectivity);
    regif_peripheral_hw_en_paused_paused_int_8_connectivity_assert: assert property(regif_peripheral_hw_en_paused_paused_int_8_connectivity);
    regif_peripheral_hw_out_paused_paused_int_8_connectivity_assert: assert property(regif_peripheral_hw_out_paused_paused_int_8_connectivity);
    regif_peripheral_hw_in_paused_paused_int_9_connectivity_assert: assert property(regif_peripheral_hw_in_paused_paused_int_9_connectivity);
    regif_peripheral_hw_en_paused_paused_int_9_connectivity_assert: assert property(regif_peripheral_hw_en_paused_paused_int_9_connectivity);
    regif_peripheral_hw_out_paused_paused_int_9_connectivity_assert: assert property(regif_peripheral_hw_out_paused_paused_int_9_connectivity);
    regif_peripheral_hw_in_paused_paused_int_10_connectivity_assert: assert property(regif_peripheral_hw_in_paused_paused_int_10_connectivity);
    regif_peripheral_hw_en_paused_paused_int_10_connectivity_assert: assert property(regif_peripheral_hw_en_paused_paused_int_10_connectivity);
    regif_peripheral_hw_out_paused_paused_int_10_connectivity_assert: assert property(regif_peripheral_hw_out_paused_paused_int_10_connectivity);
    regif_peripheral_hw_in_paused_paused_int_11_connectivity_assert: assert property(regif_peripheral_hw_in_paused_paused_int_11_connectivity);
    regif_peripheral_hw_en_paused_paused_int_11_connectivity_assert: assert property(regif_peripheral_hw_en_paused_paused_int_11_connectivity);
    regif_peripheral_hw_out_paused_paused_int_11_connectivity_assert: assert property(regif_peripheral_hw_out_paused_paused_int_11_connectivity);
    regif_peripheral_hw_in_paused_paused_int_12_connectivity_assert: assert property(regif_peripheral_hw_in_paused_paused_int_12_connectivity);
    regif_peripheral_hw_en_paused_paused_int_12_connectivity_assert: assert property(regif_peripheral_hw_en_paused_paused_int_12_connectivity);
    regif_peripheral_hw_out_paused_paused_int_12_connectivity_assert: assert property(regif_peripheral_hw_out_paused_paused_int_12_connectivity);
    regif_peripheral_hw_in_paused_paused_int_13_connectivity_assert: assert property(regif_peripheral_hw_in_paused_paused_int_13_connectivity);
    regif_peripheral_hw_en_paused_paused_int_13_connectivity_assert: assert property(regif_peripheral_hw_en_paused_paused_int_13_connectivity);
    regif_peripheral_hw_out_paused_paused_int_13_connectivity_assert: assert property(regif_peripheral_hw_out_paused_paused_int_13_connectivity);
    regif_peripheral_hw_in_paused_paused_int_14_connectivity_assert: assert property(regif_peripheral_hw_in_paused_paused_int_14_connectivity);
    regif_peripheral_hw_en_paused_paused_int_14_connectivity_assert: assert property(regif_peripheral_hw_en_paused_paused_int_14_connectivity);
    regif_peripheral_hw_out_paused_paused_int_14_connectivity_assert: assert property(regif_peripheral_hw_out_paused_paused_int_14_connectivity);
    regif_peripheral_hw_in_paused_paused_int_15_connectivity_assert: assert property(regif_peripheral_hw_in_paused_paused_int_15_connectivity);
    regif_peripheral_hw_en_paused_paused_int_15_connectivity_assert: assert property(regif_peripheral_hw_en_paused_paused_int_15_connectivity);
    regif_peripheral_hw_out_paused_paused_int_15_connectivity_assert: assert property(regif_peripheral_hw_out_paused_paused_int_15_connectivity);
    regif_peripheral_hw_in_paused_paused_int_16_connectivity_assert: assert property(regif_peripheral_hw_in_paused_paused_int_16_connectivity);
    regif_peripheral_hw_en_paused_paused_int_16_connectivity_assert: assert property(regif_peripheral_hw_en_paused_paused_int_16_connectivity);
    regif_peripheral_hw_out_paused_paused_int_16_connectivity_assert: assert property(regif_peripheral_hw_out_paused_paused_int_16_connectivity);
    regif_peripheral_hw_in_paused_paused_int_17_connectivity_assert: assert property(regif_peripheral_hw_in_paused_paused_int_17_connectivity);
    regif_peripheral_hw_en_paused_paused_int_17_connectivity_assert: assert property(regif_peripheral_hw_en_paused_paused_int_17_connectivity);
    regif_peripheral_hw_out_paused_paused_int_17_connectivity_assert: assert property(regif_peripheral_hw_out_paused_paused_int_17_connectivity);
    regif_peripheral_hw_in_paused_paused_int_18_connectivity_assert: assert property(regif_peripheral_hw_in_paused_paused_int_18_connectivity);
    regif_peripheral_hw_en_paused_paused_int_18_connectivity_assert: assert property(regif_peripheral_hw_en_paused_paused_int_18_connectivity);
    regif_peripheral_hw_out_paused_paused_int_18_connectivity_assert: assert property(regif_peripheral_hw_out_paused_paused_int_18_connectivity);
    regif_peripheral_hw_in_paused_paused_int_19_connectivity_assert: assert property(regif_peripheral_hw_in_paused_paused_int_19_connectivity);
    regif_peripheral_hw_en_paused_paused_int_19_connectivity_assert: assert property(regif_peripheral_hw_en_paused_paused_int_19_connectivity);
    regif_peripheral_hw_out_paused_paused_int_19_connectivity_assert: assert property(regif_peripheral_hw_out_paused_paused_int_19_connectivity);
    regif_peripheral_hw_in_paused_paused_int_20_connectivity_assert: assert property(regif_peripheral_hw_in_paused_paused_int_20_connectivity);
    regif_peripheral_hw_en_paused_paused_int_20_connectivity_assert: assert property(regif_peripheral_hw_en_paused_paused_int_20_connectivity);
    regif_peripheral_hw_out_paused_paused_int_20_connectivity_assert: assert property(regif_peripheral_hw_out_paused_paused_int_20_connectivity);
    regif_peripheral_hw_in_paused_paused_int_21_connectivity_assert: assert property(regif_peripheral_hw_in_paused_paused_int_21_connectivity);
    regif_peripheral_hw_en_paused_paused_int_21_connectivity_assert: assert property(regif_peripheral_hw_en_paused_paused_int_21_connectivity);
    regif_peripheral_hw_out_paused_paused_int_21_connectivity_assert: assert property(regif_peripheral_hw_out_paused_paused_int_21_connectivity);
    regif_peripheral_hw_in_paused_paused_int_22_connectivity_assert: assert property(regif_peripheral_hw_in_paused_paused_int_22_connectivity);
    regif_peripheral_hw_en_paused_paused_int_22_connectivity_assert: assert property(regif_peripheral_hw_en_paused_paused_int_22_connectivity);
    regif_peripheral_hw_out_paused_paused_int_22_connectivity_assert: assert property(regif_peripheral_hw_out_paused_paused_int_22_connectivity);
    regif_peripheral_hw_in_paused_paused_int_23_connectivity_assert: assert property(regif_peripheral_hw_in_paused_paused_int_23_connectivity);
    regif_peripheral_hw_en_paused_paused_int_23_connectivity_assert: assert property(regif_peripheral_hw_en_paused_paused_int_23_connectivity);
    regif_peripheral_hw_out_paused_paused_int_23_connectivity_assert: assert property(regif_peripheral_hw_out_paused_paused_int_23_connectivity);
    regif_peripheral_hw_in_paused_paused_int_24_connectivity_assert: assert property(regif_peripheral_hw_in_paused_paused_int_24_connectivity);
    regif_peripheral_hw_en_paused_paused_int_24_connectivity_assert: assert property(regif_peripheral_hw_en_paused_paused_int_24_connectivity);
    regif_peripheral_hw_out_paused_paused_int_24_connectivity_assert: assert property(regif_peripheral_hw_out_paused_paused_int_24_connectivity);
    regif_peripheral_hw_in_paused_paused_int_25_connectivity_assert: assert property(regif_peripheral_hw_in_paused_paused_int_25_connectivity);
    regif_peripheral_hw_en_paused_paused_int_25_connectivity_assert: assert property(regif_peripheral_hw_en_paused_paused_int_25_connectivity);
    regif_peripheral_hw_out_paused_paused_int_25_connectivity_assert: assert property(regif_peripheral_hw_out_paused_paused_int_25_connectivity);
    regif_peripheral_hw_in_paused_paused_int_26_connectivity_assert: assert property(regif_peripheral_hw_in_paused_paused_int_26_connectivity);
    regif_peripheral_hw_en_paused_paused_int_26_connectivity_assert: assert property(regif_peripheral_hw_en_paused_paused_int_26_connectivity);
    regif_peripheral_hw_out_paused_paused_int_26_connectivity_assert: assert property(regif_peripheral_hw_out_paused_paused_int_26_connectivity);
    regif_peripheral_hw_in_paused_paused_int_27_connectivity_assert: assert property(regif_peripheral_hw_in_paused_paused_int_27_connectivity);
    regif_peripheral_hw_en_paused_paused_int_27_connectivity_assert: assert property(regif_peripheral_hw_en_paused_paused_int_27_connectivity);
    regif_peripheral_hw_out_paused_paused_int_27_connectivity_assert: assert property(regif_peripheral_hw_out_paused_paused_int_27_connectivity);
    regif_peripheral_hw_in_paused_paused_int_28_connectivity_assert: assert property(regif_peripheral_hw_in_paused_paused_int_28_connectivity);
    regif_peripheral_hw_en_paused_paused_int_28_connectivity_assert: assert property(regif_peripheral_hw_en_paused_paused_int_28_connectivity);
    regif_peripheral_hw_out_paused_paused_int_28_connectivity_assert: assert property(regif_peripheral_hw_out_paused_paused_int_28_connectivity);
    regif_peripheral_hw_in_paused_paused_int_29_connectivity_assert: assert property(regif_peripheral_hw_in_paused_paused_int_29_connectivity);
    regif_peripheral_hw_en_paused_paused_int_29_connectivity_assert: assert property(regif_peripheral_hw_en_paused_paused_int_29_connectivity);
    regif_peripheral_hw_out_paused_paused_int_29_connectivity_assert: assert property(regif_peripheral_hw_out_paused_paused_int_29_connectivity);
    regif_peripheral_hw_in_paused_paused_int_30_connectivity_assert: assert property(regif_peripheral_hw_in_paused_paused_int_30_connectivity);
    regif_peripheral_hw_en_paused_paused_int_30_connectivity_assert: assert property(regif_peripheral_hw_en_paused_paused_int_30_connectivity);
    regif_peripheral_hw_out_paused_paused_int_30_connectivity_assert: assert property(regif_peripheral_hw_out_paused_paused_int_30_connectivity);
    regif_peripheral_hw_in_paused_paused_int_31_connectivity_assert: assert property(regif_peripheral_hw_in_paused_paused_int_31_connectivity);
    regif_peripheral_hw_en_paused_paused_int_31_connectivity_assert: assert property(regif_peripheral_hw_en_paused_paused_int_31_connectivity);
    regif_peripheral_hw_out_paused_paused_int_31_connectivity_assert: assert property(regif_peripheral_hw_out_paused_paused_int_31_connectivity);
    regif_peripheral_hw_in_paused_1_paused_NMI_connectivity_assert: assert property(regif_peripheral_hw_in_paused_1_paused_NMI_connectivity);
    regif_peripheral_hw_en_paused_1_paused_NMI_connectivity_assert: assert property(regif_peripheral_hw_en_paused_1_paused_NMI_connectivity);
    regif_peripheral_hw_out_paused_1_paused_NMI_connectivity_assert: assert property(regif_peripheral_hw_out_paused_1_paused_NMI_connectivity);
    regif_peripheral_hw_out_group_priority_group_priority_Group1_connectivity_assert: assert property(regif_peripheral_hw_out_group_priority_group_priority_Group1_connectivity);
    regif_peripheral_hw_out_group_priority_group_priority_Group2_connectivity_assert: assert property(regif_peripheral_hw_out_group_priority_group_priority_Group2_connectivity);
    regif_peripheral_hw_out_group_priority_group_priority_Group3_connectivity_assert: assert property(regif_peripheral_hw_out_group_priority_group_priority_Group3_connectivity);
    regif_peripheral_hw_out_group_priority_group_priority_Group4_connectivity_assert: assert property(regif_peripheral_hw_out_group_priority_group_priority_Group4_connectivity);
    regif_peripheral_hw_out_int_0_addr_addr_int_0_connectivity_assert: assert property(regif_peripheral_hw_out_int_0_addr_addr_int_0_connectivity);
    regif_peripheral_hw_out_int_1_addr_addr_int_1_connectivity_assert: assert property(regif_peripheral_hw_out_int_1_addr_addr_int_1_connectivity);
    regif_peripheral_hw_out_int_2_addr_addr_int_2_connectivity_assert: assert property(regif_peripheral_hw_out_int_2_addr_addr_int_2_connectivity);
    regif_peripheral_hw_out_int_3_addr_addr_int_3_connectivity_assert: assert property(regif_peripheral_hw_out_int_3_addr_addr_int_3_connectivity);
    regif_peripheral_hw_out_int_4_addr_addr_int_4_connectivity_assert: assert property(regif_peripheral_hw_out_int_4_addr_addr_int_4_connectivity);
    regif_peripheral_hw_out_int_5_addr_addr_int_5_connectivity_assert: assert property(regif_peripheral_hw_out_int_5_addr_addr_int_5_connectivity);
    regif_peripheral_hw_out_int_6_addr_addr_int_6_connectivity_assert: assert property(regif_peripheral_hw_out_int_6_addr_addr_int_6_connectivity);
    regif_peripheral_hw_out_int_7_addr_addr_int_7_connectivity_assert: assert property(regif_peripheral_hw_out_int_7_addr_addr_int_7_connectivity);
    regif_peripheral_hw_out_int_8_addr_addr_int_8_connectivity_assert: assert property(regif_peripheral_hw_out_int_8_addr_addr_int_8_connectivity);
    regif_peripheral_hw_out_int_9_addr_addr_int_9_connectivity_assert: assert property(regif_peripheral_hw_out_int_9_addr_addr_int_9_connectivity);
    regif_peripheral_hw_out_int_10_addr_addr_int_10_connectivity_assert: assert property(regif_peripheral_hw_out_int_10_addr_addr_int_10_connectivity);
    regif_peripheral_hw_out_int_11_addr_addr_int_11_connectivity_assert: assert property(regif_peripheral_hw_out_int_11_addr_addr_int_11_connectivity);
    regif_peripheral_hw_out_int_12_addr_addr_int_12_connectivity_assert: assert property(regif_peripheral_hw_out_int_12_addr_addr_int_12_connectivity);
    regif_peripheral_hw_out_int_13_addr_addr_int_13_connectivity_assert: assert property(regif_peripheral_hw_out_int_13_addr_addr_int_13_connectivity);
    regif_peripheral_hw_out_int_14_addr_addr_int_14_connectivity_assert: assert property(regif_peripheral_hw_out_int_14_addr_addr_int_14_connectivity);
    regif_peripheral_hw_out_int_15_addr_addr_int_15_connectivity_assert: assert property(regif_peripheral_hw_out_int_15_addr_addr_int_15_connectivity);
    regif_peripheral_hw_out_int_16_addr_addr_int_16_connectivity_assert: assert property(regif_peripheral_hw_out_int_16_addr_addr_int_16_connectivity);
    regif_peripheral_hw_out_int_17_addr_addr_int_17_connectivity_assert: assert property(regif_peripheral_hw_out_int_17_addr_addr_int_17_connectivity);
    regif_peripheral_hw_out_int_18_addr_addr_int_18_connectivity_assert: assert property(regif_peripheral_hw_out_int_18_addr_addr_int_18_connectivity);
    regif_peripheral_hw_out_int_19_addr_addr_int_19_connectivity_assert: assert property(regif_peripheral_hw_out_int_19_addr_addr_int_19_connectivity);
    regif_peripheral_hw_out_int_20_addr_addr_int_20_connectivity_assert: assert property(regif_peripheral_hw_out_int_20_addr_addr_int_20_connectivity);
    regif_peripheral_hw_out_int_21_addr_addr_int_21_connectivity_assert: assert property(regif_peripheral_hw_out_int_21_addr_addr_int_21_connectivity);
    regif_peripheral_hw_out_int_22_addr_addr_int_22_connectivity_assert: assert property(regif_peripheral_hw_out_int_22_addr_addr_int_22_connectivity);
    regif_peripheral_hw_out_int_23_addr_addr_int_23_connectivity_assert: assert property(regif_peripheral_hw_out_int_23_addr_addr_int_23_connectivity);
    regif_peripheral_hw_out_int_24_addr_addr_int_24_connectivity_assert: assert property(regif_peripheral_hw_out_int_24_addr_addr_int_24_connectivity);
    regif_peripheral_hw_out_int_25_addr_addr_int_25_connectivity_assert: assert property(regif_peripheral_hw_out_int_25_addr_addr_int_25_connectivity);
    regif_peripheral_hw_out_int_26_addr_addr_int_26_connectivity_assert: assert property(regif_peripheral_hw_out_int_26_addr_addr_int_26_connectivity);
    regif_peripheral_hw_out_int_27_addr_addr_int_27_connectivity_assert: assert property(regif_peripheral_hw_out_int_27_addr_addr_int_27_connectivity);
    regif_peripheral_hw_out_int_28_addr_addr_int_28_connectivity_assert: assert property(regif_peripheral_hw_out_int_28_addr_addr_int_28_connectivity);
    regif_peripheral_hw_out_int_29_addr_addr_int_29_connectivity_assert: assert property(regif_peripheral_hw_out_int_29_addr_addr_int_29_connectivity);
    regif_peripheral_hw_out_int_30_addr_addr_int_30_connectivity_assert: assert property(regif_peripheral_hw_out_int_30_addr_addr_int_30_connectivity);
    regif_peripheral_hw_out_int_31_addr_addr_int_31_connectivity_assert: assert property(regif_peripheral_hw_out_int_31_addr_addr_int_31_connectivity);
    regif_peripheral_hw_out_NMI_addr_addr_NMI_connectivity_assert: assert property(regif_peripheral_hw_out_NMI_addr_addr_NMI_connectivity);
    ready_after_address_phase_assert: assert property(ready_after_address_phase);
    ready_when_no_transaction_assert: assert property(ready_when_no_transaction);
    hresp_no_error_check_assert: assert property(hresp_no_error_check);
    hresp_when_no_transaction_assert: assert property(hresp_when_no_transaction);
    acc_en_check_assert: assert property(acc_en_check);
    no_acc_en_when_no_transaction_assert: assert property(no_acc_en_when_no_transaction);
    addr_check_assert: assert property(addr_check);
    rdata_check_assert: assert property(rdata_check);
    wdata_check_assert: assert property(wdata_check);
    read_enable_check_assert: assert property(read_enable_check);
    write_enable_check_assert: assert property(write_enable_check);
    access_size_byte_check_assert: assert property(access_size_byte_check);
    access_size_halfword_check_assert: assert property(access_size_halfword_check);
    access_size_word_check_assert: assert property(access_size_word_check);
    bus_error_data_phase_hreadyout_hresp_check_assert: assert property(bus_error_data_phase_hreadyout_hresp_check);
    no_acc_en_when_error_in_address_phase_assert: assert property(no_acc_en_when_error_in_address_phase);
    burst_error_response_assert: assert property(burst_error_response);
    bus_error_two_cycles_assert: assert property(bus_error_two_cycles);

endmodule

//---------------------------------------------------------------------------------------------
bind InterruptController csc_ahb_bridge_prop inst_csc_ahb_bridge_prop(.*);
//---------------------------------------------------------------------------------------------
