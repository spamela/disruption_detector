PRO disruption_efit_6

;all halo current data is in kA

;restore, 'disruption_efit_5.sav'
;restore, 'disruption_efit_M7_5.sav'
restore, 'disruption_efit_0709_5.sav'

;shot=19697
;shot=11103
;shot=11018
;shot=17725
;shot=19694

array_size=n_elements(shots)

ccu_max=make_array(array_size)
ccu_maxtime=make_array(array_size)
ccl_max=make_array(array_size)
ccl_maxtime=make_array(array_size)
p2u_max=make_array(array_size)
p2u_maxtime=make_array(array_size)
p2l_max=make_array(array_size)
p2l_maxtime=make_array(array_size)
p3u_max=make_array(array_size)
p3u_maxtime=make_array(array_size)
p3l_max=make_array(array_size)
p3l_maxtime=make_array(array_size)
divl_max=make_array(array_size)
divl_maxtime=make_array(array_size)
divu_max=make_array(array_size)
divu_maxtime=make_array(array_size)

;peak halo value arrays
halo_peaktime=make_array(array_size)
ccu_peak=make_array(array_size)
ccl_peak=make_array(array_size)
p2u_peak=make_array(array_size)
p2l_peak=make_array(array_size)
p3u_peak=make_array(array_size)
p3l_peak=make_array(array_size)
divl_peak=make_array(array_size)
divu_peak=make_array(array_size)

;vde_direction, is positive for an upward vde, negative for a downward VDE and zero if lower+upper lt 20kA, and -10 if something's wrong...
vde_direction=findgen(array_size)
vde_direction=vde_direction*(-10)



for i=0, n_elements(shots)-1 do begin

ccu=getdata('AMH_HALO/CCU', strtrim(string(fix(shots[i])),2))
ccl=getdata('AMH_HALO/CCL', strtrim(string(fix(shots[i])),2), /noecho)
p2u=getdata('AMH_HALO SUM P2U', strtrim(string(fix(shots[i])),2), /noecho)
p2l=getdata('AMH_HALO SUM P2L', strtrim(string(fix(shots[i])),2), /noecho) 
p3u=getdata('AMH_HALO SUM P3U', strtrim(string(fix(shots[i])),2), /noecho) 
p3l=getdata('AMH_HALO SUM P3L', strtrim(string(fix(shots[i])),2), /noecho)
epl_inner=getdata('AMH_PHALO SUM EPL INNER', strtrim(string(fix(shots[i])),2), /noecho)
epl_outer=getdata('AMH_PHALO SUM EPL OUTER', strtrim(string(fix(shots[i])),2), /noecho)
epu_inner=getdata('AMH_PHALO SUM EPU INNER', strtrim(string(fix(shots[i])),2), /noecho)
epu_outer=getdata('AMH_PHALO SUM EPU OUTER', strtrim(string(fix(shots[i])),2), /noecho)

if(ccu.erc ne -1) then begin
	if(n_elements(ccu.time) lt 2) then begin
		goto, nextshot
	endif
endif
		
if(ccu.erc eq -1) then begin
	ccu_max[i]=-1
	ccu_maxtime[i]=-1
	endif else begin
		max_val=max(abs(ccu.data))
		time_max=where(abs(ccu.data) ge max_val)
		ccu_max[i]=ccu.data[time_max[0]]
		ccu_maxtime[i]=ccu.time[time_max[0]]
endelse

if(ccl.erc eq -1) then begin
	ccl_max[i]=-1
	ccl_maxtime[i]=-1
	endif else begin
		max_val=max(abs(ccl.data))
		time_max=where(abs(ccl.data) ge max_val)
		ccl_max[i]=ccl.data[time_max[0]]
		ccl_maxtime[i]=ccl.time[time_max[0]]
endelse

if(p2u.erc eq -1) then begin
	p2u_max[i]=-1
	p2u_maxtime[i]=-1
	endif else begin
		max_val=max(abs(p2u.data))
		time_max=where(abs(p2u.data) ge max_val)
		p2u_max[i]=p2u.data[time_max[0]]
		p2u_maxtime[i]=p2u.time[time_max[0]]
