******************************************************
* Author: Zhuangyuan Fan
* Date: 2022-10-12
* UPdate: 2024-10-08
* Results for: Figure 4, Supplemental 
******************************************************
set more off

clear all
global setting "."
global project "${setting}/data"
cd "${project}"
global graphic "${setting}/_graphics"
global savefile "${setting}/_table"

global studyunit "h3_9"
import delimited using "${project}/place_mixing_2y_${studyunit}_wpoi.csv", clear

tabulate label_1k year
drop if year == 1992
egen yearnum = group(year)
replace func_area = "Urban Core" if func_area == "CBD"
egen func_num = group(func_area)
tabulate func_area, summarize(func_num)

*****************************************************************************************
* 0. LABELING
*****************************************************************************************

*****************************************************
* Generate differences
*****************************************************
gen unitid = unit

by unitid (year), sort: gen visitentropydiff = visit_entropy - visit_entropy[_n-1]
by unitid (year), sort: gen visit_entropypre = visit_entropy[_n-1]

by unitid (year), sort: gen visit_entropyaf = visit_entropy[_n+1]
by unitid (year), sort: gen resientropydiff = residential_entropy - residential_entropy[_n-1]
by unitid (year), sort: gen resi_entropypre = residential_entropy[_n-1]

by unitid (year), sort: gen resisegdiff = residential_seg - residential_seg[_n-1]
by unitid (year), sort: gen visitsegdiff = visit_seg - visit_seg[_n-1]
by unitid (year), sort: gen visitsegpre = visit_seg[_n-1]
by unitid (year), sort: gen residential_segpre = residential_seg[_n-1]
by unitid (year), sort: gen visitmixdiff = visit_mix - visit_mix[_n-1]
by unitid (year), sort: gen resimixdiff = resi_mix - resi_mix[_n-1]

by unitid (year), sort: gen visitmixdiff_adj = visit_mix_adjust - visit_mix_adjust[_n-1]
browse


replace mtr_trip_o=0 if mtr_trip_o==.
replace mtr_trip_d=0 if mtr_trip_d==.
replace bus_trip_d=0 if bus_trip_d==.

gen publicT_o = mtr_trip_o+bus_trip_o+tram_trip_o+ferry_trip_o
gen publicT_d = mtr_trip_d+bus_trip_d+tram_trip_d+ferry_trip_d

replace walking_trip_d=0 if walking_trip_d==.
replace walking_leg_o = 0 if walking_leg_o==.

replace total_pop = 0 if total_pop==.
gen logpop = log(total_pop+1)
gen logmtrtrip_o = log(mtr_trip_o+1)
gen logmtrleg_o = log(mtr_leg_o+1)

gen logmtrtrip_d = log(mtr_trip_d+1)
gen logmtrleg_d = log(mtr_leg_d+1)

gen logwalkingleg_o = log(walking_leg_o+1)
gen logwalkingtrip_o = log(walking_trip_o+1)

gen logwalkingleg_d = log(walking_leg_d+1)
gen logwalkingtrip_d = log(walking_trip_d+1)


gen logbusleg_o = log(bus_leg_o+1)
gen logbustrip_o = log(bus_trip_o+1)

gen logbusleg_d = log(bus_leg_d+1)
gen logbustrip_d = log(bus_trip_d+1)

gen logcartrip_o = log(car_trip_o + 1)
gen logcarleg_o = log(car_leg_o + 1)

gen logcartrip_d = log(car_trip_d + 1)
gen logcarleg_d = log(car_leg_d + 1)

gen logtaxileg_d = log(taxi_leg_d + 1)
gen logtaxileg_o = log(taxi_leg_o + 1)

gen logtaxitrip_d = log(taxi_trip_d + 1)
gen logtaxitrip_o = log(taxi_trip_o + 1)

* by destination
replace wt_trip = 0 if wt_trip==.
gen logtrip = log(wt_trip+1)

