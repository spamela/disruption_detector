PRO makeshotlist

shotnumber=make_array(20000)

read, shot, prompt='Enter start shot: '
read, shot_end, prompt='Enter the last shot: '

index=0

while(shot le shot_end) do begin

ip=getdata('amc_plasma current', strtrim(string(fix(shot)),2))

if(ip.erc EQ -1) then begin
       ;print, shot, 'There is no plasma current data'
       shot=shot+1
       goto, here
   endif

   if(n_elements(ip.data) gt 10000) then begin
       ;print, shot, 'Ip data problem'
       shot=shot+1
       goto, here
   endif

   ;check mean ip, use ip_good.pro

   start_ip=where(ip.data gt 50)
   end_ip=n_elements(start_ip)-1+start_ip[0]

   if(start_ip[0] eq -1) then begin
       ;print, shot, 'There is no plasma(2)'
       shot=shot+1
       goto, here
   endif

   avg_ip=mean(ip.data[start_ip[0]:end_ip])
   max_ip_val=max(ip.data)

   if(avg_ip lt 50 and max_ip_val lt 100) then begin
       ;print, shot, 'There is no plasma'
       shot=shot+1
       goto, here
   endif
  
   shotnumber[index]=shot
   shot=shot+1
   index=index+1
   
   ;q=where(shotnumber ne 0)
   ;print, n_elements(q)
   
here:



endwhile

pick=where(shotnumber ne 0)

shots=shotnumber[pick]

save, shots, filename='shotlist_last.sav'

END