PRO cq_bimodal, ps=ps

if keyword_set(ps) then psopen, filename='histo_cq.eps'

restore, 'disruption_efit_080710_area.sav'
;prove that it is not elongation, area, major/minor radius responsible therefore
;it must be temperature/resistance

q=where(use_hl eq 1)
!p.charsize=2.0

res=radius_5*area_5*(alog(1/(sqrt(elongation_5)*(minorradius_5/radius_5))))

;loadct,0

restore, '~/IDL_PRO/black_green_table.sav'

tvlct, r,g,b

;tvlct, [[255],[],[]]

hist2, res[q], cq_time[q]*1000, min1=0., max1=0.6, bin1=0.01, min2=0,max2=4,bin2=0.1, xtitle='AR!l0!n[ln(1/Ek!u0.5!n)]', ytitle='Current quench timescale (ms)', /whitebckg

if keyword_set(ps) then psclose

END