endelse

if(p2l.erc eq -1) then begin
	p2l_max[i]=-1
	p2l_maxtime[i]=-1
	endif else begin
		max_val=max(abs(p2l.data))
		time_max=where(abs(p2l.data) ge max_val)
		p2l_max[i]=p2l.data[time_max[0]]
		p2l_maxtime[i]=p2l.time[time_max[0]]
endelse

if(p3u.erc eq -1) then begin
	p3u_max[i]=-1
	p3u_maxtime[i]=-1
	endif else begin
		max_val=max(abs(p3u.data))
		time_max=where(abs(p3u.data) ge max_val)
		p3u_max[i]=p3u.data[time_max[0]]
		p3u_maxtime[i]=p3u.time[time_max[0]]
endelse

if(p3l.erc eq -1) then begin
	p3l_max[i]=-1
	p3l_maxtime[i]=-1
	endif else begin
		max_val=max(abs(p3l.data))
		time_max=where(abs(p3l.data) ge max_val)
		p3l_max[i]=p3l.data[time_max[0]]
		p3l_maxtime[i]=p3l.time[time_max[0]]
endelse

if(epl_inner.erc eq -1 or epl_outer.erc eq -1) then begin

	divl_max[i]=-1
	divl_maxtime[i]=-1
	endif else begin
		divl=epl_outer.data-epl_inner.data
		max_val=max(abs(divl))
		time_max=where(abs(divl) ge max_val)
		divl_max[i]=divl[time_max[0]]
		divl_maxtime[i]=epl_inner.time[time_max[0]]
endelse

if(epu_inner.erc eq -1 or epu_outer.erc eq -1) then begin
	divu_max[i]=-1
	divu_maxtime[i]=-1
	endif else begin
 		divu=epu_outer.data-epu_inner.data
		max_val=max(abs(divu))
		time_max=where(abs(divu) ge max_val)
		divu_max[i]=divu[time_max[0]]
		divu_maxtime[i]=epu_inner.time[time_max[0]]
endelse


;haloplot, shot, xrange=[0.290,0.310] ;19694
;haloplot, shot, xrange=[0.318,0.325] ;11103

;oplot, ccu_maxtime*1000, ccu_max/1000, psym=7
;oplot, ccl_maxtime*1000, ccl_max/1000, psym=7
;oplot, p2l_maxtime*1000, p2l_max/1000, psym=7
; oplot, p2u_maxtime*1000, p2u_max/1000, psym=7
; oplot, p3u_maxtime*1000, p3U_max/1000, psym=7
; oplot, p3l_maxtime*1000, p3l_max/1000, psym=7
; oplot, divu_maxtime*1000, divu_max/1000, psym=7
; oplot, divl_maxtime*1000, divl_max/1000, psym=7

;===find the values of the halo currents when P3U/L is a maximum===================================================
if(abs(p3u_max[i]) gt abs(p3l_max[i])) then begin
	halo_peaktime[i]=p3u_maxtime[i]
endif else begin
	halo_peaktime[i]=p3l_maxtime[i]
endelse

if(ccu.erc eq -1) then begin
	ccu_peak[i]=-1
	endif else begin
		time_peak=where(ccu.time ge halo_peaktime[i])
		;check to see if the point before time_peak[0] has a time that is nearer to halo_peaktime than the value at halo_peaktime
			if(time_peak[0] eq 0) then begin
				time_peak[0]=time_peak[0]+1
			endif
		diff1=abs(ccu.time[time_peak[0]-1]-halo_peaktime[i])
		diff2=abs(ccu.time[time_peak[0]]-halo_peaktime[i])
		if(diff1 gt diff2) then begin
			time_peak[0]=time_peak[0]+1
		endif else begin
			time_peak[0]=time_peak[0]-1
		endelse
		if(time_peak[0] ge n_elements(ccu.time)) then begin
			time_peak[0]=time_peak[0]-1
		endif
		ccu_peak[i]=ccu.data[time_peak[0]]
