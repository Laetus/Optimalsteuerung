import random, math, bpy

class Vector():
	
	def __init__(self,x,y,z):
		self.x = x
		self.y = y
		self.z = z
	
	# ermoeglicht Addition von Vektoren mit +
	def __add__(self,vector):
		if type(vector) != Vector:
			raise TypeError('Can only add Vectors, not '+str(type(vector)))
		x = self.x + vector.x
		y = self.y + vector.y
		z = self.z + vector.z
		return Vector(x,y,z)
	
	# ermoeglicht Subtraktion von Vektoren mit -
	def __sub__(self,vector):
		if type(vector) != Vector:
			raise TypeError('Can only subtract Vectors')
		x = self.x - vector.x
		y = self.y - vector.y
		z = self.z - vector.z
		return Vector(x,y,z)
	
	# ermoeglicht das Multiplizieren mit einem Skalar
	# Form: Vector * skalar
	# type(multiplicator): int, float, long
	def __mul__(self, multiplicator):
		if type(multiplicator) != float and type(multiplicator) != int and type(multiplicator) != long:
			raise TypeError('Can only multiply with scalars')
		x = self.x * multiplicator
		y = self.y * multiplicator
		z = self.z * multiplicator
		return Vector(x,y,z)
				
	def __str__(self):
		return str([self.x, self.y, self.z])
		
	def getLength(self):
		return math.sqrt(self.x**2 + self.y**2 + self.z**2)
		
	def crossproduct(self, vector):
		if type(vector) != Vector:
			raise TypeError('Can only cross Vectors')
		x = self.y*vector.z - self.z*vector.y
		y = self.z*vector.x - self.x*vector.z
		z = self.x*vector.y - self.y*vector.x
		return Vector(x,y,z)
	
	def normalize(self):
		blub = self.getLength()
		self.x = self.x * 1.0/blub
		self.y = self.y * 1.0/blub
		self.z = self.z * 1.0/blub
		


def genRoad(iterations = 1, startPt = Vector(0,0,1), endPt = Vector(10,0,1)):
	
	road = []
	road.append(startPt)
	road.append(endPt)

	for i in range(iterations):
		roadLen = len(road)
		for j in range(roadLen-1):
			weight = random.uniform(0.25, 0.5) 
			direction = random.choice([-1, 1])  # Von A nach B oder umgekehrt
			
			firstPt = road[roadLen-j-2]
			secondPt = road[roadLen-j-1]
			
			distance =  (secondPt-firstPt).getLength()
			
			maxDev = 0.66 * weight * distance
			

			if direction == -1:
				weight = 1-weight	
			
			random.uniform(-maxDev, maxDev)
			ortho = secondPt.crossproduct(firstPt)
			ortho.normalize()
			direction = (secondPt-firstPt).crossproduct(ortho)
			direction.normalize()  #normierung
			
			
			newPt = (firstPt*weight + secondPt*weight) + direction*maxDev
			road.insert(roadLen-j-1, newPt)
				
	return road		

def MakePolyLine(objname, curvename, cList):
	
	w = 1     
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

road = genRoad(2)
roadArray = []
for point in road:
	roadArray.append([point.x, point.y, point.z])
	
MakePolyLine("NameOfMyCurveObject", "NameOfMyCurve", roadArray) 
