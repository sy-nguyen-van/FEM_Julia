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
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\FEM_Julia\Abaqus_Mesh\Lbracket3d.cae".
Mdb()
#: A new model database has been created.
#: The model "Model-1" has been created.
session.viewports['Viewport: 1'].setValues(displayedObject=None)
session.viewports['Viewport: 1'].partDisplay.setValues(mesh=OFF)
session.viewports['Viewport: 1'].partDisplay.meshOptions.setValues(
    meshTechnique=OFF)
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=ON)
import os
os.chdir(
    r"C:\Users\snv22002\Documents\GitHub\Julia_TPMS_TopOpt\Stress_MPI_Multiresolution_v5\Read_Mesh")
Mdb()
#: A new model database has been created.
#: The model "Model-1" has been created.
session.viewports['Viewport: 1'].setValues(displayedObject=None)
a = mdb.models['Model-1'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
mdb.ModelFromInputFile(name='Vframe_3D_Size_1_5', 
    inputFileName='C:/Users/snv22002/Documents/GitHub/Julia_TPMS_TopOpt/Stress_MPI_Multiresolution_v5/Read_Mesh/Vframe_3D_Size_1_5.inp')
#: The model "Vframe_3D_Size_1_5" has been created.
#: NoKeywordsDefinedError:  This occurred while scanning input file for fixed format and parameterized data.  
#: The model "Vframe_3D_Size_1_5" has been imported from an input file. 
#: Please scroll up to check for error and warning messages.
session.viewports['Viewport: 1'].assemblyDisplay.setValues(mesh=OFF)
session.viewports['Viewport: 1'].assemblyDisplay.meshOptions.setValues(
    meshTechnique=OFF)
a = mdb.models['Vframe_3D_Size_1_5'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].setValues(displayedObject=None)
Mdb()
#: A new model database has been created.
#: The model "Model-1" has been created.
session.viewports['Viewport: 1'].setValues(displayedObject=None)
session.viewports['Viewport: 1'].setValues(displayedObject=None)
openMdb(
    pathName='C:/Users/snv22002/Documents/GitHub/Julia_TPMS_TopOpt/CAD_FEM_Files/Vframe_3D.cae')
#: The model database "C:\Users\snv22002\Documents\GitHub\Julia_TPMS_TopOpt\CAD_FEM_Files\Vframe_3D.cae" has been opened.
session.viewports['Viewport: 1'].setValues(displayedObject=None)
p = mdb.models['Vframe_3D'].parts['Vframe_3D']
session.viewports['Viewport: 1'].setValues(displayedObject=p)
session.viewports['Viewport: 1'].view.setValues(nearPlane=243.987, 
    farPlane=413.951, width=248.947, height=113.808, viewOffsetX=12.4234, 
    viewOffsetY=-3.33892)
session.viewports['Viewport: 1'].view.setValues(nearPlane=246.738, 
    farPlane=401.299, width=251.753, height=115.092, cameraPosition=(182.784, 
    276.107, 186.398), cameraUpVector=(-0.47778, 0.358842, -0.801847), 
    cameraTarget=(63.0573, 26.1788, 9.1349), viewOffsetX=12.5634, 
    viewOffsetY=-3.37656)
session.viewports['Viewport: 1'].view.setValues(nearPlane=244.761, 
    farPlane=408.057, width=249.737, height=114.17, cameraPosition=(228.37, 
    206.891, 231.663), cameraUpVector=(-0.358175, 0.605955, -0.710303), 
    cameraTarget=(63.3226, 29.4821, 9.16305), viewOffsetX=12.4627, 
    viewOffsetY=-3.3495)
del mdb.models['Vframe_3D']
p = mdb.models['Vframe_3D_Tets'].parts['Vframe_3D']
session.viewports['Viewport: 1'].setValues(displayedObject=p)
session.viewports['Viewport: 1'].partDisplay.setValues(mesh=ON)
session.viewports['Viewport: 1'].partDisplay.meshOptions.setValues(
    meshTechnique=ON)
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=OFF)
p = mdb.models['Vframe_3D_Tets'].parts['Vframe_3D']
p.deleteMesh()
p = mdb.models['Vframe_3D_Tets'].parts['Vframe_3D']
p.seedPart(size=2.0, deviationFactor=0.1, minSizeFactor=0.1)
p = mdb.models['Vframe_3D_Tets'].parts['Vframe_3D']
p.generateMesh()
p = mdb.models['Vframe_3D_Tets'].parts['Vframe_3D']
p.deleteMesh()
p = mdb.models['Vframe_3D_Tets'].parts['Vframe_3D']
p.seedPart(size=3.0, deviationFactor=0.1, minSizeFactor=0.1)
p = mdb.models['Vframe_3D_Tets'].parts['Vframe_3D']
p.generateMesh()
session.viewports['Viewport: 1'].view.setValues(nearPlane=270.298, 
    farPlane=394.364, width=228.486, height=104.721, cameraPosition=(107.777, 
    -272.092, 145.135), cameraUpVector=(-0.612272, 0.536768, 0.580519), 
    cameraTarget=(65.3357, 26.3211, 13.3432))
