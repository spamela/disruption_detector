PRO figures2, ps=ps

if(ps eq 1) then begin
		plot_ps='y'
	endif else begin
		plot_ps='n'
endelse

cd, '..'

restore, 'disruption_efit_300610_2.sav'

cd, 'figures'

;goto, normalisedCQplot

;TQ analysis
alltq=where(good_tq eq 1)
single=where(good_tq eq 1 and tq_stages eq 1)
two=where(good_tq eq 1 and tq_stages eq 2)
two_incorrecttau12=where(good_tq eq 1 and tq_stages eq 2 or tq_stages eq 2.5)

;histograms for the timescales of the thermal quench
if(ps eq 0) then begin
	window, 0
endif
histogram_at3, tau2[alltq]*1000, binsize=0.2, max=3, min=0, col=col, title=title, xtitle='!7s!3!l2!n', yrange=yrange, plot_ps=plot_ps, filename='TQ_tau2_all.eps'

if(ps eq 0) then begin
	window, 1
endif
histogram_at3, tau12[two]*1000, binsize=1, max=9, min=0, col=col, title=title, xtitle='!7s!3!l1-2!n', yrange=yrange, plot_ps=plot_ps, filename='TQ_tau12_two.eps'

;TQ energy plots
if(ps eq 0) then begin
window, 2
plot, w_disrupt[single]/1e3, tau2[single]*1e3, /nodata, xtitle='W!lTQ!n (kJ)', ytitle='!7s!3!l2!n'
oplot, w_disrupt[single]/1e3, tau2[single]*1e3, psym=6, color=truecolor('red')
oplot, w_disrupt[two]/1e3, tau2[single]*1e3, psym=7, color=truecolor('blue')
legend, ['Single phase TQ', 'Two stage TQ'], psym=[6,7], color=[truecolor('red'), truecolor('blue')], /right
endif

if(ps eq 1) then begin
set_plot, 'ps'
device, filename='tqenergytime.eps', /color, /encapsul
;print, 'Plotting postscript: ', filename
plot, w_disrupt[single]/1e3, tau2[single]*1e3, /nodata, xtitle='W!lTQ!n (kJ)', ytitle='!7s!3!l2!n'
oplot, w_disrupt[single]/1e3, tau2[single]*1e3, psym=6, color=truecolor('red')
oplot, w_disrupt[two]/1e3, tau2[single]*1e3, psym=7, color=truecolor('blue')
legend, ['Single phase TQ', 'Two stage TQ'], psym=[6,7], color=[truecolor('red'), truecolor('blue')], /right
device, /close_file
set_plot, 'x'
endif

;Energy anaylsis

!p.font=1

diff=ttq-hl_trans

all=where(use_tq eq 1 and disruption eq 1)
hmode=where(use_tq eq 1 and hmodeshot eq 1 and disruption eq 1)
lmode=where(use_tq eq 1 and hmodeshot eq 0 and disruption eq 1)

if(ps eq 0) then begin
	window, 3
endif
histogram_at3, w_ratiohl[all], binsize=0.1, max=1, min=0, col=col, title=title, xtitle='W!ldisruption!n/W!lmax!n', yrange=yrange, plot_ps=plot_ps, filename='w_ratio_all.eps'
legend, ['All shots'], /right

if(ps eq 0) then begin
	window, 4
endif
histogram_at3, w_ratiohl[hmode], binsize=0.1, max=1, min=0, col=col, title=title, xtitle='W!ldisruption!n/W!lmax!n', yrange=yrange, plot_ps=plot_ps, filename='w_ratio_hmode.eps'
legend, ['H mode'], /right

if(ps eq 0) then begin
	window, 5
endif

histogram_at3, w_ratiohl[lmode], binsize=0.1, max=1, min=0, col=col, title=title, xtitle='W!ldisruption!n/W!lmax!n', yrange=yrange, plot_ps=plot_ps, filename='w_ratio_lmode.eps'
legend, ['L mode'], /right

;High beta 

alltq2=where(use_tq eq 1 and betat_25 le 10)
beta_25=where(use_tq eq 1 and betat_25 gt 10 and q0_5 gt 1 and q0_5 lt 2 and betat_5 le 10)
beta_5=where(use_tq eq 1 and betat_5 gt 10 and q0_5 gt 1 and q0_5 lt 2)

