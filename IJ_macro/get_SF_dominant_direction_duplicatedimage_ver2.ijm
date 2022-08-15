/*
 * This macro results in the dominant direction of brighter regions in individual cropped images.
 * When you run this macro, you will be required to select the working folder. 
 * If you have performed image analysis accroding to our protcol, selecting 'tifimage-chX' should work (X is the channel number).
*/
























path=getDirectory("Select folder named 'tifimage-chX'");
inputdire	=path+"duplicated\\";
inputroidre	=path+"ROI-all\\";

listofrois=getFileList(inputroidre);


outputdire=path+"DominantDirection_SFs\\"
File.makeDirectory(outputdire);
setBatchMode("hide");
for (i = 0; i < listofrois.length; i++) {
	listEnd=indexOf(listofrois[i], ".zip");
	listoriginName=	substring(listofrois[i], 0, listEnd);
	
	open(inputdire+listoriginName+".tif");
	imagename=getTitle();
	baseNameEnd=indexOf(imagename, ".tif");
	baseoriginName=substring(imagename, 0, baseNameEnd);
	
	roiManager("reset");
	roiManager("Open", inputroidre+baseoriginName+".zip");
	roiManager("Show All");
	roiManager("Show None");
	


run("OrientationJ Dominant Direction");
saveAs("Results", outputdire+baseoriginName+".txt");
close(baseoriginName+".txt");
close();
close("Log");
}
setBatchMode("exit and display");