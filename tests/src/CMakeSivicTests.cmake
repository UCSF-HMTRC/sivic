# 
#   Copyright © 2009-2011 The Regents of the University of California.
#   All Rights Reserved.
# 
#   Redistribution and use in source and binary forms, with or without
#   modification, are permitted provided that the following conditions are met:
#   •   Redistributions of source code must retain the above copyright notice,
#       this list of conditions and the following disclaimer.
#   •   Redistributions in binary form must reproduce the above copyright notice,
#       this list of conditions and the following disclaimer in the documentation
#       and/or other materials provided with the distribution.
#   •   None of the names of any campus of the University of California, the name
#       "The Regents of the University of California," or the names of any of its
#       contributors may be used to endorse or promote products derived from this
#       software without specific prior written permission.
# 
#   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
#   ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#   WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
#   IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
#   INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
#   NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
#   PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
#   WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
#   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
#   OF SUCH DAMAGE.
#

#
#   $URL$
#   $Rev$
#   $Author$
#   $Date$
#
#   Authors:
#       Jason C. Crane, Ph.D.
#       Beck Olson


#############################################################
#   Paths to binary applications and scripts
#############################################################
SET( TEST_SCRIPT_PATH ${CMAKE_SOURCE_DIR}/trunk/tests/scripts)
SET( TEST_BIN_PATH_CMD_LINE ${CMAKE_BINARY_DIR}/trunk/applications/cmd_line/${PLATFORM})
SET( TEST_BIN_PATH_TESTS ${CMAKE_BINARY_DIR}/trunk/tests/${PLATFORM})

#############################################################
#   Location where output files from individual tests 
#   are written to. 
#############################################################
SET( TEST_RESULTS_ROOT ${SVK_TEST_ROOT}/results_tmp)
file( MAKE_DIRECTORY [ ${TEST_RESULTS_ROOT} ] )

#############################################################
#   Flags for diff to avoid errors from minor differences in 
#   paths and rootnames in header files and provenance. 
#############################################################
SET( DIFF_OPT --ignore-matching-lines=SVK_ --ignore-matching-lines=root --exclude=.svn)
SET( DIFF_OPT_DCM --ignore-matching-lines=UID --ignore-matching-lines="0008,0000" --ignore-matching-lines="0020,0000" --exclude=.svn )

########################
#   
########################
SET( TEST_NAME INSTANTIATION_TEST_MCHK)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkInstantiationTest )

#############################################################
#   Tests are in pairs:
#     - odd tests are calls to svk binaries which can be tested with valgrind
#       for memory checking (dynamic ctest analysis).  Files are generated from  
#       these tests into $(TEST_RESULTS_ROOT).  Even tests check for run-time errors
#       and memory allocation. 
#     - even tests diff result files generated in the odd test against a baseline 
#       file.  Even test check for processing correctness. 
#############################################################

########################
#   20X GE Raw to DDF
########################
SET( TEST_NAME TEST_MCHK_20XPF_2_DDF)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/ge_pfiles/20x)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/20_x_raw -o${TEST_RESULTS_PATH}/out -t 2 )

SET( TEST_NAME TEST_20XPF_2_DDF_DIFF)
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${PLATFORM} )
SET_TESTS_PROPERTIES(TEST_20XPF_2_DDF_DIFF PROPERTIES DEPENDS TEST_MCHK_20XPF_2_DDF)

########################
#   15X GE Raw to DDF
########################
SET( TEST_NAME TEST_MCHK_15XPF_2_DDF)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/ge_pfiles/15x)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/15x_raw -o${TEST_RESULTS_PATH}/out -t 2 )

SET( TEST_NAME TEST_15XPF_2_DDF_DIFF)
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${PLATFORM} )
SET_TESTS_PROPERTIES(TEST_15XPF_2_DDF_DIFF PROPERTIES DEPENDS TEST_MCHK_15XPF_2_DDF)


########################
#   14X GE Raw to DDF
########################
SET( TEST_NAME TEST_MCHK_14XPF_2_DDF)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/ge_pfiles/14x)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/14x_raw -o${TEST_RESULTS_PATH}/out -t 2 )

SET( TEST_NAME TEST_14XPF_2_DDF_DIFF)
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${PLATFORM} )
SET_TESTS_PROPERTIES(TEST_14XPF_2_DDF_DIFF PROPERTIES DEPENDS TEST_MCHK_14XPF_2_DDF)


