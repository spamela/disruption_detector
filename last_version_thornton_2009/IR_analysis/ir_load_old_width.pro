FUNCTION ir_load, shot=shot, ttq_time=ttq_time, plotting=plotting, ps=ps

;ida_path='IDA::'+filename
	shot_no='0'+strmid(strtrim(string(fix(shot)),2),0,3)+ $
		'.'+strmid(strtrim(string(fix(shot)),2),3,5)
	path='~gdt/IRdata/'
	lo_path=path+'aii'+shot_no+'osp'
	li_path=path+'aii'+shot_no+'isp'
	mo_path=path+'air'+shot_no+'osp'
	mi_path=path+'air'+shot_no+'isp'

if(keyword_set(ttq_time) ne 1) then begin	
	ttq_time=ttq(strtrim(string(fix(shot)),2))
endif

lop=getdata('aii_ptot_osp', lo_path)
lo=getdata('aii_etotsum_osp', lo_path, /noecho)
mop=getdata('air_ptot_osp', mo_path, /noecho)

;use the power trace to determine when the disruption power load arrives
;use same method as that used for bolometer (bolo_data3.pro) for lwir
threshold=where(lop.time gt ttq_time-0.025 and lop.time lt ttq_time-0.015)
thres_mean=mean(lop.data[threshold])
thres_stdev=stdev(lop.data[threshold])

peakstart=where(lop.time gt ttq_time-0.004 and lop.data ge thres_mean+1.8*thres_stdev)
	;jump in power is sudden - subtract one index from peakstart
cuttime=lop.time[peakstart[0]-1]

;now do same for MWIR
threshold_m=where(mop.time gt ttq_time-0.02 and mop.time lt ttq_time-0.006)
thres_mean_m=mean(mop.data[threshold_m])
thres_stdev_m=stdev(mop.data[threshold_m])

peakstart_m=where(mop.time gt ttq_time-0.004 and mop.data ge thres_mean_m+1.1*thres_stdev_m)
cuttime_m=mop.time[peakstart_m[0]-1]


;now read the other traces in
li=getdata('aii_etotsum_isp', li_path, /noecho)
mo=getdata('air_etotsum_osp', mo_path, /noecho)
mi=getdata('air_etotsum_isp', mi_path, /noecho)

lip=getdata('aii_ptot_isp', li_path)
mop=getdata('air_ptot_osp', mo_path)
mip=getdata('air_ptot_isp', mi_path)

;find the maximum cumulative energy deposited to divertor for each
;target, then subtract value at cuttime

range=where(lo.time gt cuttime)
range_m=where(mo.time gt cuttime_m)
steady_range=where(lo.time gt ttq_time-0.02 and lo.time lt ttq_time-0.01)
steady_range_m=where(mo.time gt ttq_time-0.02 and mo.time lt ttq_time-0.01)

energy_upper_outer=max(lo.data[range])-lo.data[peakstart[0]-1]
energy_upper_inner=max(li.data[range])-li.data[peakstart[0]-1]
energy_lower_outer=max(mo.data[range_m])-mo.data[peakstart_m[0]-1]
energy_lower_inner=max(mi.data[range_m])-mi.data[peakstart_m[0]-1]

energy_tot=energy_upper_outer + energy_upper_inner + $
	   energy_lower_outer + energy_lower_inner

;find the peak power load at the disruption (d) and in steady state (s)
peak_pow_upp_out_d=max(lop.data[range])
peak_pow_upp_inn_d=max(lip.data[range])
peak_pow_low_out_d=max(mop.data[range_m])
peak_pow_low_inn_d=max(mip.data[range_m])

;find the index of the maximum for later
profile_lo=where(lop.data eq peak_pow_upp_out_d)
profile_li=where(lip.data eq peak_pow_upp_inn_d)
profile_mo=where(mop.data eq peak_pow_low_out_d)
profile_mi=where(mip.data eq peak_pow_low_inn_d)

