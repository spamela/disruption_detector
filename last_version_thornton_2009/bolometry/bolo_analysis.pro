PRO bolo_analysis, ps=ps

;plot figures of radiated power

restore, 'disruption_bolo_030710_wpol_v3.sav'

;setup output
charsize=1.25
if(keyword_set(ps)) then begin
	!p.font=1
	!p.charsize=2.5
endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
if keyword_set(ps) then psopen, filename='rad_vs_thermal_scatter.eps'

q=where(use_hl eq 1 and wthermal_5 gt 0 and radiated_energy gt 0)

plot, wthermal_5[q]/1e3, radiated_energy[q]/1e3, psym=7, /iso, xrange=[0,120], yrange=[0,120], xtitle='W!Lthermal!n (kJ)', ytitle='W!lradiated!n (kJ)'
oplot, [0,150], [0,150], linestyle=3
xyouts, 0.70, 0.94, '100%', /normal, charsize=charsize
oplot, [0,120], [0,12], linestyle=3
xyouts, 0.70,0.20, '10%', /normal, charsize=charsize
oplot, [0,120], [0,24], linestyle=3
xyouts, 0.70, 0.29, '20%', /normal, charsize=charsize
oplot, [0,120], [0,36], linestyle=3
xyouts, 0.70, 0.37, '30%', /normal, charsize=charsize

if keyword_set(ps) then psclose

;h l mode split
if keyword_set(ps) then psopen, filename='hl_rad_therm_scatter.eps'

r=where(use_hl eq 1 and wthermal_5 gt 0 and radiated_energy gt 0 and hmode_ever eq 1)
s=where(use_hl eq 1 and wthermal_5 gt 0 and radiated_energy gt 0 and hmode_ever eq 0)

plot, wthermal_5[q]/1e3, radiated_energy[q]/1e3, psym=7, /iso, xrange=[0,120], yrange=[0,120], xtitle='W!Lthermal!n (kJ)', ytitle='W!lradiated!n (kJ)', /nodata
oplot, wthermal_5[r]/1e3, radiated_energy[r]/1e3, psym=7, color=truecolor('red')
oplot, wthermal_5[s]/1e3, radiated_energy[s]/1e3, psym=7, color=truecolor('blue')

oplot, [0,150], [0,150], linestyle=3
xyouts, 0.70, 0.94, '100%', /normal, charsize=charsize
oplot, [0,120], [0,12], linestyle=3
xyouts, 0.70,0.20, '10%', /normal, charsize=charsize
oplot, [0,120], [0,24], linestyle=3
xyouts, 0.70, 0.29, '20%', /normal, charsize=charsize
oplot, [0,120], [0,36], linestyle=3
xyouts, 0.70, 0.37, '30%', /normal, charsize=charsize

xyouts, 0.17, 0.85, 'H mode', color=truecolor('red'), charsize=charsize, /normal
xyouts, 0.17, 0.82, 'L mode', color=truecolor('blue'), charsize=charsize, /normal

if keyword_set(ps) then psclose

;produce histogram of wrad/wtherm
ra=radiated_energy[q]/wthermal_5[q]

histogram_at4, ra, max=1, min=0, binsize=0.05, xtitle='W!lradiated!n/W!lthermal!n', ytitle='Frequency'

if keyword_set(ps) then psopen, filename='rad_ratio_histo.eps'
histogram_at4, ra, max=1, min=0, binsize=0.05, xtitle='W!lradiated!n/W!lthermal!n', ytitle='Frequency'
if keyword_set(ps) then psclose

;stop
;plot 2d histogram
restore, '~/IDL_PRO/black_green_table.sav'
tvlct, r, g,b
hist2, wthermal_5[q]/1e3, radiated_energy[q]/1e3, max1=120, min1=0, max2=120, min2=0, bin1=3, bin2=3, xtitle='W!lthermal!n (kJ)', ytitle='W!lradiated!n (kJ)', /white

if(keyword_set(ps)) then begin
	hist2, wthermal_5[q]/1e3, radiated_energy[q]/1e3, max1=120, min1=0, max2=120, min2=0, bin1=3, bin2=3, xtitle='W!lthermal!n (kJ)', ytitle='W!lradiated!n (kJ)', /white, /ps, filename='rad_therm_hist.eps'
endif

loadct,0


if(keyword_set(ps)) then begin
	!p.font=-1
	!p.charsize=1
endif

stop 

END
