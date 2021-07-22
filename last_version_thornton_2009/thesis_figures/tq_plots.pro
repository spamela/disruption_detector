PRO tq_plots, ps=ps

;restore the database
restore, '~athorn/disrupt_db/END_JUNE09/disruption_efit_080710.sav'

;set the ps device
if(keyword_set(ps) eq 1) then begin
	!p.font=1
	!p.charsize=3.5
endif

;plot the wr ratios for Ip and SXR
if not keyword_set(ps) then window, 0
if keyword_set(ps) then psopen, filename='wr_ip_hist_all.eps'
	q=where(use_hl eq 1 and hmodeshot ne 0.5 and w_ratio_interp ge 0)
	histogram_at4, w_ratio_interp[q], max=1, min=0, binsize=0.05, xtitle='W!lr!n', ytitle='Normalised frequency', /normal, yrange=[0,0.14]
	xyouts, 0.56,0.86, 'Full performance disruptions', /normal
	xyouts, 0.84, 0.82, '('+strtrim(string(fix(n_elements(q))),2)+')', /normal
	print, 'Avg Wr: ', mean(w_ratio_interp[q]), 'Skew: ', skewness(w_ratio_interp[q]), 'Kurtosis: ', kurtosis(w_ratio_interp[q]), 'sigma: ', stdev(w_ratio_interp[q])


if keyword_set(ps) then psclose

if not keyword_set(ps) then window, 1
if keyword_set(ps) then psopen, filename='wr_ip_hist_hmode.eps'
	q=where(use_hl eq 1 and hmodeshot eq 1 and w_ratio_interp ge 0)
	histogram_at4, w_ratio_interp[q], max=1, min=0, binsize=0.05, xtitle='W!lr!n', ytitle='Normalised frequency', /normal, yrange=[0,0.14], col='royalblue'
	;xyouts, 0.68,0.86, 'H mode disruptions', /normal
	;xyouts, 0.86, 0.82, '('+strtrim(string(fix(n_elements(q))),2)+')', /normal
	print, 'H mode avg Wr: ', 'Skew: ', mean(w_ratio_interp[q]),skewness(w_ratio_interp[q]), 'Kurtosis: ', kurtosis(w_ratio_interp[q]), 'sigma: ', stdev(w_ratio_interp[q])


if keyword_set(ps) then psclose

if not keyword_set(ps) then window, 2
if keyword_set(ps) then psopen, filename='wr_ip_hist_lmode.eps'
	q=where(use_hl eq 1 and hmodeshot eq 0 and w_ratio_interp ge 0)
	histogram_at4, w_ratio_interp[q], max=1, min=0, binsize=0.05, xtitle='W!lr!n', ytitle='Normalised frequency', /normal, yrange=[0,0.14], col='royalblue'
	;xyouts, 0.68,0.86, 'L mode disruptions', /normal
	;xyouts, 0.84, 0.82, '('+strtrim(string(fix(n_elements(q))),2)+')', /normal
	print, 'L mode avg Wr: ', 'Skew: ', mean(w_ratio_interp[q]), skewness(w_ratio_interp[q]), 'Kurtosis: ', kurtosis(w_ratio_interp[q]), 'sigma: ', stdev(w_ratio_interp[q])


if keyword_set(ps) then psclose
;2d histograms
;possibly....

!p.charsize=2.5

;TQ timescales
if not keyword_set(ps) then window,3
if keyword_set(ps) then psopen, filename='tau_2_hist.eps'
	r=where(good_tq eq 1 and tq_stages gt 0.5)
	histogram_at4, tau2[r]*1000, max=2.5, min=0, binsize=0.05, xtitle='TQ fast timescale (ms)', ytitle='Frequency', /normal
	hist=(histogram(tau2[r]*1000, max=2.5, min=0, binsize=0.05, locations=locations))
	;hist=hist/total(hist)
	;xvals=locations+(0.05/2.0)
	;yerr=sqrt(hist*1.0)
	;zero=where(yerr eq 0) 
	;yerr[zero]=0.0001
	;start=[1]
	;result=mpfitfun('poisson', xvals, hist, yerr, start)
	;x_for_fit=(findgen(1000)/1000.)*2.5
	;oplot, xvals, poisson(xvals,result), color=truecolor('red')
	
if keyword_set(ps) then psclose

;CHECK tau2 time for </> 10000 varaition

;	a=where(good_tq eq 1 and tq_stages gt 0.5 and shots le 10000)
;	b=where(good_tq eq 1 and tq_stages gt 0.5 and shots gt 10000)

;	if not keyword_set(ps) then window, 3
;	if keyword_set(ps) then psopen, filename='tau2_hist_l10000.eps'

;	histogram_at4, tau2[a]*1000, max=2.5, min=0, binsize=0.1, xtitle='TQ fast timescale (ms)', ytitle='Frequency', title='Shots < 10000'
	
;	if keyword_set(ps) then psclose
;	if not keyword_set(ps) then window, 4
;	if keyword_set(ps) then psopen, filename='tau2_hist_g10000.eps'
		
;	histogram_at4, tau2[b]*1000, max=2.5, min=0, binsize=0.1, xtitle='TQ fast timescale (ms)', ytitle='Frequency', title='Shots > 10000'

;	if keyword_set(ps) then psclose
;END CHECK

;plot the 2d hist of the hugill diagram w/o disruptivity
;code copied from ~disrupt_db/ITPA_SL/figures2.pro

mean_density_5=density_5/(8*minorradius_5)

q=where(disruption eq 1 and radius_5 gt 0 and mean_density_5 gt 0 and w_disrupt gt 0)

xvals=((mean_density_5*radius_5)/(abs(btoroidal_5)))/1e19
yvals=1/qa_5

restore, '~/IDL_PRO/black_green_table.sav'
tvlct, r,g,b

if(keyword_set(ps) eq 1) then begin
	hist2, xvals[q], yvals[q], max1=15, min1=0, max2=0.3, min2=0, bin1=.5, bin2=0.01, /whitebckg, /atps, filename='hugill_allgoodshots_small.eps', xtitle='nR/B!lphi!n (10!u-19!n m!u-2!n T!u-1!n)', ytitle='1/q!la!n'
endif else begin
	window, 7
	hist2, xvals[q], yvals[q], max1=15, min1=0, max2=0.3, min2=0, bin1=.5, bin2=0.01, filename='hugill_allgoodshots_small.eps', xtitle='nR/B!lphi!n (10!u-19!n m!u-2!n T!u-1!n)', ytitle='1/q!la!n'
endelse

loadct,0, /silent



;unset the ps device
if(keyword_set(ps) eq 1) then begin
	!p.font=-1
	!p.charsize=0.
endif

stop

END

;FUNCTION poisson, x, p
;	y=((p[0]^x)*exp(-p[0]))/factorial(x)
;	return, y
;END
	