########################
#   12X GE Raw to DDF
########################
SET( TEST_NAME TEST_MCHK_12XPF_2_DDF)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/ge_pfiles/12x)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/12x_raw -o${TEST_RESULTS_PATH}/out -t 2 )

SET( TEST_NAME TEST_12XPF_2_DDF_DIFF)
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${PLATFORM} )
SET_TESTS_PROPERTIES(TEST_12XPF_2_DDF_DIFF PROPERTIES DEPENDS TEST_MCHK_12XPF_2_DDF)


########################
#   11X GE Raw to DDF
########################
SET( TEST_NAME TEST_MCHK_11XPF_2_DDF)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/ge_pfiles/11x)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/11x_raw -o${TEST_RESULTS_PATH}/out -t 2 )

SET( TEST_NAME TEST_11XPF_2_DDF_DIFF)
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${PLATFORM} )
SET_TESTS_PROPERTIES(TEST_11XPF_2_DDF_DIFF PROPERTIES DEPENDS TEST_MCHK_11XPF_2_DDF)


########################
#   UCSF ddf to UCSF DDF
########################
SET( TEST_NAME TEST_MCHK_DDF_2_DDF)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/ddf_files/ddf_to_ddf)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/20x_1.ddf -o${TEST_RESULTS_PATH}/out -t 2 )

SET( TEST_NAME TEST_DDF_2_DDF_DIFF)
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${PLATFORM} )
SET_TESTS_PROPERTIES(TEST_DDF_2_DDF_DIFF PROPERTIES DEPENDS TEST_MCHK_DDF_2_DDF)


########################
#   DICOM MRI to UCSF IDF 
########################
SET( TEST_NAME TEST_MCHK_DCMMRI_2_IDF)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/DICOM/mri_phantom)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/E0000S4I1.DCM -o${TEST_RESULTS_PATH}/out -t 3 )

SET( TEST_NAME TEST_DCMMRI_2_IDF_DIFF)
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out_1 )
SET_TESTS_PROPERTIES(TEST_DCMMRI_2_IDF_DIFF PROPERTIES DEPENDS TEST_MCHK_DCMMRI_2_IDF)


########################
#   DICOM MRI to DICOM MRI 
########################
SET( TEST_NAME TEST_MCHK_DCMMRI_2_DCMMRI)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/DICOM/mri_phantom)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/E0000S4I1.DCM -o${TEST_RESULTS_PATH}/out.dcm -t 6 )

SET( TEST_NAME TEST_DCMMRI_2_DCMMRI_XML)
ADD_TEST(${TEST_NAME} /netopt/dicom/bin/dcm2xml +M +Wb ${TEST_RESULTS_PATH}/out.dcm ${TEST_RESULTS_PATH}/out.xml ) 
SET_TESTS_PROPERTIES(TEST_DCMMRI_2_DCMMRI_XML PROPERTIES DEPENDS TEST_MCHK_DCMMRI_2_DCMMRI)
   
SET( TEST_NAME TEST_DCMMRI_2_DCMMRI_DIFF)
ADD_TEST(${TEST_NAME} diff ${DIFF_OPT_DCM} -r ${TEST_RESULTS_PATH}/out.xml ${TEST_CASE_ROOT}/out_2/out.xml ) 
SET_TESTS_PROPERTIES(TEST_DCMMRI_2_DCMMRI_DIFF PROPERTIES DEPENDS TEST_DCMMRI_2_DCMMRI_XML)


########################
#   UCSF IDF to UCSF IDF 
#   int2
########################
SET( TEST_NAME TEST_MCHK_IDF_2_IDF_INT2)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/idf_files/idf_to_idf_int2)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/vol.idf -o${TEST_RESULTS_PATH}/out -t 3 )

SET( TEST_NAME TEST_IDF_2_IDF_INT2_DIFF)
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${PLATFORM} )
SET_TESTS_PROPERTIES(TEST_IDF_2_IDF_INT2_DIFF PROPERTIES DEPENDS TEST_MCHK_IDF_2_IDF_INT2)


########################
#   UCSF IDF to UCSF IDF 
#   real 
########################
SET( TEST_NAME TEST_MCHK_IDF_2_IDF_REAL)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/idf_files/idf_to_idf_real)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/vol.idf -o${TEST_RESULTS_PATH}/out -t 3 )

