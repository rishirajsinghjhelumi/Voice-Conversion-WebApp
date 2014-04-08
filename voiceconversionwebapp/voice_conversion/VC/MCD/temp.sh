#!/bin/bash

sh mcd.sh /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/bdl/ /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/awb/  temp.out /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/AWB2BDL/awb_align_bdl

sh mcd.sh /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/bdl/ /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/clb/  temp.out /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/CLB2BDL/clb_align_bdl/

sh mcd.sh /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/bdl/ /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/ksp/  temp.out /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/KSP2BDL/ksp_align_bdl/

sh mcd.sh /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/bdl/ /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/rms/  temp.out /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/RMS2BDL/rms_align_bdl/

sh mcd.sh /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/bdl/ /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/slt/  temp.out /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/SLT2BDL/slt_align_bdl/

sh mcd.sh /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/slt/ /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/awb/  temp.out /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/AWB2SLT/awb_align_slt/

sh mcd.sh /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/slt/ /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/clb/  temp.out /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/CLB2SLT/clb_align_slt/

sh mcd.sh /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/slt/ /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/ksp/  temp.out /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/KSP2SLT/ksp_align_slt/

sh mcd.sh /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/slt/ /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/rms/  temp.out /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/RMS2SLT/rms_align_slt/

sh mcd.sh /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/slt/ /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/bdl/  temp.out /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/BDL2SLT/bdl_align_slt/

sh src/estbinarytoascii.sh /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/AWB2BDL/awb_align_bdl/ /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/AWB2BDL/awb_align_bdl/
sh src/estbinarytoascii.sh /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/CLB2BDL/clb_align_bdl/ /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/CLB2BDL/clb_align_bdl/
sh src/estbinarytoascii.sh /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/KSP2BDL/ksp_align_bdl/ /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/KSP2BDL/ksp_align_bdl/
sh src/estbinarytoascii.sh /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/RMS2BDL/rms_align_bdl/ /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/RMS2BDL/rms_align_bdl/
sh src/estbinarytoascii.sh /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/SLT2BDL/slt_align_bdl/ /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/SLT2BDL/slt_align_bdl/


sh src/estbinarytoascii.sh /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/AWB2SLT/awb_align_slt/ /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/AWB2SLT/awb_align_slt
sh src/estbinarytoascii.sh /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/CLB2SLT/clb_align_slt/ /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/CLB2SLT/clb_align_slt
sh src/estbinarytoascii.sh /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/KSP2SLT/ksp_align_slt/ /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/KSP2SLT/ksp_align_slt
sh src/estbinarytoascii.sh /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/RMS2SLT/rms_align_slt/ /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/RMS2SLT/rms_align_slt
sh src/estbinarytoascii.sh /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/BDL2SLT/bdl_align_slt/ /home/bajibabu/Lab_work/Voice_conversion/parallel_VC/BDL2SLT/bdl_align_slt


#sh mcd.sh ../../BDL_AF/mcep ../../own_EXP/KSP2BDL/unsmoothed_mcep/ ../../own_EXP/scores/KSP2BDL_own_exp
#sh mcd.sh ../../BDL_AF/mcep ../../own_EXP/SLT2BDL/unsmoothed_mcep/ ../../own_EXP/scores/SLT2BDL_own_exp
#sh mcd.sh ../../BDL_AF/mcep ../../own_EXP/RMS2BDL/unsmoothed_mcep/ ../../own_EXP/scores/RMS2BDL_own_exp
#sh mcd.sh ../../BDL_AF/mcep ../../own_EXP/CLB2BDL/unsmoothed_mcep/ ../../own_EXP/scores/CLB2BDL_own_exp
#sh mcd.sh ../../BDL_AF/mcep ../../own_EXP/AWB2BDL/unsmoothed_mcep/ ../../own_EXP/scores/AWB2BDL_own_exp