session.viewports['Viewport: 1'].view.setValues(nearPlane=255.749, 
    farPlane=408.14, width=216.188, height=99.0847, cameraPosition=(194.966, 
    253.474, 220.095), cameraUpVector=(-0.84089, 0.364881, -0.399708), 
    cameraTarget=(66.2177, 31.6377, 14.1015))
session.viewports['Viewport: 1'].view.setValues(session.views['Iso'])
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\Julia_TPMS_TopOpt\CAD_FEM_Files\Vframe_3D.cae".
a = mdb.models['Vframe_3D_Tets'].rootAssembly
a.regenerate()
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(mesh=ON)
session.viewports['Viewport: 1'].assemblyDisplay.meshOptions.setValues(
    meshTechnique=ON)
session.viewports['Viewport: 1'].view.setValues(session.views['Back'])
session.viewports['Viewport: 1'].view.setProjection(projection=PARALLEL)
a = mdb.models['Vframe_3D_Tets'].rootAssembly
n1 = a.instances['Vframe_3D-1'].nodes
nodes1 = n1.getSequenceFromMask(mask=(
    '[#48 #e0000 #c0000000 #3ff #0:18 #c0e07000 #e070381', 
    ' #70381c #0:254 #100000 #0:92 #28000000 #0:3 #16000', 
    ' #0:23 #2a0 #0:15 #80000 #0:25 #a000 #0:4', 
    ' #11900000 #1 #0:35 #2000000 #0:5 #200 #0:2', 
    ' #1000 #0:3 #500 #0:3 #40000000 #0 #14', 
    ' #0 #980000 #2000c2 #10140120 #4000002 #20d000 #1', 
    ' #2900200 #34000000 #15300 #1da00000 #b01 #0 #2ad', 
    ' #0 #6005402a #700 #a0200000 #40d #4f980000 #0', 
    ' #5844000 #0:2 #10062008 #20000000 #6a #0 #400', 
    ' #0:6 #400 #0:4 #800000 #0:2 #10 #6', ' #0:2 #c0840 #400000 ]', ), )
a.Set(nodes=nodes1, name='Left')
#: The set 'Left' has been edited (168 nodes).
a = mdb.models['Vframe_3D_Tets'].rootAssembly
n1 = a.instances['Vframe_3D-1'].nodes
nodes1 = n1.getSequenceFromMask(mask=(
    '[#4800 #0:3 #e0000000 #0 #3ffc00 #0:30 #c0e07000', 
    ' #e070381 #70381c #0:524 #4 #0:6 #20 #0:6', 
    ' #54000000 #0:11 #800 #0:12 #40000000 #0:40 #8', 
    ' #0:37 #400 #0:26 #2a8000 #0:4 #a #0:3', 
    ' #1a000 #0:2 #10000000 #0:3 #100 #0:22 #40', 
    ' #0:7 #800000 #0:13 #2000 #20 #0 #4000', 
    ' #8000140 #54000a0 #1400 #bc00400 #ab #340000 #40000408', 
    ' #310908a #2200008 #450 #0:3 #30000000 #2000 #0', 
    ' #600018 #0 #100000 #20000 #0:2 #1804 #440000', 
    ' #0 #200 #20000000 #c #138c0000 #0:14 #100000', 
    ' #0 #10000000 #1 #c0001000 #0:2 #11008000 #905 ]', ), )