;find the peak power load during steady state (hopefully)
peak_pow_upp_out_s=lop.data[steady_range[0]]
peak_pow_upp_inn_s=lip.data[steady_range[0]]
peak_pow_low_out_s=mop.data[steady_range_m[0]]
peak_pow_low_inn_s=mip.data[steady_range_m[0]]

;heat flux width calcs.
;see lab book 5 pg 40 for method (and pg 41), or read following

;read in the q profiles
q_lo=getdata('aii_qprofile_osp', lo_path, /noecho)
q_li=getdata('aii_qprofile_isp', li_path, /noecho)
q_mo=getdata('air_qprofile_osp', mo_path, /noecho)
q_mi=getdata('air_qprofile_isp', mi_path, /noecho)

;LWIR OUTER
;steady state width
peak_lo_max_s=max(q_lo.data[*,steady_range[0]])
peak_lo_index_s=where(q_lo.data[*,steady_range[0]] eq peak_lo_max_s)
peak_lo_pos_s=q_lo.x[peak_lo_index_s[0]]
;fwhm
thres_lo_fwhm_s=where(q_lo.data[*,steady_range[0]] ge (0.5*peak_lo_max_s))
outer_r_lo_s=q_lo.x[thres_lo_fwhm_s[n_elements(thres_lo_fwhm_s)-1]]
inner_r_lo_s=q_lo.x[thres_lo_fwhm_s[0]]
width_lo_s=outer_r_lo_s-inner_r_lo_s
;disruption
peak_lo_max_d=max(q_lo.data[*,range[0]])
peak_lo_index_d=where(q_lo.data[*,range[0]] eq peak_lo_max_d)
peak_lo_pos_d=q_lo.x[peak_lo_index_d[0]]
;fwhm
thres_lo_fwhm_d=where(q_lo.data[*,range[0]] ge (0.5*peak_lo_max_d))
outer_r_lo_d=q_lo.x[thres_lo_fwhm_d[n_elements(thres_lo_fwhm_d)-1]]
inner_r_lo_d=q_lo.x[thres_lo_fwhm_d[0]]
width_lo_d=outer_r_lo_d-inner_r_lo_d
expansion_lo=width_lo_d/width_lo_s


;LWIR INNER
;steady
peak_li_max_s=max(q_li.data[*,steady_range[0]])
peak_li_index_s=where(q_li.data[*,steady_range[0]] eq peak_li_max_s)
peak_li_pos_s=q_li.x[peak_li_index_s[0]]
;disruption
peak_li_max_d=max(q_li.data[*,range[0]])
peak_li_index_d=where(q_li.data[*,range[0]] eq peak_li_max_d)
peak_li_pos_d=q_li.x[peak_li_index_d[0]]

;MWIR OUTER
;steady
peak_mo_max_s=max(q_mo.data[*,steady_range_m[0]])
peak_mo_index_s=where(q_mo.data[*,steady_range_m[0]] eq peak_mo_max_s)
peak_mo_pos_s=q_mo.x[peak_mo_index_s[0]]
;fwhm
thres_mo_fwhm_s=where(q_mo.data[*,steady_range_m[0]] ge (0.5*peak_mo_max_s))
outer_r_mo_s=q_mo.x[thres_mo_fwhm_s[n_elements(thres_mo_fwhm_s)-1]]
inner_r_mo_s=q_mo.x[thres_mo_fwhm_s[0]]
width_mo_s=outer_r_mo_s-inner_r_mo_s
;disruption
peak_mo_max_d=max(q_mo.data[*,range_m[0]])
peak_mo_index_d=where(q_mo.data[*,range_m[0]] eq peak_mo_max_d)
peak_mo_pos_d=q_mo.x[peak_mo_index_d[0]]
;fwhm
thres_mo_fwhm_d=where(q_mo.data[*,range_m[0]] ge (0.5*peak_mo_max_d))
outer_r_mo_d=q_mo.x[thres_mo_fwhm_d[n_elements(thres_mo_fwhm_d)-1]]
inner_r_mo_d=q_mo.x[thres_mo_fwhm_d[0]]
width_mo_d=outer_r_mo_d-inner_r_mo_d
expansion_mo=width_mo_d/width_mo_s


