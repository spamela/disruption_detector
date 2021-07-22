FUNCTION bolo_data3, shot=shot, plot=plot, ttq=ttq

;determine the deposited energy due to radaition during a disruption.

if(keyword_set(ttq)) then begin
	ttq_time=ttq
endif else begin
	ttq_time=ttq(shot)
endelse

;print, ttq_time

bol=getdata('abm_prad_pol', shot)
if(bol.erc ne -1) then begin

	;define a window around the ttq time
	;ATHORN - change maximum extent of ttq_window to 10ms after ttq_time from 9ms.
	ttq_window=where(bol.time ge ttq_time-0.007 and bol.time le ttq_time+0.015)

	;find mean of data vals in window before t(TQ)
	ttq_baseline=where(bol.time ge ttq_time-0.01 and bol.time le ttq_time-0.003)
	if(ttq_baseline[0] ne -1) then begin
		base=mean(bol.data[ttq_baseline])
		stdev_base=stdev(bol.data[ttq_baseline])

		;find where power in window exceeds 110% of the gradient from the fit
		threshold=where(bol.data[ttq_window] gt base+(1.5*stdev_base))
		end_threshold=where(bol.time gt ttq_time and bol.data lt 0)

		;ATHORN mod - 21/06/11 - problems with the end_threshold point
		;some shot (25998,25999) show negative Prad prior to the rise
		;the negative values upset the analysis code and lead to low
		;radiated powers - need to ammend end_threshold definition

		;find max in TTQ window
		ttq_maximum=max(bol.data[ttq_window])
		ttq_max_time_pt=where(bol.data[ttq_window] eq ttq_maximum)
		rad_max_time=bol.time[ttq_window[ttq_max_time_pt[0]]]
		end_threshold_new=where(bol.time[ttq_window] gt rad_max_time and bol.data[ttq_window] lt 0)

		;returns -20 (no end threshold position found) in some shots (26166) as
		;p(rad) does not fall below zero. If this is the case then raise the bol.data[ttq_window]
		;threshold for end_threshold_new.
		if end_threshold_new[0] eq -1 then begin
			print, 'Radiated power does not fall below zero'
			print, 'Raising P(rad) end threshold level to: ', strtrim(string((base+(3.*stdev_base))),2)/1e6, 'MJ'
			end_threshold_new=where(bol.time[ttq_window] gt rad_max_time and $
					bol.data[ttq_window] lt base+(3.*stdev_base))
		endif

		;Some shots still have too high a threshold (26191)
		if end_threshold_new[0] eq -1 then begin
			;print, 'Radiated power does not fall below zero'
			print, 'Raising P(rad) end threshold level to: ', strtrim(string((base+(5.*stdev_base))),2)/1e6, 'MJ'
			end_threshold_new=where(bol.time[ttq_window] gt rad_max_time and $
					bol.data[ttq_window] lt base+(5.*stdev_base))
		endif

		;threshold broken on 26191...


		;find the total radiated energy by integrating from threshld to end_threshold.
		if(threshold[0] ne -1 and end_threshold_new[0] ne -1) then begin
			if(bol.time[ttq_window[end_threshold_new[0]]] gt bol.time[ttq_window[threshold[0]]]) then begin
				rad_energy=int_tabulated(bol.time[ttq_window[threshold[0]]:ttq_window[end_threshold_new[0]]], $
						bol.data[ttq_window[threshold[0]]:ttq_window[end_threshold_new[0]]])

				if(keyword_set(plot)) then begin
					plot, bol.time, bol.data, xrange=[ttq_time-0.01, ttq_time+0.01]
					oplot, [ttq_time,ttq_time], !y.crange, color=truecolor('red')
					oplot, !x.crange,[base,base], color=truecolor('limegreen')
					oplot, bol.time[ttq_window], bol.data[ttq_window], color=truecolor('blue')
					oplot, [bol.time[ttq_window[threshold[0]]], bol.time[ttq_window[end_threshold_new[0]]]],$
					 [bol.data[ttq_window[threshold[0]]], bol.data[ttq_window[end_threshold_new[0]]]], psym=7
					oplot, bol.time[ttq_window[threshold[0]]:ttq_window[end_threshold_new[0]]], $
					 bol.data[ttq_window[threshold[0]]:ttq_window[end_threshold_new[0]]], color=truecolor('gold')
					;oplot, [bol.time[ttq_window[end_threshold_new[0]]],$
				;	bol.time[ttq_window[end_threshold_new[0]]]], $
					 ;!y.crange, color=truecolor('red')
				endif
			endif else begin
				rad_energy=-40
			endelse

		;ATHORN mods end 21/06/11
	
		endif else begin
			print, 'No peak radiated threshold found'
			rad_energy=-20
		endelse
	endif else begin
		rad_energy=-50
	endelse

endif else begin
	rad_energy=-10
endelse

;stop

struct={rad_energy:rad_energy}

return, struct

END
