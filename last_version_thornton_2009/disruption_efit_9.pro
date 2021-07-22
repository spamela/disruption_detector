PRO disruption_efit_9

;corrects the values obtained in disruption_efit_5 and disruption_efit_8 for shots that have disrupting eq 0. For these shots, the values of Bn, Bt, q0, etc will be taken at the time of the maximum value of Bt. 

;restore, 'disruption_efit_8.sav'
;restore, 'disruption_efit_M7_8.sav'
restore, 'disruption_efit_0709_8.sav'

shots_to_change=where(disrupting eq 0)

for i=0, n_elements(shots_to_change)-1 do begin
	
	betandata=getdata('EFM_BETAN',strtrim(string(fix(shots[shots_to_change[i]])),2))
	betapdata=getdata('EFM_BETAP',strtrim(string(fix(shots[shots_to_change[i]])),2),/noecho)
	betatdata=getdata('EFM_BETAT',strtrim(string(fix(shots[shots_to_change[i]])),2),/noecho)
	q0data=getdata('EFM_Q_AXIS',strtrim(string(fix(shots[shots_to_change[i]])),2),/noecho)
	q95data=getdata('EFM_Q_95',strtrim(string(fix(shots[shots_to_change[i]])),2),/noecho)
	elongationdata=getdata('EFM_ELONGATION',strtrim(string(fix(shots[shots_to_change[i]])),2),/noecho)
	lidata=getdata('EFM_LI',strtrim(string(fix(shots[shots_to_change[i]])),2),/noecho)
	drsepdata=getdata('ESM_DR_SEP_OUT',strtrim(string(fix(shots[shots_to_change[i]])),2),/noecho)
	btoroidaldata=getdata('efm_bphi_rmag', strtrim(string(fix(shots[shots_to_change[i]])),2), /noecho)
	minorradiusdata=getdata('efm_minor_radius', strtrim(string(fix(shots[shots_to_change[i]])),2), /noecho)
	ip=getdata('amc_plasma current', strtrim(string(fix(shots[shots_to_change[i]])),2),/noecho)
	
	if(betatdata.erc eq -1)then begin
		betan_5[shots_to_change[i]]=-1
		betap_5[shots_to_change[i]]=-1
		betat_5[shots_to_change[i]]=-1
		q0_5[shots_to_change[i]]=-1
		q95_5[shots_to_change[i]]=-1
		elongation_5[shots_to_change[i]]=-1
		li_5[shots_to_change[i]]=-1
		betan_25[shots_to_change[i]]=-1
		betap_25[shots_to_change[i]]=-1
		betat_25[shots_to_change[i]]=-1
		q0_25[shots_to_change[i]]=-1
		q95_25[shots_to_change[i]]=-1
		elongation_25[shots_to_change[i]]=-1
		li_25[shots_to_change[i]]=-1
	endif else begin
		
		maxbetat=max(betatdata.data)
		time_find=where(betatdata.data eq maxbetat)
		
		time_find_ip=betatdata.time[where(betatdata.data ge maxbetat)]
		time_find_ip2=where(ip.time ge time_find_ip[0])
		
		ip_disruption[shots_to_change[i]]=ip.data[time_find_ip2[0]]
	
		betat_5[shots_to_change[i]]=betatdata.data[time_find[0]]
		betat_25[shots_to_change[i]]=betatdata.data[time_find[0]]
		
		betap_5[shots_to_change[i]]=betapdata.data[time_find[0]]
		betap_25[shots_to_change[i]]=betapdata.data[time_find[0]]
	
		betat_5[shots_to_change[i]]=betatdata.data[time_find[0]]
		betat_25[shots_to_change[i]]=betatdata.data[time_find[0]]
		
		q0_5[shots_to_change[i]]=q0data.data[time_find[0]]
		q0_25[shots_to_change[i]]=q0data.data[time_find[0]]
		
		q95_5[shots_to_change[i]]=q95data.data[time_find[0]]
		q95_25[shots_to_change[i]]=q95data.data[time_find[0]]
	
		elongation_5[shots_to_change[i]]=elongationdata.data[time_find[0]]
		elongation_25[shots_to_change[i]]=elongationdata.data[time_find[0]]
	
		li_5[shots_to_change[i]]=lidata.data[time_find[0]]
		li_25[shots_to_change[i]]=lidata.data[time_find[0]]
	
		if(btoroidaldata.erc eq -1) then begin
			btoroidal_5[shots_to_change[i]]=-1
			btoroidal_25[shots_to_change[i]]=-1
		endif else begin
			time_find2=where(btoroidaldata.time ge betatdata.time[time_find[0]])
			if(time_find2[0] eq -1) then begin
				btoroidal_5[shots_to_change[i]]=-1
				btoroidal_25[shots_to_change[i]]=-1
			endif else begin
			btoroidal_5[shots_to_change[i]]=btoroidaldata.data[time_find2[0]]
			btoroidal_25[shots_to_change[i]]=btoroidaldata.data[time_find2[0]]
			endelse
		endelse
	
		if(minorradiusdata.erc eq -1) then begin
			minorradius_5[shots_to_change[i]]=-1
			minorradius_25[shots_to_change[i]]=-1
		endif else begin
			time_find3=where(minorradiusdata.time ge betatdata.time[time_find[0]])
			if(time_find3[0] eq -1) then begin
				minorradius_5[shots_to_change[i]]=-1
				minorradius_25[shots_to_change[i]]=-1
			endif else begin
			minorradius_5[shots_to_change[i]]=minorradiusdata.data[time_find3[0]]
			minorradius_25[shots_to_change[i]]=minorradiusdata.data[time_find3[0]]
			endelse
		endelse
	
		if(drsepdata.erc eq -1) then begin
			drsep_5[shots_to_change[i]]=-1
			drsep_25[shots_to_change[i]]=-1
		endif else begin
			find5=where(drsepdata.time ge betatdata.time[time_find[0]])
		
			if(find5[0] ne -1) then begin
				drsep_5[shots_to_change[i]]=drsepdata.data[find5[0]]
				drsep_25[shots_to_change[i]]=drsepdata.data[find5[0]]
			endif else begin
				drsep_5[shots_to_change[i]]=-1
				drsep_25[shots_to_change[i]]=-1
			endelse
		endelse
		
	endelse
	
endfor

;save, filename='disruption_efit_M7_9.sav'
save, filename='disruption_efit_0709_9.sav'

END
	
	