a.Set(nodes=nodes1, name='Right')
#: The set 'Right' has been edited (147 nodes).
a = mdb.models['Vframe_3D_Tets'].rootAssembly
n1 = a.instances['Vframe_3D-1'].nodes
nodes1 = n1.getSequenceFromMask(mask=('[#0:10 #3e0000 #0 #3e #0:51 #3e #1f00', 
    ' #f8000 #7c00000 #e0000000 #3 #1f0 #f800 #7c0000', 
    ' #3e000000 #0:787 #200000 #0:208 #8 #0:3 #4', 
    ' #0:105 #20000000 #0:44 #200 #0:38 #8 #0', 
    ' #8 #0:26 #b00 #0:3 #500a8000 #1 #0:46', 
    ' #8000000 #0:2 #30000 #0:3 #a800 #0 #50', 
    ' #0:8 #540 #0:18 #100000 #200 #0:2 #50000000', 
    ' #1 #58a828 #48000000 #6000000 #16000 #0 #18400000', 
    ' #15 #2800000 #a0 #300 #60000000 #8000001 #0:6', 
    ' #20000000 #0:3 #100000 #80000000 #0:41 #1000 #0:2', 
    ' #1000200 #0:12 #40000000 #8400 #0 #110 #0:10', 
    ' #80480008 #2a2 #0:10 #380000 #3 #0:12 #2', 
    ' #0:13 #4 #0:11 #40500003 #29 #0:3 #680', 
    ' #100 #0:4 #300 #2000 #540 #1 #0:8', 
    ' #600000 #0 #58 #0:8 #10 #0:12 #2000000', 
    ' #1102a0 #0:10 #30 #0:7 #10000000 #5000 #1', 
    ' #0:4 #80000000 #0:11 #400 #0:23 #4 #0:36', 
    ' #40000000 #0:9 #1000 #0:8 #80000000 #0:8 #100', ' #0:7 #1000 ]', ), )
a.Set(nodes=nodes1, name='Top')
#: The set 'Top' has been edited (189 nodes).
session.viewports['Viewport: 1'].view.setValues(session.views['Iso'])
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\Julia_TPMS_TopOpt\CAD_FEM_Files\Vframe_3D.cae".
session.viewports['Viewport: 1'].assemblyDisplay.setValues(mesh=OFF)
session.viewports['Viewport: 1'].assemblyDisplay.meshOptions.setValues(
    meshTechnique=OFF)
del mdb.jobs['Vframe_3D_Tets_Size_6_0']
del mdb.jobs['Vframe_3D_Size_1_5']
mdb.Job(name='Vframe_3D', model='Vframe_3D_Tets', description='', 
    type=ANALYSIS, atTime=None, waitMinutes=0, waitHours=0, queue=None, 
    memory=90, memoryUnits=PERCENTAGE, getMemoryFromAnalysis=True, 
    explicitPrecision=SINGLE, nodalOutputPrecision=SINGLE, echoPrint=OFF, 
    modelPrint=OFF, contactPrint=OFF, historyPrint=OFF, userSubroutine='', 
    scratch='', resultsFormat=ODB, numThreadsPerMpiProcess=1, 
    multiprocessingMode=DEFAULT, numCpus=1, numGPUs=0)
