PRO density_limit_plot, ps=ps

;plot the density at the time of the disruption (as defined
;by the current trace) against the Hugill parameter

if keyword_set(ps) then begin
	setup_ps
	psopen, filename='ngw_ne_plot.eps'
endif

restore, 'disruption_efit_080710_area.sav'

use=where(use_hl eq 1 and density_5 gt 0 and nbi_disruption ne -1 and $
		ip_flattop_yn eq 1)
area=area_5[use]
density=density_5[use]
ip=ip_disruption[use]
r=minorradius_5[use]
shotlist=shots[use]

zvariable=nbi_disruption[use]
max_z=max(zvariable)+(0.01*max(zvariable))
min_z=0;min(zvariable)

ned=density/(8*r)
n_gw=(ip/1e3)/(!pi*r*r)

ratio=(ned/1e20)/n_gw

q=where(ratio gt 1.0)

plot, n_gw, ned/1e20, xtitle='I!lp!n/'+greek('pi')+'a!u2!n', $
	ytitle='n!le!n (x10!u20!n m!u-3!n)', xrange=[0,1.5], yrange=[0,1.5], $
	psym=7, /iso, position=[0.15,0.15,0.9,0.9]

n_colors=255
n_levels=200

loadct,39, /silent
;restore, '~/IDL_PRO/black_green_table.sav'
;tvlct, r,g,b

for i=0, n_elements(use)-1 do begin
	znnn=(zvariable[i]-min_z)/(max_z-min_z)
	oplot, [n_gw[i],n_gw[i]], [ned[i],ned[i]]/1e20, psym=8, color=znnn*n_colors
	if ratio[i] gt 1.0 and ned[i]/1e20 lt 2 then begin
		print, znnn*n_colors, zvariable[i]
		stop
	endif
endfor

oplot, [0,2.],[0,2.];, color=truecolor()

;borrow this method from GOURDON BphiPlot.pro
level = (min_z + findgen(n_levels+1)/n_levels*(max_z-min_z))
color = findgen(n_levels+1)/n_levels*n_colors
xbar=findgen(2)
bar_dummy=[transpose(color), transpose(color)]

chars=!p.charsize
!p.charsize=0.1
cp_shade, bar_dummy,xbar,level,position=[0.68,0.15,0.73,0.90], /noerase
!p.charsize=chars
axis, yaxis=1, ytitle='Injected NBI power (MW)', yrange=[min_z, max_z], /save, ys=1

if keyword_set(ps) then begin
	psclose
	setup_ps, /unset
endif

stop

END
