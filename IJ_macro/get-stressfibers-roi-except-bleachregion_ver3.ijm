/*
 * This macro is for detecting brighter regions than bleached area.
 * 1. Open a cropped image from folder 'duplicated' and set threshold to distinguish between brighter and darker regions
 * 2. Run AnalyzeParticles and then detected regions will be added into ROI manager.
 * 3. Select ROIs in pre-bleach frames and delete them with Delete command in ROI manager.
 * 4. Select ROIs that are NOT corresponding to brighter regions and unexpected regions.
 * 5. Make sure that there are two ROIs in one frame after bleached frame. 
 * 6. Run this macro
 */




















getPixelSize(unit, pixelWidth, pixelHeight);
image_path=getDirectory("image");
originpath_End=	indexOf(image_path,"duplicated\\" );
path=			substring(image_path, 0, originpath_End);
outputfile	=path+"detect-sf\\";
outputroi	=path+"ROI-stressfiber\\";
File.makeDirectory(outputfile);
File.makeDirectory(outputroi);
originname=getTitle();
baseEnd=indexOf(originname, ".tif");
baseoriginName=	substring(originname, 0, baseEnd);
File.makeDirectory(outputfile+baseoriginName);

run("Grays");

n=roiManager("count");

run("Set Measurements...", "area mean standard centroid bounding fit shape stack redirect=None decimal=3");
setBatchMode("hide");
for (i = 0; i < n; i++) {

	roiManager("Select", i);
	run("Fit Ellipse");
	run("Fit Rectangle");
	roiManager("Add");
}

N=roiManager("count");
for (i = 0; i < N/2; i++) {
	roiManager("Select", i+n);
	roiManager("Measure");
	saveAs("Results", outputfile+baseoriginName+"\\"+IJ.pad(i, 5)+".txt");
	close("Results");
}
setBatchMode("exit and display");
roiManager("Save", outputroi+baseoriginName+".zip");
close();
roiManager("reset");