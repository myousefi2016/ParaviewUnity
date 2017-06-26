vtk_module(vtkIOParallel
  GROUPS
    StandAlone
  TEST_DEPENDS
    vtkParallelMPI
    vtkRenderingParallel
    vtkTestingCore
    vtkTestingRendering
  KIT
    vtkParallel
  DEPENDS
    vtkCommonCore
    vtkCommonDataModel
    vtkCommonExecutionModel
    vtkIOCore
    vtkIOGeometry
    vtkIOImage
    vtkIOLegacy
    vtkIONetCDF
  PRIVATE_DEPENDS
    vtkCommonMisc
    vtkCommonSystem
    vtkFiltersCore
    vtkFiltersExtraction
    vtkFiltersParallel
    vtkParallelCore
    vtkexodusII
    vtkjsoncpp
    vtknetcdf
    vtksys
  )