if(ps eq 0) then begin
window, 7
plot, w_ratiohl[alltq2], betat_5[alltq2], psym=7, yrange=[0,20], xtitle='W!lr!n/W!lmax!n', ytitle='!7b!3!lt!n'
oplot, w_ratiohl[beta_25], betat_5[beta_25], psym=7, color=truecolor('blue')
oplot, w_ratiohl[beta_5], betat_5[beta_5], psym=7, color=truecolor('red')
legend, ['All shot', '!7b!3!lt!n > 10 5ms before TQ', '!7b!3!lt!n > 10 25ms before TQ'], psym=[7,7,7], color=[truecolor('white'), truecolor('blue'), truecolor('red')], /right
endif

if(ps eq 1) then begin
set_plot, 'ps'
device, filename='highbeta_wr.eps', /color, /encapsul
plot, w_ratiohl[alltq2], betat_5[alltq2], psym=7, yrange=[0,20], xtitle='W!lr!n/W!lmax!n', ytitle='!7b!3!lt!n'
oplot, w_ratiohl[beta_25], betat_5[beta_25], psym=7, color=truecolor('blue')
oplot, w_ratiohl[beta_5], betat_5[beta_5], psym=7, color=truecolor('red')
legend, ['All shot', '!7b!3!lt!n > 10 5ms before TQ', '!7b!3!lt!n > 10 25ms before TQ'], psym=[7,7,7], color=[truecolor('black'), truecolor('blue'), truecolor('red')], /right
device , /close_file
set_plot, 'x'
endif

single=where(tq_stages eq 1 and good_tq eq 1)
two=where(tq_stages eq 2 and good_tq eq 1)
highbeta=where(tq_stages eq 1 and betat_5 gt 10 and good_tq eq 1)

if(ps eq 1) then begin
	set_plot, 'ps'
	device, filename='plot.eps', /color, /encapsul
endif else begin
	window, 8
endelse

plot, w_disrupt[single]/1e3, tau2[single]*1000, xrange=[0,150], yrange=[0,4], psym=7
oplot, w_disrupt[two]/1e3, tau2[two]*1000, psym=4, color=truecolor('red')
oplot, w_disrupt[highbeta]/1e3, tau2[highbeta]*1000, psym=5, color=truecolor('blue')

if(ps eq 1) then begin
	set_plot,'ps'
	device, filename='halo_op_space.eps', /color, /encapsul
endif else begin
	window, 9
endelse

;halo current operating space
;plot MAST operating space for halo currents
data=where(disrupting eq 1 and ip_disruption ne 0 and (fhalo*ip_disruption) ne 1 and disruption eq 1)
using=where(use_tq eq 1 and ip_disruption ne 0 and (fhalo*ip_disruption) ne 1 and disruption eq 1)

plot, ip_disruption[data]/1e3, fhalo[data], psym=7, yrange=[0,1], xrange=[0,1.5], /nodata, xtitle = 'I!lp!n(t!lTQ!n) (MA)', ytitle='f!lhalo!n', charsize=1.5
oplot,ip_disruption[data]/1e3, fhalo[data], psym=7
oplot,ip_disruption[using]/1e3, fhalo[using], psym=5, color=truecolor('red')

xvals=findgen(250)
xvals=xvals/249
xvals=xvals*1500
yvals1=250/xvals ;line for halo = 250kA
yvals2=150/xvals ;line for halo = 150kA
yvals3=200/xvals ;line for halo = 200kA

oplot, xvals/1e3, yvals1, linestyle=2
oplot, xvals/1e3, yvals2, linestyle=1
oplot, xvals/1e3, yvals3, linestyle=4

legend, ['I!lhalo!n = 0.15MA', 'I!lhalo!n = 0.2MA',' I!lhalo!n = 0.25MA'], linestyle=[1,4,2], position=[1, 0.95]

if(ps eq 1) then begin
	device, /close_file
	set_plot,'x'
endif

;plot duration of CQ vs. maxium size of halos (can be found using max_halo=ip_disruption*fhalo)
if(ps eq 1) then begin
	set_plot,'ps'
	device, filename='cqtime_halosize.eps', /color, /encapsul
endif else begin
	window, 10
endelse


plot, cq_time[data], (ip_disruption[data]*fhalo[data]), psym=7, xrange=[0,0.02]

if(ps eq 1) then begin
	device, /close_file
	set_plot,'x'
endif else begin
	window, 11
endelse

if(ps eq 1) then begin
	set_plot,'ps'
	device, filename='cqrate_halosize.eps', /color, /encapsul
endif