SET( TEST_NAME TEST_IDF_2_IDF_REAL_DIFF)
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out )
SET_TESTS_PROPERTIES(TEST_IDF_2_IDF_REAL_DIFF PROPERTIES DEPENDS TEST_MCHK_IDF_2_IDF_REAL)


########################
#   VARIAN fdf to UCSF IDF 
########################
SET( TEST_NAME TEST_MCHK_FDF_2_IDF)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/varian/fdf)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/lac.0001.fdf -o${TEST_RESULTS_PATH}/out -t 3 )

SET( TEST_NAME TEST_FDF_2_IDF_DIFF)
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${PLATFORM} )
SET_TESTS_PROPERTIES(TEST_FDF_2_IDF_DIFF PROPERTIES DEPENDS TEST_MCHK_FDF_2_IDF)


########################
#   VARIAN fid to UCSF DDF 
########################
SET( TEST_NAME TEST_MCHK_VARIANFID_2_DDF)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/varian/fid_cs)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/fid -o${TEST_RESULTS_PATH}/out -t 2 )

SET( TEST_NAME TEST_VARIANFID_2_DDF_DIFF )
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${PLATFORM} )
SET_TESTS_PROPERTIES(TEST_VARIANFID_2_DDF_DIFF PROPERTIES DEPENDS TEST_MCHK_VARIANFID_2_DDF)


########################
#   GE Signa 5x to UCSF IDF 
########################
SET( TEST_NAME TEST_MCHK_SIGNA5X_2_IDF)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/ge_signa_files/Signa5x)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/E8668S3I1.MR -o${TEST_RESULTS_PATH}/out -t 3 )

SET( TEST_NAME TEST_SIGNA5X_2_IDF_DIFF)
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${PLATFORM} )
SET_TESTS_PROPERTIES(TEST_SIGNA5X_2_IDF_DIFF PROPERTIES DEPENDS TEST_MCHK_SIGNA5X_2_IDF)


########################
#   GE Signa 5x V2 to UCSF IDF 
########################
SET( TEST_NAME TEST_MCHK_SIG5XV2_2_IDF)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/ge_signa_files/Signa5XVersion2)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/E18636S3I1.MR -o${TEST_RESULTS_PATH}/out -t 3 )

SET( TEST_NAME TEST_SIG5XV2_2_IDF_DIFF)
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${PLATFORM} )
SET_TESTS_PROPERTIES(TEST_SIG5XV2_2_IDF_DIFF PROPERTIES DEPENDS TEST_MCHK_SIG5XV2_2_IDF)



########################
#   GE Signa LX2 to UCSF IDF 
########################
SET( TEST_NAME TEST_MCHK_SIGLX2_2_IDF)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/ge_signa_files/SignaLX2)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/E12916S3I1.MR -o${TEST_RESULTS_PATH}/out -t 3 )

SET( TEST_NAME TEST_SIGLX2_2_IDF_DIFF)
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${PLATFORM} )
SET_TESTS_PROPERTIES(TEST_SIGLX2_2_IDF_DIFF PROPERTIES DEPENDS TEST_MCHK_SIGLX2_2_IDF)


########################
#   SIEMENS RDA to DDF
########################
SET( TEST_NAME TEST_MCHK_RDA_2_DDF)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/siemens_rda/sv)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/sample.rda -o${TEST_RESULTS_PATH}/out -t 2 )

SET( TEST_NAME TEST_RDA_2_DDF_DIFF)
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/${PLATFORM} )
SET_TESTS_PROPERTIES(TEST_RDA_2_DDF_DIFF PROPERTIES DEPENDS TEST_MCHK_RDA_2_DDF)


########################
#   DICOM MRS to DICOM MRS 
#   only checks the header
########################
SET( TEST_NAME TEST_MCHK_DCMMRS_2_DCMMRS)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/DICOM/mrs)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/mrs.dcm -o${TEST_RESULTS_PATH}/out.dcm -t 4 )

SET( TEST_NAME TEST_DCMMRS_2_DCMMRS_XML)
ADD_TEST(${TEST_NAME} /netopt/dicom/bin/dcm2xml +M +Wb ${TEST_RESULTS_PATH}/out.dcm ${TEST_RESULTS_PATH}/out.xml ) 
SET_TESTS_PROPERTIES(TEST_DCMMRS_2_DCMMRS_XML PROPERTIES DEPENDS TEST_MCHK_DCMMRS_2_DCMMRS)

