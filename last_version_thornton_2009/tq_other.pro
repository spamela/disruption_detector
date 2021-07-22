PRO tq, shot

;find the time of the TQ by using the SXR data

;restore, 'disruption_efit_9.sav'
;restore, 'disruption_efit_ITPA_flattop.sav'
restore, 'disruption_efit_0709_12a.sav'

q=where(shots eq shot)

ttq_time=ttq[q]
print, 'T(tq): ', ttq_time

sxr=getdata('xsx_hcaml#1', shot, /noecho)

;smoothsxr=wv_denoise(sxr.data, 'symlet', 2, coefficients=100)
smoothsxr=smooth(sxr.data, 5)

!p.multi=[0,2]

;stop

twindow=0.002
twindow2=0.008

;find the TQ in the SXR emission, ideally the last quench will be found if the disruption has two phases
;to do this use a window around the TTQ time found by using the current trace

derivsxr=deriv(sxr.time, smoothsxr)
;smoothsxrderiv=wv_denoise(sxr.data, 'symlet', 2, coefficients=100)
windowtime=where(sxr.time ge (ttq_time[0]-twindow) and sxr.time le (ttq_time[0]+twindow))
windowtimebig=where(sxr.time ge (ttq_time[0]-twindow2) and sxr.time le (ttq_time[0]-twindow))
;more, windowtime
max_sxrderiv=max(abs(derivsxr[windowtime]))
;print, max_sxrderiv
max_sxrpoint=where(abs(derivsxr[windowtime]) eq max_sxrderiv)
;print, max_sxrpoint
max_dsxrtime=sxr.time[(windowtime[0]-1)+max_sxrpoint[0]]
;print, max_dsxrtime

;find points around the maxium value of the gradient and fit a line through these points

fitslope_start=max_dsxrtime-0.0002
fitslope_end=max_dsxrtime+0.0002

;fitarraytime=[sxr.time[windowtime[0]+max_sxrpoint[0]-1],sxr.time[windowtime[0]+max_sxrpoint[0]],sxr.time[windowtime[0]+max_sxrpoint[0]+1],sxr.time[windowtime[0]+max_sxrpoint[0]+2],sxr.time[windowtime[0]+max_sxrpoint[0]+3]]
;fitarraydata=[sxr.data[windowtime[0]+max_sxrpoint[0]-1],sxr.data[windowtime[0]+max_sxrpoint[0]],sxr.data[windowtime[0]+max_sxrpoint[0]+1],sxr.data[windowtime[0]+max_sxrpoint[0]+2],sxr.data[windowtime[0]+max_sxrpoint[0]+3]]

windowtimeslope=where(sxr.time ge fitslope_start and sxr.time le fitslope_end)
fitslopetime=sxr.time[windowtimeslope]
fitslopedata=sxr.data[windowtimeslope]

linearfit=linfit(fitslopetime, fitslopedata)
fitteddata=linearfit[0]+(sxr.time*(linearfit[1]))

;fit a line across the flat region to find an intercept with the TQ fit, then use the intercept as the maximum value of the SXR emission

fitflattop_timestart=max_dsxrtime-0.0020
fitflattop_timeend=max_dsxrtime-0.0010

windowtime2=where(sxr.time ge fitflattop_timestart and sxr.time le fitflattop_timeend)
fittime=sxr.time[windowtime2]
fitdata=smoothsxr[windowtime2]

linearfit2=ladfit(fittime, fitdata)
fitteddata2=linearfit2[0]+(sxr.time*(linearfit2[1]))

;find the intercept of the two lines to find the maximum SXR emission
incpt_time=(linearfit2[0]-linearfit[0])/(linearfit[1]-linearfit2[1])

;print, incpt_time
sxr_valfind=where(sxr.time ge incpt_time)
incpt_sxr=smoothsxr[sxr_valfind[0]] ;take this to be the maximum SXR emission

;find the time between SXR emission being 90% of incpt_sxr and 20% of incpt_sxr
;print, incpt_sxr
minsxr=0.2*incpt_sxr
maxsxr=0.9*incpt_sxr

findmin=where(smoothsxr[windowtime] le minsxr)
;findmax=where(smoothsxr[windowtime] le maxsxr)

;athorn mod 12/12/08 - ammend the maximum point so that the point is found by working backwards from the maximum gradient time until the value of the smoothed sxr trace is equal to or greater than maxsxr
index=0L
sxr_90pc_position=0

while (sxr_90pc_position lt maxsxr) do begin
	findmax_dsrtimepoint=where(sxr.time eq max_dsxrtime)
	sxr_90pc_position=smoothsxr[((findmax_dsrtimepoint[0])-index)]
	;print, findmax_dsrtimepoint[0]-index
	index=index+1
