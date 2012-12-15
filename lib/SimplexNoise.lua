--[[---------------------------------------------
**********************************************************************************
Simplex Noise Module, Translated by Levybreak
Modified by Jared "Nergal" Hewitt for use with MapGen for Love2D

Original Source: http://staffwww.itn.liu.se/~stegu/simplexnoise/simplexnoise.pdf
	The code there is in java, the original implementation by Ken Perlin
**********************************************************************************
--]]---------------------------------------------

local SimplexNoise = {}

SimplexNoise.Gradients3D = {{1,1,0},{-1,1,0},{1,-1,0},{-1,-1,0},
{1,0,1},{-1,0,1},{1,0,-1},{-1,0,-1},
{0,1,1},{0,-1,1},{0,1,-1},{0,-1,-1}}

SimplexNoise.p = {151,160,137,91,90,15,
131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180}

-- To remove the need for index wrapping, double the permutation table length
for i=1,#SimplexNoise.p do
	SimplexNoise.p[i-1] = SimplexNoise.p[i]
	SimplexNoise.p[i] = nil
end

for i=1,#SimplexNoise.Gradients3D do
	SimplexNoise.Gradients3D[i-1] = SimplexNoise.Gradients3D[i]
	SimplexNoise.Gradients3D[i] = nil
end

SimplexNoise.perm = {}

for i=0,255 do
	SimplexNoise.perm[i] = SimplexNoise.p[i]
	SimplexNoise.perm[i+256] = SimplexNoise.p[i]
end

SimplexNoise.Dot2D = function(tbl, x, y)
	return tbl[1]*x + tbl[2]*y
end

SimplexNoise.Prev2D = {}

-- 2D simplex noise
SimplexNoise.Noise2D = function(xin, yin)
	if SimplexNoise.Prev2D[xin] and SimplexNoise.Prev2D[xin][yin] then return SimplexNoise.Prev2D[xin][yin] end 

	local n0, n1, n2 -- Noise contributions from the three corners
	-- Skew the input space to determine which simplex cell we're in
	local F2 = 0.5*(math.sqrt(3.0)-1.0)
	local s = (xin+yin)*F2 -- Hairy factor for 2D
	local i = math.floor(xin+s)
	local j = math.floor(yin+s)
	local G2 = (3.0-math.sqrt(3.0))/6.0
	
	local t = (i+j)*G2
	local X0 = i-t -- Unskew the cell origin back to (x,y) space
	local Y0 = j-t
	local x0 = xin-X0 -- The x,y distances from the cell origin
	local y0 = yin-Y0
	
	-- For the 2D case, the simplex shape is an equilateral triangle.
	-- Determine which simplex we are in.
	local i1, j1; -- Offsets for second (middle) corner of simplex in (i,j) coords
	if(x0>y0) then 
		i1=1 
		j1=0  -- lower triangle, XY order: (0,0)->(1,0)->(1,1)
	else
		i1=0
		j1=1 -- upper triangle, YX order: (0,0)->(0,1)->(1,1)
	end
	
	-- A step of (1,0) in (i,j) means a step of (1-c,-c) in (x,y), and
	-- a step of (0,1) in (i,j) means a step of (-c,1-c) in (x,y), where
	-- c = (3-sqrt(3))/6

	local x1 = x0 - i1 + G2 -- Offsets for middle corner in (x,y) unskewed coords
	local y1 = y0 - j1 + G2
	local x2 = x0 - 1.0 + 2.0 * G2 -- Offsets for last corner in (x,y) unskewed coords
	local y2 = y0 - 1.0 + 2.0 * G2

	-- Work out the hashed gradient indices of the three simplex corners
	local ii = LuaBit.band(i , 255)
	local jj = LuaBit.band(j , 255)
	local gi0 = SimplexNoise.perm[ii+SimplexNoise.perm[jj]] % 12
	local gi1 = SimplexNoise.perm[ii+i1+SimplexNoise.perm[jj+j1]] % 12
	local gi2 = SimplexNoise.perm[ii+1+SimplexNoise.perm[jj+1]] % 12

	-- Calculate the contribution from the three corners
	local t0 = 0.5 - x0*x0-y0*y0
	if t0<0 then 
		n0 = 0.0;
	else
		t0 = t0 * t0
		n0 = t0 * t0 * SimplexNoise.Dot2D(SimplexNoise.Gradients3D[gi0], x0, y0) -- (x,y) of Gradients3D used for 2D gradient
	end
	
	local t1 = 0.5 - x1*x1-y1*y1;
	if (t1<0) then
		n1 = 0.0
	else
		t1 = t1*t1
		n1 = t1 * t1 * SimplexNoise.Dot2D(SimplexNoise.Gradients3D[gi1], x1, y1)
	end
	
	local t2 = 0.5 - x2*x2-y2*y2;
	if (t2<0) then
		n2 = 0.0
	else
		t2 = t2*t2
		n2 = t2 * t2 * SimplexNoise.Dot2D(SimplexNoise.Gradients3D[gi2], x2, y2)
	end

	
	-- Add contributions from each corner to get the final noise value.
	-- The result is scaled to return values in the localerval [-1,1].
	
	local retval = 70.0 * (n0 + n1 + n2)
	
	if not SimplexNoise.Prev2D[xin] then SimplexNoise.Prev2D[xin] = {} end
	SimplexNoise.Prev2D[xin][yin] = retval
	
	return retval
end 

SimplexNoise.e = 2.71828182845904523536

SimplexNoise.PrevBlur2D = {}

SimplexNoise.GBlur2D = function(x,y,stdDev)
	if SimplexNoise.PrevBlur2D[x] and SimplexNoise.PrevBlur2D[x][y] and SimplexNoise.PrevBlur2D[x][y][stdDev] then return SimplexNoise.PrevBlur2D[x][y][stdDev] end
	local pwr = ((x^2+y^2)/(2*(stdDev^2)))*-1
	local ret = ((1/(2*math.pi*(stdDev^2)))*e)^pwr
	if not SimplexNoise.PrevBlur2D[x] then PrevBlur2D[x] = {} end
	if not SimplexNoise.PrevBlur2D[x][y] then PrevBlur2D[x][y] = {} end
	SimplexNoise.PrevBlur2D[x][y][stdDev] = ret
	return ret
end 

SimplexNoise.FractalSum2DNoise = function(x,y,itier) --very expensive, much more so that standard 2D noise.
	local ret = SimplexNoise.Noise2D(x,y)
	for i=1,itier do
		local itier = 2^itier
		ret = ret + (i/itier)*(Noise2D(x*(itier/i),y*(itier/i)))
	end
	return ret
end 

SimplexNoise.FractalSumAbs2DNoise = function(x,y,itier) --very expensive, much more so that standard 2D noise.
	local ret = math.abs(SimplexNoise.Noise2D(x,y))
	for i=1,itier do
		local itier = 2^itier
		ret = ret + (i/itier)*(math.abs(SimplexNoise.Noise2D(x*(itier/i),y*(itier/i))))
	end
	return ret
end 

SimplexNoise.Turbulent2DNoise = function(x,y,itier) --very expensive, much more so that standard 2D noise.
	local ret = math.abs(SimplexNoise.Noise2D(x,y))
	for i=1,itier do
		local itier = 2^itier
		ret = ret + (i/itier)*(math.abs(SimplexNoise.Noise2D(x*(itier/i),y*(itier/i))))
	end
	return math.sin(x+ret)
end

return SimplexNoise