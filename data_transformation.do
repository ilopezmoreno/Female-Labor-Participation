***************************************
***** Data Transformation Process *****
***************************************

* In this section I document all the decisions I made related to missing values and also the data transformation process of some variables. 

*** Missing values decisions ***

* The variable eda7c includes observation that were categorize as 0 if respondents were below 14 years old
* In order to remove these kids from the sample, I will order stata to replace them as missing values. 
tab eda7c
tab eda eda7c
replace eda7c=. if eda7c==0

* The variable hij5c includes observation that were categorize as "0" for those who "Doesn't apply" 
tab hij5c sex // As it can be observed, does who doesn't apply are only men. 
* Therefore, I will replace "0" as a missing value
replace hij5c=. if hij5c==0
* In addition, there are 15 cases where the female respondents did not specified if they had kids.
tab eda hij5c if hij5c==5 & sex==2
* Therefore, I will replace "5" as a missing value
replace hij5c=. if hij5c==5

label define hij5c 1 "No kids", modify
label define hij5c 2 "1 to 2 kids", modify
label define hij5c 3 "3 to 5 kids", modify
label define hij5c 4 "6 or more kids", modify


* The variable "e_con" includes 31 observations that were categorize as "9" for those who "Doesn't know their marital situation"
tab e_con, nolabel // As you can observe, 
* Therefore, I will replace "9" as a missing value
replace e_con=. if e_con==9



label define e_con 1 "Free Union", modify
label define e_con 2 "Separated", modify
label define e_con 3 "Divorced", modify
label define e_con 4 "Widowed", modify
label define e_con 5 "Married", modify
label define e_con 6 "Single", modify


*** Data Transformation ***


* The variable "clase1" differentiates between the economically active population and the non-economically active population. 
tab clase1
* 1 = Economically Active / 2 = Non-Economically Active
* I will replace value 2 for value 0 to make it a dummy variable
replace clase1=0 if clase1==2


* Defining value names of variable "est" which means "social stratum"
* 10 = Low / 20 = Medium Low / 30 = Medium High / 40 = High
label define est 10 "Low" 20 "Medium-Low" 30 "Medium-High" 40 "High" 
label value est est
tab est


*** Generate a "female disempowerment variable"

* In the employment survey "COE1", the variable "p2g2" shows why the people are not looking for a job. 
* There are different options, but the most populars are:
* "09" - I don't have someone to take care of my children, elderly or sick persons that are living in the household.
* "04" - I think that because of my age or my appearance, I would not be accepted for a job.
* "07" - I'm recovering from an accident or a disease. 
* In addition, there is an answer that could be a good proxy of female disempowerment. 
* "10" - A relative is not letting me work. 
* The problem with this answer is that there could be elderly people that are choosing this option. 
* However, I want to know if women that are married and that have a working age are picking this option. 

tab p2g2 // 705 people answered that a relative is not letting them work
tab p2g2 if p2g2==10 [fweight=fac] // Using the expansion variable "fac" we now that 227,153 are not working because a relative is not letting them
tab p2g2 if p2g2==10 & sex==0 & e_con==5 & eda>=18 & eda<=65 [fweight=fac] // From the 227,153 people that are not working because a relative is not letting them, 59,175 are women in working ages that are married. 
tab ent p2g2 if p2g2==10 & sex==0 & e_con==5 & eda>=18 & eda<=65 [fweight=fac]
tab mun p2g2 if p2g2==10 & sex==0 & e_con==5 & eda>=18 & eda<=65 [fweight=fac]

gen disempowerment=0
replace disempowerment=1 if p2g2==10 & sex==0 & e_con==5 & eda>=18 & eda<=65
tab eda disempowerment // Data quality check: 
tab disempowerment [fweight=fac] 


* Generate unique_id 
egen house_id = concat(cd_a ent con v_sel n_hog h_mud), punct(.) // unique_id for each household 
egen person_id = concat(cd_a ent con v_sel n_hog h_mud n_ren), punct(.) // unique_id for each individual
egen ent_mun = concat(ent mun), punct(.) // unique_id for each municipality 

label define t_loc 1 "More than 100,000", modify
label define t_loc 2 "Between 15,000 and 99,999", modify
label define t_loc 3 "Between 2,500 and 14,999", modify
label define t_loc 4 "Less than 2,500", modify



* Generate dummy variables to identify males and females.
gen female=.
replace female=1 if sex==2
replace female=0 if sex==1
label define female_label 1 "Female" 0 "Male"
label values female female_label


gen male=.
replace male=1 if sex==1
replace male=0 if sex==2
label define male_label 1 "Male" 0 "Female"
label values male male_label



tab female // Data quality check. Result: 0 missing values.
tab male // Data quality check. Result: 0 missing values.
tab sex // Data quality check. Result: New variables are correct.






* Generate a categorical variable to identify if the person works in the primary, secondary or terciary sector. 
generate P4A_Sector=.
rename p4a P4A 
replace P4A_Sector=1 if P4A>=1100 & P4A<=1199 // If values in P4A are between 1100 & 1199 classify as PRIMARY SECTOR
replace P4A_Sector=2 if P4A>=2100 & P4A<=3399 // If values in P4A are between 2100 & 2399 classify as SECONDARY SECTOR
replace P4A_Sector=3 if P4A>=4300 & P4A<=9399 // If values in P4A are between 4300 & 9399 classify as TERCIARY SECTOR
replace P4A_Sector=4 if P4A>=9700 & P4A<=9999 // *If values in P4A are between 9700 & 9999 classify as UNSPECIFIED ACTIVITIES
* Define values of variable P4A_Sector
label var P4A_Sector "Economic Sector Categories"
label define P4A_Sector 1 "Primary Sector" 2 "Secondary Sector" 3 "Terciary Sector" 4 "Unspecified Sector"
label value P4A_Sector P4A_Sector
tab P4A_Sector // Data quality check. Result: 0 missing values


