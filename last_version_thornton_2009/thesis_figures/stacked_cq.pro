PRO stacked_cq, ps=ps

;make a stacked bar chart for the current quench times

if(keyword_set(ps) eq 1) then begin
	!p.font=1
	!p.charsize=2.5
	psopen, filename='cq_stacked.eps'
endif

restore, '~athorn/disrupt_db/END_JUNE09/disruption_efit_300610_2.sav'

;if(exists(use_260610) eq 0) then begin
;	;need to correct the NBI cease variable - it omits ohmic discharges
;	nbi_good_a=where(nbi_disruption lt 0.5)
;	nbi_good_b=where(nbi_cease ge ttq)
;	good_nbi=make_array(n_elements(nbi_cease))
;	good_nbi[nbi_good_a]=1
;	good_nbi[nbi_good_b]=1
;	good=where(disruption eq 1 and good_nbi eq 1 and ip_flattop_yn eq 1 and isol_constant eq 1)
;	use_260610=make_array(n_elements(shots))
;	use_260610[good]=1
;endif

zmagnetic=zmagaxis

using_g10000=where(shots ge 10000 and use_280610 eq 1)
using_l10000=where(shots lt 10000 and use_280610 eq 1)
lsndischarges=where(use_280610 eq 1 and zmagnetic lt -0.003)
usndischarges=where(use_280610 eq 1 and zmagnetic gt 0.003)

all=where(use_280610)

binsize_=0.1
max_=4
min_=0
;norm_val=max(hist_all)*1.0
yrange=[0,200]
xtitle='Current quench time (ms)'
ytitle='Frequency'
col=truecolor('royalblue')

max=max_+binsize_
min=min_-binsize_

hist=histogram(cq_time[using_g10000]*1000, max=max_, min=min_, binsize=binsize_, location=labels)
hist2=histogram(cq_time[using_l10000]*1000, max=max_, min=min_, binsize=binsize_,location=labels2)
hist3=histogram(cq_time[lsndischarges]*1000, max=max_, min=min_, binsize=binsize_, location=labels3)
hist4=histogram(cq_time[usndischarges]*1000, max=max_, min=min_, binsize=binsize_, location=labels4)
hist_all=histogram(cq_time[all]*1000, max=max_, min=min_, binsize=binsize_, location=labs)

;normalise, or not - that is the question. If so do it here.
hist=hist
hist2=hist2
hist3=hist3
hist4=hist4

;make the baselines
;zero2=where(hist2 ne 0)
;second=hist2
;third=hist3
;for i=0, n_elements(zero2)-1 do begin
;	second[zero2[i]]=(hist[zero2[i]]+hist2[zero2[i]])
;endfor

;zero3=where(hist3 ne 0)
;for i=0, n_elements(zero3)-1 do begin
;	third[zero3[i]]=(second[zero3[i]]+hist2[zero3[i]])
;endfor

;second=second/norm_val
;third=third/norm_val

labels=labels+(binsize_*0.5)

plot, labels, hist+hist2+hist3, psym=10, xstyle=1, xrange=[min_+binsize_,max_-binsize_],ytitle=ytitle, xtitle=xtitle, /nodata, xticklen=0.000001, yrange=yrange

n_colors=n_elements(labels)

color=make_array(n_colors)
for i=0, n_colors-1 do begin
    color[i]=truecolor('royalblue')
endfor

n_hist=n_elements(hist)

;bar_plot, hist, /over, color=color, barspace=0.0001, baserange=1, barwidth=1, /outline, baroffset=1
bar_plot, (hist[1:(n_hist-3)]), /over, color=color, barspace=0.0001, baserange=1, barwidth=1, /outline

color=make_array(n_colors)
for i=0, n_colors-1 do begin
    color[i]=truecolor('firebrick')
endfor

;hist2=hist+hist2
n_hist=n_elements(hist2)

;stop

;bar_plot, hist2, /over, color=color, barspace=0.0001, baserange=1, barwidth=1, /outline, baselines=hist
bar_plot, (hist2[1:(n_hist-3)]+hist[1:(n_hist-3)]), /over, color=color, barspace=0.0001, baserange=1, barwidth=1, /outline, baselines=hist[1:(n_hist-3)]

color=make_array(n_colors)
for i=0, n_colors-1 do begin
    color[i]=truecolor('firebrick')
endfor

;hist3=hist+hist2+hist3
n_hist=n_elements(hist3)
;stop

;bar_plot, (hist3[1:(n_hist-3)]+hist2[1:(n_hist-3)]+hist[1:(n_hist-3)]), /over, color=color, barspace=0.0001, baserange=1, barwidth=1, /outline, baselines=(hist[1:(n_hist-3)]+hist2[1:(n_hist-3)])

color=make_array(n_colors)
for i=0, n_colors-1 do begin
    color[i]=truecolor('gold')
endfor

n_hist=n_elements(hist4)

;bar_plot, (hist4[1:(n_hist-3)]+hist3[1:(n_hist-3)]+hist2[1:(n_hist-3)]+hist[1:(n_hist-3)]), /over, color=color, barspace=0.0001, baserange=1, barwidth=1, /outline, baselines=(hist[1:(n_hist-3)]+hist2[1:(n_hist-3)]+hist3[1:(n_hist-3)])


;xyouts, 0.75, 0.85, 'LSN discharges', /normal, color=truecolor('red'), charsize=1.5
xyouts, 0.72, 0.85, '< MAST#10000', /normal, color=truecolor('firebrick'), charsize=2.5
xyouts, 0.72, 0.80, '> MAST#10000', /normal, color=truecolor('royalblue'), charsize=2.5

;stop
if(keyword_set(ps) eq 1) then begin
	psclose
	!p.font=-1
	!p.charsize=1.0
endif
	
stop
END