plot, cq_rate[data]/1e3, (ip_disruption[data]*fhalo[data]), psym=7, xrange=[0,1e3]

if(ps eq 1) then begin
	device, /close_file
	set_plot,'x'
endif

;cq rate and timescale histograms for selected

using=where(use_hl eq 1 and disruption eq 1)
disrupt=where(disrupting eq 1 and ip_disruption gt 0 and disruption eq 1)
using_g10000=where(shots ge 10000 and disruption eq 1 and use_hl eq 1 and zmagnetic ge -0.003)
using_l10000=where(shots lt 10000 and disruption eq 1 and use_hl eq 1 and zmagnetic ge -0.003)
lsndischarges=where(disruption eq 1 and use_hl eq 1 and zmagnetic lt -0.003)

histogram_at3, cq_time[disrupt]*1000, binsize=0.2, max=5, min=0, col=col, title=title, xtitle='CQ time (ms)', plot_ps=plot_ps, filename='CQ_time_all.eps'
histogram_at3, cq_time[using]*1000, binsize=0.3, max=5, min=0, col=col, title=title, xtitle='CQ time (ms)', plot_ps=plot_ps, filename='CQ_time.eps'
histogram_at3, cq_rate[using]/1000, binsize=50, max=1000, min=0, col=col, title=title, xtitle='CQ rate (MA/s)', plot_ps=plot_ps, filename='CQ_rate.eps'

;plot histogram for CQ time of all shots >10000 and all <10000 and those where the discharge are LSN
histogram_at3, cq_time[using_g10000]*1000, binsize=0.3, max=5, min=0, col=col, title=title, xtitle='CQ time (ms)', plot_ps=plot_ps, filename='CQ_time_gt10000.eps', norm=796, yrange=[0,0.2]
histogram_at3, cq_time[using_l10000]*1000, binsize=0.3, max=5, min=0, col=truecolor('red'), title=title, xtitle='CQ time (ms)', plot_ps=plot_ps, filename='CQ_time_lt10000.eps', norm=796, yrange=[0,0.2]
histogram_at3, cq_time[lsndischarges]*1000, binsize=0.3, max=5, min=0, col=truecolor('green'), title=title, xtitle='CQ time (ms)', plot_ps=plot_ps, filename='CQ_time_lsn.eps', norm=796, yrange=[0,0.2]

if(ps eq 1) then begin
	set_plot,'ps'
	device, filename='ipvscqtime.eps', /encapsul
endif

plot, ip_disruption[disrupt]/1e3, cq_time[disrupt]*1000, psym=7,symsize=0.5, yrange=[0,6], xtitle='I!lp_disruption!n (MA)', ytitle='CQ time (ms)'

if(ps eq 1) then begin
	device, /close_file
	set_plot,'x'
endif

if(ps eq 1) then begin
	set_plot,'ps'
	device, filename='ipvscqtime_use.eps', /encapsul
endif

plot, ip_disruption[using]/1e3, cq_time[using]*1000, psym=7,symsize=0.5, yrange=[0,4], xtitle='I!lp_disruption!n (MA)', ytitle='CQ time (ms)'
up=where(use_hl eq 1 and vde_direction eq 1)
down=where(use_hl eq 1 and vde_direction eq -1)
oplot, ip_disruption[up]/1e3, cq_time[up]*1000, psym=7,symsize=0.5, color=truecolor('red')
oplot, ip_disruption[down]/1e3, cq_time[down]*1000, psym=7,symsize=0.5, color=truecolor('blue')
legend, ['upward VDE', 'downward VDE'], psym=[7,7], symsize=[0.5,0.5], color=[truecolor('red'), truecolor('blue')]

if(ps eq 1) then begin
	device, /close_file
	set_plot,'x'
endif

;disruptions as a percentage of MAST shots over time
;from disruptivity.pro

; cd, '~athorn/disrupt_db/NEW'
; 
; if(ps eq 0) then begin
; window, 6
; disruptivity, 4000, 19000, 1000
; endif
; 
; if(ps eq 1) then begin
; set_plot, 'ps'
; device, filename='mast_disruptivity.eps', /color, /encapsul
; ;print, 'Plotting postscript: ', filename
; disruptivity, 4000, 19000, 1000 
; device, /close_file
; set_plot, 'x'
; endif

;normalisedCQplot:

cd, '~athorn/disrupt_db/ITPA_SL/FIGURES'