* Generate dummy variables to identify if the person works in the primary, secondary or terciary sector. 
generate agri_sector=.
replace agri_sector=1 if P4A>=1100 & P4A<=1199 // If values in P4A are between 1100 & 1199 classify as PRIMARY SECTOR
replace agri_sector=0 if P4A>=2100 & P4A<=3399 // If values in P4A are between 2100 & 2399 do not classify as PRIMARY SECTOR
replace agri_sector=0 if P4A>=4300 & P4A<=9399 // If values in P4A are between 4300 & 9399 do not classify as PRIMARY SECTOR
replace agri_sector=0 if P4A>=9700 & P4A<=9999 // If values in P4A are between 9700 & 9999 do not classify as PRIMARY SECTOR

generate ind_sector=.
replace ind_sector=0 if P4A>=1100 & P4A<=1199 // If values in P4A are between 1100 & 1199 do not classify as SECONDARY SECTOR
replace ind_sector=1 if P4A>=2100 & P4A<=3399 // If values in P4A are between 2100 & 2399 classify as SECONDARY SECTOR
replace ind_sector=0 if P4A>=4300 & P4A<=9399 // If values in P4A are between 4300 & 9399 do not classify as SECONDARY SECTOR
replace ind_sector=0 if P4A>=9700 & P4A<=9999 // If values in P4A are between 9700 & 9999 do not classify as SECONDARY SECTOR

generate serv_sector=.
replace serv_sector=0 if P4A>=1100 & P4A<=1199 // If values in P4A are between 1100 & 1199 do not classify as TERCIARY SECTOR
replace serv_sector=0 if P4A>=2100 & P4A<=3399 // If values in P4A are between 2100 & 2399 do not classify as TERCIARY SECTOR
replace serv_sector=1 if P4A>=4300 & P4A<=9399 // If values in P4A are between 4300 & 9399 classify as TERCIARY SECTOR
replace serv_sector=0 if P4A>=9700 & P4A<=9999 // If values in P4A are between 9700 & 9999 do not classify as TERCIARY SECTOR

generate unsp_sector=.
replace unsp_sector=0 if P4A>=1100 & P4A<=1199 // If values in P4A are between 1100 & 1199 do not classify as UNSPECIFIED SECTOR
replace unsp_sector=0 if P4A>=2100 & P4A<=3399 // If values in P4A are between 2100 & 2399 do not classify as UNSPECIFIED SECTOR
replace unsp_sector=0 if P4A>=4300 & P4A<=9399 // If values in P4A are between 4300 & 9399 do not classify as UNSPECIFIED SECTOR
replace unsp_sector=1 if P4A>=9700 & P4A<=9999 // If values in P4A are between 9700 & 9999 classify as UNSPECIFIED SECTOR


* Calculate the percentage of jobs by sector in each municipality
by ent_mun, sort: egen pct_agri_employ = mean(100 * agri_sector) // To calculate the percentage of agricultural jobs in each municipality
by ent_mun, sort: egen pct_ind_employ = mean(100 * ind_sector) // To calculate the percentage of industrial jobs in each municipality
by ent_mun, sort: egen pct_serv_employ = mean(100 * serv_sector) // To calculate the percentage of service jobs in each municipality
by ent_mun, sort: egen pct_unsp_employ = mean(100 * unsp_sector) // To calculate the percentage of unspecified jobs in each municipality



generate employ_share_agri=.
replace employ_share_agri=1 if pct_agri_employ>=0 & pct_agri_employ<=9.99999999 // If values in P4A are between 1100 & 1199 do not classify as UNSPECIFIED SECTOR
replace employ_share_agri=2 if pct_agri_employ>=10 & pct_agri_employ<=19.99999999 // If values in P4A are between 2100 & 2399 do not classify as UNSPECIFIED SECTOR
replace employ_share_agri=3 if pct_agri_employ>=20 & pct_agri_employ<=29.99999999 // If values in P4A are between 4300 & 9399 do not classify as UNSPECIFIED SECTOR
replace employ_share_agri=4 if pct_agri_employ>=30 & pct_agri_employ<=39.99999999 // If values in P4A are between 9700 & 9999 classify as UNSPECIFIED SECTOR
replace employ_share_agri=5 if pct_agri_employ>=40 & pct_agri_employ<=49.99999999 // If values in P4A are between 1100 & 1199 do not classify as UNSPECIFIED SECTOR
replace employ_share_agri=6 if pct_agri_employ>=50 & pct_agri_employ<=59.99999999 // If values in P4A are between 2100 & 2399 do not classify as UNSPECIFIED SECTOR
replace employ_share_agri=7 if pct_agri_employ>=60 & pct_agri_employ<=69.99999999 // If values in P4A are between 4300 & 9399 do not classify as UNSPECIFIED SECTOR
replace employ_share_agri=8 if pct_agri_employ>=70 & pct_agri_employ<=79.99999999 // If values in P4A are between 9700 & 9999 classify as UNSPECIFIED SECTOR
replace employ_share_agri=9 if pct_agri_employ>=80 & pct_agri_employ<=89.99999999 // If values in P4A are between 4300 & 9399 do not classify as UNSPECIFIED SECTOR
replace employ_share_agri=10 if pct_agri_employ>=90 & pct_agri_employ<=100 // If values in P4A are between 9700 & 9999 classify as UNSPECIFIED SECTOR
label var employ_share_agri "Share of agricultural employment"
label define employ_share_agri 1 "0-9.9" 2 "10-19.99" 3 "20-29.99" 4 "30-39.99" 5 "40-49.99" 6 "50-59.99" 7 "60-69.99" 8 "70-79.99" 9 "80-89.99" 10 "90-100"
label value employ_share_agri employ_share_agri
tab employ_share_agri // Data quality check. Result: 0 missing values
 

