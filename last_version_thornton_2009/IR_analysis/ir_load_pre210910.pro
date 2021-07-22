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
;find the peak power load during steady state (hopefully)
peak_pow_upp_out_s=lop.data[steady_range[0]]
peak_pow_upp_inn_s=lip.data[steady_range[0]]
peak_pow_low_out_s=mop.data[steady_range_m[0]]
peak_pow_low_inn_s=mip.data[steady_range_m[0]]

;heat flux width calcs.
;see lab book 5 pg 42 for method, or read following

;read in the q profiles
q_lo=getdata('aii_qprofile_osp', lo_path, /noecho)
q_li=getdata('aii_qprofile_isp', li_path, /noecho)
q_mo=getdata('air_qprofile_osp', mo_path, /noecho)
q_mi=getdata('air_qprofile_isp', mi_path, /noecho)

width_lo=integral_width(q_lo)
width_li=integral_width(q_li)
width_mo=integral_width(q_mo)
width_mi=integral_width(q_mi)

;find the steady state widths
steady_width_lo=mean(width_lo[steady_range])
steady_width_li=mean(width_li[steady_range])
steady_width_mo=mean(width_mo[steady_range_m])
steady_width_mi=mean(width_mi[steady_range_m])

;divide by widths to get ratio disrupt/steady
ratio_lo=width_lo/steady_width_lo
ratio_li=width_li/steady_width_li
ratio_mo=width_mo/steady_width_mo
ratio_mi=width_mi/steady_width_mi

;find the expansion during the disruption
exp_window=where(q_lo.time gt ttq_time-0.004 and q_lo.time lt ttq_time+0.01)
exp_window_m=where(q_mo.time gt ttq_time-0.004 and q_mo.time lt ttq_time+0.01)
expansion_lo=max(ratio_lo[exp_window])
expansion_li=max(ratio_li[exp_window])
expansion_mo=max(ratio_mo[exp_window])
expansion_mi=max(ratio_mi[exp_window])

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
	if keyword_set(ps) then psopen, filename='heat_flux_widths'+strtrim(string(fix(shot)),2)+'.eps'
	!p.multi=0

	plot, q_lo.time, width_lo*1000, /ylog, xtitle='Time', ytitle='Width (mm)',yrange=[50, 1000], ys=1, xrange=[ttq_time-0.01, ttq_time+0.1], position=[0.10,0.55,0.95,0.95]
	oplot, q_li.time, width_li*1000, color=truecolor('red')
	oplot, q_mo.time, width_mo*1000, color=truecolor('blue')
	oplot, q_mi.time, width_mi*1000, color=truecolor('limegreen')
	xyouts, 0.85, 0.9, 'LWIR OSP' ,/normal
	xyouts, 0.85, 0.86, 'LWIR ISP', /normal, color=truecolor('red')
	xyouts, 0.85, 0.82, 'MWIR OSP', /normal, color=truecolor('blue')
	xyouts, 0.85, 0.78, 'MWIR ISP', /normal, color=truecolor('limegreen')

	plot, q_lo.time, ratio_lo, /ylog, xtitle='Time', ytitle='Ratio',yrange=[1, 50], ys=1, xrange=[ttq_time-0.01, ttq_time+0.1], position=[0.10,0.10,0.95,0.45], /noerase
	oplot, q_li.time, ratio_li, color=truecolor('red')
	oplot, q_mo.time, ratio_mo, color=truecolor('blue')
	oplot, q_mi.time, ratio_mi, color=truecolor('limegreen')
	xyouts, 0.85, 0.42, 'LWIR OSP' ,/normal
	xyouts, 0.85, 0.38, 'LWIR ISP', /normal, color=truecolor('red')
	xyouts, 0.85, 0.35, 'MWIR OSP', /normal, color=truecolor('blue')
	xyouts, 0.85, 0.31, 'MWIR ISP', /normal, color=truecolor('limegreen')
	!p.multi=0
	if(keyword_set(ps)) then begin
		psclose
		!p.font=-1
		!p.charsize=1.0
	endif

endif
;stop

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
      peak_pow_low_inn_s:peak_pow_low_inn_s, $
      width_upp_out:width_lo, $
      width_upp_inn:width_li, $
      width_low_out:width_mo, $
      width_low_inn:width_mi, $
      ratio_upp_out:ratio_lo, $
      ratio_upp_inn:ratio_li, $
      ratio_low_out:ratio_mo, $
      ratio_low_inn:ratio_mi, $
      expansion_upp_out:expansion_lo, $
      expansion_upp_inn:expansion_li, $
      expansion_low_out:expansion_mo, $
      expansion_low_inn:expansion_mi}

return, data

END
