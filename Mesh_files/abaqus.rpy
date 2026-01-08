# -*- coding: mbcs -*-
#
# Abaqus/CAE Release 2022 replay file
# Internal Version: 2021_09_15-13.57.30 176069
# Run by snv22002 on Sat Oct  4 19:19:24 2025
#

# from driverUtils import executeOnCaeGraphicsStartup
# executeOnCaeGraphicsStartup()
#: Executing "onCaeGraphicsStartup()" in the site directory ...
from abaqus import *
from abaqusConstants import *
session.Viewport(name='Viewport: 1', origin=(0.0, 0.0), width=192.481246948242, 
    height=220.888900756836)
session.viewports['Viewport: 1'].makeCurrent()
session.viewports['Viewport: 1'].maximize()
from caeModules import *
from driverUtils import executeOnCaeStartup
executeOnCaeStartup()
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=ON)
openMdb(
    pathName='C:/Users/snv22002/Documents/GitHub/FEM_Julia/Mesh_files/cantilever3d.cae')
#: The model database "C:\Users\snv22002\Documents\GitHub\FEM_Julia\Mesh_files\cantilever3d.cae" has been opened.
session.viewports['Viewport: 1'].setValues(displayedObject=None)
p = mdb.models['Model-1'].parts['Part-1']
session.viewports['Viewport: 1'].setValues(displayedObject=p)
session.viewports['Viewport: 1'].view.setValues(nearPlane=88.8981, 
    farPlane=139.431, width=68.5428, height=30.2689, viewOffsetX=1.08006, 
    viewOffsetY=-0.275565)
session.viewports['Viewport: 1'].view.setValues(nearPlane=91.2213, 
    farPlane=136.805, width=70.3341, height=31.0599, cameraPosition=(76.7546, 
    65.4957, 78.1579), cameraUpVector=(-0.632731, 0.564684, -0.529889), 
    cameraTarget=(-0.532927, -1.41147, 27.3282), viewOffsetX=1.10829, 
    viewOffsetY=-0.282766)
a = mdb.models['Model-1'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(
    optimizationTasks=OFF, geometricRestrictions=OFF, stopConditions=OFF)
mdb.jobs['Cantilever_3D'].submit(consistencyChecking=OFF)
#: The job input file "Cantilever_3D.inp" has been submitted for analysis.
#: Error in job Cantilever_3D: 31305 elements have missing property definitions. The elements have been identified in element set ErrElemMissingSection.
#: Job Cantilever_3D: Analysis Input File Processor aborted due to errors.
session.viewports['Viewport: 1'].partDisplay.setValues(sectionAssignments=ON, 
    engineeringFeatures=ON)
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=OFF)
p1 = mdb.models['Model-1'].parts['Part-1']
session.viewports['Viewport: 1'].setValues(displayedObject=p1)
#: Error in job Cantilever_3D: Analysis Input File Processor exited with an error - Please see the  Cantilever_3D.dat file for possible error messages if the file exists.
#: Job Cantilever_3D aborted due to errors.
mdb.models['Model-1'].Material(name='Material-1')
mdb.models['Model-1'].materials['Material-1'].Elastic(table=((119000.0, 0.3), 
    ))
mdb.models['Model-1'].HomogeneousSolidSection(name='Section-1', 
    material='Material-1', thickness=None)
session.viewports['Viewport: 1'].partDisplay.setValues(sectionAssignments=OFF, 
    engineeringFeatures=OFF)
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=ON)
mdb.models['Model-1'].parts.changeKey(fromName='Part-1', toName='PART-1')
#: Warning: One or more instances of this part exists in the
#: assembly. They have been modified to refer to the renamed part.
#: Any assembly features and attributes that depend on the original
#: instance may become invalid due to this operation. You may need
#: to edit assembly attributes, sets, surfaces, and reference points.
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\FEM_Julia\Mesh_files\cantilever3d.cae".
session.viewports['Viewport: 1'].partDisplay.setValues(sectionAssignments=ON, 
    engineeringFeatures=ON)
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=OFF)
p = mdb.models['Model-1'].parts['PART-1']
c = p.cells
cells = c.getSequenceFromMask(mask=('[#1 ]', ), )
region = regionToolset.Region(cells=cells)
p = mdb.models['Model-1'].parts['PART-1']
p.SectionAssignment(region=region, sectionName='Section-1', offset=0.0, 
    offsetType=MIDDLE_SURFACE, offsetField='', 
    thicknessAssignment=FROM_SECTION)
