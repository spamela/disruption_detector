PRO disruption_efit_7

;find the TPF of the discharges and the values of f(halo)

;restore, 'disruption_efit_6.sav'
;restore, 'disruption_efit_M7_6.sav'
restore, 'disruption_efit_0709_6.sav'

fhalo=make_array(n_elements(shots))
TPF=make_array(n_elements(shots),8)

;for loop goes here
for i=0, (n_elements(shots)-1) do begin

;make an array to hold all of the max currents and times
values=make_array(2,8)

;fill array with values of max halo time and max halo current
values[0,0]=abs(ccu_max[i])
values[1,0]=abs(ccu_maxtime[i])
values[0,1]=abs(ccl_max[i])
values[1,1]=abs(ccl_maxtime[i])
values[0,2]=abs(p2u_max[i])
values[1,2]=abs(p2u_maxtime[i])
values[0,3]=abs(p2l_max[i])
values[1,3]=abs(p2l_maxtime[i])
values[0,4]=abs(p3u_max[i])
values[1,4]=abs(p3u_maxtime[i])
values[0,5]=abs(p3l_max[i])
values[1,5]=abs(p3l_maxtime[i])
values[0,6]=abs(divu_max[i])
values[1,6]=abs(divu_maxtime[i])
values[0,7]=abs(divl_max[i])
values[1,7]=abs(divl_maxtime[i])

;max currents in values[0,*]
;time of max current in values[1,*]

;get the largest halo current value and time
find_max=max(values[0,*])
max_index=where(values[0,*] eq find_max)
time_tpf=values[1,max_index]

;calculate f halo = max halo in any coil/Ip(ttq)
fhalo[i]=find_max/ip_disruption[i]

;find the maximum TPF, need to get the signals from each of the P2,P3, EPU and EPL supports
;calculate the maximum TPF at the time when there is the maximum f_halo

;p2u support legs
p2u1=getdata('amh_halo/p2u/1', strtrim(string(fix(shots[i])),2))
p2u2=getdata('amh_halo/p2u/2', strtrim(string(fix(shots[i])),2), /noecho)
p2u3=getdata('amh_halo/p2u/3', strtrim(string(fix(shots[i])),2), /noecho)
p2u4=getdata('amh_halo/p2u/4', strtrim(string(fix(shots[i])),2), /noecho)
p2u5=getdata('amh_halo/p2u/5', strtrim(string(fix(shots[i])),2), /noecho)
p2u6=getdata('amh_halo/p2u/6', strtrim(string(fix(shots[i])),2), /noecho)

halo_vals=make_array(6)

