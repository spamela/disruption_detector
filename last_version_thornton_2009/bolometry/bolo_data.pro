PRO bolo_data, shot=shot

;make a database which analyses the bolometry data for disrupting discharges.
;use this as a test program to locate the disruption radiation peak and 
;identify the background level for subtraction.

;shot=13114;use a natural disruption as a test

;can use TQ from i_p analysis
ttq_time=ttq(shot)

print, ttq_time

bol=getdata('abm_prad_pol', shot)

;define a window around the ttq time
ttq_window=where(bol.time ge ttq_time-0.007 and bol.time le ttq_time+0.009)

;fit gaussion to this section with nterm=6
;a=make_array(6)

result=mpfitpeak(bol.time[ttq_window], bol.data[ttq_window],a, error=0.2*bol.data[ttq_window], chi=bestnorm, dof=dof)
;result=gaussfit(bol.time[ttq_window], bol.data[ttq_window])

;integrate area under fitted gaussian
tot=int_tabulated(bol.time[ttq_window], result)

;some overestimation occurs as a result of the window starting slightly early. It's not far
;off though. shot 23598 this program says 25.4kJ of radiated energy, by hand analysis
;for power balance says about 25kJ. 

print, tot/1e3

plot, bol.time, bol.data, xrange=[ttq_time-0.01, ttq_time+0.01]
oplot, [ttq_time,ttq_time], !y.crange, color=truecolor('red')
oplot, bol.time[ttq_window], bol.data[ttq_window], color=truecolor('blue')
oplot, bol.time[ttq_window], result, color=truecolor('green')


print, 'Reduced chi sq: ', bestnorm/dof




stop

END

