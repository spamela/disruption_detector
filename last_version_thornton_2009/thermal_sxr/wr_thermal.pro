PRO wr_thermal

;program to calculate the value of Wr using the SXR 90% time as the TQ time. 
;takes data from END_JUNE09 on SXR time, sXr fit quality, h mode end time, and shot type (H or L mode)

;generate a database file from the output of END_JUNE09 database. 
databasename_2='tq_sxr_database_300610.sav'
print, databasename_2
if(file_test(databasename_2) eq 0) then begin
	makedatabase_file, databasename_2
	print, 'Database created - save file :', databasename_2
endif

;stop

;restore tx sxr database
restore, databasename_2

;make array to contain the new data
w_thermal_sxr=make_array(n_elements(shots))

;want to find the thermal energy remaining at the time given by 90% sxr fall. Need to run EFIT to do this
;need to loop over all shots in the database.

i=0

for i=0, n_elements(shots)-1 do begin
	cd, '~athorn/EFIT'

	;make the command to run efit
	;runefit shot time step n_interations

	efit_starttime=strtrim(string(ttq_sxr[i]-0.0002),2)
	time_step=strtrim(string(0.0002),2)
	iterations=strtrim(string(4),2)
	args=strtrim(string(fix(shots[i])),2)+' '+efit_starttime+' '+time_step+' '+iterations
	print, 'runefit ' + args
	
	;run EFIT
	spawn, 'runefit ' + args

	;go back to correct directory
	cd, '~athorn/disrupt_db/END_JUNE09/thermal_sxr'

	;now want to read in the efm_thermal_energy from the EFIT file just created
	path='~athorn/edge1scratch/EFIT/OUTPUT/'

	if(shots[i] lt 10000) then begin
		ida_file='efm00'+strmid(strtrim(string(fix(shots[i])),2),0,2)+'.'+ $
		strmid(strtrim(string(fix(shots[i])),2),2,4)
	endif
	if(shots[i] ge 10000) then begin
		ida_file='efm0'+strmid(strtrim(string(fix(shots[i])),2),0,3)+'.'+ $
		strmid(strtrim(string(fix(shots[i])),2),3,4)
	endif

	getdata_path='IDA::'+path+ida_file
	
	;getdata the trace
	efm=getdata('efm_plasma_energy', getdata_path)

	if(efm.erc ne -1) then begin
		;find the time
		time=where(efm.time ge ttq_sxr[i])

		if(time[0] eq -1) then begin
			w_thermal_sxr[i]=-10
		endif else begin
			w_thermal_sxr[i]=efm.data[time[0]]
		endelse
	endif else begin
		w_thermal_sxr[i]=-20
	endelse

	print, w_thermal_sxr[i]

endfor

save, filename='wr_thermal_020710.sav'

END

PRO makedatabase_file, databasename_2

restore, '~athorn/disrupt_db/END_JUNE09/disruption_efit_300610_2.sav'

s=where(good_tq eq 1)

shots=shots[s]
good_tq=good_tq[s]
hmodeshot=hmodeshot[s]
hl_trans=hl_trans[s]
ttq_sxr=ttq_sxr[s]
use_hl=use_hl[s]
wmax_hl=wmax_hl[s]
w_flattop=w_flattop[s]
w_disrupt=w_disrupt[s]
w_maximum=w_maximum[s]

save, shots, good_tq, hmodeshot, hl_trans, ttq_sxr, use_hl, wmax_hl, w_flattop, w_disrupt, w_maximum, filename=databasename_2

END