* Generate a categorical variable to identify the economic activity that each individual does in the three sector specified above

* The Economic Sector Classification is based on manuals from INEGI 
* INEGI Codes for the classification of economic activities are available at: https://www.inegi.org.mx/contenidos/programas/enoe/15ymas/doc/clasificaciones_enoe.pdf
* From page 9 to page 16 you will find how INEGI classify each code in different categories
* Based on those codes and categories, I can dissagregate each activity in a more specific clasification of economic activities, so I can identify the main occupations of men and women. 

generate P4A_Class=.

* If values in P4A are between 1100 & 1199 classify as "Agriculture, Livestock, Forestry, Hunting and Fishing"
replace P4A_Class=1 if P4A>=1100 & P4A<=1199
*1110 Agricultura
*1121 Cr??a y explotaci??n de animales
*1122 Acuicultura
*1130 Aprovechamiento forestal
*1141 Pesca
*1142 Caza y captura
*1150 Servicios relacionados con las actividades agropecuarias y forestales
*1199 Descripciones insuficientemente especificadas de subsector de actividad del sector 11: Agricultura, cr??a y explotaci??n de animales, aprovechamiento forestal, pesca y caza

* If values in P4A are between 2100 & 2199 classify as "Mining"
replace P4A_Class=2 if P4A>=2100 & P4A<=2199
*2110 Extracci??n de petr??leo y gas
*2121 Miner??a de carb??n mineral
*2122 Miner??a de minerales met??licos
*2123 Miner??a de minerales no met??licos
*2129 Descripciones insuficientemente especificadas de minerales met??licos y no met??licos
*2131 Servicios relacionados con la miner??a
*2132 Perforaci??n de pozos petroleros y de gas
*2199 Descripciones insuficientemente especificadas de subsector de actividad del sector 21 

* If values in P4A are between 2210 & 2299 classify as "Generation, Transmition and distribution of Electricity, Water & Gas"
replace P4A_Class=3 if P4A>=2210 & P4A<=2299
*2210 Generaci??n, transmisi??n y distribuci??n de energ??a el??ctrica
*2221 Captaci??n, tratamiento y suministro de agua
*2222 Suministro de gas por ductos al consumidor final

* If values in P4A are between 2300 & 2399 classify as "Construction"
replace P4A_Class=4 if P4A>=2300 & P4A<=2399
*2361 Edificaci??n residencial
*2362 Autoconstrucci??n residencial
*2363 Edificaci??n no residencial
*2370 Construcci??n de obras de ingenier??a civil
*2381 Trabajos especializados para la construcci??n
*2382 Trabajos de alba??iler??a de instalaciones hidrosanitarias y el??ctricas y de trabajos en exteriores
*2399 Descripciones insuficientemente especificadas de subsector de actividad del sector 23, Construcci??n

* If values in P4A are between 3100 & 3399 classify as "Transformation Industry (Manufacturing)"
replace P4A_Class=5 if P4A>=3100 & P4A<=3399
*3110 Industria alimentaria
*3120 Industria de las bebidas y del tabaco
*3130 Fabricaci??n de insumos textiles y acabado de textiles
*3140 Fabricaci??n de productos textiles, excepto prendas de vestir
*3150 Fabricaci??n de prendas de vestir
*3160 Curtido y acabado de cuero y piel, y fabricaci??n de productos de cuero, piel y materiales suced??neos
*3210 Industria de la madera
*3220 Industria del papel
*3230 Impresi??n e industrias conexas
*3240 Fabricaci??n de productos derivados del petr??leo y del carb??n
*3250 Industria qu??mica
*3260 Industria del pl??stico y del hule 
*3270 Fabricaci??n de productos a base de minerales no met??licos
*3310 Industrias met??licas b??sicas
*3320 Fabricaci??n de productos met??licos
*3330 Fabricaci??n de maquinaria y equipo
*3340 Fabricaci??n de equipo de computaci??n, comunicaci??n, medici??n y de otros equipos, componentes y accesorios electr??nicos
*3350 Fabricaci??n de accesorios, aparatos el??ctricos y equipo de generaci??n de energ??a el??ctrica
*3360 Fabricaci??n de equipo de transporte y partes para veh??culos automotores
*3370 Fabricaci??n de muebles, colchones y persianas
*3380 Otras industrias manufactureras
*3399 Descripciones insuficientemente especificadas de subsector de actividad del sector 31-33 Industrias manufactureras 

