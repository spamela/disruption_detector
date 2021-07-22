PRO cq_time_maximum

;find the maximum cq duration on MAST
;use the old database

restore, 'disruption_efit_080710.sav'

;select shots where the divertor has been changed
;q=where(use_hl eq 1 and shots gt 10000)
q=where(use eq 1 and shots gt 10000)

;lift the shots, times and cq time for the shots to be used
shots_selected=shots[q]
cq_times_selected=cq_time[q]
ttq_selected=ttq[q]
cq_times_select_norm100=cq_times_selected*(100/60.) ;normalise to 100% decay

;histogram_at4, cq_times_select_norm100*1e3, max=60, min=0, binsize=5

;find the ones which are a long way from the average
w=where(cq_times_select_norm100 gt 15/1e3) ;three and they IRE

histogram_at4, cq_times_selected*1e3, max=6, min=0, binsize=0.2


stop

END
