/*
 * This macro results time series of coordinates that are surrounding a bleached region for every cropped images.
 * When you run this macro, you will be required to select the working folder. 
 * If you have performed image analysis accroding to our protcol, selecting 'tifimage-chX' should work (X is the channel number).
*/





















path=getDirectory("Select folder named 'tifimage-chX'");

inputroidre	=path+"ROI-stressfiber\\";

listofrois=getFileList(path+"ROI-stressfiber\\");

for (q = 0; q < listofrois.length ; q++) {

	listEnd=indexOf(listofrois[q], ".zip");
	listoriginName=	substring(listofrois[q], 0, listEnd);

	open(path+"\\duplicated\\"+listoriginName+".tif");
	roiManager("reset");
	originname=getTitle();
	baseEnd=indexOf(originname, ".tif");
	baseoriginName=	substring(originname, 0, baseEnd);
	
	outputROI=path+"ROI-all\\";
	File.makeDirectory(outputROI);
	outputResults_rec=path+"Recovery\\";
	File.makeDirectory(outputResults_rec);
	outputResults_pre=path+"Prebleach\\";
	File.makeDirectory(outputResults_pre);
	outtensor=path+"tensor-coordinates\\";
	File.makeDirectory(outtensor);
	outtensorcoordinates=outtensor+baseoriginName+"\\";
	File.makeDirectory(outtensorcoordinates);
	
	roiManager("reset");
	roiManager("Open", inputroidre+baseoriginName+".zip");
	
	N=roiManager("count");
	roiManager("Select", 0);
	PrebleachFrame=getSliceNumber()-1;
	
	/*
	for (k = 0; k < N; k++) {
	
		
		roiManager("Select", k);
		Roi.getCoordinates(xpoints, ypoints);
		Array.print(xpoints);
	}
	*/
	
	for (k = 0; k < N/2/2; k++) {
	
		
		roiManager("Select", 2*k+N/2);
		Roi.getCoordinates(x1points, y1points);
		//Array.print(x1points);
		roiManager("Select", 2*k+N/2+1);
		Roi.getCoordinates(x2points, y2points);
		//Array.print(x2points);
	
		
		
		Array.getStatistics(x1points, x1min, x1max, x1mean, stdDev);
		Array.getStatistics(y1points, y1min, y1max, y1mean, stdDev);
		Array.getStatistics(x2points, x2min, x2max, x2mean, stdDev);
		Array.getStatistics(y2points, y2min, y2max, y2mean, stdDev);
		
		if (x1min<x2min) {
			xpoints_left=Array.copy(x1points);
			ypoints_left=Array.copy(y1points);
			xmin_left	=x1min;
			xmax_left	=x1max;
			
			xpoints_right=Array.copy(x2points);
			ypoints_right=Array.copy(y2points);
			xmin_right	=x2min;
			xmax_right	=x2max;
		}
		if (x1min>x2min) {
			xpoints_left=Array.copy(x2points);
			ypoints_left=Array.copy(y2points);
			xmin_left	=x2min;
			xmax_left	=x2max;
			
			xpoints_right=Array.copy(x1points);
			ypoints_right=Array.copy(y1points);
			xmin_right	=x1min;
			xmax_right	=x1max;
		}
		//left
		j=0;
		left=newArray(4);
		keep=newArray(4);
		for (i = 0; i < 4; i++) {
	
		if (xpoints_left[i]>xmin_left) {
			if (xpoints_left[i]<xmax_left) {
				keep[2*j]=xpoints_left[i]; 
				keep[2*j+1]=ypoints_left[i]; 
				j=j+1;
				}
		}
		if (xpoints_left[i]==xmax_left) {
			left[0]=xpoints_left[i];
			left[1]=ypoints_left[i];
		}
	
		if (keep[0]>keep[2]) {
				left[2]=keep[0];
				left[3]=keep[0+1];			
		}
		if (keep[0]<keep[2]) {
				left[2]=keep[2];
				left[3]=keep[2+1];
		}
		
		
		}
		//Array.print(left);
		/////
	
		
	//ri	ght
		j=0;
		right=newArray(4);
		//keep=newArray(4);
		for (i = 0; i < 4; i++) {
	
		if (xpoints_right[i]<xmax_right) {
			if (xpoints_right[i]>xmin_right) {
				keep[2*j]=xpoints_right[i]; 
				keep[2*j+1]=ypoints_right[i]; 
				j=j+1;
				}
		}
		if (xpoints_right[i]==xmin_right) {
			right[0]=xpoints_right[i];
			right[1]=ypoints_right[i];
		}
	
		if (keep[0]<keep[2]) {
				right[2]=keep[0];
				right[3]=keep[0+1];			
		}
		if (keep[0]>keep[2]) {
				right[2]=keep[2];
				right[3]=keep[2+1];
		}
		
		
		}
		
		//Array.print(right);
	
		/*roiManager("Select", k*2);
		makePolygon(left[0],left[1],left[2],left[3],right[0],right[1],right[2],right[3]);
		roiManager("Add");
		*/
	/////////////////
	
		lefttop=newArray(2);
		leftbot=newArray(2);
		righttop=newArray(2);
		rightbot=newArray(2);
		
		if (left[1]<left[3]) {
		lefttop[0]=left[0];
		lefttop[1]=left[1];		
		leftbot[0]=left[2];
		leftbot[1]=left[3];
		}
		if (left[1]>left[3]) {
		leftbot[0]=left[0];
		leftbot[1]=left[1];
		lefttop[0]=left[2];
		lefttop[1]=left[3];	
		}
		
		if (right[1]<right[3]) {
		righttop[0]=right[0];
		righttop[1]=right[1];		
		rightbot[0]=right[2];
		rightbot[1]=right[3];
		}
		if (right[1]>right[3]) {
		rightbot[0]=right[0];
		rightbot[1]=right[1];
		righttop[0]=right[2];
		righttop[1]=right[3];	
		}
	
		roiManager("Select", k*2);
		makePolygon(leftbot[0],leftbot[1],lefttop[0],lefttop[1],righttop[0],righttop[1],rightbot[0],rightbot[1]);
		roiManager("Add");
		
		
		//print(leftbot[0],leftbot[1],lefttop[0],lefttop[1],righttop[0],righttop[1],rightbot[0],rightbot[1]);
		
		Table.create(k);
		Table.setColumn("leftbot", leftbot);
		Table.setColumn("lefttop", lefttop);
		Table.setColumn("righttop", righttop);
		Table.setColumn("rightbot", rightbot);
		saveAs("Results", outtensorcoordinates+IJ.pad(k, 3)+".txt");
		//run("Close");
		close(IJ.pad(k, 3)+".txt");
	
	}
	
	//saveAs("Text", outtensor+baseoriginName+".txt");
	n=roiManager("count");
	A=newArray(n-N);
	for (i = 0; i < n-N; i++) {
		A[i]=i+(n-N/2/2);
	}
	//Array.print(A);
	roiManager("Select", A);
	run("Set Measurements...", "area mean standard min centroid center bounding shape integrated stack redirect=None decimal=3");
	roiManager("Measure");
	saveAs("Results", outputResults_rec+baseoriginName+".txt");
	close("Results");
	
	
	roiManager("Save", outputROI+baseoriginName+".zip");
	
	//measure prebleach
	roiManager("Select", n-N/2/2);
	run("Previous Slice [<]");
	run("Previous Slice [<]");
	run("Previous Slice [<]");
	run("Previous Slice [<]");
	run("Previous Slice [<]");
	run("Previous Slice [<]");
	for (f = 0; f < PrebleachFrame; f++) {
	run("Measure");
	run("Next Slice [>]");
	
		}
	//run("Measure");
	saveAs("Results", outputResults_pre+baseoriginName+".txt");
	close("Results");
	close();
		
		}