endwhile
;end athorn mod 12/12/08

;athorn mod 02/07/09
if(n_elements(findmax_dsrtimepoint) eq 0) then begin
    print, 'Problems'
    goto, endofprogram
endif
;athorn mod ends 02/07/09

sxr_90pc=sxr.time[findmax_dsrtimepoint[0]-index] ;athorn mod 12/12/08, changed from windowtime[0]-1+findmax[0] to findmax_dsrtimepoint, end athorn mod 12/12/08
sxr_20pc=sxr.time[(windowtime[0]-1)+findmin[0]]

TQ_time=sxr_20pc[0]-sxr_90pc[0]

print, 'TQ_time: ', tq_time

print, 'Minor rad: ', minorradius_5[q]
print, 'W_TQ: ', w_disrupt[q] 

;find out if the TQ is single step of two step

maxwindowbig=max(smoothsxr[windowtimebig])
maxbigfind=where(smoothsxr[windowtimebig] eq maxwindowbig)
timesxrmax_2=sxr.time[windowtimebig[maxbigfind[0]]]
peak_5mswindow=maxwindowbig

;print, 'Second peak time: ', timesxrmax_2
;print, 'Max second peak:  ', peak_5mswindow
 
;compare the maximum of the bigger window with the maximum of the smaller window.
;Shots with the maximum in the big window significantly larger (say 30% larger) than in the smaller window
;will have a two stage TQ.

if(peak_5mswindow gt incpt_sxr*1.6) then begin
	print, 'Two stage TQ'
	maxderivwindow2=where(abs(derivsxr[windowtimebig]) ge 50)
	if(maxderivwindow2[0] eq -1) then begin
		print, 'Problem'
		goto,here
	endif
	timederiv=sxr.time[windowtimebig[maxderivwindow2[0]]]
	timesxrmax_2=timederiv
	valuesxr100=smoothsxr[windowtimebig[maxderivwindow2[0]]]
	max_sxrone=0.9*valuesxr100
	find90=where(smoothsxr ge max_sxrone and sxr.time ge timesxrmax_2)
	time90one=sxr.time[find90[0]]
	data90one=smoothsxr[find90[0]]
	here:
	endif else begin
		print, 'Single stage TQ'
		time90one=0
		data90one=0
  endelse

;athorn mods 02/07/09
if(n_elements(time90one) eq 0) then begin
    print, 'Yet more problems
    goto, endofprogram
endif
;athorn mods end 02/07/09

;plot things to check the calculations

plot, sxr.time, sxr.data, xrange=[ttq_time-0.008, ttq_time+0.005], title=shot
oplot, sxr.time, smoothsxr, color=truecolor('red')
oplot, [ttq_time, ttq_time], !y.crange, color=truecolor('blue')
oplot, [max_dsxrtime, max_dsxrtime], [sxr.data[(windowtime[0]-1)+max_sxrpoint[0]], sxr.data[(windowtime[0]-1)+max_sxrpoint[0]]], psym=7, color=truecolor('limegreen')
oplot, fitslopetime, fitslopedata, color=truecolor('gold')
oplot, sxr.time, fitteddata, color=truecolor('orange')
oplot, sxr.time, fitteddata2, color=truecolor('cyan')
oplot, [incpt_time, incpt_time], [incpt_sxr, incpt_sxr], psym=7, symsize=2
oplot, [sxr_90pc, sxr_90pc], [smoothsxr[findmax_dsrtimepoint[0]-index], smoothsxr[findmax_dsrtimepoint[0]]-index], psym=7, color=truecolor('cyan')
oplot, [sxr_20pc, sxr_20pc], [minsxr, minsxr], psym=7, color=truecolor('cyan')
oplot, [timesxrmax_2, timesxrmax_2], [maxwindowbig, maxwindowbig], psym=7, color=truecolor('gold')
oplot, [time90one,time90one], [data90one,data90one], color=truecolor('limegreen'), psym=7, symsize=2

plot, sxr.time, derivsxr, xrange=[ttq_time-0.005, ttq_time+0.005], yrange=[min(derivsxr), max(derivsxr)]
;oplot, sxr.time, derivsxr, color=truecolor('red')
oplot, [ttq_time, ttq_time], !y.crange, color=truecolor('blue')
oplot, [ttq_time[0]-twindow, ttq_time[0]-twindow], !y.crange, color=truecolor('gold')
oplot, [ttq_time[0]+twindow, ttq_time[0]+twindow], !y.crange, color=truecolor('gold')
oplot, [max_dsxrtime, max_dsxrtime], [max_sxrderiv, max_sxrderiv], psym=7, color=truecolor('limegreen')

!p.multi=0

endofprogram:

;stop

END
