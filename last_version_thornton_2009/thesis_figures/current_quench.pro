PRO current_quench, ps=ps

if(keyword_set(ps) eq 1) then begin
	!p.font=1
	!p.charsize=1.5
	plot_ps=1
	psopen, filename='cq_timescales.eps'
endif else begin
	plot_ps=0
endelse

restore, '~athorn/disrupt_db/END_JUNE09/disruption_efit_230610.sav'

;this variable is missing from the END_JUNE09 files - sub for zmagaxis (may be unwise - need to check)
zmagnetic=zmagaxis

;identify all shots to use in the database
;use all shots which have full energy disruptions = use

all=where(use eq 1)

histogram_at4, cq_time[all]*1000, binsize=0.1, max=4, min=0, title=title, xtitle='Current quench time (ms)', ytitle='Frequency'

if keyword_set(ps) then psclose

;plot the histograms for the LSN <10k >10k plot here. Need to normalised these so they can be overplotted.

using_g10000=where(shots ge 10000 and use eq 1 and zmagnetic ge -0.003)
using_l10000=where(shots lt 10000 and use eq 1 and zmagnetic ge -0.003)
lsndischarges=where(use eq 1 and zmagnetic lt -0.003)

if keyword_set(ps) then psopen, filename='cq_time_g10000.eps'
histogram_at4, cq_time[using_g10000]*1000, binsize=0.1, max=4, min=0, col=col, xtitle='CQ time (ms)', /normal, norm_val=1232, yrange=[0,0.1]
if keyword_set(ps) then psclose

if keyword_set(ps) then psopen, filename='cq_time_l10000.eps'
histogram_at4, cq_time[using_l10000]*1000, binsize=0.1, max=4, min=0, col=truecolor('red'), xtitle='CQ time (ms)', /normal, norm_val=1232, yrange=[0,0.1]
if keyword_set(ps) then psclose

if keyword_set(ps) then psopen, filename='cq_time_lsn.eps'
histogram_at4, cq_time[lsndischarges]*1000, binsize=0.1, max=4, min=0, col=truecolor('green'), xtitle='CQ time (ms)', /normal, norm_val=1232, yrange=[0,0.1]
if keyword_set(ps) then psclose




stop




if(keyword_set(ps) eq 1) then begin
	!p.font=1
	!p.charsize=1.5
endif



END
