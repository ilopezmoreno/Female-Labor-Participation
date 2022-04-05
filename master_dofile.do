* We define the main working directory
gl root  = "C:\Users\Aida Flores\Desktop\Replication Exercise" // Please specify the working directory using the folder that was created in your computer. 
cd "$root"

* Run the do files

do "data_cleaning.do"	
cd "$root"

do "data_transformation.do"	
cd "$root"

do "regressions.do"	
cd "$root"

do "graphs.do"	
cd "$root"

do "maps.do"	
cd "$root"
