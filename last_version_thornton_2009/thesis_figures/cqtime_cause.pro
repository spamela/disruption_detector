PRO cqtime_cause, ps=ps

restore, '~/disrupt_db/END_JUNE09/disruption_efit_240610.sav'

if(keyword_set(ps)) then begin
	!p.font=1
	!p.charsize=1.5
endif

all=where(use eq 1)
zmagnetic=zmagaxis

using_g10000=where(shots ge 10000 and use eq 1 and zmagnetic ge -0.003)
using_l10000=where(shots lt 10000 and use eq 1 and zmagnetic ge -0.003)
lsndischarges=where(use eq 1 and zmagnetic lt -0.003)

nbi_good_a=where(nbi_disruption lt 0.5)
nbi_good_b=where(nbi_cease ge ttq)
good_nbi=make_array(n_elements(nbi_cease))
good_nbi[nbi_good_a]=1
good_nbi[nbi_good_b]=1
good=where(disruption eq 1 and good_nbi eq 1 and ip_flattop_yn eq 1 and isol_constant eq 1)

use_260610=make_Array(n_elements(shots))
use_260610[good]=1

all=where(use_260610 eq 1)
good_g10000=where(use_260610 eq 1 and shots ge 10000)
good_l10000=where(use_260610 eq 1 and shots lt 10000)

;rule out each of the possbile causes of the change in current quench time

;start with elongation and li. Use values 5ms before the disruption.
if keyword_set(ps) then psopen, filename='kappa_li_plot.eps'

plot,  elongation_5[all], li_5[all], psym=7, xrange=[1,3], yrange=[0,5], /nodata, xtitle=' Elongation (arb.)', ytitle='l!li!n (arb.)'
oplot, elongation_5[good_l10000], li_5[good_l10000], psym=7, color=truecolor('red')
oplot,  elongation_5[good_g10000], li_5[good_g10000], psym=7, color=truecolor('blue')

xyouts, 0.75, 0.85, '< MAST#10000', /normal, color=truecolor('red')
xyouts, 0.75, 0.80, '> MAST#10000', /normal, color=truecolor('blue')

if keyword_set(ps) then psclose

;next move on to major radius against minor radius, again 5ms before ttq
if keyword_set(ps) then psopen, filename='r_a_plot.eps'

plot, minorradius_5[all], radius_5[all], psym=7, xrange=[0.3,0.8], yrange=[0.7,1.0], xs=1, ys=1, /nodata, xtitle='Minor radius (m)', ytitle='Major radius (m)'
oplot, minorradius_5[good_l10000], radius_5[good_l10000], psym=7, color=truecolor('red'), symsize=0.5
oplot,  minorradius_5[good_g10000], radius_5[good_g10000], psym=7, color=truecolor('blue'), symsize=0.5

xyouts, 0.75, 0.85, '< MAST#10000', /normal, color=truecolor('red')
xyouts, 0.75, 0.80, '> MAST#10000', /normal, color=truecolor('blue')

if keyword_set(ps) then psclose



if(keyword_set(ps)) then begin
	!p.font=-1
	!p.charsize=0
endif
stop

END