SET( TEST_NAME TEST_DCMMRS_2_DCMMRS_DIFF )
ADD_TEST(${TEST_NAME} diff ${DIFF_OPT_DCM} -r ${TEST_RESULTS_PATH}/out.xml ${TEST_CASE_ROOT}/${PLATFORM}/out.xml)
SET_TESTS_PROPERTIES(TEST_DCMMRS_2_DCMMRS_DIFF PROPERTIES DEPENDS TEST_DCMMRS_2_DCMMRS_XML)


########################
#   PFile Reader Tests: 
########################
SET( TEST_NAME TEST_MCHK_GEPFILE_2_DDF_1)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME}/ )
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/ge_pfiles/14x_mbrease)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_gepfile_reader -i ${TEST_CASE_ROOT}/input/mbrease_teavg -o${TEST_RESULTS_PATH}/out -t 2 -as )

SET( TEST_NAME TEST_GEPFILE_2_DDF_1_DIFF)
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out_4 )
SET_TESTS_PROPERTIES(TEST_GEPFILE_2_DDF_1_DIFF PROPERTIES DEPENDS TEST_MCHK_GEPFILE_2_DDF_1)


########################
#   PFile Reader Tests: 
#   this one is too large for valgrind 
#   so turn off MCHK for now:
########################
SET( TEST_NAME TEST_MCHK_GEPFILE_2_DDF_2)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/ge_pfiles/14x_mbrease)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_gepfile_reader -i ${TEST_CASE_ROOT}/input/mbrease_teavg -o${TEST_RESULTS_PATH}/out -t 2 -a -u --deid_type 1 --deid_pat_id DEID_PATID --deid_study_id DEID_STUDYID )

SET( TEST_NAME TEST_GEPFILE_2_DDF_2_DIFF)
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out_6 )
SET_TESTS_PROPERTIES(TEST_GEPFILE_2_DDF_2_DIFF PROPERTIES DEPENDS TEST_MCHK_GEPFILE_2_DDF_2)


########################
#   PFile Reader Tests: 
#   this one is too large for valgrind 
#   so turn off MCHK for now:
########################
SET( TEST_NAME TEST_MCHK_GEPFILE_2_DDF_LAC)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/ge_pfiles/14x_lac_flyback)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_gepfile_reader -i ${TEST_CASE_ROOT}/input/14x_lac_flyback -o${TEST_RESULTS_PATH}/out -t 2  --deid_type 1 --deid_pat_id DEID_PATID --deid_study_id DEID_STUDYID --one_time_pt)

SET( TEST_NAME TEST_GEPFILE_2_DDF_LAC_DIFF)
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out )
SET_TESTS_PROPERTIES(TEST_GEPFILE_2_DDF_LAC_DIFF PROPERTIES DEPENDS TEST_MCHK_GEPFILE_2_DDF_LAC)


########################
#   Oblique Reslice: 
########################
SET( TEST_NAME TEST_MCHK_OBLIQUE_RESLICE)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/reslicing/axial_to_oblique)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_reslice -i ${TEST_CASE_ROOT}/input/axial_vol.idf --target ${TEST_CASE_ROOT}/input/oblique_mrsvol.ddf -o${TEST_RESULTS_PATH}/out -t 3 )

SET( TEST_NAME TEST_OBLIQUE_RESLICE_DIFF)
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out )
SET_TESTS_PROPERTIES(TEST_OBLIQUE_RESLICE_DIFF PROPERTIES DEPENDS TEST_MCHK_OBLIQUE_RESLICE)


########################
#   Metabolite Map Generation
########################
SET( TEST_NAME TEST_MCHK_INTEGRATE_MET_MAP)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/met_maps/integration_pk_ht)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_quantify -i ${TEST_CASE_ROOT}/input/mrs.ddf -o${TEST_RESULTS_PATH}/out -t 3 --peak_center 1.99 --peak_width .4 --peak_name NAA --algo 2)

SET( TEST_NAME TEST_INTEGRATE_MET_MAP_DIFF)
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out )
SET_TESTS_PROPERTIES(TEST_INTEGRATE_MET_MAP_DIFF PROPERTIES DEPENDS TEST_MCHK_INTEGRATE_MET_MAP)


