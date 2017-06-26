vtk_module(vtkDomainsChemistryOpenGL2
  TCL_NAME
    vtkRenderingChemistryOpenGLII
  IMPLEMENTS
    vtkDomainsChemistry
  BACKEND
    OpenGL2
  IMPLEMENTATION_REQUIRED_BY_BACKEND
  KIT
    vtkOpenGL
  TEST_DEPENDS
    vtkIOGeometry
    vtkTestingCore
    vtkTestingRendering
    vtkInteractionStyle
    vtkRendering${VTK_RENDERING_BACKEND}
    ${extra_opengl_depend}
  DEPENDS
    vtkCommonCore
    vtkDomainsChemistry
    vtkRenderingOpenGL2
  PRIVATE_DEPENDS
    vtkCommonDataModel
    vtkCommonExecutionModel
    vtkCommonMath
    vtkRenderingCore
    vtkglew
  )