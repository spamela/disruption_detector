PRO disruption_efit

;same program as disruption_new.pro, but now reruns EFIT to find the energy
;at the disruption and derive Wr.

;get the list of shots to be analysed

;restore, 'shotlist.sav' ;original list of shots to run upto shot 19026
;restore, 'disruption_efit.sav'
;restore, 'shotlist2.sav' ;shots from 19000to22066
;restore, 'disruption_efit_newshots_last2.sav'
restore, 'shotlist_last.sav

continue=0

if(continue eq 0) then begin

print, 'NEW'

;make the required arrays
duration=make_array(n_elements(shots))
ip_disruption=make_array(n_elements(shots))
ip_end_time=make_array(n_elements(shots))
ip_flattop=make_array(n_elements(shots))
ip_flattop_yn=make_array(n_elements(shots))
ttq=make_array(n_elements(shots))
ip_maximum=make_array(n_elements(shots))

isol_change=make_array(n_elements(shots))
isol_constant=make_array(n_elements(shots))

nbi_cease=make_array(n_elements(shots))
nbi_constant=make_array(n_elements(shots))
nbi_disruption=make_array(n_elements(shots))
nbi_max=make_array(n_elements(shots))

w_maximum=make_array(n_elements(shots))
w_disrupt=make_array(n_elements(shots))
w_flattop=make_array(n_elements(shots))
w_ratio=make_array(n_elements(shots))

index=0

endif

for i=index, n_elements(shots)-1 do begin
;for i=0, 1 do begin

;call in required traces
ip=getdata('amc_plasma current', strmid(string(fix(shots[i])),2))
w=getdata('efm_plasma_energy',strmid(string(fix(shots[i])),2), /noecho)
isol=getdata('amc_sol current', strmid(string(fix(shots[i])),2), /noecho)
nbi=getdata('anb_tot_sum_power',strmid(string(fix(shots[i])),2), /noecho)

;paste in the find tq from tqfind_at.pro

if(ip.erc eq -1) then begin
	;ttq[i]=-1
	;duration[i]=-1
	goto, endofprogram
endif

ip60=where(ip.data gt 60)

if(ip60[0] eq -1) then begin
	;ttq[i]=-2
	;duration[i]=-1
	goto, endofprogram
endif

endip60=n_elements(ip60)-1

tendip60=ip.time[ip60[endip60]]

window60=where(ip.time gt tendip60-0.05 and ip.time lt tendip60+0.01)

starts=ip.time[window60[0]]
ends=ip.time[window60[n_elements(window60)-1]]

;find where current goes above 50 kA, for start, end and duration of shot
start_ip=where(ip.data gt 50)
end_ip=n_elements(start_ip)-1+start_ip[0]
shot_stop=ip.time[end_ip]
shot_start=ip.time[start_ip[0]]
shot_time=shot_stop[0]-shot_start[0]
duration[i]=shot_time
ip_end_time[i]=ip.time[end_ip]

;check if the shot disrupts somehow
max_ip=max(ip.data)
max_ip_find=where(ip.data eq max_ip)

ip_maximum[i]=max_ip

time_ipwindow=ip.time[window60]
data_ipwindow=ip.data[window60]

max_ipwindow=max(data_ipwindow)
deriv_ipwindow=deriv(time_ipwindow, data_ipwindow)
maxderiv_ipwindow=max(deriv_ipwindow)

max_dip=where(deriv_ipwindow eq maxderiv_ipwindow and data_ipwindow gt 50)

if(max_dip[0] eq -1)then begin
    ttq[i]=end_ip
    goto, endofprogram
endif

max_dip_time=time_ipwindow[max_dip]
original_max_dip=max_dip

;athorn mod 26/10/08 starts here:

;work back and check that this is the first peak

for peakpoint=0, 2 do begin
    if(deriv_ipwindow[max_dip-peakpoint] lt -5000) then begin
        max_dip=max_dip-peakpoint+1
        goto, outofforloop
    endif
endfor

outofforloop:

;correct max derivative of Ip so that it lies on the first
;rise of the Ip

