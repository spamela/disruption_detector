PRO ir_db

if(file_test('ir_db_part.sav') eq 0) then begin
;make a database of disruptions with IR data

;read in the list of shots with MWIR and LWIR data
shot_list=read_ascii('irlist.txt')
shots=shot_list.field1

;find the disruption time using the plasma current
tq_time=make_array(n_elements(shots))

isol_change=make_array(n_elements(shots))
isol_constant=make_array(n_elements(shots))

nbi_cease=make_array(n_elements(shots))
nbi_constant=make_array(n_elements(shots))
nbi_disruption=make_array(n_elements(shots))
nbi_max=make_array(n_elements(shots))

ip_flattop=make_array(n_elements(shots))
use=make_array(n_elements(shots))
ir_data=make_array(n_elements(shots))

wthermal_5=make_array(n_elements(shots))
wmag_5=make_array(n_elements(shots))
wradiated=make_array(n_elements(shots))

energy_tot=make_array(n_elements(shots))
energy_upper_outer=make_array(n_elements(shots))
energy_upper_inner=make_array(n_elements(shots))
energy_lower_outer=make_array(n_elements(shots))
energy_lower_inner=make_array(n_elements(shots))
peak_pow_upp_out_d=make_array(n_elements(shots))
peak_pow_upp_inn_d=make_array(n_elements(shots))
peak_pow_low_out_d=make_array(n_elements(shots))
peak_pow_low_inn_d=make_array(n_elements(shots))
peak_pow_upp_out_s=make_array(n_elements(shots))
peak_pow_upp_inn_s=make_array(n_elements(shots))
peak_pow_low_out_s=make_array(n_elements(shots))
peak_pow_low_inn_s=make_array(n_elements(shots))
expansion_upp_out=make_array(n_elements(shots))
expansion_upp_inn=make_array(n_elements(shots))
expansion_low_out=make_array(n_elements(shots))
expansion_low_inn=make_array(n_elements(shots))

for i=0, n_elements(shots)-1 do begin
	tq_time[i]=ttq(strtrim(string(fix(shots[i])),2))
	isol=getdata('amc_sol current', strmid(string(fix(shots[i])),2), /noecho)
	nbi=getdata('anb_tot_sum_power',strmid(string(fix(shots[i])),2), /noecho)
	ip=getdata('amc_plasma current',strmid(string(fix(shots[i])),2), /noecho)
	
if(tq_time[i] gt 0) then begin
	start_ip=where(ip.data gt 50)
	end_ip=n_elements(start_ip)-1+start_ip[0]
	find=where(ip.time ge tq_time[i])
	;determine if the Isol is constant
;isol calcs
      if(isol.erc eq -1) then begin
          ;print, shots[i], 'Isol is missing'
          isol_change[i]=-1
          goto, end_isol_calc
      endif

      max_isol_time=max(isol.time)
      isol_deriv=smooth(deriv(isol.time, isol.data),10)
;      isol_change_pt = where(isol_deriv GT 3 and isol.time GT 0.1)
;      isol_change_pt = where(isol_deriv GT 100 and isol.time GT 0.1) 
;ammended 24/11/08, to correct oversensitivity in gradient of isol in shots 18360/18361 -athorn
      isol_change_pt = where(isol_deriv GT 100 and isol.time GT 0.1) 
;ammended 12/01/09 to correct for shots in rampdown.
      if(isol_change_pt[0] eq -1) then begin
          ;print, shots[i], 'Isol does not change'
          isol_change[i]=ip.time[end_ip]
          goto, end_isol_calc
      endif

      isol_atchange=isol.data[isol_change_pt[0]]
      isol_time=isol.time[isol_change_pt[0]]

      isol_change[i]=isol_time

end_isol_calc:


	;determine if the NBI is constant/above 400kW
;NBI calcs

      if(nbi.erc eq -1 or shots[i] eq 15957 or shots[i] eq 20765 or shots[i] eq 21073 or n_elements(nbi.time) lt 3) then begin
          ;print, shots[i], 'NBI data missing'
          nbi_cease[i]=-1
          nbi_disruption[i]=-1
          nbi_max[i]=-1
          goto, end_nbi_calc
      endif

      nbi_mean=mean(nbi.data)
      nbi_deriv=smooth(deriv(nbi.time, nbi.data),75)
      min_value=min(nbi_deriv)
      nbi_change=where(nbi.time gt 0.15 and nbi_deriv lt -50)
      max_nbi=max(nbi.data)

      if(nbi_mean lt 0.01) then begin
          nbi_max[i]=max_nbi
          nbi_cease[i]=ip.time[end_ip]
      endif
      if(nbi_change[0] eq -1) then begin
         nbi_cease[i]=-3
          nbi_max[i]=max_nbi
      endif

       if(nbi_mean gt 0.01 and nbi_change[0] ne -1) then begin
          nbi_cease[i]=nbi.time[nbi_change[0]]
          nbi_max[i]=max_nbi
      endif

      disruption_nbi=where(nbi.time ge tq_time[i])

      if(disruption_nbi[0] eq -1) then begin
          nbi_cease[i]=-1
          nbi_max[i]=max_nbi
          nbi_disruption[i]=-1
          goto, end_nbi_calc
      endif

      nbi_disruption[i]=nbi.data(disruption_nbi[0])
      nbi_max[i]=max_nbi

end_nbi_calc:

	;determine if there is a flattop
	disrupt_point=find[0]

 if((ip.data[disrupt_point-40] lt (ip.data[disrupt_point-10]*0.9) or $
         (ip.data[disrupt_point-40] gt ip.data[disrupt_point-10]*1.1))) then begin
          ip_flattop[i]=-1
          ;w_flattop[i]=-1
          goto, end_ip_calc
      endif

      ip_flattop[i]=ip.data[disrupt_point-30]