session.viewports['Viewport: 1'].partDisplay.setValues(sectionAssignments=OFF, 
    engineeringFeatures=OFF, mesh=ON)
session.viewports['Viewport: 1'].partDisplay.meshOptions.setValues(
    meshTechnique=ON)
p = mdb.models['Model-1'].parts['PART-1']
c = p.cells
pickedRegions = c.getSequenceFromMask(mask=('[#1 ]', ), )
p.deleteMesh(regions=pickedRegions)
p = mdb.models['Model-1'].parts['PART-1']
c = p.cells
pickedRegions = c.getSequenceFromMask(mask=('[#1 ]', ), )
p.setMeshControls(regions=pickedRegions, elemShape=HEX, technique=STRUCTURED)
p = mdb.models['Model-1'].parts['PART-1']
p.generateMesh()
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\FEM_Julia\Mesh_files\cantilever3d.cae".
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\FEM_Julia\Mesh_files\cantilever3d.cae".
a = mdb.models['Model-1'].rootAssembly
a.regenerate()
session.viewports['Viewport: 1'].setValues(displayedObject=a)
#: Warning: Instance 'Part-1-1' has been modified to refer to renamed part 'PART-1'.
session.viewports['Viewport: 1'].assemblyDisplay.setValues(mesh=ON)
session.viewports['Viewport: 1'].assemblyDisplay.meshOptions.setValues(
    meshTechnique=ON)
a = mdb.models['Model-1'].rootAssembly
del a.features['Part-1-1']
session.viewports['Viewport: 1'].assemblyDisplay.setValues(mesh=OFF)
session.viewports['Viewport: 1'].assemblyDisplay.meshOptions.setValues(
    meshTechnique=OFF)
a1 = mdb.models['Model-1'].rootAssembly
p = mdb.models['Model-1'].parts['PART-1']
a1.Instance(name='PART-1-1', part=p, dependent=ON)
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\FEM_Julia\Mesh_files\cantilever3d.cae".
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\FEM_Julia\Mesh_files\cantilever3d.cae".
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\FEM_Julia\Mesh_files\cantilever3d.cae".
session.viewports['Viewport: 1'].assemblyDisplay.setValues(mesh=ON)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(mesh=OFF)
del mdb.models['Model-1'].rootAssembly.sets['Loads']
session.viewports['Viewport: 1'].assemblyDisplay.setValues(
    adaptiveMeshConstraints=ON)
mdb.models['Model-1'].StaticStep(name='Step-1', previous='Initial')
session.viewports['Viewport: 1'].assemblyDisplay.setValues(step='Step-1')
session.viewports['Viewport: 1'].assemblyDisplay.setValues(loads=ON, bcs=ON, 
    predefinedFields=ON, connectors=ON, adaptiveMeshConstraints=OFF)
a = mdb.models['Model-1'].rootAssembly
f1 = a.instances['PART-1-1'].faces
faces1 = f1.getSequenceFromMask(mask=('[#10 ]', ), )
region = regionToolset.Region(faces=faces1)
mdb.models['Model-1'].EncastreBC(name='BC-1', createStepName='Step-1', 
    region=region, localCsys=None)
session.viewports['Viewport: 1'].view.setValues(nearPlane=86.3648, 
    farPlane=141.965, width=112.716, height=49.7761, viewOffsetX=4.84111, 
    viewOffsetY=3.90806)
session.viewports['Viewport: 1'].view.setValues(nearPlane=96.4091, 
    farPlane=140.291, width=125.825, height=55.5652, cameraPosition=(82.2772, 
    80.7261, -2.36908), cameraUpVector=(-0.911791, 0.407024, 0.0544923), 
    cameraTarget=(6.48952, 0.525676, 26.9173), viewOffsetX=5.40414, 
    viewOffsetY=4.36257)
session.viewports['Viewport: 1'].view.setValues(nearPlane=87.4561, 
    farPlane=153.021, width=114.141, height=50.4052, cameraPosition=(72.3603, 
    42.2941, -61.4392), cameraUpVector=(-0.62695, 0.701119, 0.339655), 
    cameraTarget=(8.16582, -1.37916, 22.2584), viewOffsetX=4.90229, 
    viewOffsetY=3.95744)
