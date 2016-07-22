* Microsimulation for kihasa 
* This do file aggregates NaSTaB_H and NaSTaB_P all period
* mailto:namun@snu.ac.kr

* Preprocessing. 

clear all
cd "~/Documents/writings/2016/MicroSIM_/_data/NaSTaB_microsim" // correct this location to your work folder

/*

If you are to use STATA14, encoding should be modified to utf8. 

Example:

cd your_dta_location    // go to your working folder
unicode encoding set euckr 
unicode translate *.dta, invalid 

*/

loc p_data "../NaSTaB_P_stata/" // personal data
loc h_data "../NaSTaB_H_stata/" // household data

loc maxYear = 7 // set this to the maximum index of NaSTaB

* Merging Personal Data

use "`p_data'NaSTaB01P",clear
rename pid01 pid
rename hid01* hid*
rename ps01* ps*
rename p01* p*
rename ver_01 pver
gen year = 1
save aggregated,replace

forvalues i=2/`maxYear'{
	use "`p_data'NaSTaB0`i'P", clear
	rename pid0`i' pid
	rename hid0`i'* hid*
	rename ps0`i'* ps*
	rename p0`i'* p*
	rename ver_0`i' pver
	gen year = `i'
	// merge 1:1 pid using aggregated
	append using aggregated
	// drop _m
	save aggregated,replace
}

* Merging household data

forvalues i=1/7{
	use "`h_data'NaSTaB0`i'H",clear
	rename h0`i'* h*
	rename w0`i'* w*
	rename hs0`i'* hs*
	capture confirm variable ver_0`i'
	if _rc==0 {
		rename ver_0`i' hver
	}
	rename hid0`i'* hid*
	gen year = `i'
	merge 1:m hid year using aggregated
	drop if pid==.
	drop _m
	save aggregated, replace
}


tsset pid year