########################
#   MRS FFT test: 
########################
SET( TEST_NAME TEST_MCHK_MRS_FFT )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/mrs_fft)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkMrsImageFFT ${TEST_CASE_ROOT}/input/raw.ddf ${TEST_RESULTS_PATH}/recon )

SET( TEST_NAME TEST_MRS_FFT_DIFF )
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out )
SET_TESTS_PROPERTIES(TEST_MRS_FFT_DIFF PROPERTIES DEPENDS TEST_MCHK_MRS_FFT)

########################
#   MRI FFT test: 
########################
SET( TEST_NAME TEST_MCHK_EVEN_MRI_FFT )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/mri_fft)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkMriImageFFTTest ${TEST_CASE_ROOT}/input/testBoxEven.idf ${TEST_RESULTS_PATH} )

SET( TEST_NAME TEST_EVEN_MRI_FFT_DIFF )
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out_even )
SET_TESTS_PROPERTIES(TEST_EVEN_MRI_FFT_DIFF PROPERTIES DEPENDS TEST_MCHK_EVEN_MRI_FFT)

########################
#   MRI FFT test: 
########################
SET( TEST_NAME TEST_MCHK_ODD_MRI_FFT )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/mri_fft)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkMriImageFFTTest ${TEST_CASE_ROOT}/input/testBoxOdd.idf ${TEST_RESULTS_PATH} )

SET( TEST_NAME TEST_ODD_MRI_FFT_DIFF )
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out_odd )
SET_TESTS_PROPERTIES(TEST_ODD_MRI_FFT_DIFF PROPERTIES DEPENDS TEST_MCHK_ODD_MRI_FFT)

####################################################
#   Image center test for even image dimensions
####################################################
SET( TEST_NAME TEST_MCHK_EVEN_IMAGE_CENTER )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/image_center)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkImageFourierCenterTest ${TEST_CASE_ROOT}/input/constantEven.idf ${TEST_RESULTS_PATH} )

SET( TEST_NAME TEST_EVEN_IMAGE_CENTER_DIFF )
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out_even )
SET_TESTS_PROPERTIES(TEST_EVEN_IMAGE_CENTER_DIFF PROPERTIES DEPENDS TEST_MCHK_EVEN_IMAGE_CENTER)

####################################################
#   Image center test for odd image dimensions
####################################################
SET( TEST_NAME TEST_MCHK_ODD_IMAGE_CENTER )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/image_center)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkImageFourierCenterTest ${TEST_CASE_ROOT}/input/constantOdd.idf ${TEST_RESULTS_PATH} )

SET( TEST_NAME TEST_ODD_IMAGE_CENTER_DIFF )
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out_odd )
SET_TESTS_PROPERTIES(TEST_ODD_IMAGE_CENTER_DIFF PROPERTIES DEPENDS TEST_MCHK_ODD_IMAGE_CENTER)

########################
#   Image padding test: 
########################
SET( TEST_NAME TEST_MCHK_EVEN_IMAGE_PAD )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/image_pad)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkMriZeroFillTest ${TEST_CASE_ROOT}/input/testBoxCenterEven.idf ${TEST_RESULTS_PATH} )

SET( TEST_NAME TEST_EVEN_IMAGE_PAD_DIFF )
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out_even )
SET_TESTS_PROPERTIES(TEST_EVEN_IMAGE_PAD_DIFF PROPERTIES DEPENDS TEST_MCHK_EVEN_IMAGE_PAD)

########################
#   Image padding test: 
########################
SET( TEST_NAME TEST_MCHK_ODD_IMAGE_PAD )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/image_pad)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkMriZeroFillTest ${TEST_CASE_ROOT}/input/testBoxCenterOdd.idf ${TEST_RESULTS_PATH} )

SET( TEST_NAME TEST_ODD_IMAGE_PAD_DIFF )
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out_odd )
SET_TESTS_PROPERTIES(TEST_ODD_IMAGE_PAD_DIFF PROPERTIES DEPENDS TEST_MCHK_ODD_IMAGE_PAD)

########################
#   Spectra padding test: 
########################
SET( TEST_NAME TEST_MCHK_MRS_ZERO_FILL )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/mrs_zero_fill)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkMrsZeroFillTest ${SVK_TEST_ROOT}/mrs_zero_fill/input/delta.ddf ${TEST_RESULTS_PATH}/out )

