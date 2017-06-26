/*=========================================================================

  Program:   ParaView
  Module:    vtkPVLightingHelper.cxx

  Copyright (c) Kitware, Inc.
  All rights reserved.
  See Copyright.txt or http://www.paraview.org/HTML/Copyright.html for details.

     This software is distributed WITHOUT ANY WARRANTY; without even
     the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
     PURPOSE.  See the above copyright notice for more information.

=========================================================================*/
#include "vtkPVLightingHelper.h"

#include "vtkObjectFactory.h"
#include "vtkShader2Collection.h"
#include "vtkShaderProgram2.h"
#include "vtkgl.h"

extern const char* vtkPVLightingHelper_s;

vtkStandardNewMacro(vtkPVLightingHelper);
vtkCxxSetObjectMacro(vtkPVLightingHelper, Shader, vtkShaderProgram2);
//----------------------------------------------------------------------------
vtkPVLightingHelper::vtkPVLightingHelper()
{
  this->Shader = 0;
}

//----------------------------------------------------------------------------
vtkPVLightingHelper::~vtkPVLightingHelper()
{
  this->SetShader(0);
}

//----------------------------------------------------------------------------
void vtkPVLightingHelper::Initialize(vtkShaderProgram2* pgm, vtkShader2Type mode)
{
  if (this->Shader != pgm)
  {
    this->SetShader(pgm);
    if (pgm)
    {
      vtkShader2* s = vtkShader2::New();
      s->SetSourceCode(vtkPVLightingHelper_s);
      s->SetType(mode);
      s->SetContext(this->Shader->GetContext());
      this->Shader->GetShaders()->AddItem(s);
      s->Delete();
    }
  }
}

//----------------------------------------------------------------------------
#define VTK_MAX_LIGHTS 8
void vtkPVLightingHelper::PrepareForRendering()
{
  GLint ivalue;
  glGetIntegerv(vtkgl::CURRENT_PROGRAM, &ivalue);
  if (ivalue != 0)
  {
    vtkErrorMacro("PrepareForRendering() cannot be called after a shader program has been bound.");
    return;
  }

  for (int cc = 0; cc < VTK_MAX_LIGHTS; cc++)
  {
    // use the light's 4th diffuse component to store an enabled bit
    GLfloat lightDiffuse[4];
    glGetLightfv(GL_LIGHT0 + cc, GL_DIFFUSE, lightDiffuse);

    // enable/disable the light for fixed function
    if (glIsEnabled(GL_LIGHT0 + cc))
    {
      lightDiffuse[3] = 1;
    }
    else
    {
      lightDiffuse[3] = 0;
    }
    glLightfv(GL_LIGHT0 + cc, GL_DIFFUSE, lightDiffuse);
  }
}

//----------------------------------------------------------------------------
void vtkPVLightingHelper::PrintSelf(ostream& os, vtkIndent indent)
{
  this->Superclass::PrintSelf(os, indent);
  os << indent << "Shader: " << this->Shader << endl;
}
