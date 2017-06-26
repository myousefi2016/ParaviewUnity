vtk_module(vtkImagingFourier
  GROUPS
    Imaging
    StandAlone
  KIT
    vtkImaging
  DEPENDS
    vtkCommonCore
    vtkCommonExecutionModel
    vtkImagingCore
  PRIVATE_DEPENDS
    vtkCommonDataModel
    vtksys
  )