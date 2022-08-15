/*
 * This macro is to crop single bleached regions from a whole cell image.
 * 1. Open tiff file that you want to analyze.
 * 2. Choose a rectangle region including a single bleached region
 * 3. Add to ROI manager (Short cut key: ctr+t)
 * 4. Do process 2 and 3 repeatedly against other bleached regions. 
 * 5. Run this macro.
 */
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
path=getDirectory("image");
getPixelSize(unit, pixelWidth, pixelHeight);
pixelsize=pixelWidth;

print("Resolution="+pixelsize+"um/pixel");

outputROI	=path+"ROI\\";
outputfile	=path+"duplicated\\";
outputrectanglecoordinate	=path+"rectangle_coordinate_to_correct\\";

originname=getTitle();
baseEnd=indexOf(originname, ".tif");
baseoriginName=	substring(originname, 0, baseEnd);
	
///*
File.makeDirectory(outputROI);
File.makeDirectory(outputfile);

File.makeDirectory(outputrectanglecoordinate);

//*/
n=roiManager("count");
run("Set Scale...", "distance=1 known="+ pixelsize +" unit=micron");
run("Grays");
setBatchMode(true);

for (j = 0; j < n; j++) {

//duplicate
roiManager("Select", j);
run("Duplicate...", "duplicate");

imagename=getTitle();
	baseNameEnd=indexOf(imagename, ".tif");
	baseName=	substring(imagename, 0, baseNameEnd);
	/*savedire=	path+"Results-txt\\"+baseName+"-"+IJ.pad(j, 5)+"\\";
	File.makeDirectory(path+"Results-txt\\")	
	File.makeDirectory(savedire)	
	*/


N=nSlices;

run("Grays");
/*for (i = 0; i < N; i++) {
	savefile	=	savedire+i+".txt";
	run("Image to Results");
	saveAs("Results", savefile);
	close("Results");
	run("Next Slice [>]");
}
*/
saveAs("Tiff", outputfile+baseName+"-"+IJ.pad(j, 5));
close();
//get rectangle coordinates
selectWindow(originname);
run("Set Measurements...", "area mean standard min centroid center bounding shape integrated stack redirect=None decimal=3");
roiManager("Select", j);
run("Measure");
saveAs("Results", outputrectanglecoordinate+baseName+"-"+IJ.pad(j, 5)+".txt");
close("Results");
//
}

setBatchMode("exit and display");
roiManager("Show All");
roiManager("Show None");
run("Save");
roiManager("Save", outputROI+baseoriginName+".zip");