t60overS=make_array(n_elements(shots))
ipoverS=make_array(n_elements(shots))
usinghl=where(use_hl eq 1 and disruption eq 1)
disrupt=where(disrupting eq 1 and disruption eq 1)

if(ps eq 1) then begin
	set_plot,'ps'
	device, filename='normalisedCQ.eps', /color, /encapsul
endif

for i=0, n_elements(shots)-1 do begin
	t60overS[i]=((cq_time[i]*1*1000)/(elongation_25[i]*minorradius_25[i]*minorradius_25[i]*!pi))
	ipoverS[i]=ip_disruption[i]/(elongation_25[i]*minorradius_25[i]*minorradius_25[i]*!pi)
	
endfor

!p.charsize=1.5
plot, ipoverS[disrupt]/1e3, t60overS[disrupt], psym=4, /xlog, /ylog, yrange=[0.1,100], xrange=[0.1, 2], ytitle='t!lCQ60%!n/S (ms/m!u2!n)', xtitle='I!lp_disruption!n/S (MA/m!u2!n)', symsize=0.5
oplot, ipoverS[usinghl]/1e3, t60overS[usinghl], psym=7, color=truecolor('red')
oplot, [0.1,10], [1.67,1.67], color=truecolor('green'), linestyle=3, thick=2
legend, ['Ramp down disruptions', 'Full performace disruption'], psym=[4,7], colors=[truecolor('black'), truecolor('red')], /right
xyouts, 0.78,0.48,'1.67 ms/m!u2!n limit', charsize =1.2, /normal
!p.charsize=0

if(ps eq 1) then begin
	device, /close_file
	set_plot, 'x'
endif

;plot showing VDE direction and CQ time
s=where(vde_direction eq -1 and use_tq eq 1 and disruption eq 1)
t=where(vde_direction eq 1 and use_tq eq 1 and disruption eq 1)
useshots=where(use_tq eq 1 and disruption eq 1)

if(ps eq 1) then begin
	set_plot,'ps'
	device, filename='vde_zmag.eps', /color
endif

plot, zmagaxis[useshots], cq_time[useshots]*1000, psym=7, yrange=[0,4], xtitle='Magnetic axis Z position (m)', ytitle='CQ time (ms)', ys=1, /nodata
oplot, zmagaxis[t], cq_time[t]*1000, psym=7, color=truecolor('blue')
oplot, zmagaxis[s], cq_time[s]*1000, psym=7, color=truecolor('red')
legend, ['Upward VDEs', 'Downward VDE'], psym=[7,7], color=[truecolor('blue'), truecolor('red')]

if(ps eq 1) then begin
	device, /close_file
	set_plot, 'x'
endif

if(ps eq 1) then begin
	set_plot, 'ps'
	device, filename='cq_fitting.eps', /color, /encapsul
endif

r=where(use_tq eq 1 and RMSE_exp gt RMSE_lin and disruption eq 1)
s=where(use_tq eq 1 and RMSE_exp lt RMSE_lin and disruption eq 1)

plot, ip_disruption[useshots]/1000, cq_time[useshots]*1000, psym=7, yrange=[0,4], /nodata, xtitle='I!lp_disruption!n (MA)', ytitle='CQ time (ms)'
oplot, ip_disruption[s]/1000, cq_time[s]*1000, psym=7, color=truecolor('blue')
oplot, ip_disruption[r]/1000, cq_time[r]*1000, psym=5, color=truecolor('red')

legend, ['Exponential fit', 'Linear fit'], psym=[7,5], color=[truecolor('blue'), truecolor('red')]

if(ps eq 1) then begin
	device, /close_file
	set_plot, 'x'
endif

;CQ plot showing the splitting based on the change of divertor plus other things...

if(ps eq 1) then begin
	set_plot, 'ps'
   print, 'plotting'
	device, filename='CQ_time_fullenergy_shotnumber.eps', /encapsul, /color
endif

!p.font=1
!p.charsize=1.75

a=where(use_hl eq 1 and disruption eq 1 and zmagaxis lt -0.05)
b=where(use_hl eq 1 and disruption eq 1 and zmagaxis ge -0.003 and zmagaxis lt 0.003)
c=where(use_hl eq 1 and disruption eq 1 and zmagaxis gt 0.003)

e=where(shots ge 10000 and use_hl eq 1 and disruption eq 1)
f=where(shots lt 10000 and use_hl eq 1 and disruption eq 1)