* If values in P4A are between 4300 & 4399 classify as "Wholesale Trade" 
replace P4A_Class=6 if P4A>=4300 & P4A<=4399
*4310 Comercio al por mayor de abarrotes, alimentos, bebidas, hielo y tabaco
*4320 Comercio al por mayor de productos textiles y calzado
*4330 Comercio al por mayor de productos farmac??uticos, de perfumer??a, art??culos para el esparcimiento, electrodom??sticos menores y aparatos de l??nea blanca
*4340 Comercio al por mayor de materias primas agropecuarias y forestales, para la industria, y materiales de desecho
*4350 Comercio al por mayor de maquinaria, equipo y mobiliario para actividades agropecuarias, industriales, de servicios y comerciales, y de otra maquinaria y equipo de uso general
*4360 Comercio al por mayor de camiones y de partes y refacciones nuevas para autom??viles, camionetas y camiones
*4370 Intermediaci??n de comercio al por mayor
*4399 Descripciones insuficientemente especificadas de subsector de actividad del sector 43, Comercio al por mayor 

* If values in P4A are between 4600 & 4699 classify as "Retail Trade" 
replace P4A_Class=7 if P4A>=4600 & P4A<=4699
*4611 Comercio al por menor de abarrotes, alimentos, bebidas, hielo y tabaco
*4612 Comercio ambulante de abarrotes, alimentos, bebidas, hielo y tabaco
*4620 Comercio al por menor en tiendas de autoservicio y departamentales
*4631 Comercio al por menor de productos textiles, bisuter??a, accesorios de vestir y calzado
*4632 Comercio ambulante de productos textiles, bisuter??a, accesorios de vestir y calzado
*4641 Comercio al por menor de art??culos para el cuidado de la salud
*4642 Comercio ambulante de art??culos para el cuidado de la salud 
*4651 Comercio al por menor de art??culos de papeler??a, para el esparcimiento y otros art??culos de uso personal
*4652 Comercio ambulante de art??culos de papeler??a, para el esparcimiento y otros art??culos de uso personal
*4661 Comercio al por menor de enseres dom??sticos, computadoras, art??culos para la decoraci??n de interiores y de art??culos usados
*4662 Comercio ambulante de muebles, art??culos para el hogar y de art??culos usados.
*4671 Comercio al por menor de art??culos de ferreter??a, tlapaler??a y vidrios
*4672 Comercio ambulante de art??culos de ferreter??a, tlapaler??a
*4681 Comercio al por menor de veh??culos de motor, refacciones, combustibles y lubricantes
*4682 Comercio ambulante de partes y refacciones para autom??viles, camionetas y combustibles
*4690 Comercio al por menor exclusivamente a trav??s de Internet, y cat??logos impresos, televisi??n y similares
*4699 Descripciones insuficientemente especificadas de subsector de actividad del sector 43, Comercio al por menor 

* If values in P4A are between 4800 & 4899 classify as "Transportation, communications, mail and warehousing"
replace P4A_Class=8 if P4A>=4800 & P4A<=4899
*4810 Transporte a??reo
*4820 Transporte por ferrocarril
*4830 Transporte por agua
*4840 Autotransporte de carga
*4850 Transporte terrestre de pasajeros, excepto por ferrocarril
*4860 Transporte por ductos
*4870 Transporte tur??stico
*4881 Servicios relacionados con el transporte
*4882 Servicios de reparaci??n y limpieza exterior de aviones, barcos y trenes
*4899 Descripciones insuficientemente especificadas de subsector de actividad del sector 48, Transporte

* If values in P4A are between 4900 & 4999 classify as "Postal Services"
replace P4A_Class=9 if P4A>=4900 & P4A<=4999
*4910 Servicios postales
*4920 Servicios de mensajer??a y paqueter??a
*4930 Servicios de almacenamiento

* If values in P4A are between 5100 & 5199 classify as "Media Communication"
replace P4A_Class=10 if P4A>=5100 & P4A<=5199
*5110 Edici??n de peri??dicos, revistas, libros, software y otros materiales, y edici??n de estas publicaciones integrada con la impresi??n
*5120 Industria f??lmica y del video, e industria del sonido
*5150 Radio y televisi??n
*5170 Otras telecomunicaciones
*5180 Procesamiento electr??nico de informaci??n, hospedaje y otros servicios relacionados
*5190 Otros servicios de informaci??n
*5199 Descripciones insuficientemente especificadas de subsector de actividad del sector 51, Informaci??n en medios masivos 

* If values in P4A are between 5200 & 5299 classify as "Financial and insurance services"
replace P4A_Class=11 if P4A>=5200 & P4A<=5299
*5210 Banca central (Banco de M??xico)
*5221 Banca m??ltiple, y administraci??n de fondos y fideicomisos del sector privado
*5222 Otras instituciones de intermediaci??n crediticia y financiera no burs??til del sector privado
*5223 Banca de desarrollo, y administraci??n de fondos y fideicomisos del sector p??blico
*5229 Descripciones insuficientemente especificadas de servicios financieros no burs??tiles
*5230 Actividades burs??tiles, cambiarias y de inversi??n financiera
*5240 Compa????as de fianzas, seguros y pensiones
*5299 Descripciones insuficientemente especificadas de subsector de actividad del sector 52, Servicios financieros y de seguros