session.viewports['Viewport: 1'].view.setValues(nearPlane=87.9033, 
    farPlane=152.784, width=114.725, height=50.6631, cameraPosition=(70.8925, 
    38.9833, -64.3125), cameraUpVector=(-0.604961, 0.720207, 0.339593), 
    cameraTarget=(8.1383, -1.58749, 21.9979), viewOffsetX=4.92736, 
    viewOffsetY=3.97768)
session.viewports['Viewport: 1'].view.setValues(session.views['Iso'])
session.viewports['Viewport: 1'].view.setValues(nearPlane=89.112, 
    farPlane=139.217, width=61.3235, height=27.0808, viewOffsetX=0.0237329, 
    viewOffsetY=0.0245898)
session.viewports['Viewport: 1'].view.setValues(nearPlane=97.7569, 
    farPlane=127.723, width=67.2725, height=29.7079, cameraPosition=(106.676, 
    32.8912, 9.05655), cameraUpVector=(-0.624376, 0.768789, -0.138265), 
    cameraTarget=(-0.657022, -1.51704, 27.2012), viewOffsetX=0.0260353, 
    viewOffsetY=0.0269753)
session.viewports['Viewport: 1'].view.setValues(nearPlane=97.3185, 
    farPlane=128.161, width=66.9708, height=29.5747, viewOffsetX=0.0259185, 
    viewOffsetY=0.0268543)
session.viewports['Viewport: 1'].view.setValues(nearPlane=97.3172, 
    farPlane=128.162, width=66.97, height=29.5743, viewOffsetX=0.0259182, 
    viewOffsetY=0.0268539)
session.viewports['Viewport: 1'].view.setValues(nearPlane=90.9961, 
    farPlane=136.648, width=62.6201, height=27.6534, cameraPosition=(91.8914, 
    38.4385, 80.1204), cameraUpVector=(-0.492928, 0.758957, -0.425449), 
    cameraTarget=(-0.492056, -1.59115, 26.3017), viewOffsetX=0.0242347, 
    viewOffsetY=0.0251096)
session.viewports['Viewport: 1'].view.setValues(nearPlane=100.204, 
    farPlane=126.299, width=68.957, height=30.4518, cameraPosition=(111.637, 
    16.6032, 15.4408), cameraUpVector=(-0.491979, 0.859129, -0.140904), 
    cameraTarget=(-0.535115, -1.52427, 26.4975), viewOffsetX=0.0266871, 
    viewOffsetY=0.0276506)
session.viewports['Viewport: 1'].view.setValues(nearPlane=80.9497, 
    farPlane=142.006, width=55.7069, height=24.6005, cameraPosition=(11.2002, 
    45.8828, -75.9824), cameraUpVector=(-0.110754, 0.71697, 0.68825), 
    cameraTarget=(0.299774, -1.76329, 27.1896), viewOffsetX=0.0215592, 
    viewOffsetY=0.0223375)
a = mdb.models['Model-1'].rootAssembly
f1 = a.instances['PART-1-1'].faces
faces1 = f1.getSequenceFromMask(mask=('[#20 ]', ), )
region = regionToolset.Region(faces=faces1)
mdb.models['Model-1'].boundaryConditions['BC-1'].setValues(region=region)
session.viewports['Viewport: 1'].view.setValues(session.views['Iso'])
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\FEM_Julia\Mesh_files\cantilever3d.cae".
session.viewports['Viewport: 1'].assemblyDisplay.setValues(mesh=ON)
a = mdb.models['Model-1'].rootAssembly
n1 = a.instances['PART-1-1'].nodes
nodes1 = n1.getSequenceFromMask(mask=(
    '[#7ff #0:16 #ffe0000 #0:17 #1ffc #0:16 #3ff80000', 
    ' #0:17 #7ff0 #0:16 #ffe00000 #0:17 #1ffc0 #0:16', 
    ' #ff800000 #3 #0:16 #7ff00 #0:16 #fe000000 #f', ' #0:16 #1ffc00 ]', ), )