if(deriv_ipwindow[max_dip-1] lt -5000)then begin
    derivwindow2time=time_ipwindow[0:max_dip-1]
    derivwindow2data=data_ipwindow[0:max_dip-1]
    if(n_elements(derivwindow2time) le 3) then begin
        max_dip=original_max_dip
        goto, notenoughpoints
    endif

    dip2=deriv(derivwindow2time, derivwindow2data)
    max_deriv_ipwindow2=max(dip2)
    max_dip=where(deriv_ipwindow eq max_deriv_ipwindow2 and data_ipwindow gt 50)

    if(max_dip eq -1) then begin
        max_dip=original_max_dip
        ;print, 'max dp original'
    endif

    if(ABS(time_ipwindow[max_dip]-max_dip_time) gt 0.01) then begin
        max_dip=original_max_dip
        ;print, 'max dp original'
    endif

endif

notenoughpoints:

if(max_dip[0] eq -1)then begin
    ttq[i]=ip_end_time[i]
    goto, endofprogram
endif

;athorn mod 26/10/08 ends here

tpeak=time_ipwindow[max_dip[0]]
ippeak=data_ipwindow[max_dip[0]]

window_maxdip=where(time_ipwindow gt tpeak-0.0008 and time_ipwindow lt tpeak+0.0008)

time_windowmaxdip=time_ipwindow[window_maxdip]
data_windowmaxdip=data_ipwindow[window_maxdip]

if(ippeak lt 150) then begin
	;print, 'Ip is too low'
	ttq[i]=ip_end_time[i]
    goto, endofprogram
endif

x=time_windowmaxdip
y=data_windowmaxdip
r=linfit(x,y, chisq=chisq)

if(r[1] lt 2000) then begin
	ttq[i]=ip_end_time[i]
	goto, endofprogram	
endif

peak_windowb4=where(time_ipwindow gt tpeak-0.007 and time_ipwindow lt tpeak-0.002)

if(peak_windowb4[0] eq -1) then begin
    ttq[i]=-1
    goto, endofprogram
endif

x1=time_ipwindow[peak_windowb4]
y1=data_ipwindow[peak_windowb4]

r1=linfit(x1,y1, chisq=chisq1)

fit=r[0]+r[1]*(time_ipwindow)
fit1=r1[0]+r1[1]*ip.time


ttq[i]=(r1[0]-r[0])/(r[1]-r1[1])
find=where(ip.time ge ttq[i])
iptq=ip.data[find[0]]

ip_disruption[i]=ip.data[find[0]]

;perform flattop analysis, set the disrupt_point to the point found for the ttq in data space.

disrupt_point=find[0]

 if((ip.data[disrupt_point-40] lt (ip.data[disrupt_point-10]*0.9) or $
         (ip.data[disrupt_point-40] gt ip.data[disrupt_point-10]*1.1))) then begin
          ip_flattop[i]=-1
          w_flattop[i]=-1
          goto, end_ip_calc
      endif

      ip_flattop[i]=ip.data[disrupt_point-30]

      if(w.erc eq -1) then begin
          w_flattop[i]=-2
          goto, end_ip_calc
      endif

      w_flat=where(w.time eq (ip.time[disrupt_point]-0.014) or w.time gt (ip.time[disrupt_point]-0.014))

      if(w_flat[0] eq -1) then begin
          w_flattop[i]=-1
          goto, end_ip_calc
      endif

      w_flattop[i]=w.data[w_flat[0]]
   
end_ip_calc:

;NBI calcs

      if(nbi.erc eq -1 or shots[i] eq 15957 or shots[i] eq 20765 or shots[i] eq 21073 or n_elements(nbi.time) lt 3) then begin
          ;print, shots[i], 'NBI data missing'
          nbi_cease[i]=-1
          nbi_disruption[i]=-1
          nbi_max[i]=-1
          goto, end_nbi_calc
      endif

      nbi_mean=mean(nbi.data)
      nbi_deriv=smooth(deriv(nbi.time, nbi.data),75)
      min_value=min(nbi_deriv)
      nbi_change=where(nbi.time gt 0.15 and nbi_deriv lt -50)
      max_nbi=max(nbi.data)
      
      if(nbi_mean lt 0.01) then begin
          nbi_max[i]=max_nbi
          nbi_cease[i]=ip.time[end_ip]
      endif

      if(nbi_change[0] eq -1) then begin
         nbi_cease[i]=-3
          nbi_max[i]=max_nbi
      endif

       if(nbi_mean gt 0.01 and nbi_change[0] ne -1) then begin
          nbi_cease[i]=nbi.time[nbi_change[0]]
          nbi_max[i]=max_nbi
      endif

      disruption_nbi=where(nbi.time ge ttq[i])

      if(disruption_nbi[0] eq -1) then begin
          nbi_cease[i]=-1
          nbi_max[i]=max_nbi
          nbi_disruption[i]=-1
          goto, end_nbi_calc
      endif

      nbi_disruption[i]=nbi.data(disruption_nbi[0])
      nbi_max[i]=max_nbi