* If values in P4A are between 5300 & 5399 classify as "Real estate services and rental of movable and intangible assets "
replace P4A_Class=12 if P4A>=5300 & P4A<=5399
*5310 Servicios inmobiliarios
*5321 Servicios de alquiler de autom??viles, camiones y otros transportes terrestres
*5322 Servicios de alquiler y centros de alquiler de bienes muebles, excepto equipo de transporte terrestre
*5330 Servicios de alquiler de marcas registradas, patentes y franquicias
*5399 Descripciones insuficientemente especificadas de subsector de actividad del sector 53, Servicios inmobiliarios y de alquiler de bienes muebles e intangibles 

* If values in P4A are between 5400 & 5499 classify as "Professional, scientific and technical services"
replace P4A_Class=13 if P4A>=5400 & P4A<=5499
*5411 Servicios profesionales, cient??ficos y t??cnicos
*5412 Servicios de investigaci??n cient??fica y desarrollo
*5413 Servicios veterinarios
*5414 Servicios de fotograf??a 

* If values in P4A are between 5500 & 5599 classify as "Corporative services"
replace P4A_Class=14 if P4A>=5500 & P4A<=5599
*5510 Corporativos 

* If values in P4A are between 5600 & 5599 classify as "Business support services, waste management and remediation services"
replace P4A_Class=15 if P4A>=5600 & P4A<=5699
*5611 Servicios de apoyo a los negocios, de empleo, apoyo secretarial y otros servicios de apoyo a los negocios
*5612 Limpieza interior de aviones, barcos y trenes
*5613 Servicios de limpieza y de instalaci??n y mantenimiento de ??reas verdes
*5614 Servicios de investigaci??n, protecci??n y seguridad
*5615 Agencias de viajes y servicios de reservaciones
*5616 Servicios combinados de apoyo a instalaciones
*5620 Manejo de desechos y servicios de remediaci??n 

* If values in P4A are between 6100 & 6199 classify as "Education Services"
replace P4A_Class=16 if P4A>=6100 & P4A<=6199
*6111 Escuela de educaci??n b??sica, media y especial pertenecientes al sector privado
*6112 Escuela de educaci??n b??sica, media y especial pertenecientes al sector p??blico
*6119 Escuela de educaci??n b??sica, media y especial no especificadas de sector privado o p??blico
*6121 Escuelas de educaci??n postbachillerato no universitaria perteneciente al sector privado
*6122 Escuelas de educaci??n postbachillerato no universitaria perteneciente al sector p??blico
*6129 Escuelas de educaci??n postbachillerato no universitaria no especificadas de sector privado o p??blico
*6131 Escuelas de educaci??n superior pertenecientes al sector privado
*6132 Escuelas de educaci??n superior pertenecientes al sector p??blico
*6139 Escuelas de educaci??n superior no especificadas de sector privado o p??blico
*6141 Otros servicios educativos pertenecientes al sector privado
*6142 Otros servicios educativos pertenecientes al sector p??blico
*6149 Otros servicios educativos no especificados de sector privado o p??blico
*6150 Servicios de apoyo a la educaci??n
*6199 Descripciones insuficientemente especificadas de subsector de actividad del sector 61, Servicios educativos 

* If values in P4A are between 6200 & 6299 classify as "Health Services"
replace P4A_Class=17 if P4A>=6200 & P4A<=6299
*6211 Servicios m??dicos de consulta externa y servicios relacionados pertenecientes al sector privado
*6212 Servicios m??dicos de consulta externa y servicios relacionados pertenecientes al sector p??blico
*6219 Servicios m??dicos de consulta externa y servicios relacionados no especificados de sector privado o p??blico
*6221 Hospitales pertenecientes al sector privado
*6222 Hospitales pertenecientes al sector p??blico
*6229 Hospitales no especificados de sector privado o p??blico
*6231 Residencias de asistencia social y para el cuidado de la salud pertenecientes al sector privado 
*6232 Residencias de asistencia social y para el cuidado de la salud pertenecientes al sector p??blico
*6239 Residencias de asistencia social y para el cuidado de la salud no especificadas de sector privado o p??blico
*6241 Otros servicios de asistencia social pertenecientes al sector privado
*6242 Otros servicios de asistencia social pertenecientes al sector p??blico
*6249 Otros servicios de asistencia social no especificados de sector privado o p??blico
*6251 Guarder??as pertenecientes al sector privado
*6252 Guarder??as pertenecientes al sector p??blico
*6259 Guarder??as no especificados de sector privado o p??blico
*6299 Descripciones insuficientemente especificadas de subsector de actividad del sector 62, Servicios de salud y de asistencia social 

* If values in P4A are between 7110 & 7199 classify as "Cultural, sporting and other recreational services" 
replace P4A_Class=18 if P4A>=7100 & P4A<=7199
*7111 Compa????as y grupos de espect??culos art??sticos
*7112 Deportistas y equipos deportivos profesionales y semiprofesionales
*7113 Promotores, agentes y representantes de espect??culos art??sticos, deportivos y similares
*7114 Artistas, escritores y t??cnicos independientes
*7115 Trabajadores ambulantes en espect??culos
*7120 Museos, sitios hist??ricos, zool??gicos y similares
*7131 Parques con instalaciones recreativas y casas de juegos electr??nicos
*7132 Venta de billetes de loter??a nacional
*7133 Venta ambulante de billetes de loter??a nacional