by unitid (year), sort: gen publictdiff = log(publicT_d+1) - log(publicT_d[_n-1]+1)
by unitid (year), sort: gen walkingdiff = log(walking_trip_d+1) - log(walking_trip_d[_n-1]+1)
by unitid (year), sort: gen mtrdiff = log(mtr_trip_d+1) - log(mtr_trip_d[_n-1]+1)
by unitid (year), sort: gen taxidiff = log(taxi_trip_d+1) - log(taxi_trip_d[_n-1]+1)
by unitid (year), sort: gen privatediff = logcartrip_d - logcartrip_d[_n-1]
by unitid (year), sort: gen busdiff = log(bus_trip_d+1) - log(bus_trip_d[_n-1]+1)
by unitid (year), sort: gen cardiff = log(car_trip_d+1) - log(car_trip_d[_n-1]+1)

* by origin
by unitid (year), sort: gen publictdiff_o = log(publicT_o+1) - log(publicT_o[_n-1]+1)
by unitid (year), sort: gen walkingdiff_o = log(walking_trip_o+1) - log(walking_trip_o[_n-1]+1)
by unitid (year), sort: gen mtrdiff_o = log(mtr_trip_o+1) - log(mtr_trip_o[_n-1]+1)
by unitid (year), sort: gen taxidiff_o= log(taxi_trip_o+1) - log(taxi_trip_o[_n-1]+1)
by unitid (year), sort: gen privatediff_o = logcartrip_o - logcartrip_o[_n-1]
by unitid (year), sort: gen busdiff_o = log(bus_trip_o+1) - log(bus_trip_o[_n-1]+1)
by unitid (year), sort: gen cardiff_o= log(car_trip_o+1) - log(car_trip_o[_n-1]+1)
by unitid (year), sort: gen logpopdiff = logpop - logpop[_n-1]

by unitid (year), sort: gen residiff = resi_mix - resi_mix[_n-1]
by unitid (year), sort: gen visitdiff = visit_mix - visit_mix[_n-1]
by unitid (year), sort:gen visit_mix_pre = visit_mix[_n-1]
by unitid (year), sort:gen resi_mix_pre = resi_mix[_n-1]

by unitid (year), sort: gen visitcountdiff = logtrip - logtrip[_n-1]
by unitid (year), sort: gen logvisitcountpre = logtrip[_n-1]
by unitid (year), sort: gen lowdiff = per_1 - per_1[_n-1]
by unitid (year), sort: gen highdiff = per_5 - per_5[_n-1]

tabulate year res

label var visit_mix_adjust "Daytime Mixing Adjusted"
label var visit_entropy "Daytime Mixing (Entropy)"
label var visit_seg "Daytime Segregation"
label var residential_seg "Nighttime Segregation"
label var residential_entropy "Nighttime Mixing (Entropy)"
label var resi_mix "Nighttime Mixing"
label var visit_mix "Daytime Mixing"
label var total_pop "Population"
// label var l_isolation "L-H Interaction"

label var resimixdiff "$\Delta$ Nighttime Mixing"
label var visitmixdiff "$\Delta$ Daytime Mixing"
// label var isolationdiff "$\Delta$ L-H Interaction"
label var logpopdiff "$\Delta$ Log(Population)"
label var logpop "Log(Pop)"
label var logtrip "Log(Trip A.)"

label var logpopdiff "$\Delta$ Log(Pop.)"
label var visitcountdiff "$\Delta$ Log(Trip A.)"

// label var walkingdiff "$\Delta$ Log(Walking Trip A.)"

label var publictdiff "$\Delta$ Log(Public T. Trip A.)"
label var busdiff "$\Delta$ Log(Bus Trips Attracted)"
label var privatediff "$\Delta$ Log(Private Car Trip A.)"
label var mtrdiff "$\Delta$ Log(MTR Trips Attracted)"