endelse

if(ccl.erc eq -1) then begin
	ccl_peak[i]=-1
	endif else begin
		time_peak=where(ccl.time ge halo_peaktime[i])
			if(time_peak[0] eq 0) then begin
				time_peak[0]=time_peak[0]+1
			endif
		diff1=abs(ccl.time[time_peak[0]-1]-halo_peaktime[i])
		diff2=abs(ccl.time[time_peak[0]]-halo_peaktime[i])
		if(diff1 gt diff2) then begin
			time_peak[0]=time_peak[0]+1
		endif else begin
			time_peak[0]=time_peak[0]-1
		endelse
		if(time_peak[0] ge n_elements(ccl.time)) then begin
			time_peak[0]=time_peak[0]-1
		endif
		ccl_peak[i]=ccl.data[time_peak[0]]	
endelse

if(p2u.erc eq -1) then begin
	p2u_peak[i]=-1
	endif else begin	
		time_peak=where(p2u.time ge halo_peaktime[i])
			if(time_peak[0] eq 0) then begin
				time_peak[0]=time_peak[0]+1
			endif
		diff1=abs(p2u.time[time_peak[0]-1]-halo_peaktime[i])
		diff2=abs(p2u.time[time_peak[0]]-halo_peaktime[i])
		if(diff1 gt diff2) then begin
			time_peak[0]=time_peak[0]+1
		endif else begin
			time_peak[0]=time_peak[0]-1
		endelse
		if(time_peak[0] ge n_elements(p2u.time)) then begin
			time_peak[0]=time_peak[0]-1
		endif
		p2u_peak[i]=p2u.data[time_peak[0]]	
endelse

if(p2l.erc eq -1) then begin
	p2l_max[i]=-1
	endif else begin	
		time_peak=where(p2l.time ge halo_peaktime[i])
			if(time_peak[0] eq 0) then begin
				time_peak[0]=time_peak[0]+1
			endif
		diff1=abs(p2l.time[time_peak[0]-1]-halo_peaktime[i])
		diff2=abs(p2l.time[time_peak[0]]-halo_peaktime[i])
		if(diff1 gt diff2) then begin
			time_peak[0]=time_peak[0]+1
		endif else begin
			time_peak[0]=time_peak[0]-1
		endelse
		if(time_peak[0] ge n_elements(p2l.time)) then begin
			time_peak[0]=time_peak[0]-1
		endif
		p2l_peak[i]=p2l.data[time_peak[0]]	
endelse

if(p3u.erc eq -1) then begin
	p3u_peak[i]=-1
	endif else begin	
		time_peak=where(p3u.time ge halo_peaktime[i])
			if(time_peak[0] eq 0) then begin
				time_peak[0]=time_peak[0]+1
			endif
		diff1=abs(p3u.time[time_peak[0]-1]-halo_peaktime[i])
		diff2=abs(p3u.time[time_peak[0]]-halo_peaktime[i])
		if(diff1 gt diff2) then begin
			time_peak[0]=time_peak[0]+1
		endif else begin
			time_peak[0]=time_peak[0]-1
		endelse
		if(time_peak[0] ge n_elements(p3u.time)) then begin
			time_peak[0]=time_peak[0]-1
		endif
		p3u_peak[i]=p3u.data[time_peak[0]]	
endelse

if(p3l.erc eq -1) then begin
	p3l_peak[i]=-1
	endif else begin	
		time_peak=where(abs(p3l.time) ge halo_peaktime[i])
			if(time_peak[0] eq 0) then begin
				time_peak[0]=time_peak[0]+1
			endif
		diff1=abs(p3l.time[time_peak[0]-1]-halo_peaktime[i])
		diff2=abs(p3l.time[time_peak[0]]-halo_peaktime[i])
		if(diff1 gt diff2) then begin
			time_peak[0]=time_peak[0]+1
		endif else begin
			time_peak[0]=time_peak[0]-1
		endelse
		if(time_peak[0] ge n_elements(p3l.time)) then begin
			time_peak[0]=time_peak[0]-1
		endif
		p3l_peak[i]=p3l.data[time_peak[0]]	
