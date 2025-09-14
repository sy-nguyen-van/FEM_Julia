# -*- coding: mbcs -*-
#
# Abaqus/CAE Release 2022 replay file
# Internal Version: 2021_09_15-13.57.30 176069
# Run by snv22002 on Sun Sep 14 11:32:20 2025
#

# from driverUtils import executeOnCaeGraphicsStartup
# executeOnCaeGraphicsStartup()
#: Executing "onCaeGraphicsStartup()" in the site directory ...
from abaqus import *
from abaqusConstants import *
session.Viewport(name='Viewport: 1', origin=(0.0, 0.0), width=194.972900390625, 
    height=208.755569458008)
session.viewports['Viewport: 1'].makeCurrent()
session.viewports['Viewport: 1'].maximize()
from caeModules import *
from driverUtils import executeOnCaeStartup
executeOnCaeStartup()
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=ON)
openMdb(
    pathName='C:/Users/snv22002/Documents/GitHub/FEM_Julia/Abaqus_Mesh/Lbracket3d.cae')
#: The model database "C:\Users\snv22002\Documents\GitHub\FEM_Julia\Abaqus_Mesh\Lbracket3d.cae" has been opened.
session.viewports['Viewport: 1'].setValues(displayedObject=None)
p = mdb.models['Model-1'].parts['Part-1']
session.viewports['Viewport: 1'].setValues(displayedObject=p)
a = mdb.models['Model-1'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(
    optimizationTasks=OFF, geometricRestrictions=OFF, stopConditions=OFF)
mdb.jobs['Lbracket3d'].submit(consistencyChecking=OFF)
#: The job input file "Lbracket3d.inp" has been submitted for analysis.
#: Job Lbracket3d: Analysis Input File Processor completed successfully.
#: Job Lbracket3d: Abaqus/Standard completed successfully.
#: Job Lbracket3d completed successfully. 
o3 = session.openOdb(
    name='C:/Users/snv22002/Documents/GitHub/FEM_Julia/Abaqus_Mesh/Lbracket3d.odb')
#: Model: C:/Users/snv22002/Documents/GitHub/FEM_Julia/Abaqus_Mesh/Lbracket3d.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     1
#: Number of Meshes:             1
#: Number of Element Sets:       1
#: Number of Node Sets:          3
#: Number of Steps:              1
session.viewports['Viewport: 1'].setValues(displayedObject=o3)
session.viewports['Viewport: 1'].makeCurrent()
session.viewports['Viewport: 1'].odbDisplay.display.setValues(plotState=(
    CONTOURS_ON_DEF, ))
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='U', outputPosition=NODAL, refinement=(INVARIANT, 
    'Magnitude'), )
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='S', outputPosition=INTEGRATION_POINT, refinement=(INVARIANT, 
    'Mises'), )
session.viewports['Viewport: 1'].view.setValues(nearPlane=215.325, 
    farPlane=380.137, width=213.521, height=97.6135, viewOffsetX=38.3279, 
    viewOffsetY=0.950337)
a = mdb.models['Model-1'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(mesh=ON)
session.viewports['Viewport: 1'].assemblyDisplay.meshOptions.setValues(
    meshTechnique=ON)
p = mdb.models['Model-1'].parts['Part-1']
session.viewports['Viewport: 1'].setValues(displayedObject=p)
session.viewports['Viewport: 1'].partDisplay.setValues(mesh=ON)
session.viewports['Viewport: 1'].partDisplay.meshOptions.setValues(
    meshTechnique=ON)
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=OFF)
o7 = session.odbs['C:/Users/snv22002/Documents/GitHub/FEM_Julia/Abaqus_Mesh/Lbracket3d.odb']
session.viewports['Viewport: 1'].setValues(displayedObject=o7)
session.viewports['Viewport: 1'].view.setValues(nearPlane=216.336, 
    farPlane=379.125, width=214.524, height=98.0718, viewOffsetX=48.3396, 
    viewOffsetY=-0.409204)