label var publictdiff_o "$\Delta$ Log(Public T. Trip P.)"
label var busdiff_o "$\Delta$ Log(Bus Trips Produced)"
label var privatediff_o "$\Delta$ Log(Private Car Trip P.)"
label var mtrdiff_o "$\Delta$ Log(MTR Trips P.)"
label var cardiff_o "$\Delta$ Log(Car Trips P.)"

label var logmtrleg_d "Log(MTR Legs (D))"
label var logbusleg_d "Log(Bus Legs (D))"
label var logcarleg_d "Log(Car Legs (D))"
label var logwalkingleg_d "Log(Walking Legs (D))"
label var logtaxileg_d "Log(Taxi Legs(D))"


label var logmtrtrip_d "Log(MTR Trip (D))"
label var logbustrip_d "Log(Bus Trip (D))"
label var logcartrip_d "Log(Car Trip (D))"
label var logwalkingtrip_d "Log(Walking Trip (D))"
label var logtaxitrip_d "Log(Taxi Trips(D))"

label var logmtrleg_o "Log(MTR Legs (O))"
label var logbusleg_o "Log(Bus Legs (O))"
label var logcarleg_o "Log(Car Legs (O))"
label var logwalkingleg_o "Log(Walking Legs (O))"
label var logtaxileg_o "Log(Taxi Legs(D))"


label var logmtrtrip_o "Log(MTR Trip (O))"
label var logbustrip_o "Log(Bus Trip (O))"
label var logcartrip_o "Log(Car Trip (O))"
label var logwalkingtrip_o "Log(Walking Trip (O))"
label var logtaxitrip_o "Log(Taxi Trip(o))"

label var logpop "Log(Population)"
label var logtrip "Log(Total Trips)"

label var cardiff "$\Delta$ Log(Car Trips A.)"
label var taxidiff "$\Delta$ Log(Taxi Trips A.)"

label var lowdiff "$\Delta\%$ Low Income Visitor"
label var highdiff "$\Delta\%$ High Income Visitor"

// label var residiffadj "$\Delta$ Night Mixing"
label var visitmixdiff_adj "$\Delta$ Place Mixing"
la var logaccommodation "Log(Accomodation)"
la var logfood "Log(Food)"
la var loghealth "Log(Health)"
la var logretail "Log(Retail)"
la var logothers "Log(Other POI)"
la var logtransportation "Log(Transport)"
la var logrecreation "Log(Recreation)"
la var func_area "Functional Area"



global logpoi logaccommodation logeducation logfood loghealth logothers logrecreation logretail logtransportation
corr $logpoi

********************************************************************
* Figure 2 (R1 UPDATES a-e)
********************************************************************
// drop if logpop ==.
binscatter visit_mix logbustrip_d if (num_person>=7), controls(year) nq(100) savegraph("${graphic}/bustrips_mixing_no_control.eps") replace ///
ytitle("Daytime Mixing", margin(small) size(small)) ///
xtitle("Log(Bus Trips)") ///
ysc(r(0.35 0.9)) ///
xsc(r(-2 15)) ///
xsize(2) ysize(2) graphregion(fcolor(white)) plotregion(fcolor(white))


binscatter visit_mix logbustrip_d if (num_person>=7), controls(logtrip logpop $logpoi year) nq(100) savegraph("${graphic}/bustrips_mixing.eps") replace ///
ytitle("Daytime Mixing", margin(small) size(small)) ///
xtitle("Log(Bus Trips)") ///
ysc(r(0.35 0.9)) ///
xsc(r(-2 15)) ///
xsize(2) ysize(2) graphregion(fcolor(white)) plotregion(fcolor(white))

binscatter visit_mix logwalkingtrip_d if (num_person>=7), controls(year) nq(100) line(lfit) savegraph("${graphic}/walk_mixing_no_control.eps") replace ///
ytitle("Daytime Mixing", margin(small) size(small)) ///
xtitle("Log(Walking Trips)") ///
ysc(r(0.35 0.85)) ///
xsc(r(-2 15)) ///
xsize(2) ysize(2) graphregion(fcolor(white)) plotregion(fcolor(white))

