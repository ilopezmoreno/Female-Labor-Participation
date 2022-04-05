*Crear mapa de México por estado


* We define the working directory
gl root  = "$root" 
cd "$root"

use mexstatesdb, clear

spmap id using mexstatescoord.dta, id(id)

use stateleveldatabase, clear

rename estado_sin_acento ESTADO

merge m:1 ESTADO using "mexstatesdb"

spmap w_pov_wjob using mexstatescoord.dta, id(id) title("Percentage of poor women without a job (Mexico, 2018)", size(medium)) subtitle("Made by Isaac-López Moreno", size(small))
graph export "$root\pw_unemployed.png", replace

spmap w_pov_work using mexstatescoord.dta, id(id) title("Percentage of poor women with a job (Mexico, 2018)", size(medium)) subtitle("Made by Isaac-López Moreno", size(small))
graph export "$root\pw_employed.png", replace

spmap w_nopov_wjob using mexstatescoord.dta, id(id) title("Percentage of non-poor women without a job (Mexico, 2018)", size(medium)) subtitle("Made by Isaac-López Moreno", size(small))
graph export "$root\npw_unemployed.png", replace

spmap w_nopov_work using mexstatescoord.dta, id(id) title("Percentage of non-poor women with a job (Mexico, 2018)", size(medium)) subtitle("Made by Isaac-López Moreno", size(small))
graph export "$root\npw_employed.png", replace