SET( TEST_NAME TEST_MRS_ZERO_FILL_DIFF )
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out )
SET_TESTS_PROPERTIES(TEST_MRS_ZERO_FILL_DIFF PROPERTIES DEPENDS TEST_MCHK_MRS_ZERO_FILL)

########################
#   voxel shifting: 
########################
SET( TEST_NAME TEST_MCHK_MRS_VOXEL_SHIFT )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/mrs_voxel_shift)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkMrsFFTVoxelShiftTest ${SVK_TEST_ROOT}/mrs_zero_fill/input/delta.ddf ${TEST_RESULTS_PATH}/out )

SET( TEST_NAME TEST_MRS_VOXEL_SHIFT_DIFF )
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out )
SET_TESTS_PROPERTIES(TEST_MRS_VOXEL_SHIFT_DIFF PROPERTIES DEPENDS TEST_MCHK_MRS_VOXEL_SHIFT)

########################
#   Spectra phase test: 
########################
SET( TEST_NAME TEST_PHASE_SPEC )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/phase_spec)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkMrsLinearPhaseTest ${SVK_TEST_ROOT}/mrs_zero_fill/input/delta.ddf ${TEST_RESULTS_PATH}/out )

SET( TEST_NAME TEST_PHASE_SPEC_DIFF )
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out )
SET_TESTS_PROPERTIES(TEST_PHASE_SPEC_DIFF PROPERTIES DEPENDS TEST_PHASE_SPEC )


##############################
#   Image linear phase test: 
##############################
SET( TEST_NAME TEST_MCHK_EVEN_IMAGE_LINEAR_PHASE )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/image_linear_phase)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkImageLinearPhaseTest ${TEST_CASE_ROOT}/input/testBoxEven.idf ${TEST_RESULTS_PATH} )

SET( TEST_NAME TEST_EVEN_IMAGE_LINEAR_PHASE_DIFF )
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out_even )
SET_TESTS_PROPERTIES(TEST_EVEN_IMAGE_LINEAR_PHASE_DIFF PROPERTIES DEPENDS TEST_MCHK_EVEN_IMAGE_LINEAR_PHASE)


##############################
#   Image linear phase test: 
##############################
SET( TEST_NAME TEST_MCHK_ODD_IMAGE_LINEAR_PHASE )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/image_linear_phase)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkImageLinearPhaseTest ${TEST_CASE_ROOT}/input/testBoxOdd.idf ${TEST_RESULTS_PATH} )

SET( TEST_NAME TEST_ODD_IMAGE_LINEAR_PHASE_DIFF )
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out_odd )
SET_TESTS_PROPERTIES(TEST_ODD_IMAGE_LINEAR_PHASE_DIFF PROPERTIES DEPENDS TEST_MCHK_ODD_IMAGE_LINEAR_PHASE)


##############################
#   sinc interpolate test for even data set: 
##############################
SET( TEST_NAME TEST_MCHK_EVEN_SINC_INTERPOLATE )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/sinc_interpolate)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkSincInterpolateTest ${TEST_CASE_ROOT}/input/testBoxCenterEven.idf ${TEST_RESULTS_PATH} )

SET( TEST_NAME TEST_EVEN_SINC_INTERPOLATE_DIFF )
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out_even )
SET_TESTS_PROPERTIES(TEST_EVEN_SINC_INTERPOLATE_DIFF PROPERTIES DEPENDS TEST_MCHK_EVEN_SINC_INTERPOLATE)

##############################
#   sinc interpolate test for odd data set: 
##############################
SET( TEST_NAME TEST_MCHK_ODD_SINC_INTERPOLATE )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/sinc_interpolate)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkSincInterpolateTest ${TEST_CASE_ROOT}/input/testBoxCenterOdd.idf ${TEST_RESULTS_PATH} )

SET( TEST_NAME TEST_ODD_SINC_INTERPOLATE_DIFF )
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out_odd )
SET_TESTS_PROPERTIES(TEST_ODD_SINC_INTERPOLATE_DIFF PROPERTIES DEPENDS TEST_MCHK_ODD_SINC_INTERPOLATE)


########################
#   Data combining test: 
########################
SET( TEST_NAME TEST_MCHK_COMBINE )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/combining)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkMrsCombine ${TEST_CASE_ROOT}/input/phantom_8ch.dcm ${TEST_RESULTS_PATH}/out )

