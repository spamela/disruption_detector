PRO disruption_efit_280610_1a

restore, '~athorn/disrupt_db/END_JUNE09/disruption_efit_280610_2.sav'

q=where(shots eq 3879)
i=0

nbi=getdata('anb_tot_sum_power', strtrim(string(fix(shots[q[i]])),2))

      if(nbi.erc eq -1 or shots[q[i]] eq 15957 or shots[q[i]] eq 20765 or shots[q[i]] eq 21073 or n_elements(nbi.time) lt 3) then begin
          ;print, shots[i], 'NBI data missing'
          nbi_cease[q[i]]=-1
          nbi_disruption[q[i]]=-1
          nbi_max[q[i]]=-1
          goto, end_nbi_calc
      endif

      nbi_mean=mean(nbi.data)
      nbi_deriv=smooth(deriv(nbi.time, nbi.data),75)
      min_value=min(nbi_deriv)
      nbi_change=where(nbi.time gt 0.15 and nbi_deriv lt -50)
      max_nbi=max(nbi.data)
      
      if(nbi_mean lt 0.01) then begin
          nbi_max[q[i]]=max_nbi
          nbi_cease[q[i]]=ip.time[end_ip]
      endif

      if(nbi_change[0] eq -1) then begin
         nbi_cease[q[i]]=-3
          nbi_max[q[i]]=max_nbi
      endif

       if(nbi_mean gt 0.01 and nbi_change[0] ne -1) then begin
          nbi_cease[q[i]]=nbi.time[nbi_change[0]]
          nbi_max[q[i]]=max_nbi
      endif

      disruption_nbi=where(nbi.time ge ttq[q[i]])

      if(disruption_nbi[0] eq -1) then begin
          nbi_cease[q[i]]=-1
          nbi_max[q[i]]=max_nbi
          nbi_disruption[q[i]]=-1
          goto, end_nbi_calc
      endif

      nbi_disruption[q[i]]=nbi.data(disruption_nbi[0])
      nbi_max[q[i]]=max_nbi

end_nbi_calc:

stop
END
