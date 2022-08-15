/*
 This macro is to split color channels and convert into tiff images.
 After running this, 'tifimage-chX' will be created, in which there is/are tiff images you want to analyze.
 */



















//
path=getDirectory("Chose current folder that contains 'LSM_images'");

inputfile=path+"LSM_images\\";

if (File.exists(inputfile)==0){
	print("Add all images you want to analyze into folder name 'LSM_images'");
	return;
}

list=getFileList(inputfile);
//
extension_LSM = "."+retFilenameWE(list[0]);
// return filename extension
function retFilenameWE(t) {
    _name = split(t,"."); 
    ot = _name[_name.length-1];
    return ot;
}

for (i=0; i<list.length; i++){
	open(inputfile+list[i]);
	imagename=getTitle();
	//ext
	baseNameEnd=indexOf(imagename, extension_LSM);
	//
	baseName=substring(imagename, 0, baseNameEnd);
	getDimensions(width, height, channels, slices, frames);
	n=nSlices;
	//split channels
	for (j=1; j<=channels; j++){ 
	run("Duplicate...", "title=ch"+j+" duplicate channels="+j+"-"+j);
	run("Grays");
	outputfile=path+"tifimage-ch"+j+"\\";
	File.makeDirectory(outputfile);
	savefile=outputfile+IJ.pad(i, 5)+"-"+baseName;
	saveAs("Tiff",savefile);
	close();
	}
	

	close();
}
