FUNCTION integral_width, q

;calculate the integrated heat flux width at the divertor plate using the
;method set out in NF 49 085038
int_width=make_array(n_elements(q.time))

for i=0, n_elements(q.time)-1 do begin
;this is the method set out in Arnoux NF 49 2009 085038	
;	int_width[i]=(1/max(q.data[*,i]))*(int_tabulated(q.x,q.data[*,i]))
;this is the method set out in Loarte JNM 266-269 1999 587-592
	maximum=where(q.data[*,i] eq max(q.data[*,i]))
	r_max=q.x[maximum[0]]
	int_width[i]=(1/(2*!pi*r_max*max(q.data[*,i])))*(int_tabulated(q.x,(2*!pi*q.x*q.data[*,i])))
endfor
return, int_width

END