end_nbi_calc:

;isol calcs
      if(isol.erc eq -1) then begin
          ;print, shots[i], 'Isol is missing'
          isol_change[i]=-1
          goto, end_isol_calc
      endif

      max_isol_time=max(isol.time)
      isol_deriv=smooth(deriv(isol.time, isol.data),10)
;      isol_change_pt = where(isol_deriv GT 3 and isol.time GT 0.1)
;      isol_change_pt = where(isol_deriv GT 100 and isol.time GT 0.1) ;ammended 24/11/08, to correct oversensitivity in gradient of isol in shots 18360/18361 - athorn
      isol_change_pt = where(isol_deriv GT 100 and isol.time GT 0.1) ;ammended 12/01/09 to correct for shots in rampdown. 
      if(isol_change_pt[0] eq -1) then begin
          ;print, shots[i], 'Isol does not change'
          isol_change[i]=ip.time[end_ip]
          goto, end_isol_calc
      endif

      isol_atchange=isol.data[isol_change_pt[0]]
      isol_time=isol.time[isol_change_pt[0]]

      isol_change[i]=isol_time
     
end_isol_calc:

;find w_max
      
      if(w.erc eq -1) then begin
          w_maximum[i]=-1
          w_max=-1
          goto, end_wmax_calc
      endif
      
      w_max=max(w.data)
      w_maximum[i]=w_max

end_wmax_calc:

;print, ttq[i], 'ends: ', ip_end_time[i]

if(ttq[i] ne ip_end_time[i]) then begin
           shot_st=strtrim(string(fix((shots[i]))),2)
           disrupt_st=string(ttq[i]-0.0002)
           time_step_st=string(0.0002)
           steps=4
           iter_st=string(steps)
   
           arg = shot_st + disrupt_st + time_step_st + iter_st
	   print, 'nice +4 RUNEFIT ' + arg


           cd, '~athorn/EFIT'

           spawn, 'echo' +arg
           spawn, 'nice +4 RUNEFIT ' + arg


           cd, '..'

           ;energy data from efit using new run
   
           ;cd, 'EFIT/OUTPUT'

           ;create filename to find efit file just created

           ;print, shot

           if(shots[i] lt 10000)then begin
                shotstr=strtrim(string(shots[i]),2)
                efit_1=(strmid(shotstr,0,2))
                efit_2=(strmid(shotstr,2,2))
                point='.'
                filename='efm00' + efit_1 + point + efit_2
           endif else begin
                shotstr=strtrim(string(shots[i]),2)
                efit_1=strmid(shotstr,0,3)
                efit_2=strmid(shotstr,3,2)
                point='.'
                ;print, efit_1
                ;print, efit_2
                filename='efm0' + efit_1 + point + efit_2
          endelse


           print, filename

           location='IDA::~athorn/EFIT/OUTPUT/' + filename

           ;load the efit fine timescale trace
           w_fine=-1
           w_fine=getdata('efm_plasma_energy',location)
          
           if(w_fine.erc EQ -1) then begin
               w_d=!values.f_nan
               goto, next_bit
           endif

           w_point=where(w_fine.time GE (ttq[i]))

           if(w_point[0] eq -1) then begin
               w_d=-1
               goto, ratio
           endif

           w_d=w_fine.data[w_point[0]]
           

ratio:
next_bit:
   
       endif

;end of the EFIT bit

       ;calc w_ratio and w_disruption
       
       if(ttq[i] ne ip_end_time[i])then begin

           w_ratio[i]=((w_d)/(w_max))
           w_disrupt[i]=w_d
       endif else begin
           w_ratio[i]=0
           w_disrupt[i]=0
       endelse

endofprogram:



index=i

print, index

cd, '~athorn/disrupt_db/ITPA_SL'

;save, filename='disruption_efit.sav'
save, filename='disruption_efit.sav

endfor

END
