PRO hmodes, ps=ps

;make plot showing MHD activity in H mode discharges

xrange=[-10, 5]

if(keyword_set(ps)) then begin
	!p.font=1
	!p.charsize=2.5
	!x.thick=2
	!y.thick=2
	!p.thick=4
	psopen, filename='hmodes.eps'
endif

!p.font=1
!p.charsize=1.75
;!p.thick=

ip2=getdata('amc_plasma current',20501)
ip1=getdata('amc_plasma current',18048)
ip3=getdata('amc_plasma current',23447)

da2=getdata('xim_da/hu10/t',20501)
da1=getdata('xim_da/hu10/t',18048)
da3=getdata('xim_da/hu10/t',23447)

nodd2=getdata('ama_n=odd signal',20501)
nodd1=getdata('ama_n=odd signal',18048)
nodd3=getdata('ama_n=odd signal',23447)

xsx2=getdata('xsx_hcaml#1',20501)
xsx1=getdata('xsx_hcaml#1',18048)
xsx3=getdata('xsx_hcaml#1',23447)

ttq2=ttq(20501)
ttq1=ttq(18048)
ttq3=ttq(23447)

plot, (ip1.time-ttq1)*1000, ip1.data/1e3, ytitle='I!lp!n (MA)', position=[0.12,0.78,0.95,0.95], charsize=0.001, xrange=xrange, yticks=3, yrange=[0,1.5], ys=1
axis, yaxis=0, ytitle='I!lp!n (MA)', yticks=3, ys=1
oplot, (ip2.time-ttq2)*1000, ip2.data/1e3, color=truecolor('red')
oplot, (ip3.time-ttq3)*1000, ip3.data/1e3, color=truecolor('blue')
xyouts, 0.12, 0.96, 'PLASMA CURRENT', /normal, charsize=1.75
xyouts, 0.56, 0.92, 'MAST#18048', /normal, charsize=1.75
xyouts, 0.69, 0.92, 'MAST#20501', /normal, charsize=1.75, color=truecolor('red')
xyouts, 0.82, 0.92, 'MAST#23447', /normal, charsize=1.75,color=truecolor('blue')

plot, (xsx1.time-ttq1)*1000, xsx1.data*1e3, ytitle='Signal (mV)', position=[0.12,0.57,0.95,0.74], /noerase,  charsize=0.001, xrange=xrange, yticks=4
axis, yaxis=0,ytitle='Signal (mV)', yticks=4
oplot, (xsx2.time-ttq2)*1000, xsx2.data*1e3, color=truecolor('red')
oplot, (xsx3.time-ttq3)*1000, xsx3.data*1e3, color=truecolor('blue')
xyouts, 0.12, 0.75, 'SOFT X RAY (HCAML#1)', /normal, charsize=1.75

plot, (nodd1.time-ttq1)*1000, nodd1.data*1e3, ytitle='B field (mT)', position=[0.12,0.36,0.95,0.53], /noerase, charsize=0.001, yticks=2, yrange=[-2,2] , xrange=xrange;[-2,2]
axis, yaxis=0,ytitle='B field (mT)', yticks=2
oplot, (nodd2.time-ttq2)*1000, nodd2.data*1e3, color=truecolor('red')
oplot, (nodd3.time-ttq3)*1000, nodd3.data*1e3, color=truecolor('blue')
xyouts, 0.12, 0.54, 'MAGNETIC FLUCTUATION', /normal, charsize=1.75

plot, (da1.time-ttq1)*1000, da1.data, ytitle='Signal (V)', position=[0.12,0.15,0.95,0.32], /noerase, yticks=3, xrange=xrange, xtitle='T-T(TQ) (ms)';,  charsize=0.001
;axis, yaxis=0,ytitle='Signal (V)'
oplot, (da2.time-ttq2)*1000, da2.data, color=truecolor('red')
oplot, (da3.time-ttq3)*1000, da3.data, color=truecolor('blue')

xyouts, 0.12, 0.33, 'D(ALPHA) EMISSION', /normal, charsize=1.75


if(keyword_set(ps)) then begin
	psclose
	!p.font=-1
	!p.charsize=0.0
	!x.thick=0.
	!y.thick=0.
	!p.thick=0.
endif

stop

END

