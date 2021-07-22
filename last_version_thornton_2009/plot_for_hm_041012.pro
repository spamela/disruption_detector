PRO plot_for_hm_041012, ps=ps

;look at the CQ time for Hendrik - specifically, are there any disruptions
;where the CQ time is longer than 5 ms

restore, 'disruption_efit_080710_area.sav'

;cut out the wonky data
selected=where(ip_disruption gt 0 and cq_time gt 0 and shots gt 10000)

plot, ip_disruption[selected], cq_time[selected]*1e3, psym=3

;find the long CQ time shots
select_long=where(ip_disruption gt 0 and cq_time gt 0.003 and shots gt 10000)

oplot, ip_disruption[select_long], cq_time[select_long]*1e3, psym=3, $
	col=truecolor('firebrick')

;plot the plasma current for the long shots and check that they all IRE
long_cq=make_array(n_elements(shots))

if file_test('hm_data.sav') eq 0 then begin
for i=0, n_elements(select_long)-1 do begin
	ip=getdata('amc_plasma current', string(shots[select_long[i]], $
															format='(i5)'))

	plot, ip.time, ip.data/1e3, $
		xrange=[ttq[select_long[i]],ip_end_time[select_long[i]]], $
		title=shots[select_long[i]]

	cursor, x, y, /down
	if !mouse.button eq 1 then long_cq[select_long[i]]=1
	if !mouse.button eq 4 then long_cq[select_long[i]]=-1

endfor
save, long_cq, filename='hm_data.sav'
endif else begin
	restore, 'hm_data.sav'
endelse

q=where(long_cq eq 1)
more,q

;check these manually (there are 22) and then filter
q=where(shots eq 10595) ;IREs
long_cq[q]=-1
q=where(shots eq 10669) ;IREs -last CQ < 2ms
long_cq[q]=-1
q=where(shots eq 10673) ;IREs -last CQ < 2ms
long_cq[q]=-1
q=where(shots eq 10701) ;IREs -last CQ < 2ms
long_cq[q]=-1
q=where(shots eq 16443) ;doesn't disrupt
long_cq[q]=-1
q=where(shots eq 17048) ;IRE, last disrupt <5ms
long_cq[q]=-1
q=where(shots eq 17431) ;IRE, last disrupt <5ms
long_cq[q]=-1
q=where(shots eq 20800) ;doesn't disrupt
long_cq[q]=-1
q=where(shots eq 20802) ;doesn't disrupt
long_cq[q]=-1
q=where(shots eq 21354) ;IRE, last disrupt <5ms
long_cq[q]=-1
q=where(shots eq 21912) ;IRE, last disrupt <5ms
long_cq[q]=-1
q=where(shots eq 22089) ;CQ < 5ms
long_cq[q]=-1
q=where(shots eq 22174) ;doesn't disrupt
long_cq[q]=-1
q=where(shots eq 22175) ;doesn't disrupt
long_cq[q]=-1
q=where(shots eq 22188) ;CQ < 5ms
long_cq[q]=-1
q=where(shots eq 22197) ;doesn't disrupt
long_cq[q]=-1
q=where(shots eq 22206) ;doesn't disrupt
long_cq[q]=-1

q=where(long_cq eq 1)
more,q

selected_cq=where(ip_disruption gt 0 and cq_time gt 0 and shots gt 10000 and $
			long_cq ne -1 and ip_disruption gt 200)
if keyword_set(ps) then begin
	setup_ps
	!p.font=0
	!p.charsize=1.25
	atpsopen, filename='cq_times_for_hendrick.eps'
endif

plot, ip_disruption[selected_cq]/1e3, $
	(cq_time[selected_cq]*1e3)*(100/60.), psym=8, symsize=0.25, $
	xrange=[0.1,1.5], /xlog, xs=1, yrange=[0,6], $
	position=[0.15,0.15,0.68,0.9], $
	xtitle='Plasma current (kA)', $
	ytitle='T(CQ) [Scaled 80-20%] (ms)'

if keyword_set(ps) then begin
	atpsclose
	setup_ps
endif


stop

END