a.Set(nodes=nodes1, name='LOAD')
#: The set 'LOAD' has been created (121 nodes).
session.viewports['Viewport: 1'].assemblyDisplay.setValues(mesh=OFF)
a = mdb.models['Model-1'].rootAssembly
region = a.sets['LOAD']
mdb.models['Model-1'].ConcentratedForce(name='Load-1', createStepName='Step-1', 
    region=region, cf2=-1.0, distributionType=UNIFORM, field='', 
    localCsys=None)
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\FEM_Julia\Mesh_files\cantilever3d.cae".
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\FEM_Julia\Mesh_files\cantilever3d.cae".
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\FEM_Julia\Mesh_files\cantilever3d.cae".
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\FEM_Julia\Mesh_files\cantilever3d.cae".
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\FEM_Julia\Mesh_files\cantilever3d.cae".
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\FEM_Julia\Mesh_files\cantilever3d.cae".
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\FEM_Julia\Mesh_files\cantilever3d.cae".
session.viewports['Viewport: 1'].assemblyDisplay.setValues(loads=OFF, bcs=OFF, 
    predefinedFields=OFF, connectors=OFF)
mdb.jobs['Cantilever_3D'].submit(consistencyChecking=OFF)
#: The job input file "Cantilever_3D.inp" has been submitted for analysis.
#: Job Cantilever_3D: Analysis Input File Processor completed successfully.
#: Job Cantilever_3D: Abaqus/Standard completed successfully.
#: Job Cantilever_3D completed successfully. 
#: 
#: Point 1: 5., 5., 50.  Point 2: 5., 5., 0.
#:    Distance: 50.  Components: 0., 0., -50.
#: 
#: Point 1: 5., 5., 50.  Point 2: 5., -5., 50.
#:    Distance: 10.  Components: 0., -10., 0.
session.viewports['Viewport: 1'].partDisplay.setValues(sectionAssignments=ON, 
    engineeringFeatures=ON, mesh=OFF)
session.viewports['Viewport: 1'].partDisplay.meshOptions.setValues(
    meshTechnique=OFF)
p1 = mdb.models['Model-1'].parts['PART-1']
session.viewports['Viewport: 1'].setValues(displayedObject=p1)
a = mdb.models['Model-1'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
o3 = session.openOdb(
    name='C:/Users/snv22002/Documents/GitHub/FEM_Julia/Mesh_files/Cantilever_3D.odb')
#: Model: C:/Users/snv22002/Documents/GitHub/FEM_Julia/Mesh_files/Cantilever_3D.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     1
#: Number of Meshes:             1
#: Number of Element Sets:       1
#: Number of Node Sets:          2
#: Number of Steps:              1
session.viewports['Viewport: 1'].setValues(displayedObject=o3)
session.viewports['Viewport: 1'].makeCurrent()
a = mdb.models['Model-1'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].setValues(
    displayedObject=session.odbs['C:/Users/snv22002/Documents/GitHub/FEM_Julia/Mesh_files/Cantilever_3D.odb'])
session.viewports['Viewport: 1'].odbDisplay.display.setValues(plotState=(
    CONTOURS_ON_DEF, ))
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='U', outputPosition=NODAL, refinement=(INVARIANT, 
    'Magnitude'), )
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='S', outputPosition=INTEGRATION_POINT, refinement=(INVARIANT, 
    'Mises'), )
