Files that I have used to postprocess SOWFA results for my master's project.

Here is my workflow:

1. Use convertU as described in the file. 
2. Download the .txt files to a 'Simulations/casename' directory e.g '/Simulations/0.1roughness'
3. Make sure the path variable in LOAD is pointing to the simulations directory.
4. Copy and paste the heights vector at the top of any of the .txt files into the heights variable in LOAD. 
5. Delete the top 2 rows from each of the 3 .txt files. 
6. Run plotData

Adapt as necessary to get the plots you want