plot, ip_disruption, cq_time*1000, yrange=[0,4], /nodata, xrange=[0,1500], xtitle='Plasma current (kA)', ytitle='CQ time (ms)'
oplot, ip_disruption[e], cq_time[e]*1000, color=truecolor('red'), psym=7
oplot, ip_disruption[f], cq_time[f]*1000, color=truecolor('blue'), psym=7
oplot, ip_disruption[a], cq_time[a]*1000, color=truecolor('green'), psym=7

legend, ['> #10000', '< #10000', 'LSN all shots'], psym=[7,7,7], color=[truecolor('red'), truecolor('blue'), truecolor('green')]

!p.font=0
!p.charsize=1

if(ps eq 1) then begin
	device, /close_file
	set_plot, 'x'
endif

if(ps eq 1) then begin
	set_plot, 'ps'
	device, filename='CQ_time_elongation.eps', /encapsul, /color
endif

!p.font=1
!p.charsize=1.75

plot, elongation_5, cq_time*1000, yrange=[0,4], /nodata, xrange=[1,2.5], xtitle='Elongation', ytitle='CQ time (ms)', font=1, charsize=1.75
oplot, elongation_5[e], cq_time[e]*1000, color=truecolor('red'), psym=7
oplot, elongation_5[f], cq_time[f]*1000, color=truecolor('blue'), psym=7
oplot, elongation_5[a], cq_time[a]*1000, color=truecolor('green'), psym=7
legend, ['> #10000', '< #10000', 'LSN all shots'], psym=[7,7,7], color=[truecolor('red'), truecolor('blue'), truecolor('green')], charsize=1.5

if(ps eq 1) then begin
	device, /close_file
	set_plot, 'x'
endif

;hugill diagram and operating space histogram plots

!p.font=1
!p.charsize=1.5

mean_density_5=density_5/(8*minorradius_5)

q=where(disruption eq 1 and radius_5 gt 0 and mean_density_5 gt 0 and w_disrupt gt 0)

xvals=((mean_density_5*radius_5)/(abs(btoroidal_5)))/1e19
yvals=1/qa_5

if(ps eq 1) then begin
	hist2, xvals[q], yvals[q], max1=15, min1=0, max2=0.3, min2=0, bin1=.5, bin2=0.01, /whitebckg, /atps, filename='hugill_allgoodshots_small.eps', xtitle='nR/B!lphi!n (10!u-19!n m!u-2!n T!u-1!n)', ytitle='1/q!la!n'
endif else begin
	hist2, xvals[q], yvals[q], max1=15, min1=0, max2=0.3, min2=0, bin1=.5, bin2=0.01, filename='hugill_allgoodshots_small.eps', xtitle='nR/B!lphi!n (10!u-19!n m!u-2!n T!u-1!n)', ytitle='1/q!la!n'
endelse

q=where(use_hl eq 1 and disruption eq 1)
if(ps eq 1) then begin
	hist2, w_ratiohl[q], betat_5[q], max1=1, min1=0, max2=15, min2=0, bin1=0.075, bin2=1, /whitebckg, /atps, filename='2dhist_wr_betat.eps', xtitle='W!lr!n', ytitle='Toroidal beta'
endif else begin
	hist2, w_ratiohl[q], betat_5[q], max1=1, min1=0, max2=15, min2=0, bin1=0.075, bin2=1, xtitle='W!lr!n', ytitle='Toroidal beta'
endelse

if(ps eq 1) then begin
	hist2, w_ratiohl[q], betan_5[q], max1=1, min1=0, max2=5, min2=0, bin1=.075, bin2=0.5, /whitebckg, /atps, filename='2dhist_wr_betan.eps', xtitle='W!lr!n', ytitle='Normalised beta'
endif else begin
	hist2, w_ratiohl[q], betan_5[q], max1=1, min1=0, max2=5, min2=0, bin1=.075, bin2=0.5, xtitle='W!lr!n', ytitle='Normalised beta'
endelse

if(ps eq 1) then begin
	hist2, w_ratiohl[q], w_maximum[q]/1000, max1=1, min1=0, max2=160, min2=0, bin1=.075, bin2=10, /whitebckg, /atps, filename='2dhist_wr_wmax.eps', xtitle='W!lr!n', ytitle='W!lmaximum!n (kJ)'
endif else begin
	hist2, w_ratiohl[q], w_maximum[q], max1=1, min1=0, max2=160, min2=0, bin1=.075, bin2=10, xtitle='W!lr!n', ytitle='W!lmaximum!n (kJ)'
endelse

!p.font=-1

END