binscatter visit_mix logwalkingtrip_d if (num_person>=7), controls(logtrip logpop $logpoi year) nq(100) line(lfit) savegraph("${graphic}/walk_mixing.eps") replace ///
ytitle("Daytime Mixing", margin(small) size(small)) ///
xtitle("Log(Walking Trips)") ///
ysc(r(0.35 0.85)) ///
xsc(r(-2 15)) ///
xsize(2) ysize(2) graphregion(fcolor(white)) plotregion(fcolor(white))


binscatter visit_mix logmtrtrip_d if (num_person>=7), controls(year) nq(100) line(lfit) savegraph("${graphic}/mtr_mixing_no_control.eps") replace ///
ytitle("Daytime Mixing", margin(small) size(small)) ///
xtitle("Log(MTR Trips)") ///
ysc(r(0.35 0.9)) ///
xsc(r(-2 15)) ///
xsize(2) ysize(2) graphregion(fcolor(white)) plotregion(fcolor(white))


binscatter visit_mix logmtrtrip_d if (num_person>=7), controls(logtrip logpop $logpoi year) nq(100) line(lfit) savegraph("${graphic}/mtr_mixing.eps") replace ///
ytitle("Daytime Mixing", margin(small) size(small)) ///
xtitle("Log(MTR Trips)") ///
ysc(r(0.35 0.9)) ///
xsc(r(-2 15)) ///
xsize(2) ysize(2) graphregion(fcolor(white)) plotregion(fcolor(white))


binscatter visit_mix logcartrip_d if (num_person>=7), controls(year) nq(100) line(lfit) savegraph("${graphic}/car_mixing_no_control.eps") replace ///
ytitle("Daytime Mixing", margin(small) size(small)) ///
xtitle("Log(CAR Trips)") ///
ysc(r(0.35 0.9)) ///
xsc(r(-2 15)) ///
xsize(2) ysize(2) graphregion(fcolor(white)) plotregion(fcolor(white))

binscatter visit_mix logcartrip_d if (num_person>=7), controls(logtrip logpop $logpoi year) nq(100) line(lfit) savegraph("${graphic}/car_mixing.eps") replace ///
ytitle("Daytime Mixing", margin(small) size(small)) ///
xtitle("Log(CAR Trips)") ///
ysc(r(0.35 0.9)) ///
xsc(r(-2 15)) ///
xsize(2) ysize(2) graphregion(fcolor(white)) plotregion(fcolor(white))

binscatter visit_mix logtaxitrip_d if (num_person>=7), controls(year) nq(100) line(lfit) savegraph("${graphic}/taxi_mixing_no_control.eps") replace ///
ytitle("Daytime Mixing", margin(small) size(small)) ///
xtitle("Log(Taxi Trips)") ///
ysc(r(0.35 0.9)) ///
xsc(r(-2 15)) ///
xsize(2) ysize(2) graphregion(fcolor(white)) plotregion(fcolor(white))

binscatter visit_mix logtaxitrip_d if (num_person>=7), controls(logtrip logpop $logpoi year) nq(100) line(lfit) savegraph("${graphic}/taxi_mixing.eps") replace ///
ytitle("Daytime Mixing", margin(small) size(small)) ///
xtitle("Log(Taxi Trips)") ///
ysc(r(0.35 0.9)) ///
xsc(r(-2 15)) ///
xsize(2) ysize(2) graphregion(fcolor(white)) plotregion(fcolor(white))