end_ip_calc:


	;define a use flag for the shot
	if(tq_time[i] gt 0 and nbi_cease[i] gt tq_time[i] or nbi_max[i] lt 400 and isol_change[i] gt tq_time[i]) then begin
		use[i]=1
	endif

	;read in the wthermal and wmagnetic traces from EFIT
	wtherm=getdata('efm_plasma_energy', strtrim(string(fix(shots[i])),2))
	wmag=getdata('efm_wpol',  strtrim(string(fix(shots[i])),2))

;stop

	if(wtherm.erc ne -1 and wmag.erc ne -1) then begin
		q=where(wtherm.time ge tq_time[i]-0.005)
		if(q[0] ne -1) then begin
			wthermal_5[i]=wtherm.data[q[0]]
			wmag_5[i]=wmag.data[q[0]]
		endif else begin
			wthermal_5[i]=-10
			wmag_5[i]=-10
		endelse
	endif else begin
		wthermal_5[i]=-10
		wmag_5[i]=-10
	endelse

	;perform the bolometer anaylsis as set out in bolo_data3.pro
	result=bolo_data3(shot=strtrim(string(fix(shots[i])),2), ttq=tq_time[i])
	wradiated[i]=result.rad_energy

;stop	

endif else begin
isol_change[i]=-10
isol_constant[i]=-10
nbi_cease[i]=-10
nbi_constant[i]=-10
nbi_disruption[i]=-10
nbi_max[i]=-10
ip_flattop[i]=-10
endelse
endfor

i=0

save, filename='ir_db_part.sav'

endif else begin
;stop
restore, filename='ir_db_part.sav'

variable=i

;look at what data is available for each shot
;define a number based on data available
count=0

irdatapath='~gdt/IRdata/'

for i=variable, n_elements(shots)-1 do begin

	;make aii filename
	filename_li='aii0'+strmid(strtrim(string(fix(shots[i])),2),0,3)+'.'+strmid(strtrim(string(fix(shots[i])),2),3,5)+'isp'
	filename_lo='aii0'+strmid(strtrim(string(fix(shots[i])),2),0,3)+'.'+strmid(strtrim(string(fix(shots[i])),2),3,5)+'osp'
	;make air filenames
	filename_mi='air0'+strmid(strtrim(string(fix(shots[i])),2),0,3)+'.'+strmid(strtrim(string(fix(shots[i])),2),3,5)+'isp'
	filename_mo='air0'+strmid(strtrim(string(fix(shots[i])),2),0,3)+'.'+strmid(strtrim(string(fix(shots[i])),2),3,5)+'osp'

	if(file_test(irdatapath+filename_li) and $
	   file_test(irdatapath+filename_lo) and $
	   file_test(irdatapath+filename_mi) and $
	   file_test(irdatapath+filename_mo)) then begin
		
	;only runs shots with a full set of divertor coverage.
	;first check that the files are there for all cameras
	;now check to see that the LWIR is on top and MWIR
	;on the bottom

		li=getdata('aii_z_start_isp','IDA::'+irdatapath+filename_li, /noecho)
		lo=getdata('aii_z_start_osp','IDA::'+irdatapath+filename_lo, /noecho)
		mi=getdata('air_z_start_isp','IDA::'+irdatapath+filename_mi, /noecho)
		mo=getdata('air_z_start_osp','IDA::'+irdatapath+filename_mo)

		if(li.erc ne -1 and lo.erc ne -1 and mi.erc ne -1 and mo.erc ne -1) then begin
		if(li.data gt 0.0 and lo.data gt 0.0 and mi.data lt 0.0 and mo.data lt 0.0 and use[i] eq 1) then begin
		;if() then begin

			;count=count+1
			ir_data[i]=1
			if(tq_time[i] gt 0 and shots[i] ne 22123 and shots[i] ne 23780) then begin
				result=ir_load(shot=shots[i], ttq_time=tq_time[i])

				energy_tot[i]=result.energy_tot
      				energy_upper_outer[i]=result.energy_upper_outer
				energy_upper_inner[i]=result.energy_upper_inner
				energy_lower_outer[i]=result.energy_lower_outer
      				energy_lower_inner[i]=result.energy_lower_inner
      				peak_pow_upp_out_d[i]=result.peak_pow_upp_out_d
      				peak_pow_upp_inn_d[i]=result.peak_pow_upp_inn_d
      				peak_pow_low_out_d[i]=result.peak_pow_low_out_d
      				peak_pow_low_inn_d[i]=result.peak_pow_low_inn_d
     				peak_pow_upp_out_s[i]=result.peak_pow_upp_out_s
      				peak_pow_upp_inn_s[i]=result.peak_pow_upp_inn_s
      				peak_pow_low_out_s[i]=result.peak_pow_low_out_s
      				peak_pow_low_inn_s[i]=result.peak_pow_low_inn_s
				expansion_upp_out[i]=result.expansion_upp_out
			      	expansion_upp_inn[i]=result.expansion_upp_inn
			        expansion_low_out[i]=result.expansion_low_out
      			        expansion_low_inn[i]=result.expansion_low_inn
			endif
		endif
		endif
	endif

;more, shots
;print, count	
q=where(use eq 1 and ir_data eq 1) 
more,q
;wait,1
save, filename='ir_db_part.sav'

endfor
endelse

save, filename='ir_db_all.sav'
stop

END