if(p2u1.erc ne -1) then begin
	time_find=where(p2u1.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[0]=-1
		goto, p2u2g
	endif
	halo_vals[0]=abs(p2u1.data[time_find[0]])
endif

p2u2g:

if(p2u2.erc ne -1) then begin
	time_find=where(p2u2.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[1]=-1
		goto, p2u3g
	endif
	halo_vals[1]=abs(p2u2.data[time_find[0]])
endif

p2u3g:

if(p2u3.erc ne -1) then begin
	time_find=where(p2u3.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[2]=-1
		goto, p2u4g
	endif
	halo_vals[2]=abs(p2u3.data[time_find[0]])
endif

p2u4g:

if(p2u4.erc ne -1) then begin
	time_find=where(p2u4.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[3]=-1
		goto, p2u5g
	endif
	halo_vals[3]=abs(p2u4.data[time_find[0]])
endif

p2u5g:

if(p2u5.erc ne -1) then begin
	time_find=where(p2u5.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[4]=-1
		goto, p2u6g
	endif
	halo_vals[4]=abs(p2u5.data[time_find[0]])
endif

p2u6g:

if(p2u6.erc ne -1) then begin
	time_find=where(p2u6.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[5]=-1
		goto, p2all
	endif
	halo_vals[5]=abs(p2u6.data[time_find[0]])
endif

p2all:

if(p2u1.erc ne -1 or p2u2.erc ne -1 or p2u3.erc ne -1 or p2u4.erc ne -1 or p2u5.erc ne -1 or p2u6.erc ne -1) then begin
	average_good=where(halo_vals ne 0)
	IF(average_good[0] EQ -1)THEN begin
		TPF_epli = -1.0
	endif ELSE BEGIN
		avg_halo=mean(halo_vals[average_good])
		halo_lessavghalo=halo_vals-avg_halo
		max_halo_lessavghalo=max(halo_lessavghalo)
		TPF_p2u=1.000+(max_halo_lessavghalo/avg_halo)
	ENDELSE
	endif else begin
	TPF_p2u=-1.0
endelse

;p2l support legs
p2l1=getdata('amh_halo/p2l/1', strtrim(string(fix(shots[i])),2), /noecho)
p2l2=getdata('amh_halo/p2l/2', strtrim(string(fix(shots[i])),2), /noecho)
p2l3=getdata('amh_halo/p2l/3', strtrim(string(fix(shots[i])),2), /noecho)
p2l4=getdata('amh_halo/p2l/4', strtrim(string(fix(shots[i])),2), /noecho)
p2l5=getdata('amh_halo/p2l/5', strtrim(string(fix(shots[i])),2), /noecho)
p2l6=getdata('amh_halo/p2l/6', strtrim(string(fix(shots[i])),2), /noecho)

if(p2l1.erc ne -1) then begin
	time_find=where(p2l1.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[0]=-1
		goto, p2l2g
	endif
	halo_vals[0]=abs(p2l1.data[time_find[0]])
endif

p2l2g:

if(p2l2.erc ne -1) then begin
	time_find=where(p2l2.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[1]=-1
		goto, p2l3g
	endif
	halo_vals[1]=abs(p2l2.data[time_find[0]])
endif

p2l3g:

if(p2l3.erc ne -1) then begin
	time_find=where(p2l3.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[2]=-1
		goto, p2l4g
	endif
	halo_vals[2]=abs(p2l3.data[time_find[0]])
endif

p2l4g:

if(p2l4.erc ne -1) then begin
	time_find=where(p2l4.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[3]=-1
		goto, p2l5g
	endif
	halo_vals[3]=abs(p2l4.data[time_find[0]])
endif

p2l5g:

if(p2l5.erc ne -1) then begin
	time_find=where(p2l5.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[4]=-1
		goto, p2l6g
	endif
	halo_vals[4]=abs(p2l5.data[time_find[0]])
endif

p2l6g:

if(p2l6.erc ne -1) then begin
	time_find=where(p2l6.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[5]=-1
		goto, p2lall
	endif
	halo_vals[5]=abs(p2l6.data[time_find[0]])
endif

p2lall:

if(p2l1.erc ne -1 or p2l2.erc ne -1 or p2l3.erc ne -1 or p2l4.erc ne -1 or p2l5.erc ne -1 or p2l6.erc ne -1) then begin
	average_good=where(halo_vals ne 0)
	IF(average_good[0] EQ -1)THEN begin
		TPF_epli = -1.0
	endif ELSE BEGIN
		avg_halo=mean(halo_vals[average_good])
		halo_lessavghalo=halo_vals-avg_halo
		max_halo_lessavghalo=max(halo_lessavghalo)
		TPF_p2l=1.000+(max_halo_lessavghalo/avg_halo)
	ENDELSE
	endif else begin
	TPF_p2l=-1.0
endelse

;p3u support legs
p3u1=getdata('amh_halo/p3u/1', strtrim(string(fix(shots[i])),2), /noecho)
p3u2=getdata('amh_halo/p3u/2', strtrim(string(fix(shots[i])),2), /noecho)
p3u3=getdata('amh_halo/p3u/3', strtrim(string(fix(shots[i])),2), /noecho)
p3u4=getdata('amh_halo/p3u/4', strtrim(string(fix(shots[i])),2), /noecho)
p3u5=getdata('amh_halo/p3u/5', strtrim(string(fix(shots[i])),2), /noecho)
p3u6=getdata('amh_halo/p3u/6', strtrim(string(fix(shots[i])),2), /noecho)

if(p3u1.erc ne -1) then begin
	time_find=where(p3u1.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[0]=-1
		goto, p3u2g
	endif
	halo_vals[0]=abs(p3u1.data[time_find[0]])
endif

p3u2g:

if(p3u2.erc ne -1) then begin
	time_find=where(p3u2.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[1]=-1
		goto, p3u3g
	endif
	halo_vals[1]=abs(p3u2.data[time_find[0]])
endif

p3u3g:

if(p3u3.erc ne -1) then begin
	time_find=where(p3u3.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[2]=-1
		goto, p3u4g
	endif
	halo_vals[2]=abs(p3u3.data[time_find[0]])
endif

p3u4g:

if(p3u4.erc ne -1) then begin
	time_find=where(p3u4.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[3]=-1
		goto, p3u5g
	endif
	halo_vals[3]=abs(p3u4.data[time_find[0]])
endif

p3u5g:

if(p3u5.erc ne -1) then begin
	time_find=where(p3u5.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[4]=-1
		goto, p3u6g
	endif
	halo_vals[4]=abs(p3u5.data[time_find[0]])
endif

p3u6g:

if(p3u6.erc ne -1) then begin
	time_find=where(p3u6.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[5]=-1
		goto, p3uall
	endif
	halo_vals[5]=abs(p3u6.data[time_find[0]])
endif

p3uall:

if(p3u1.erc ne -1 or p3u2.erc ne -1 or p3u3.erc ne -1 or p3u4.erc ne -1 or p3u5.erc ne -1 or p3u6.erc ne -1) then begin
	average_good=where(halo_vals ne 0)
	IF(average_good[0] EQ -1)THEN begin
		TPF_epli = -1.0
	endif ELSE BEGIN
		avg_halo=mean(halo_vals[average_good])
		halo_lessavghalo=halo_vals-avg_halo
		max_halo_lessavghalo=max(halo_lessavghalo)
		TPF_p3u=1.000+(max_halo_lessavghalo/avg_halo)
	ENDELSE
	endif else begin
	TPF_p3u=-1.0
endelse

;p3l support legs
p3l1=getdata('amh_halo/p3l/1', strtrim(string(fix(shots[i])),2), /noecho)
p3l2=getdata('amh_halo/p3l/2', strtrim(string(fix(shots[i])),2), /noecho)
p3l3=getdata('amh_halo/p3l/3', strtrim(string(fix(shots[i])),2), /noecho)
p3l4=getdata('amh_halo/p3l/4', strtrim(string(fix(shots[i])),2), /noecho)
p3l5=getdata('amh_halo/p3l/5', strtrim(string(fix(shots[i])),2), /noecho)
p3l6=getdata('amh_halo/p3l/6', strtrim(string(fix(shots[i])),2), /noecho)

if(p3l1.erc ne -1) then begin
	time_find=where(p3l1.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[0]=-1
		goto, p3l2g
	endif
	halo_vals[0]=abs(p3l1.data[time_find[0]])
endif

p3l2g:

if(p3l2.erc ne -1) then begin
	time_find=where(p3l2.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[1]=-1
		goto, p3l3g
	endif
	halo_vals[1]=abs(p3l2.data[time_find[0]])
endif

p3l3g:

if(p3l3.erc ne -1) then begin
	time_find=where(p3l3.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[2]=-1
		goto, p3l4g
	endif
	halo_vals[2]=abs(p3l3.data[time_find[0]])
endif

p3l4g:

if(p3l4.erc ne -1) then begin
	time_find=where(p3l4.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[3]=-1
		goto, p3l5g
	endif
	halo_vals[3]=abs(p3l4.data[time_find[0]])
endif

p3l5g:

if(p3l5.erc ne -1) then begin
	time_find=where(p3l5.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[4]=-1
		goto, p3l6g
	endif
	halo_vals[4]=abs(p3l5.data[time_find[0]])
endif

p3l6g:

if(p3l6.erc ne -1) then begin
	time_find=where(p3l6.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[5]=-1
		goto, p3lall
	endif
	halo_vals[5]=abs(p3l6.data[time_find[0]])
endif

p3lall:

if(p3l1.erc ne -1 or p3l2.erc ne -1 or p3l3.erc ne -1 or p3l4.erc ne -1 or p3l5.erc ne -1 or p3l6.erc ne -1) then begin
	average_good=where(halo_vals ne 0)
	IF(average_good[0] EQ -1)THEN begin
		TPF_epli = -1.0
	endif ELSE BEGIN
		avg_halo=mean(halo_vals[average_good])
		halo_lessavghalo=halo_vals-avg_halo
		max_halo_lessavghalo=max(halo_lessavghalo)
		TPF_p3l=1.000+(max_halo_lessavghalo/avg_halo)
	ENDELSE
	endif else begin
	TPF_p3l=-1.0
endelse

;print, tpf_p2u, tpf_p2l, tpf_p3u, tpf_p3l

;EPU outer
;epuo1=getdata('amh_phalo/epu/o1', strtrim(string(fix(shots[i])),2), /noecho)
epuo2=getdata('amh_phalo/epu/o2', strtrim(string(fix(shots[i])),2), /noecho)
epuo3=getdata('amh_phalo/epu/o3', strtrim(string(fix(shots[i])),2), /noecho)
epuo4=getdata('amh_phalo/epu/o4', strtrim(string(fix(shots[i])),2), /noecho)
epuo5=getdata('amh_phalo/epu/o5', strtrim(string(fix(shots[i])),2), /noecho)
epuo6=getdata('amh_phalo/epu/o6', strtrim(string(fix(shots[i])),2), /noecho)

; if(epuo1.erc ne -1) then begin
; 	time_find=where(epuo1.time ge time_tpf[0])
; 	if(time_find[0] eq -1)then
; 		halo_vals[0]=-1
; 		goto, epuo2g
; 	endif
; 	halo_vals[0]=abs(epuo1.data[time_find[0]])
; endif

;epu02g:

if(epuo2.erc ne -1) then begin
	time_find=where(epuo2.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[1]=-1
		goto, epuo3g
	endif
	halo_vals[1]=abs(epuo2.data[time_find[0]])
endif

epuo3g:

if(epuo3.erc ne -1) then begin
	time_find=where(epuo3.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[2]=-1
		goto, epuo4g
	endif
	halo_vals[2]=abs(epuo3.data[time_find[0]])
endif

epuo4g:

if(epuo4.erc ne -1) then begin
	time_find=where(epuo4.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[3]=-1
		goto, epuo5g
	endif
	halo_vals[3]=abs(epuo4.data[time_find[0]])
endif

epuo5g:

if(epuo5.erc ne -1) then begin
	time_find=where(epuo5.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[4]=-1
		goto, epuo6g
	endif
	halo_vals[4]=abs(epuo5.data[time_find[0]])
endif

epuo6g:

if(epuo6.erc ne -1) then begin
	time_find=where(epuo6.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[5]=-1
		goto, epuoall
	endif
	halo_vals[5]=abs(epuo6.data[time_find[0]])
endif

epuoall:

if(epuo2.erc ne -1 or epuo3.erc ne -1 or epuo4.erc ne -1 or epuo5.erc ne -1 or epuo6.erc ne -1) then begin
	average_good=where(halo_vals ne 0)
	IF(average_good[0] EQ -1)THEN begin
		TPF_epli = -1.0
	endif ELSE BEGIN
		avg_halo=mean(halo_vals[average_good])
		halo_lessavghalo=halo_vals-avg_halo
		max_halo_lessavghalo=max(halo_lessavghalo)
		TPF_epuo=1.000+(max_halo_lessavghalo/avg_halo)
	ENDELSE
	endif else begin
	TPF_epuo=-1.0
endelse


;EPU inner
epui1=getdata('amh_phalo/epu/i1', strtrim(string(fix(shots[i])),2), /noecho)
;epui2=getdata('amh_phalo/epu/i2', strtrim(string(fix(shots[i])),2), /noecho)
epui3=getdata('amh_phalo/epu/i3', strtrim(string(fix(shots[i])),2), /noecho)
epui4=getdata('amh_phalo/epu/i4', strtrim(string(fix(shots[i])),2), /noecho)
;epui5=getdata('amh_phalo/epu/i5', strtrim(string(fix(shots[i])),2), /noecho)
;epui6=getdata('amh_phalo/epu/i6', strtrim(string(fix(shots[i])),2), /noecho)

if(epui1.erc ne -1) then begin
	time_find=where(epui1.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[0]=-1
		goto, epui2g
	endif
	halo_vals[0]=abs(epui1.data[time_find[0]])
endif

epui2g:

; if(epui2.erc ne -1) then begin
; 	time_find=where(epui2.time ge time_tpf[0])
; 	if(time_find[0] eq -1)then
; 		halo_valos[1]=-1
; 		goto, epui3g
; 	endif
; 	halo_vals[1]=abs(epui2.data[time_find[0]])
; endif

; epui3g:

if(epui3.erc ne -1) then begin
	time_find=where(epui3.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[2]=-1
		goto, epui4g
	endif
	halo_vals[2]=abs(epui3.data[time_find[0]])
endif

epui4g:

if(epui4.erc ne -1) then begin
	time_find=where(epui4.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[3]=-1
		goto, epui5g
	endif
	halo_vals[3]=abs(epui4.data[time_find[0]])
endif

epui5g:

; if(epui5.erc ne -1) then begin
; 	time_find=where(epui5.time ge time_tpf[0])
; 	halo_vals[4]=abs(epui5.data[time_find[0]])
; endif

; if(epui6.erc ne -1) then begin
; 	time_find=where(epui6.time ge time_tpf[0])
; 	halo_vals[5]=abs(epui6.data[time_find[0]])
; endif

if(epui1.erc ne -1 or epui3.erc ne -1 or epui4.erc ne -1) then begin
	average_good=where(halo_vals ne 0)
	IF(average_good[0] EQ -1)THEN begin
		TPF_epli = -1.0
	endif ELSE BEGIN
		avg_halo=mean(halo_vals[average_good])
		halo_lessavghalo=halo_vals-avg_halo
		max_halo_lessavghalo=max(halo_lessavghalo)
		TPF_epui=1.000+(max_halo_lessavghalo/avg_halo)
	ENDELSE
	endif else begin
	TPF_epui=-1.0
endelse

;EPL outer
eplo1=getdata('amh_phalo/epl/o1', strtrim(string(fix(shots[i])),2), /noecho)
eplo2=getdata('amh_phalo/epl/o2', strtrim(string(fix(shots[i])),2), /noecho)
eplo3=getdata('amh_phalo/epl/o3', strtrim(string(fix(shots[i])),2), /noecho)
eplo4=getdata('amh_phalo/epl/o4', strtrim(string(fix(shots[i])),2), /noecho)
eplo5=getdata('amh_phalo/epl/o5', strtrim(string(fix(shots[i])),2), /noecho)
eplo6=getdata('amh_phalo/epl/o6', strtrim(string(fix(shots[i])),2), /noecho)

if(eplo1.erc ne -1) then begin
	time_find=where(eplo1.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[0]=-1
		goto, eplo2g
	endif
	halo_vals[0]=abs(eplo1.data[time_find[0]])
endif

eplo2g:

if(eplo2.erc ne -1) then begin
	time_find=where(eplo2.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[1]=-1
		goto, eplo3g
	endif
	halo_vals[1]=abs(eplo2.data[time_find[0]])
endif

eplo3g:

if(eplo3.erc ne -1) then begin
	time_find=where(eplo3.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[2]=-1
		goto, eplo4g
	endif
	halo_vals[2]=abs(eplo3.data[time_find[0]])
endif

eplo4g:

if(eplo4.erc ne -1) then begin
	time_find=where(eplo4.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[3]=-1
		goto, eplo5g
	endif
	halo_vals[3]=abs(eplo4.data[time_find[0]])
endif

eplo5g:

if(eplo5.erc ne -1) then begin
	time_find=where(eplo5.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[4]=-1
		goto, eplo6g
	endif
	halo_vals[4]=abs(eplo5.data[time_find[0]])
endif

eplo6g:

if(eplo6.erc ne -1) then begin
	time_find=where(eplo6.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[5]=-1
		goto, eploall
	endif
	halo_vals[5]=abs(eplo6.data[time_find[0]])
endif

eploall:

if(eplo1.erc ne -1 or eplo2.erc ne -1 or eplo3.erc ne -1 or eplo4.erc ne -1 or eplo5.erc ne -1 or eplo6.erc ne -1) then begin
	average_good=where(halo_vals ne 0)
	IF(average_good[0] EQ -1)THEN begin
		TPF_epli = -1.0
	endif ELSE BEGIN
		avg_halo=mean(halo_vals[average_good])
		halo_lessavghalo=halo_vals-avg_halo
		max_halo_lessavghalo=max(halo_lessavghalo)
		TPF_eplo=1.000+(max_halo_lessavghalo/avg_halo)
	ENDELSE
	endif else begin
	TPF_eplo=-1.0
endelse

;EPL inner
epli1=getdata('amh_phalo/epu/i1', strtrim(string(fix(shots[i])),2), /noecho)
epli2=getdata('amh_phalo/epu/i2', strtrim(string(fix(shots[i])),2), /noecho)
epli3=getdata('amh_phalo/epu/i3', strtrim(string(fix(shots[i])),2), /noecho)
epli4=getdata('amh_phalo/epu/i4', strtrim(string(fix(shots[i])),2), /noecho)
;epli5=getdata('amh_phalo/epu/i5', strtrim(string(fix(shots[i])),2), /noecho)
;epli6=getdata('amh_phalo/epu/i6', strtrim(string(fix(shots[i])),2), /noecho)

if(epli1.erc ne -1) then begin
	time_find=where(epli1.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[0]=-1
		goto, epli2g
	endif
	halo_vals[0]=abs(epli1.data[time_find[0]])
endif

epli2g:

if(epli2.erc ne -1) then begin
	time_find=where(epli2.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[1]=-1
		goto, epli3g
	endif
	halo_vals[1]=abs(epli2.data[time_find[0]])
endif

epli3g:

if(epli3.erc ne -1) then begin
	time_find=where(epli3.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[2]=-1
		goto, epli4g
	endif
	halo_vals[2]=abs(epli3.data[time_find[0]])
endif

epli4g:

if(epli4.erc ne -1) then begin
	time_find=where(epli4.time ge time_tpf[0])
	if(time_find[0] eq -1)then begin
		halo_vals[2]=-1
		goto, epli5g
	endif
	halo_vals[3]=abs(epli4.data[time_find[0]])
endif

;if(epli5.erc ne -1) then begin
; 	time_find=where(epli5.time ge time_tpf[0])
; 	halo_vals[4]=abs(epli5.data[time_find[0]])
; endif

;if(epli6.erc ne -1) then begin
; 	time_find=where(epli6.time ge time_tpf[0])
; 	halo_vals[5]=abs(epli6.data[time_find[0]])
; endif

epli5g:

if(epli1.erc ne -1 or epli2.erc ne -1 or epli3.erc ne -1 or epli4.erc ne -1) then begin
	average_good=where(halo_vals ne 0)
	IF(average_good[0] EQ -1)THEN begin
		TPF_epli = -1.0
	endif ELSE BEGIN
		avg_halo=mean(halo_vals[average_good])
		halo_lessavghalo=halo_vals-avg_halo
		max_halo_lessavghalo=max(halo_lessavghalo)
		TPF_epli=1.000+(max_halo_lessavghalo/avg_halo)
	ENDELSE
	endif else begin
	TPF_epli=-1.0
endelse

tpl_array=make_array(8)

tpl_array=[tpf_p2u, tpf_p2l, tpf_p3u, tpf_p3l, tpf_epuo, tpf_epui, tpf_eplo, tpf_epli]

maximumtpf=max(tpl_array)

TPF[i,*]=tpl_array

;print, TPF[i]

endfor

;save, filename='disruption_efit_7.sav'
;save, filename='disruption_efit_M7_7.sav'
save, filename='disruption_efit_0709_7.sav'

END