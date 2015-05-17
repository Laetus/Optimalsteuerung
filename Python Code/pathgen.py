import bpy, random, math

  
# weight    
w = 1   

def genRoad(roadpoints = 200, maxAngleXY = 30):

    startVektor = [0,0,0]

    maxAngleXZ = 0
    minDist = 0.5
    maxDist = 1

    road = [[-1,0,0]]
    road.append(startVektor)


    for i in range(0, roadpoints):
    	angleXY = random.normalvariate(0,0.5)
    	angleXZ = random.normalvariate(0.001,0.5)
    	
    	distance = random.uniform(minDist, maxDist)
    	# unter einem gewissen Prozentsatz des Maximalwinkels, wird die Änderung auf 0 gesetzt
    	if angleXY <=0.15 and angleXY > -0.15:
    		angleXY = 0
    		
    	if angleXZ <=0.15 and angleXZ > -0.15:
    		angleXZ = 0
    		
    	# überspringe unpassende Zufallswerte Wahrscheinlichkeit < 5%
    	if angleXY > 1 or angleXY < -1 or angleXZ > 1 or angleXZ < -1:
    		i = i-1
    	else:
    		richtung = [road[-1][0]-road[-2][0],road[-1][1]-road[-2][1],road[-1][2]-road[-2][2]]
    		radXY = math.radians(maxAngleXY*angleXY)
    		radXZ = math.radians(maxAngleXZ*angleXZ)
    		
			# Rotation um die z-Achse
    		cosAlpha = math.cos(radXY)
    		sinAlpha = math.sin(radXY)
    				
    		a0 = richtung[0]*cosAlpha - richtung[1]*sinAlpha
    		a1 = richtung[0]*sinAlpha + richtung[1]*cosAlpha
    		a2 = richtung[2]
    		
    		# Rotation um die y-Achse
    		cosBeta = math.cos(radXZ)
    		sinBeta = math.sin(radXZ)
    		
    		a0 = a0*cosBeta - a2*sinBeta
    		a2 = -a0*sinBeta + a2*cosBeta
    		
    		# Normierung und Reskalierung
    		
    		lengthA = math.sqrt(a0**2+a1**2+a2**2)
    		
    		a0 = distance/lengthA * a0
    		a1 = distance/lengthA * a1
    		a2 = distance/lengthA * a2
    		
    		newPoint = [road[-1][0] + a0, road[-1][1] +a1,road[-1][2] +a2]
    		road.append(newPoint) 
    return road

def MakePolyLine(objname, curvename, cList):    
    curvedata = bpy.data.curves.new(name=curvename, type='CURVE')    
    curvedata.dimensions = '3D'    
    
    objectdata = bpy.data.objects.new(objname, curvedata)    
    objectdata.location = (0,0,0) #object origin    
    bpy.context.scene.objects.link(objectdata)    
    
    polyline = curvedata.splines.new('NURBS')    
    polyline.points.add(len(cList)-1)    
    for num in range(len(cList)):    
        x, y, z = cList[num]    
        polyline.points[num].co = (x, y, z, w)    
    
    polyline.order_u = len(polyline.points)-1  
    polyline.use_endpoint_u = True  
      
road = genRoad(100, 30)
MakePolyLine("NameOfMyCurveObject", "NameOfMyCurve", road)  
