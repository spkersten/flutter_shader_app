numX = 4
numY = 3

for j in range(numY):
    for i in range(numX):
        print(f"layout(location = {2 + 3 * (i + j * numX)}) in vec3 colors{i}_{j};")

for j in range(numY):
    for i in range(numX):
        print(f"""
float basis{i}_{j} = cos(pi * x * float({i})) * cos(pi * y * float({j}));
pixel[0] += color{i}_{j}[0] * basis{i}_{j};
pixel[1] += color{i}_{j}[1] * basis{i}_{j};
pixel[2] += color{i}_{j}[2] * basis{i}_{j};
        """)