SET( TEST_NAME TEST_COMBINE_DIFF )
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out )
SET_TESTS_PROPERTIES(TEST_COMBINE_DIFF PROPERTIES DEPENDS TEST_MCHK_COMBINE)


########################
#   Read Sym EPSI data test: 
########################
SET( TEST_NAME TEST_MCHK_READ_SYM_EPSI)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/sym_epsi)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_gepfile_reader -i ${TEST_CASE_ROOT}/input/c13_3d_raw -o ${TEST_RESULTS_PATH}/out -t2 )

SET( TEST_NAME TEST_READ_SYM_EPSI_DIFF )
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/output )
SET_TESTS_PROPERTIES(TEST_READ_SYM_EPSI_DIFF PROPERTIES DEPENDS TEST_MCHK_READ_SYM_EPSI)


########################
#   Read GE .shf file (sdbm) test: 
########################
SET( TEST_NAME TEST_MCHK_READ_GE_SHF )
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/ge_sdbm_files )
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/test.shf -o ${TEST_RESULTS_PATH}/out -t2 )

SET( TEST_NAME TEST_READ_GE_SHF_DIFF )
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/output )
SET_TESTS_PROPERTIES(TEST_READ_GE_SHF_DIFF PROPERTIES DEPENDS TEST_MCHK_READ_GE_SHF)


########################
#   Convert GE Postage Stamp file to DDF test:
########################
SET( TEST_NAME TEST_MCHK_GE_POSTAGE_TO_DDF)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME} )
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/ge_postage_stamp)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert -i ${TEST_CASE_ROOT}/input/000001.DCM -o ${TEST_RESULTS_PATH}/out -t2 )

SET( TEST_NAME TEST_GE_POSTAGE_TO_DDF_DIFF )
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/output )
SET_TESTS_PROPERTIES(TEST_GE_POSTAGE_TO_DDF_DIFF PROPERTIES DEPENDS TEST_MCHK_GE_POSTAGE_TO_DDF)


########################
#   apodization test: 
########################
SET( TEST_NAME TEST_MCHK_MRS_APODIZATION)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/mrs_apodization)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_TESTS}/svkMrsApodizationFilterTest  ${SVK_TEST_ROOT}/ge_pfiles/20x/input/20_x_raw ${TEST_RESULTS_PATH}/out )

SET( TEST_NAME TEST_MRS_APODIZATION_DIFF)
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/out )
SET_TESTS_PROPERTIES(TEST_MRS_APODIZATION_DIFF PROPERTIES DEPENDS TEST_MCHK_MRS_APODIZATION)


########################
#   multi-volume DICIOM 2 IDF test: 
########################
SET( TEST_NAME TEST_MCHK_MULTI_VOL_DCM_2_IDF)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/multi_volume)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert ${TEST_CASE_ROOT}/input/E10755S2I1.DCM ${TEST_RESULTS_PATH}/out -t3 )

SET( TEST_NAME TEST_MULTI_VOL_DCM_2_IDF_DIFF)
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/output_dcm )
SET_TESTS_PROPERTIES(TEST_MULTI_VOL_DCM_2_IDF_DIFF PROPERTIES DEPENDS TEST_MCHK_MULTI_VOL_DCM_2_IDF)


########################
#   multi-volume IDF 2 IDF test: 
########################
SET( TEST_NAME TEST_MCHK_MULTI_VOL_IDF_2_IDF)
SET( TEST_RESULTS_PATH ${TEST_RESULTS_ROOT}/${TEST_NAME})
file( MAKE_DIRECTORY [ ${TEST_RESULTS_PATH} ] )
SET( TEST_CASE_ROOT ${SVK_TEST_ROOT}/multi_volume)
ADD_TEST(${TEST_NAME}  ${TEST_BIN_PATH_CMD_LINE}/svk_file_convert ${TEST_CASE_ROOT}/input/vol_1.idf ${TEST_RESULTS_PATH}/out -t3 )

SET( TEST_NAME TEST_MULTI_VOL_IDF_2_IDF_DIFF)
ADD_TEST(${TEST_NAME}  diff ${DIFF_OPT} -r ${TEST_RESULTS_PATH} ${TEST_CASE_ROOT}/output_idf )
SET_TESTS_PROPERTIES(TEST_MULTI_VOL_IDF_2_IDF_DIFF PROPERTIES DEPENDS TEST_MCHK_MULTI_VOL_IDF_2_IDF)