********************************************************************
* Figure 2 (R2 seperate the function area)
********************************************************************
binscatter visit_mix logbustrip_d if (num_person>=7), controls(logtrip logpop $logpoi year) by(func_area) nq(100) savegraph("${graphic}/bustrips_mixing_by_func.eps") replace ///
ytitle("Daytime Mixing", margin(small) size(small)) ///
xtitle("Log(Bus Trips)") ///
ysc(r(0.35 0.85)) ///
xsc(r(-5 10)) ///
xsize(3) ysize(3) graphregion(fcolor(white)) plotregion(fcolor(white)) ///
mcolor(red blue green)


binscatter visit_mix logmtrtrip_d if (num_person>=7), controls(logtrip logpop $logpoi year) by(func_area) nq(100) line(lfit) savegraph("${graphic}/mtr_mixing_by_func.eps") replace ///
ytitle("Daytime Mixing", margin(small) size(small)) ///
xtitle("Log(MTR Trips)") ///
ysc(r(0.35 0.85)) ///
xsc(r(-5 10)) ///
xsize(2) ysize(2) graphregion(fcolor(white)) plotregion(fcolor(white)) ///
mcolor(red blue green)

binscatter visit_mix logwalkingtrip_d if (num_person>=7), controls(logtrip logpop $logpoi year) by(func_area) nq(100) line(lfit) savegraph("${graphic}/walk_mixing_by_func.eps") replace ///
ytitle("Daytime Mixing", margin(small) size(small)) ///
xtitle("Log(Walking Trips)") ///
ysc(r(0.35 0.85)) ///
xsc(r(-5 10)) ///
xsize(2) ysize(2) graphregion(fcolor(white)) plotregion(fcolor(white)) ///
mcolor(red blue green)

binscatter visit_mix logcartrip_d if (num_person>=7), controls(logtrip logpop $logpoi year) by(func_area) nq(100) line(lfit) savegraph("${graphic}/car_mixing_by_func.eps") replace ///
ytitle("Daytime Mixing", margin(small) size(small)) ///
xtitle("Log(CAR Trips)") ///
ysc(r(0.35 0.85)) ///
xsc(r(-5 10)) ///
xsize(2) ysize(2) graphregion(fcolor(white)) plotregion(fcolor(white)) ///
mcolor(red blue green)

binscatter visit_mix logtaxitrip_d if (num_person>=7), controls(logtrip logpop $logpoi year) by(func_area) nq(100) line(lfit) savegraph("${graphic}/taxi_mixing_func.eps") replace ///
ytitle("Daytime Mixing", margin(small) size(small)) ///
xtitle("Log(Taxi Trips)") ///
ysc(r(0.35 0.85)) ///
xsc(r(-5 10)) ///
xsize(2) ysize(2) graphregion(fcolor(white)) plotregion(fcolor(white)) ///
mcolor(red blue green)

*****************************************************************************************
* Figure 2 f. change of place-based mixing
*****************************************************************************************
global diff_o mtrdiff_o busdiff_o cardiff_o taxidiff_o walkingdiff_o
global diff_d mtrdiff busdiff cardiff taxidiff walkingdiff
global condition2 num_person>=7 & homesurveycount>=5

global allvari $diff_d visitcountdiff residiff logpopdiff lowdiff highdiff visit_mix_pre resi_mix_pre
foreach v of varlist $allvari { 
	egen std`v' = std(`v')
}

eststo did: reg visitmixdiff_adj stdmtrdiff stdbusdiff stdtaxidiff stdwalkingdiff stdcardiff stdvisitcountdiff stdresidiff stdlogpopdiff $logpoi i.func_num i.func_num if($condition2), r
esttab did using "${savefile}/fig2-f-long_mixing-9-mode-std.csv", replace wide plain r2

esttab did using "${savefile}/fig2-f-long_mixing-9-mode-std.tex", replace booktabs label ///
		 cells(b(star fmt(%9.3f)) se(par)) stats(N r2, fmt(%7.0f %7.4f) labels("Observations" "R-squared")) starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.005) 

		 