* If values in P4A are between 7210 & 7299 classify as "Temporary accommodation services & food or beverage preparation services" 
replace P4A_Class=19 if P4A>=7200 & P4A<=7299
*7210 Servicios de alojamiento temporal
*7221 Servicios de preparaci??n de alimentos y bebidas
*7222 Servicios de preparaci??n de alimentos y bebidas por trabajadores en unidades ambulantes
*7223 Centros nocturnos

* If values in P4A are between 8110 & 8199 classify as "Other services except governmental activities"
replace P4A_Class=20 if P4A>=8100 & P4A<=8199
*8111 Servicios de reparaci??n y mantenimiento de autom??viles y camiones
*8112 Servicios de reparaci??n y mantenimiento de equipo, maquinaria, art??culos para el hogar y personales
*8119 Descripciones insuficientemente especificadas de servicios de reparaci??n y mantenimiento
*8121 Servicios personales
*8122 Estacionamientos y pensiones para veh??culos automotores
*8123 Servicios de cuidado y de lavado de autom??viles por trabajadores ambulantes
*8124 Servicios de revelado e impresi??n de fotograf??as
*8125 Servicios de administraci??n de cementerios
*8130 Asociaciones y organizaciones
*8140 Hogares con empleados dom??sticos

* If values in P4A are between 9300 & 9399 classify as "Government & International Organizations"
replace P4A_Class=21 if P4A>=9300 & P4A<=9399
*9311 ??rganos legislativos
*9312 Administraci??n P??blica Federal
*9313 Administraci??n P??blica Estatal
*9314 Administraci??n P??blica Municipal
*9319 Descripciones de administraci??n p??blica que no especifican el nivel de gobierno
*9320 Organismos internacionales y extraterritoriales

* If values in P4A are between 9700 & 9999 classify as "Unspecified activities"
replace P4A_Class=22 if P4A>=9700 & P4A<=9999
*9999 No especificado de sector de actividad

label var P4A_Class "Economic Activities Classification"
label define P4A_Class 1 "Agriculture, Livestock, Forestry, Hunting and Fishing" 2 "Mining" 3 "Generation, Transmition and distribution of Electricity, Water & Gas" 4 "Construction" 5 "Manufacturing" 6 "Wholesale Trade" 7 "Retail Trade" 8 "Transportation, communications, mail and warehousing" 9 "Postal Services" 10 "Media Communication" 11 "Financial and insurance services" 12 "Real estate services and rental of movable and intangible assets" 13 "Professional, scientific and technical services" 14 "Corporative services" 15 "Business support services, waste management and remediation services" 16 "Education Services" 17 "Health Services" 18 "Cultural, sporting and other recreational services" 19 "Temporary accommodation services & food or beverage preparation services" 20 "Other services except governmental activities" 21 "Government & International Organizations" 22 "Unspecified activities"
label value P4A_Class P4A_Class
tab P4A_Class // Data quality check. Result: 0 missing values


* Generate a set of dummy variables to identify the sectoral distribution of employment depending on the population size of the LOCALITY where the people live. 
tab t_loc // t_loc is a categorical variable that takes the value of
* 1 if the location has more than 100,000 inhabitants 
* 2 if the location has between 15,000 and 99,999 inhabitants
* 3 if the location has between 2,500 and 14,999 inhabitants
* 4 if the location has less than 2,500 inhabitants
tab P4A_Sector if t_loc==1 // Result: Agri:  0.80% | Ind:25.50% | Serv: 72.97%
tab P4A_Sector if t_loc==2 // Result: Agri:  5.26% | Ind:28.42% | Serv: 65.97% 
tab P4A_Sector if t_loc==3 // Result: Agri: 14.33% | Ind:28.63% | Serv: 56.71% 
tab P4A_Sector if t_loc==4 // Result: Agri: 40.41% | Ind:23.03% | Serv: 36.10%  
* agri_towns will identify agricultural towns, where more than 40% of the total employment is in agricultural activities.
generate agri_towns=.
replace agri_towns=1 if t_loc==4
replace agri_towns=0 if t_loc<4
label define agri_towns 0 "No Agricultural Town" 1 "Agricultural Town"
label value agri_towns agri_towns
* ind_towns will identify industrial towns, where more than 28% of the total employment is in industrial activities, and there is between 2,500 and 14,999 inhabitants
generate ind_towns=.
replace ind_towns=1 if t_loc==3
replace ind_towns=0 if t_loc>3
replace ind_towns=0 if t_loc<3
label define ind_towns 0 "No Industrial Town" 1 "Industrial Town"
label value ind_towns ind_towns
* ind_city will identify ind_city, where more than 28% of the total employment is in industrial activities, and there is between 15,000 and 99,999 inhabitants
generate ind_cities=.
replace ind_cities=1 if t_loc==2
replace ind_cities=0 if t_loc<2
replace ind_cities=0 if t_loc>2
label define ind_cities 0 "No Industrial City" 1 "Industrial City"
label value ind_cities ind_cities
* serv_cities will  identify service oriented cities, where more than 70% of the total employment is in service activities
generate serv_cities=.
replace serv_cities=1 if t_loc==1
replace serv_cities=0 if t_loc>1
label define serv_cities 0 "No Service City" 1 "Service City"
label value serv_cities serv_cities
* Data quality check. To verify if the new variables to identify the population size and the sectoral distribution of employment were created correctly. 
tab agri_towns // Result: 0 missing values
tab ind_towns // Result: 0 missing values
tab ind_cities // Result: 0 missing values
tab serv_cities // Result: 0 missing values
tab t_loc // Result: New variables are correct.


