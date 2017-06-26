# CoProcessing test expects the following arguments to be passed to cmake using
# -DFoo=BAR arguments.

# COPROCESSING_TEST_DRIVER -- path to CxxParticlePathExample
# COPROCESSING_TEST_DIR    -- path to temporary dir
# COPROCESSING_SOURCE_DIR -- path to where the source code with the python scripts are
# PVBATCH
# MPIEXEC
# MPIEXEC_NUMPROC_FLAG
# MPIEXEC_NUMPROCS
# MPIEXEC_PREFLAGS
# VTK_MPI_POSTFLAGS

# remove result files generated by  the test
file(REMOVE "${COPROCESSING_TEST_DIR}/particles*vtp" )

if(NOT EXISTS "${COPROCESSING_TEST_DRIVER}")
  message(FATAL_ERROR "'${COPROCESSING_TEST_DRIVER}' does not exist")
endif()

message("Executing :
      ${MPIEXEC} ${MPIEXEC_NUMPROC_FLAG} ${MPIEXEC_NUMPROCS} ${MPIEXEC_PREFLAGS}
      \"${COPROCESSING_TEST_DRIVER}\"
      \"${COPROCESSING_SOURCE_DIR}/SampleScripts/particlepath.py\"")
execute_process(COMMAND
  ${MPIEXEC} ${MPIEXEC_NUMPROC_FLAG} ${MPIEXEC_NUMPROCS} ${MPIEXEC_PREFLAGS}
  "${COPROCESSING_TEST_DRIVER}"
  "${COPROCESSING_SOURCE_DIR}/SampleScripts/particlepath.py"
  WORKING_DIRECTORY ${COPROCESSING_TEST_DIR}
  RESULT_VARIABLE rv)

if(NOT rv EQUAL 0)
  message(FATAL_ERROR "Test executable return value was ${rv}")
endif()

# below is the restarted "simulation"
message("Executing (restart):
      ${MPIEXEC} ${MPIEXEC_NUMPROC_FLAG} ${MPIEXEC_NUMPROCS} ${MPIEXEC_PREFLAGS}
      \"${COPROCESSING_TEST_DRIVER}\" --restart 50
      \"${COPROCESSING_SOURCE_DIR}/SampleScripts/particlepath.py\"")
execute_process(COMMAND
  ${MPIEXEC} ${MPIEXEC_NUMPROC_FLAG} ${MPIEXEC_NUMPROCS} ${MPIEXEC_PREFLAGS}
  "${COPROCESSING_TEST_DRIVER}" --restart 50
  "${COPROCESSING_SOURCE_DIR}/SampleScripts/particlepath.py"
  WORKING_DIRECTORY ${COPROCESSING_TEST_DIR}
  RESULT_VARIABLE rv)

if(NOT rv EQUAL 0)
  message(FATAL_ERROR "Test executable (restart) return value was ${rv}")
endif()

message("Executing :
      ${PVBATCH} ${COPROCESSING_SOURCE_DIR}/TestScripts/verifyparticlepath.py ${COPROCESSING_TEST_DIR}")

execute_process(COMMAND "${PVBATCH}" "${COPROCESSING_SOURCE_DIR}/TestScripts/verifyparticlepath.py" "${COPROCESSING_TEST_DIR}"
  RESULT_VARIABLE rv
  WORKING_DIRECTORY ${COPROCESSING_TEST_DIR})

if(NOT rv EQUAL 0)
  message(FATAL_ERROR "verifyparticlepath.py failed.")
endif()