*****************************************************************************************
* Figure 2 Full Table. Include the transportation modes
*****************************************************************************************

global alllegs logmtrleg_d logbusleg_d logcarleg_d logtaxileg_d logwalkingleg_d
global alltrips logmtrtrip_d logbustrip_d logcartrip_d logtaxitrip_d logwalkingtrip_d


eststo clear
eststo r1: reg visit_mix logpop logtrip $logpoi i.yearnum if($condition2), r
eststo r2: reg visit_mix $alllegs i.yearnum if($condition2), r
eststo r3: reg visit_mix logpop logtrip $alllegs $logpoi i.func_num i.yearnum if($condition2), r

eststo r4: reg visit_mix $alltrips i.yearnum if($condition2), r
eststo r5: reg visit_mix logpop logtrip $alltrips $logpoi i.func_num i.yearnum if($condition2), r

eststo rr1: reg resi_mix logpop logtrip $logpoi i.yearnum if($condition2), r
eststo rr2: reg resi_mix $alllegs i.yearnum if($condition2), r
eststo rr3: reg resi_mix logpop logtrip $alllegs $logpoi i.func_num i.yearnum if($condition2), r

eststo rr4: reg resi_mix $alltrips i.yearnum if($condition2), r
eststo rr5: reg resi_mix logpop logtrip $alltrips $logpoi i.func_num i.yearnum if($condition2), r
esttab r* using "${savefile}/Fig-4-a-e-cross-sectional.tex", replace booktabs label ///
		 cells(b(star fmt(%9.3f)) se(par)) stats(N r2, fmt(%7.0f %7.4f) labels("Observations" "R-squared")) starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.005)


*****************************************************************************************
* 1. Simple change comparison between the treatment and control group
*****************************************************************************************
tabulate res

global condition2 personsurveycount>=3 & treat!=.
// summarize homesurveycount

gen post = 0
replace post = 1 if (year==2011)

* OPTION 1
tabulate label_1k
gen treat = .
replace treat = 1 if label_1k == "treatment"
// replace treat = 1 if ring == "1000"
replace treat = 0 if label_1k == "control"
// replace treat = 0 if ring == "2000"
// replace treat = 0 if ring == "2500"
// replace treat = 0 if ring == "3000"
// replace treat = 0 if ring == "no station"

egen treatgroup = group(label_1k)
tabulate label_1k, summarize(treat)

tabulate treat, summarize(total_pop)

* Before the MTR station extension, 

eststo clear
eststo did1: reg visit_mix i.post##i.treat if($condition2), r
eststo did2: reg visit_mix i.post##i.treat logtrip if($condition2), r
eststo did3: reg visit_mix i.post##i.treat logtrip logpop if($condition2), r

eststo did4: reg resi_mix i.post##i.treat if($condition2), r
eststo did5: reg resi_mix i.post##i.treat logtrip if($condition2), r
eststo did6: reg resi_mix i.post##i.treat logtrip logpop if($condition2), r

esttab did* using "${savefile}/longitudinal_mixing_h3_9.tex", replace booktabs label ///
		 cells(b(star fmt(%9.3f)) se(par)) stats(N r2, fmt(%7.0f %7.4f) labels("Observations" "R-squared")) starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.005)
		 


tabulate ring_merge, summarize(treat)

eststo clear
eststo did1: reg visit_mix i.post##i.treat if($condition2), r
eststo did2: reg visit_mix i.post##i.treat logtrip if($condition2), r
eststo did3: reg visit_mix i.post##i.treat logtrip logpop if($condition2), r

eststo did1: reg per_1 i.post##i.treat if($condition2), r

esttab did* using "${savefile}/longitudinal_mixing_day_h3_9_1000_allother.tex", replace booktabs label ///
		 cells(b(star fmt(%9.3f)) se(par)) stats(N r2, fmt(%7.0f %7.4f) labels("Observations" "R-squared")) starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.005)