a = mdb.models['Model-1'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(mesh=ON)
session.viewports['Viewport: 1'].assemblyDisplay.meshOptions.setValues(
    meshTechnique=ON)
mdb.meshEditOptions.setValues(enableUndo=True, maxUndoCacheElements=0.5)
p = mdb.models['Model-1'].parts['PART-1']
session.viewports['Viewport: 1'].setValues(displayedObject=p)
session.viewports['Viewport: 1'].partDisplay.setValues(sectionAssignments=OFF, 
    engineeringFeatures=OFF, mesh=ON)
session.viewports['Viewport: 1'].partDisplay.meshOptions.setValues(
    meshTechnique=ON)
elemType1 = mesh.ElemType(elemCode=C3D8, elemLibrary=STANDARD, 
    secondOrderAccuracy=OFF, distortionControl=DEFAULT)
elemType2 = mesh.ElemType(elemCode=C3D6, elemLibrary=STANDARD)
elemType3 = mesh.ElemType(elemCode=C3D4, elemLibrary=STANDARD, 
    secondOrderAccuracy=OFF, distortionControl=DEFAULT)
p = mdb.models['Model-1'].parts['PART-1']
c = p.cells
cells = c.getSequenceFromMask(mask=('[#1 ]', ), )
pickedRegions =(cells, )
p.setElementType(regions=pickedRegions, elemTypes=(elemType1, elemType2, 
    elemType3))
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\FEM_Julia\Mesh_files\cantilever3d.cae".
a = mdb.models['Model-1'].rootAssembly
a.regenerate()
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(mesh=OFF, loads=ON, 
    bcs=ON, predefinedFields=ON, connectors=ON)
session.viewports['Viewport: 1'].assemblyDisplay.meshOptions.setValues(
    meshTechnique=OFF)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(loads=OFF, bcs=OFF, 
    predefinedFields=OFF, connectors=OFF)
mdb.jobs['Cantilever_3D'].submit(consistencyChecking=OFF)
#: The job input file "Cantilever_3D.inp" has been submitted for analysis.
#: Job Cantilever_3D: Analysis Input File Processor completed successfully.
#: Job Cantilever_3D: Abaqus/Standard completed successfully.
#: Job Cantilever_3D completed successfully. 
o3 = session.openOdb(
    name='C:/Users/snv22002/Documents/GitHub/FEM_Julia/Mesh_files/Cantilever_3D.odb')
#: Model: C:/Users/snv22002/Documents/GitHub/FEM_Julia/Mesh_files/Cantilever_3D.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     1
#: Number of Meshes:             1
#: Number of Element Sets:       1
#: Number of Node Sets:          2
#: Number of Steps:              1
session.viewports['Viewport: 1'].setValues(displayedObject=o3)
session.viewports['Viewport: 1'].makeCurrent()
session.viewports['Viewport: 1'].odbDisplay.display.setValues(plotState=(
    CONTOURS_ON_DEF, ))
session.viewports['Viewport: 1'].view.setValues(nearPlane=87.8515, 
    farPlane=142.941, width=76.659, height=33.8531, viewOffsetX=4.88824, 
    viewOffsetY=-2.52342)
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='U', outputPosition=NODAL, refinement=(INVARIANT, 
    'Magnitude'), )
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='S', outputPosition=INTEGRATION_POINT, refinement=(INVARIANT, 
    'Mises'), )
session.viewports['Viewport: 1'].view.setValues(nearPlane=87.8523, 
    farPlane=142.94, width=76.6597, height=33.8533, viewOffsetX=4.88828, 
    viewOffsetY=-2.52344)
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='U', outputPosition=NODAL, refinement=(INVARIANT, 
    'Magnitude'), )
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='S', outputPosition=INTEGRATION_POINT, refinement=(INVARIANT, 
    'Mises'), )
session.viewports['Viewport: 1'].view.setValues(nearPlane=88.7932, 
    farPlane=141.999, width=56.8634, height=25.1112, viewOffsetX=15.1054, 
    viewOffsetY=-0.791451)
a = mdb.models['Model-1'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(loads=ON, bcs=ON, 
    predefinedFields=ON, connectors=ON)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(mesh=ON, loads=OFF, 
    bcs=OFF, predefinedFields=OFF, connectors=OFF)
session.viewports['Viewport: 1'].assemblyDisplay.meshOptions.setValues(
    meshTechnique=ON)
p = mdb.models['Model-1'].parts['PART-1']
session.viewports['Viewport: 1'].setValues(displayedObject=p)
elemType1 = mesh.ElemType(elemCode=C3D20, elemLibrary=STANDARD)
elemType2 = mesh.ElemType(elemCode=C3D15, elemLibrary=STANDARD)
elemType3 = mesh.ElemType(elemCode=C3D10, elemLibrary=STANDARD)
p = mdb.models['Model-1'].parts['PART-1']
c = p.cells
cells = c.getSequenceFromMask(mask=('[#1 ]', ), )
pickedRegions =(cells, )
p.setElementType(regions=pickedRegions, elemTypes=(elemType1, elemType2, 
    elemType3))
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\FEM_Julia\Mesh_files\cantilever3d.cae".
a = mdb.models['Model-1'].rootAssembly
a.regenerate()
session.viewports['Viewport: 1'].setValues(displayedObject=a)
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\FEM_Julia\Mesh_files\cantilever3d.cae".
session.viewports['Viewport: 1'].assemblyDisplay.setValues(mesh=OFF)
session.viewports['Viewport: 1'].assemblyDisplay.meshOptions.setValues(
    meshTechnique=OFF)
mdb.jobs['Cantilever_3D'].submit(consistencyChecking=OFF)
#: The job input file "Cantilever_3D.inp" has been submitted for analysis.
session.viewports['Viewport: 1'].assemblyDisplay.setValues(loads=ON, bcs=ON, 
    predefinedFields=ON, connectors=ON)
#: Job Cantilever_3D: Analysis Input File Processor completed successfully.
#: Job Cantilever_3D: Abaqus/Standard completed successfully.
#: Job Cantilever_3D completed successfully. 
o3 = session.openOdb(
    name='C:/Users/snv22002/Documents/GitHub/FEM_Julia/Mesh_files/Cantilever_3D.odb')
#: Model: C:/Users/snv22002/Documents/GitHub/FEM_Julia/Mesh_files/Cantilever_3D.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     1
#: Number of Meshes:             1
#: Number of Element Sets:       1
#: Number of Node Sets:          2
#: Number of Steps:              1
session.viewports['Viewport: 1'].setValues(displayedObject=o3)
session.viewports['Viewport: 1'].makeCurrent()
a = mdb.models['Model-1'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].setValues(
    displayedObject=session.odbs['C:/Users/snv22002/Documents/GitHub/FEM_Julia/Mesh_files/Cantilever_3D.odb'])
session.viewports['Viewport: 1'].assemblyDisplay.setValues(loads=OFF, bcs=OFF, 
    predefinedFields=OFF, connectors=OFF)
session.viewports['Viewport: 1'].odbDisplay.display.setValues(plotState=(
    CONTOURS_ON_DEF, ))
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='U', outputPosition=NODAL, refinement=(INVARIANT, 
    'Magnitude'), )
