PRO bolo_db

;database to extract radiated power from the abm_prad_pol trace
;use the disruption database stored in ~disrupt_db/
;END_JUNE09/disruption_efit_230610.sav to give ttq times and
;shot numbers

;rerun for using new database (added some additional ohmic disruptions)

restore, '~athorn/disrupt_db/END_JUNE09/disruption_efit_300610_2.sav'

;make array to store the data
radiated_energy=make_array(n_elements(shots))
;rad_red_chi=make_array(n_elements(shots))
;rad_fit_offset=make_array(n_elements(shots))

for i=0, n_elements(shots)-1 do begin
	
	if(ttq[i] gt 0) then begin
;		;take analysis of the bolo data from the code bolo_data.pro in this dir
;		bol=getdata('abm_prad_pol', strtrim(string(fix(shots[i])),2), /noecho)
;		if(bol.erc ne -1) then begin
;			;define a window around the ttq time
;			ttq_window=where(bol.time ge ttq[i]-0.007 and bol.time le ttq[i]+0.009)
;			if(ttq_window[0] ne -1) then begin
;				finite_vals=total(finite(bol.data[ttq_window]))/n_elements(bol.data[ttq_window])
;				if(finite_vals eq 1) then begin
;
;				;fit gaussion to this section with nterm=6
;				result=mpfitpeak(bol.time[ttq_window], bol.data[ttq_window],a, $
;					error=0.2*bol.data[ttq_window], bestnorm=bestnorm, dof=dof)
;				;integrate area under fitted gaussian
;				radiated_energy[i]=(int_tabulated(bol.time[ttq_window], result))
;				rad_red_chi[i]=bestnorm/dof
;				rad_fit_offset[i]=a[3]
;				print, shots[i]
;				endif else begin
;					radiated_energy[i]=-10
;					rad_red_chi[i]=-10
;					rad_fit_offset[i]=-10
;				endelse
;
;			endif else begin
;				radiated_energy[i]=-10
;				rad_red_chi[i]=-10
;				rad_fit_offset[i]=-10
;			endelse
;		endif else begin
;			radiated_energy[i]=-20
;			rad_red_chi[i]=-10
;			rad_fit_offset[i]=-10
;		endelse
;	endif else begin
;		radiated_energy[i]=-30
;		rad_red_chi[i]=-10
;		rad_fit_offset[i]=-10
;	endelse

	rad=bolo_data3(shot=strtrim(string(fix(shots[i])),2), ttq=ttq[i])
	radiated_energy[i]=rad.rad_energy

	endif else begin
	
	radiated_energy[i]=-30

	endelse
endfor

save, filename='disruption_db_bolo_030710_v3.sav'

END