mdb.jobs.changeKey(fromName='Vframe_3D', toName='Vframe3d')
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\Julia_TPMS_TopOpt\CAD_FEM_Files\Vframe_3D.cae".
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\Julia_TPMS_TopOpt\CAD_FEM_Files\Vframe_3D.cae".
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\Julia_TPMS_TopOpt\CAD_FEM_Files\Vframe_3D.cae".
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\Julia_TPMS_TopOpt\CAD_FEM_Files\Vframe_3D.cae".
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\Julia_TPMS_TopOpt\CAD_FEM_Files\Vframe_3D.cae".
mdb.saveAs(
    pathName='C:/Users/snv22002/Documents/GitHub/Julia_TPMS_TopOpt/Stress_MPI_Multiresolution_v5/Read_Mesh/Vframe_3D.cae')
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\Julia_TPMS_TopOpt\Stress_MPI_Multiresolution_v5\Read_Mesh\Vframe_3D.cae".
Mdb()
#: A new model database has been created.
#: The model "Model-1" has been created.
session.viewports['Viewport: 1'].setValues(displayedObject=None)
a = mdb.models['Model-1'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
openMdb(
    pathName='C:/Users/snv22002/Documents/GitHub/Julia_TPMS_TopOpt/Stress_MPI_Multiresolution_v5/Read_Mesh/Vframe_3D.cae')
#: The model database "C:\Users\snv22002\Documents\GitHub\Julia_TPMS_TopOpt\Stress_MPI_Multiresolution_v5\Read_Mesh\Vframe_3D.cae" has been opened.
a = mdb.models['Vframe_3D_Tets'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
a = mdb.models['Vframe_3D_Tets'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
mdb.jobs['Vframe3d'].writeInput(consistencyChecking=OFF)
#: The job input file has been written to "Vframe3d.inp".
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\Julia_TPMS_TopOpt\Stress_MPI_Multiresolution_v5\Read_Mesh\Vframe_3D.cae".
mdb.ModelFromInputFile(name='Vframe3d', 
    inputFileName='C:/Users/snv22002/Documents/GitHub/Julia_TPMS_TopOpt/Stress_MPI_Multiresolution_v5/Read_Mesh/Vframe3d.inp')
#: The model "Vframe3d" has been created.
#: The part "VFRAME_3D" has been imported from the input file.
#: 
#: WARNING: The following keywords/parameters are not yet supported by the input file reader:
#: ---------------------------------------------------------------------------------
#: *PREPRINT
#: The model "Vframe3d" has been imported from an input file. 
#: Please scroll up to check for error and warning messages.
a = mdb.models['Vframe3d'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
a = mdb.models['Vframe_3D_Tets'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
del mdb.models['Vframe_3D_Tets']
a = mdb.models['Vframe3d'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
del mdb.jobs['Vframe3d']
session.viewports['Viewport: 1'].view.setValues(nearPlane=215.028, 
    farPlane=334.881, cameraPosition=(155.811, -28.1782, 266.069), 
    cameraUpVector=(-0.420914, 0.907082, 0.00577146), cameraTarget=(60, 30, 
    15))
session.viewports['Viewport: 1'].partDisplay.setValues(mesh=OFF)
session.viewports['Viewport: 1'].partDisplay.meshOptions.setValues(
    meshTechnique=OFF)
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=ON)
p1 = mdb.models['Vframe3d'].parts['VFRAME_3D']
session.viewports['Viewport: 1'].setValues(displayedObject=p1)
mdb.Model(name='ABQdummy')
del mdb.models['Vframe3d']
#: The model "ABQdummy" has been created.
session.viewports['Viewport: 1'].setValues(displayedObject=None)
a = mdb.models['ABQdummy'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
mdb.ModelFromInputFile(name='Vframe3d', 
    inputFileName='C:/Users/snv22002/Documents/GitHub/Julia_TPMS_TopOpt/Stress_MPI_Multiresolution_v5/Read_Mesh/Vframe3d.inp')
del mdb.models['ABQdummy']
#: The model "Vframe3d" has been created.
#: The part "PART-1" has been imported from the input file.
#: The model "Vframe3d" has been imported from an input file. 
#: Please scroll up to check for error and warning messages.
a = mdb.models['Vframe3d'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].view.setValues(session.views['Front'])
session.viewports['Viewport: 1'].view.setValues(nearPlane=250.563, 
    farPlane=292.024, width=146.604, height=67.0213, cameraPosition=(61.285, 
    30.6811, 281.293), cameraTarget=(61.285, 30.6811, 10))
session.viewports['Viewport: 1'].view.setValues(cameraPosition=(55.9659, 
    15.7668, 281.293), cameraTarget=(55.9659, 15.7668, 10))
session.viewports['Viewport: 1'].view.setProjection(projection=PARALLEL)
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\Julia_TPMS_TopOpt\Stress_MPI_Multiresolution_v5\Read_Mesh\Vframe_3D.cae".
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\Julia_TPMS_TopOpt\Stress_MPI_Multiresolution_v5\Read_Mesh\Vframe_3D.cae".
mdb.saveAs(
    pathName='C:/Users/snv22002/Documents/GitHub/Julia_TPMS_TopOpt/Stress_MPI_Multiresolution_v5/Read_Mesh/Vframe3d')
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\Julia_TPMS_TopOpt\Stress_MPI_Multiresolution_v5\Read_Mesh\Vframe3d.cae".
mdb.Job(name='Vframe3d', model='Vframe3d', description='', type=ANALYSIS, 
    atTime=None, waitMinutes=0, waitHours=0, queue=None, memory=90, 
    memoryUnits=PERCENTAGE, getMemoryFromAnalysis=True, 
    explicitPrecision=SINGLE, nodalOutputPrecision=SINGLE, echoPrint=OFF, 
    modelPrint=OFF, contactPrint=OFF, historyPrint=OFF, userSubroutine='', 
    scratch='', resultsFormat=ODB, parallelizationMethodExplicit=DOMAIN, 
    numDomains=1, activateLoadBalancing=False, numThreadsPerMpiProcess=1, 
    multiprocessingMode=DEFAULT, numCpus=1, numGPUs=0)
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\Julia_TPMS_TopOpt\Stress_MPI_Multiresolution_v5\Read_Mesh\Vframe3d.cae".
mdb.jobs['Vframe3d'].writeInput(consistencyChecking=OFF)
#: The job input file has been written to "Vframe3d.inp".
p1 = mdb.models['Vframe3d'].parts['PART-1']
session.viewports['Viewport: 1'].setValues(displayedObject=p1)
session.viewports['Viewport: 1'].partDisplay.setValues(mesh=ON)
session.viewports['Viewport: 1'].partDisplay.meshOptions.setValues(
    meshTechnique=ON)
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=OFF)
mdb.meshEditOptions.setValues(enableUndo=True, maxUndoCacheElements=0.5)
p = mdb.models['Vframe3d'].parts['PART-1']
p.renumberElement(startLabel=1, increment=1)
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\Julia_TPMS_TopOpt\Stress_MPI_Multiresolution_v5\Read_Mesh\Vframe3d.cae".
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\Julia_TPMS_TopOpt\Stress_MPI_Multiresolution_v5\Read_Mesh\Vframe3d.cae".
a = mdb.models['Vframe3d'].rootAssembly
a.regenerate()
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(mesh=ON)
session.viewports['Viewport: 1'].assemblyDisplay.meshOptions.setValues(
    meshTechnique=ON)
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\Julia_TPMS_TopOpt\Stress_MPI_Multiresolution_v5\Read_Mesh\Vframe3d.cae".
session.viewports['Viewport: 1'].assemblyDisplay.setValues(mesh=OFF)
session.viewports['Viewport: 1'].assemblyDisplay.meshOptions.setValues(
    meshTechnique=OFF)
mdb.jobs['Vframe3d'].writeInput(consistencyChecking=OFF)
#: The job input file has been written to "Vframe3d.inp".
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\Julia_TPMS_TopOpt\Stress_MPI_Multiresolution_v5\Read_Mesh\Vframe3d.cae".
mdb.jobs.changeKey(fromName='Vframe3d', toName='Vframe3d_Size_2_0')
mdb.jobs['Vframe3d_Size_2_0'].writeInput(consistencyChecking=OFF)
#: The job input file has been written to "Vframe3d_Size_2_0.inp".
session.viewports['Viewport: 1'].view.setValues(nearPlane=248.374, 
    farPlane=294.212, width=176.507, height=83.8341, cameraPosition=(65.5525, 
    15.3905, 281.293), cameraTarget=(65.5525, 15.3905, 10))
mdb.Model(name='Model-2', modelType=STANDARD_EXPLICIT)
#: The model "Model-2" has been created.
a = mdb.models['Model-2'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
a = mdb.models['Vframe3d'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
del mdb.models['Vframe3d']
a = mdb.models['Model-2'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
mdb.ModelFromInputFile(name='Vframe3d', 
    inputFileName='C:/Users/snv22002/Documents/GitHub/Julia_TPMS_TopOpt/Stress_MPI_Multiresolution_v5/Read_Mesh/Vframe3d.inp')
#: The model "Vframe3d" has been created.
#: The part "PART-1" has been imported from the input file.
#: The model "Vframe3d" has been imported from an input file. 
#: Please scroll up to check for error and warning messages.
a = mdb.models['Vframe3d'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
a = mdb.models['Model-2'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
del mdb.models['Model-2']
a = mdb.models['Vframe3d'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].partDisplay.setValues(mesh=OFF)
session.viewports['Viewport: 1'].partDisplay.meshOptions.setValues(
    meshTechnique=OFF)
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=ON)
p1 = mdb.models['Vframe3d'].parts['PART-1']
session.viewports['Viewport: 1'].setValues(displayedObject=p1)
session.viewports['Viewport: 1'].partDisplay.setValues(mesh=ON)
session.viewports['Viewport: 1'].partDisplay.meshOptions.setValues(
    meshTechnique=ON)
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=OFF)
mdb.meshEditOptions.setValues(enableUndo=True, maxUndoCacheElements=0.5)
p = mdb.models['Vframe3d'].parts['PART-1']
p.renumberElement(startLabel=1, increment=1)
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\Julia_TPMS_TopOpt\Stress_MPI_Multiresolution_v5\Read_Mesh\Vframe3d.cae".
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\Julia_TPMS_TopOpt\Stress_MPI_Multiresolution_v5\Read_Mesh\Vframe3d.cae".
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\Julia_TPMS_TopOpt\Stress_MPI_Multiresolution_v5\Read_Mesh\Vframe3d.cae".
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\Julia_TPMS_TopOpt\Stress_MPI_Multiresolution_v5\Read_Mesh\Vframe3d.cae".
a = mdb.models['Vframe3d'].rootAssembly
a.regenerate()
session.viewports['Viewport: 1'].setValues(displayedObject=a)
del mdb.jobs['Vframe3d_Size_2_0']
mdb.Job(name='Vframe3d_Size_2_0', model='Vframe3d', description='', 
    type=ANALYSIS, atTime=None, waitMinutes=0, waitHours=0, queue=None, 
    memory=90, memoryUnits=PERCENTAGE, getMemoryFromAnalysis=True, 
    explicitPrecision=SINGLE, nodalOutputPrecision=SINGLE, echoPrint=OFF, 
    modelPrint=OFF, contactPrint=OFF, historyPrint=OFF, userSubroutine='', 
    scratch='', resultsFormat=ODB, parallelizationMethodExplicit=DOMAIN, 
    numDomains=1, activateLoadBalancing=False, numThreadsPerMpiProcess=1, 
    multiprocessingMode=DEFAULT, numCpus=1, numGPUs=0)
mdb.jobs['Vframe3d_Size_2_0'].writeInput(consistencyChecking=OFF)
#: The job input file has been written to "Vframe3d_Size_2_0.inp".
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\Julia_TPMS_TopOpt\Stress_MPI_Multiresolution_v5\Read_Mesh\Vframe3d.cae".
openMdb(
    pathName='C:/Users/snv22002/Documents/GitHub/Julia_TPMS_TopOpt/Stress_MPI_Multiresolution_v5/Read_Mesh/U_Shape.cae')
#: The model database "C:\Users\snv22002\Documents\GitHub\Julia_TPMS_TopOpt\Stress_MPI_Multiresolution_v5\Read_Mesh\U_Shape.cae" has been opened.
a = mdb.models['U_Shape'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
a = mdb.models['U_Shape'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(mesh=ON)
session.viewports['Viewport: 1'].assemblyDisplay.meshOptions.setValues(
    meshTechnique=ON)
session.viewports['Viewport: 1'].view.setValues(nearPlane=126.842, 
    farPlane=254.209, cameraPosition=(133.315, 133.383, 138.23), 
    cameraUpVector=(-0.575985, 0.585567, -0.570397))
openMdb(
    pathName='C:/Users/snv22002/Documents/GitHub/Julia_TPMS_TopOpt/Stress_MPI_Multiresolution_v5/Read_Mesh/Vframe3d.cae')
#: The model database "C:\Users\snv22002\Documents\GitHub\Julia_TPMS_TopOpt\Stress_MPI_Multiresolution_v5\Read_Mesh\Vframe3d.cae" has been opened.
a = mdb.models['Vframe3d'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
a = mdb.models['Vframe3d'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].partDisplay.setValues(mesh=OFF)
session.viewports['Viewport: 1'].partDisplay.meshOptions.setValues(
    meshTechnique=OFF)
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=ON)
p1 = mdb.models['Vframe3d'].parts['PART-1']
session.viewports['Viewport: 1'].setValues(displayedObject=p1)
del mdb.models['Vframe3d'].parts['PART-1']
iges = mdb.openIges(
    'C:/Users/snv22002/Documents/GitHub/Julia_TPMS_TopOpt/Stress_MPI_Multiresolution_v5/Read_Mesh/Vframe3d.igs', 
    msbo=True, trimCurve=DEFAULT, scaleFromFile=OFF)
mdb.models['Vframe3d'].PartFromGeometryFile(name='Vframe3d', geometryFile=iges, 
    combine=False, stitchTolerance=1.0, dimensionality=THREE_D, 
    type=DEFORMABLE_BODY, convertToAnalytical=1, stitchEdges=1)
p = mdb.models['Vframe3d'].parts['Vframe3d']
session.viewports['Viewport: 1'].setValues(displayedObject=p)
session.viewports['Viewport: 1'].partDisplay.setValues(mesh=ON)
session.viewports['Viewport: 1'].partDisplay.meshOptions.setValues(
    meshTechnique=ON)
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=OFF)
p = mdb.models['Vframe3d'].parts['Vframe3d']
p.seedPart(size=2.5, deviationFactor=0.1, minSizeFactor=0.1)
p = mdb.models['Vframe3d'].parts['Vframe3d']
c = p.cells
pickedRegions = c.getSequenceFromMask(mask=('[#1 ]', ), )
p.setMeshControls(regions=pickedRegions, elemShape=TET, technique=FREE)
elemType1 = mesh.ElemType(elemCode=C3D20R)
elemType2 = mesh.ElemType(elemCode=C3D15)
elemType3 = mesh.ElemType(elemCode=C3D10)
p = mdb.models['Vframe3d'].parts['Vframe3d']
c = p.cells
cells = c.getSequenceFromMask(mask=('[#1 ]', ), )
pickedRegions =(cells, )
p.setElementType(regions=pickedRegions, elemTypes=(elemType1, elemType2, 
    elemType3))
p = mdb.models['Vframe3d'].parts['Vframe3d']
p.generateMesh()
p = mdb.models['Vframe3d'].parts['Vframe3d']
p.deleteMesh()
p = mdb.models['Vframe3d'].parts['Vframe3d']
p.seedPart(size=2.0, deviationFactor=0.1, minSizeFactor=0.1)
p = mdb.models['Vframe3d'].parts['Vframe3d']
p.generateMesh()
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\Julia_TPMS_TopOpt\Stress_MPI_Multiresolution_v5\Read_Mesh\Vframe3d.cae".
p = mdb.models['Vframe3d'].parts['Vframe3d']
p.deleteMesh()
p = mdb.models['Vframe3d'].parts['Vframe3d']
p.seedPart(size=2.5, deviationFactor=0.1, minSizeFactor=0.1)
p = mdb.models['Vframe3d'].parts['Vframe3d']
p.generateMesh()
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\Julia_TPMS_TopOpt\Stress_MPI_Multiresolution_v5\Read_Mesh\Vframe3d.cae".
a = mdb.models['Vframe3d'].rootAssembly
a.regenerate()
session.viewports['Viewport: 1'].setValues(displayedObject=a)
#* FeatureError: Regeneration failed
a = mdb.models['Vframe3d'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(mesh=OFF)
session.viewports['Viewport: 1'].assemblyDisplay.meshOptions.setValues(
    meshTechnique=OFF)
a = mdb.models['Vframe3d'].rootAssembly
del a.features['PART-1-1']
a1 = mdb.models['Vframe3d'].rootAssembly
p = mdb.models['Vframe3d'].parts['Vframe3d']
a1.Instance(name='Vframe3d-1', part=p, dependent=ON)
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\Julia_TPMS_TopOpt\Stress_MPI_Multiresolution_v5\Read_Mesh\Vframe3d.cae".
mdb.jobs['Vframe3d_Size_2_0'].writeInput(consistencyChecking=OFF)
#: The job input file has been written to "Vframe3d_Size_2_0.inp".
session.viewports['Viewport: 1'].partDisplay.setValues(mesh=OFF)
session.viewports['Viewport: 1'].partDisplay.meshOptions.setValues(
    meshTechnique=OFF)
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=ON)
p1 = mdb.models['Vframe3d'].parts['Vframe3d']
session.viewports['Viewport: 1'].setValues(displayedObject=p1)
session.viewports['Viewport: 1'].partDisplay.setValues(mesh=ON)
session.viewports['Viewport: 1'].partDisplay.meshOptions.setValues(
    meshTechnique=ON)
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=OFF)
elemType1 = mesh.ElemType(elemCode=C3D8R, elemLibrary=STANDARD)
elemType2 = mesh.ElemType(elemCode=C3D6, elemLibrary=STANDARD)
elemType3 = mesh.ElemType(elemCode=C3D4, elemLibrary=STANDARD, 
    secondOrderAccuracy=OFF, distortionControl=DEFAULT)
p = mdb.models['Vframe3d'].parts['Vframe3d']
c = p.cells
cells = c.getSequenceFromMask(mask=('[#1 ]', ), )
pickedRegions =(cells, )
p.setElementType(regions=pickedRegions, elemTypes=(elemType1, elemType2, 
    elemType3))
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\Julia_TPMS_TopOpt\Stress_MPI_Multiresolution_v5\Read_Mesh\Vframe3d.cae".
a = mdb.models['Vframe3d'].rootAssembly
a.regenerate()
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(mesh=ON)
session.viewports['Viewport: 1'].assemblyDisplay.meshOptions.setValues(
    meshTechnique=ON)
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\Julia_TPMS_TopOpt\Stress_MPI_Multiresolution_v5\Read_Mesh\Vframe3d.cae".
session.viewports['Viewport: 1'].assemblyDisplay.setValues(mesh=OFF)
session.viewports['Viewport: 1'].assemblyDisplay.meshOptions.setValues(
    meshTechnique=OFF)
mdb.jobs['Vframe3d_Size_2_0'].writeInput(consistencyChecking=OFF)
#* WindowsError: [Error 32] The process cannot access the file because it is 
#* being used by another process: 'Vframe3d_Size_2_0.inp'
mdb.jobs['Vframe3d_Size_2_0'].writeInput(consistencyChecking=OFF)
#: The job input file has been written to "Vframe3d_Size_2_0.inp".