* Generate a set of dummy variables to identify the marital status 
* union_married will identify people who are married or who are living together under the common-law regime
generate married_union=.
replace married_union=1 if e_con==1 // Common-Law Union
replace married_union=0 if e_con==2 // Separated
replace married_union=0 if e_con==3 // Divorced
replace married_union=0 if e_con==4 // Widow or widower
replace married_union=1 if e_con==5 // Married
replace married_union=0 if e_con==6 // Single
replace married_union=0 if e_con==9 // Don't Know
label define married_union 0 "Not married" 1 "Married"
label value married_union married_union
*single will idenfity people who are single
generate single=.
replace single=0 if e_con==1 // Common-Law Union
replace single=0 if e_con==2 // Separated
replace single=0 if e_con==3 // Divorced
replace single=0 if e_con==4 // Widow or widower
replace single=0 if e_con==5 // Married
replace single=1 if e_con==6 // Single
replace single=0 if e_con==9 // Don't Know
label define single 0 "Not Single" 1 "Single"
label value single single
*divorce_sep_wid will idenfity people who are divorced, separated or are widows / widowers
generate divorce_sep_wid=.
replace divorce_sep_wid=0 if e_con==1 // Common-Law Union
replace divorce_sep_wid=1 if e_con==2 // Separated
replace divorce_sep_wid=1 if e_con==3 // Divorced
replace divorce_sep_wid=1 if e_con==4 // Widow or widower
replace divorce_sep_wid=0 if e_con==5 // Married
replace divorce_sep_wid=0 if e_con==6 // Single
replace divorce_sep_wid=0 if e_con==9 // Don't Know
label define divorce_sep_wid 0 "Not Divorced, Separated, Widowed" 1 "Divorced, Separated, Widowed"
label value divorce_sep_wid divorce_sep_wid
* Data quality check. To verify if the new variables to identify the marital status were created correctly
tab married_union // Data quality check.
tab single // Data quality check.
tab divorce_sep_wid // Data quality check.
tab e_con // Data quality check.


* Generate a set of dummy variables to identify the educational attaintment  

*no_studies will identify people who doesn't have any studies.
generate no_studies=.
replace no_studies=1 if cs_p13_1==0 // 0 = No studies at all 
replace no_studies=1 if cs_p13_1==1 // 1 = Pre-school
replace no_studies=0 if cs_p13_1==2 // 2 = Elementary school
replace no_studies=0 if cs_p13_1==3 // 3 = Secondary school 
replace no_studies=0 if cs_p13_1==4 // 4 = High School
replace no_studies=0 if cs_p13_1==5 // 5 = Teacher Training College
replace no_studies=0 if cs_p13_1==6 // 6 = Technical career
replace no_studies=0 if cs_p13_1==7 // 7 = Bachelor's Degree
replace no_studies=0 if cs_p13_1==8 // 8 = Master's Degree
replace no_studies=0 if cs_p13_1==9 // 9 = Ph.D.
replace no_studies=0 if cs_p13_1==99 // 99 = Doesn't Know

*element_sch will identify people who have finished just elementary school or less 
generate element_sch=.
replace element_sch=0 if cs_p13_1==0 // 0 = No studies at all 
replace element_sch=0 if cs_p13_1==1 // 1 = Pre-school
replace element_sch=1 if cs_p13_1==2 // 2 = Elementary school
replace element_sch=0 if cs_p13_1==3 // 3 = Secondary school 
replace element_sch=0 if cs_p13_1==4 // 4 = High School
replace element_sch=0 if cs_p13_1==5 // 5 = Teacher Training College
replace element_sch=0 if cs_p13_1==6 // 6 = Technical career
replace element_sch=0 if cs_p13_1==7 // 7 = Bachelor's Degree
replace element_sch=0 if cs_p13_1==8 // 8 = Master's Degree
replace element_sch=0 if cs_p13_1==9 // 9 = Ph.D.
replace element_sch=0 if cs_p13_1==99 // 99 = Doesn't Know
label define element_sch 0 "More than Elementary School" 1 "Elementary School or less"
label value element_sch element_sch
*secon_sch will identify people who have finished just secondary school 
generate secon_sch=.
replace secon_sch=1 if cs_p13_1==3 // 3 = Secondary school 
replace secon_sch=0 if cs_p13_1<3 
replace secon_sch=0 if cs_p13_1>3 
label define secon_sch 0 "No" 1 "Secondary School"
label value secon_sch secon_sch
*high_sch will identify people who just have a high school degree.
generate high_sch=.
replace high_sch=1 if cs_p13_1==4 // 4 = High School
replace high_sch=0 if cs_p13_1<4 
replace high_sch=0 if cs_p13_1>4 
label define high_sch 0 "No" 1 "High School"
label value high_sch high_sch
*tech_norm_sch will identify people who have a technical career or a degree to be a teacher for elementary and secondary school.
*This differentiation is made because data indicates that in Mexico there is a similar amount of men and women at the different educational levels.
*However, in the levels of "technical career" & "Elementary Teaching Degree" there is around 70% of women and only 30% men. 
tab female if cs_p13_1==0 // 60% Female | 40% Male
tab female if cs_p13_1==1 // 50% Female | 50% Male
tab female if cs_p13_1==2 // 53% Female | 47% Male
tab female if cs_p13_1==3 // 52% Female | 48% Male
tab female if cs_p13_1==4 // 51% Female | 49% Male
tab female if cs_p13_1==5 // 70% Female | 30% Male <---- 5 = Teacher Training College
tab female if cs_p13_1==6 // 72% Female | 28% Male <---- 6 = Technical career
tab female if cs_p13_1==7 // 50% Female | 50% Male
tab female if cs_p13_1==8 // 51% Female | 49% Male
tab female if cs_p13_1==9 // 40% Female | 60% Male
* Therefore, I will generate a variable that group both levels of educations
generate tech_norm_sch=.
replace tech_norm_sch=1 if cs_p13_1==5 // 5 = Teacher Training College
replace tech_norm_sch=1 if cs_p13_1==6 // 6 = Technical career
replace tech_norm_sch=0 if cs_p13_1>6
replace tech_norm_sch=0 if cs_p13_1<5 
label define tech_norm_sch 0 "No" 1 "Technical Career or Elementary Teaching Degree"
label value tech_norm_sch tech_norm_sch
*grad_post_sch will identify people who have a graduate or post-graduate degree.
generate grad_post_sch=.
replace grad_post_sch=1 if cs_p13_1==7 // 7 = Bachelor's Degree
replace grad_post_sch=1 if cs_p13_1==8 // 8 = Master's Degree
replace grad_post_sch=1 if cs_p13_1==9 // 9 = Ph.D.
replace grad_post_sch=0 if cs_p13_1<7 
replace grad_post_sch=0 if cs_p13_1>9
label define grad_post_sch 0 "No" 1 "Graduate or Post-Graduate Degree"
label value grad_post_sch grad_post_sch


