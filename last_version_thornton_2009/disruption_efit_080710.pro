PRO disruption_efit_080710

;interpolate the values of the stored thermal energy at the disruption
;as performed in disruption_efit_240610, which alas didn't work

restore, 'disruption_efit_300610_2.sav'

;write out a file to contain the calc vals
openw,1, 'output.txt'

q=where(use_hl eq 1)

w_ratio_interp[*]=-10
w_thermal_interp[*]=-10

for i=0, n_elements(q)-1 do begin
	
	cd, '~athorn/EFIT'

        ;make the command to run efit
        ;runefit shot time step n_interations

        efit_starttime=strtrim(string(ttq[q[i]]-0.0002),2)
        time_step=strtrim(string(0.0002),2)
        iterations=strtrim(string(4),2)
        args=strtrim(string(fix(shots[q[i]])),2)+' '+efit_starttime $ 
		+ ' '+time_step+' '+iterations
        print, 'runefit ' + args

        ;run EFIT
        spawn, 'runefit ' + args

        ;go back to correct directory
        cd, '~athorn/disrupt_db/END_JUNE09/'

	path='~athorn/edge1scratch/EFIT/OUTPUT/'

	if(shots[q[i]] lt 10000) then begin
		ida_file='efm00'+strmid(strtrim(string(fix(shots[q[i]])),2),0,2)+'.'+ $
		strmid(strtrim(string(fix(shots[q[i]])),2),2,4)
	endif
	if(shots[q[i]] ge 10000) then begin
		ida_file='efm0'+strmid(strtrim(string(fix(shots[q[i]])),2),0,3)+'.'+ $
		strmid(strtrim(string(fix(shots[q[i]])),2),3,4)
	endif

	getdata_path='IDA::'+path+ida_file
	
	;getdata the trace
	efm=getdata('efm_plasma_energy', getdata_path)

	if(efm.erc ne -1) then begin
		;find the time
		time=where(efm.time ge ttq[q[i]])

		if(time[0] eq -1) then begin
			w_thermal_interp[q[i]]=-10
		endif else begin
			;need to make sure that time[0] does not equal zero
			if(time[0] ne 0) then begin
				gradient=(efm.data[time[0]]-efm.data[time[0]-1])/(0.0002)
				c_int=efm.data[time[0]]-(gradient*efm.time[time[0]])
				value=(gradient*ttq[q[i]])+c_int
				w_thermal_interp[q[i]]=value
			endif else begin
				w_thermal_interp[q[i]]=-30
			endelse
		endelse
	endif else begin
		w_thermal_interp[q[i]]=-20
	endelse

	;calculate the value of w_r using wmax_hl
	if(w_thermal_interp[q[i]] ge 0) then begin
		w_ratio_interp[q[i]]=w_thermal_interp[q[i]]/wmax_hl[q[i]]
	endif else begin
		w_ratio_interp[q[i]]=-25
	endelse

	printf, 1, w_thermal_interp[q[i]],' ', w_ratio_interp[q[i]]

;stop

endfor

save, filename='disruption_efit_080710.sav'

close, 1

END

	