endelse

if(epl_inner.erc eq -1 or epl_outer.erc eq -1) then begin
	divl_peak[i]=-1
	endif else begin
		divl=epl_outer.data-epl_inner.data	
		time_peak=where(epl_inner.time ge halo_peaktime[i])
			if(time_peak[0] eq 0) then begin
				time_peak[0]=time_peak[0]+1
			endif
		diff1=abs(epl_inner.time[time_peak[0]-1]-halo_peaktime[i])
		diff2=abs(epl_inner.time[time_peak[0]]-halo_peaktime[i])
		if(diff1 gt diff2) then begin
			time_peak[0]=time_peak[0]+1
		endif else begin
			time_peak[0]=time_peak[0]-1
		endelse
		if(time_peak[0] ge n_elements(epl_inner.time)) then begin
			time_peak[0]=time_peak[0]-1
		endif
		divl_peak[i]=divl[time_peak[0]]
endelse

if(epu_inner.erc eq -1 or epu_outer.erc eq -1) then begin
	divu_peak[i]=-1
	endif else begin
 		divu=epu_outer.data-epu_inner.data	
		time_peak=where(epu_inner.time ge halo_peaktime[i])
			if(time_peak[0] eq 0) then begin
				time_peak[0]=time_peak[0]+1
			endif
		diff1=abs(epu_inner.time[time_peak[0]-1]-halo_peaktime[i])
		diff2=abs(epu_inner.time[time_peak[0]]-halo_peaktime[i])
		if(diff1 gt diff2) then begin
			time_peak[0]=time_peak[0]+1
		endif else begin
			time_peak[0]=time_peak[0]-1
		endelse
		if(time_peak[0] ge n_elements(epu_inner.time)) then begin
			time_peak[0]=time_peak[0]-1
		endif
		divu_peak[i]=divu[time_peak[0]]	
endelse

; oplot, halo_peaktime*1000, ccu_peak/1000, psym=7, color=truecolor('red'), symsize=2
; oplot, halo_peaktime*1000, ccl_peak/1000, psym=7, color=truecolor('red'), symsize=2
; oplot, halo_peaktime*1000, p2l_peak/1000, psym=7, color=truecolor('red'), symsize=2
; oplot, halo_peaktime*1000, p2u_peak/1000, psym=7, color=truecolor('red'), symsize=2
; oplot, halo_peaktime*1000, p3U_peak/1000, psym=7, color=truecolor('red'), symsize=2
; oplot, halo_peaktime*1000, p3l_peak/1000, psym=7, color=truecolor('red'), symsize=2
; oplot, halo_peaktime*1000, divu_peak/1000, psym=7, color=truecolor('red'), symsize=2
; oplot, halo_peaktime*1000, divl_peak/1000, psym=7, color=truecolor('red'), symsize=2

;========determine the direction of the VDE====================

;find the absolute value of the upper halo currents and lower halo currents and compare. Perform the comparision at the time when P3L/U is a maximum , ie when time = halo_peaktime

lower=abs(ccl_peak[i])+abs(p2l_peak[i])+abs(p3l_peak[i])+abs(divl_peak[i])
upper=abs(ccu_peak[i])+abs(p2u_peak[i])+abs(p3u_peak[i])+abs(divu_peak[i])

if(lower gt upper and lower+upper gt 20) then begin
	;downward vde
	vde_direction[i]=-1
endif else begin
	vde_direction[i]=1
endelse

if(lower+upper le 20) then vde_direction[i]=0

;print, vde_direction[i]
nextshot:

endfor
;stop

;save, filename='disruption_efit_6.sav'
;save, filename='disruption_efit_M7_6.sav'
save, filename='disruption_efit_0709_6.sav'

END