a = mdb.models['Model-1'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(loads=ON, bcs=ON, 
    predefinedFields=ON, connectors=ON)
mdb.models['Model-1'].loads['Load-1'].setValues(cf2=-10.0, 
    distributionType=UNIFORM, field='')
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\FEM_Julia\Mesh_files\cantilever3d.cae".
session.viewports['Viewport: 1'].assemblyDisplay.setValues(mesh=ON, loads=OFF, 
    bcs=OFF, predefinedFields=OFF, connectors=OFF)
session.viewports['Viewport: 1'].assemblyDisplay.meshOptions.setValues(
    meshTechnique=ON)
p = mdb.models['Model-1'].parts['PART-1']
session.viewports['Viewport: 1'].setValues(displayedObject=p)
elemType1 = mesh.ElemType(elemCode=C3D8, elemLibrary=STANDARD, 
    secondOrderAccuracy=OFF, distortionControl=DEFAULT)
elemType2 = mesh.ElemType(elemCode=C3D6, elemLibrary=STANDARD)
elemType3 = mesh.ElemType(elemCode=C3D4, elemLibrary=STANDARD)
p = mdb.models['Model-1'].parts['PART-1']
c = p.cells
cells = c.getSequenceFromMask(mask=('[#1 ]', ), )
pickedRegions =(cells, )
p.setElementType(regions=pickedRegions, elemTypes=(elemType1, elemType2, 
    elemType3))
mdb.save()
#: The model database has been saved to "C:\Users\snv22002\Documents\GitHub\FEM_Julia\Mesh_files\cantilever3d.cae".
a = mdb.models['Model-1'].rootAssembly
a.regenerate()
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(mesh=OFF)
session.viewports['Viewport: 1'].assemblyDisplay.meshOptions.setValues(
    meshTechnique=OFF)
mdb.jobs['Cantilever_3D'].submit(consistencyChecking=OFF)
#: The job input file "Cantilever_3D.inp" has been submitted for analysis.
#: Job Cantilever_3D: Analysis Input File Processor completed successfully.
#: Job Cantilever_3D: Abaqus/Standard completed successfully.
#: Job Cantilever_3D completed successfully. 
o3 = session.openOdb(
    name='C:/Users/snv22002/Documents/GitHub/FEM_Julia/Mesh_files/Cantilever_3D.odb')
#: Model: C:/Users/snv22002/Documents/GitHub/FEM_Julia/Mesh_files/Cantilever_3D.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     1
#: Number of Meshes:             1
#: Number of Element Sets:       1
#: Number of Node Sets:          2
#: Number of Steps:              1
session.viewports['Viewport: 1'].setValues(displayedObject=o3)
session.viewports['Viewport: 1'].makeCurrent()
session.viewports['Viewport: 1'].odbDisplay.display.setValues(plotState=(
    CONTOURS_ON_DEF, ))
session.viewports['Viewport: 1'].odbDisplay.setPrimaryVariable(
    variableLabel='U', outputPosition=NODAL, refinement=(INVARIANT, 
    'Magnitude'), )