*educ will identify the level of education for each person.
generate educ=.
replace educ=1 if no_studies==1
replace educ=2 if element_sch==1
replace educ=3 if secon_sch==1
replace educ=4 if high_sch==1
replace educ=5 if tech_norm_sch==1
replace educ=6 if grad_post_sch==1

label define educ_label 1 "No Studies" 2 "Elementary School" 3 "Secondary School" 4 "High School" 5 "Technical or Normal School" 6 "Graduate & Post-Graduate" 
label values female educ_label
 

* Data quality check. To verify if the new variable were created correctly
tab no_studies // 
tab element_sch // 
tab secon_sch // 
tab high_sch // 
tab tech_norm_sch //
tab grad_post_sch //
tab cs_p13_1 //
tab educ //




*Generate variable to identify people in working ages.
generate working_age=. 
replace working_age=1 if eda<=17 
replace working_age=2 if eda>17 & eda<66
replace working_age=3 if eda>=66






*** Generate a dummy variable that contains only the women that are not working and the women that are working in the industrial sector. 
gen w_job_ind=.
replace  w_job_ind=0 if female==1 & working_age==2 & clase1==0
replace  w_job_ind=1 if female==1 & working_age==2 & clase1==1 & P4A_Sector==2








**** Variable p2g2 indicates the reasons why the survey respondent is not working. 
**** I want to check if the option 5 "Someone in not letting me work" increase in agricultural enviroments. 
**** If there was an increase, it could indicate that females in agicultural enviroments are not working because maybe the husband is not letting them work.
tab p2g2 
* Option 1 - 0.79%
* Option 2 - 0.29%
* Option 3 - 2.13%
* Option 4 - 17.54% - They think that due to his age or their look, they will not be hired
* Option 5 - 6.27% - In the locality there is no jobs, or there are jobs just during certain seasons. 
* Option 6 - 0.32% - 
* Option 7 - 11.29% - They want to recover from an injury or accident
* Option 8 - 1.92% -
* Option 9 - 40.31% - They don't have someone to take care of their children or elderly people
* Option 10 - 5.74% - A relative is not letting them work.
* Option 11 - 0.56% - 
* Option 12 - 12.84% - Other personal reasons


tab p2g2 sex if p2g2==10

tab working_age p2g2 if p2g2==10 & sex==2
tab working_age p2g2 if p2g2==10 & sex==1

tab e_con p2g2 if p2g2==10 & sex==1
tab e_con p2g2 if p2g2==10 & sex==2

**** In the four cases, option 5 "Someone in not letting me work" is around 5%-6% which indicates that there are no significant variations on this option no matter the place they live in. 

















***** Data Analysis ******

tab dur9c
tab dur9c if rama_est1==1
tab dur9c if rama_est1==2
tab dur9c if rama_est1==3


tab female if p3==6311 // 1% of the total workforce that operates agricultural machinery are women
tab female if p3==6111 // 4% of the total workforce that participates in the production of corn and beans are women
tab female if p3==6112 // 17% of the total workforce that participates in the production of vegetables are women
tab female if p3==6113 // 3% of the total workforce that participates in the production of coffe, cacao and tobbaco 
tab female if p3==6114 //
tab female if p3==6115 //


*** Descriptive statistics ***

summarize clase1 female t_loc cs_p13_1 eda educ e_con hij5c n_hij P4A_Sector P4A_Class p3 pct_agri_employ pct_serv_employ pct_agri_employ employ_share_agri