;MWIR INNER
;steady
peak_mi_max_s=max(q_mi.data[*,steady_range_m[0]])
peak_mi_index_s=where(q_mi.data[*,steady_range_m[0]] eq peak_mi_max_s)
peak_mi_pos_s=q_mi.x[peak_mi_index_s[0]]
;disruption
peak_mi_max_d=max(q_mi.data[*,range_m[0]])
peak_mi_index_d=where(q_mi.data[*,range_m[0]] eq peak_mi_max_d)
peak_mi_pos_d=q_mi.x[peak_mi_index_d[0]]

if(keyword_set(plotting)) then begin
	if not keyword_set(ps) then window,0
	if(keyword_set(ps)) then begin
		!p.font=1
		!p.charsize=1.5
		psopen, filename='Power_'+strtrim(string(fix(shot)),2)+'.eps'
	endif
	!p.multi=[0,2,2]
	plot, lop.time, lop.data, xrange=[ttq_time-0.01, ttq_time+0.1], xtitle='Time', ytitle='LWIR OSP Power (kW)'
	oplot, lop.time[threshold], lop.data[threshold], $
		 color=truecolor('limegreen')
	oplot, lop.time[peakstart-1], lop.data[peakstart-1],$
		 color=truecolor('red'), psym=-7
	plot, lip.time, lip.data, xrange=[ttq_time-0.01, ttq_time+0.1], xtitle='Time', ytitle='LWIR ISP Power (kW)'
	oplot, [cuttime, cuttime], !y.crange, color=truecolor('red')
	plot, mop.time, mop.data, xrange=[ttq_time-0.01, ttq_time+0.1], xtitle='Time', ytitle='MWIR OSP Power (kW)'
	oplot, [cuttime_m, cuttime_m], !y.crange, color=truecolor('red')
	oplot, mop.time[threshold_m], mop.data[threshold_m], $
		 color=truecolor('limegreen')
	oplot, mop.time[peakstart_m-1], mop.data[peakstart_m-1],$
		 color=truecolor('red'), psym=-7
	plot, mip.time, mip.data, xrange=[ttq_time-0.01, ttq_time+0.1], ytitle='MWIR ISP Power (kW)', xtitle='Time'
	oplot, [cuttime_m, cuttime_m], !y.crange, color=truecolor('red')
	if keyword_set(ps) then psclose
	
	if not keyword_set(ps) then window, 1
	if(keyword_set(ps)) then begin
		psopen, filename='Energy_'+strtrim(string(fix(shot)),2)+'.eps'
	endif
	!p.multi=[0,2,2]
	plot, lo.time, lo.data, xrange=[ttq_time-0.01, ttq_time+0.1], xtitle='Time', ytitle='LWIR OSP Energy (kJ)'
	oplot, [cuttime,cuttime], !y.crange, color=truecolor('red')
	plot, li.time, li.data, xrange=[ttq_time-0.01, ttq_time+0.1], xtitle='Time', ytitle='LWIR ISP Energy (kJ)'
	oplot, [cuttime,cuttime], !y.crange, color=truecolor('red')
	plot, mo.time, mo.data, xrange=[ttq_time-0.01, ttq_time+0.1], xtitle='Time', ytitle='MWIR OSP Energy (kJ)'
	oplot, [cuttime_m,cuttime_m], !y.crange, color=truecolor('red')
	plot, mi.time, mi.data, xrange=[ttq_time-0.01, ttq_time+0.1], xtitle='Time', ytitle='MWIR ISP Energy (kJ)'
	oplot, [cuttime_m,cuttime_m], !y.crange, color=truecolor('red')
	if keyword_set(ps) then psclose

	if not keyword_set(ps) then window, 2
	if keyword_set(ps) then psopen, filename='heat_flux_'+strtrim(string(fix(shot)),2)+'.eps'
	!p.multi=[0,2,2]
	plot, q_lo.x, q_lo.data[*,range], xtitle='Radius', ytitle='LWIR OSP heat flux (kW m!u-2!n)'
	oplot, [peak_lo_pos_d, peak_lo_pos_d], !y.crange, color=truecolor('red')
	oplot, q_lo.x, q_lo.data[*,steady_range[0]], linestyle=3
	oplot, [peak_lo_pos_s, peak_lo_pos_s], !y.crange, linestyle=3, $
		 color=truecolor('red')
	oplot, [inner_r_lo_s, inner_r_lo_s], !y.crange, linestyle=3, color=truecolor('blue')
	oplot, [outer_r_lo_s, outer_r_lo_s], !y.crange, linestyle=3, color=truecolor('blue')
	oplot, [inner_r_lo_d, inner_r_lo_d], !y.crange, color=truecolor('blue')
	oplot, [outer_r_lo_d, outer_r_lo_d], !y.crange, color=truecolor('blue')


	plot, q_li.x, q_li.data[*,range], xtitle='Height', ytitle='LWIR ISP heat flux (kW m!u-2!n)'
	oplot, [peak_li_pos_d, peak_li_pos_d], !y.crange, color=truecolor('red')
	oplot, q_li.x, q_li.data[*,steady_range[0]], linestyle=3
	oplot, [peak_li_pos_s, peak_li_pos_s], !y.crange, linestyle=3, $
		 color=truecolor('red')

	plot, q_mo.x, q_mo.data[*,range_m], xtitle='Radius', ytitle='MWIR OSP heat flux (kW m!u-2!n)'
	oplot, [peak_mo_pos_d, peak_mo_pos_d], !y.crange, color=truecolor('red')
	oplot, q_mo.x, q_mo.data[*,steady_range_m[0]], linestyle=3
	oplot, [peak_mo_pos_s, peak_mo_pos_s], !y.crange, linestyle=3, $
		 color=truecolor('red')
	oplot, [inner_r_mo_s, inner_r_mo_s], !y.crange, linestyle=3, color=truecolor('blue')
	oplot, [outer_r_mo_s, outer_r_mo_s], !y.crange, linestyle=3, color=truecolor('blue')
	oplot, [inner_r_mo_d, inner_r_mo_d], !y.crange, color=truecolor('blue')
	oplot, [outer_r_mo_d, outer_r_mo_d], !y.crange, color=truecolor('blue')

	plot, q_mi.x, q_mi.data[*,range_m], xtitle='Height', ytitle='MWIR ISP heat flux (kW m!u-2!n)'
	oplot, [peak_mi_pos_d, peak_mi_pos_d], !y.crange, color=truecolor('red')
	oplot, q_mi.x, q_mi.data[*,steady_range_m[0]], linestyle=3
	oplot, [peak_mi_pos_s, peak_mi_pos_s], !y.crange, linestyle=3, $
		 color=truecolor('red')

	!p.multi=0
	if(keyword_set(ps)) then begin
		psclose
		!p.font=-1
		!p.charsize=1.0
	endif

endif
stop

data={energy_tot:energy_tot, $
      energy_upper_outer:energy_upper_outer, $
      energy_upper_inner:energy_upper_inner, $
      energy_lower_outer:energy_lower_outer, $
      energy_lower_inner:energy_lower_inner, $
      peak_pow_upp_out_d:peak_pow_upp_out_d, $
      peak_pow_upp_inn_d:peak_pow_upp_inn_d, $
      peak_pow_low_out_d:peak_pow_low_out_d, $
      peak_pow_low_inn_d:peak_pow_low_inn_d, $
      peak_pow_upp_out_s:peak_pow_upp_out_s, $
      peak_pow_upp_inn_s:peak_pow_upp_inn_s, $
      peak_pow_low_out_s:peak_pow_low_out_s, $
      peak_pow_low_inn_s:peak_pow_low_inn_s}

return, data

END
