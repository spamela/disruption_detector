PRO ir_thesis, ps=ps

restore, 'ir_db_all.sav'

if(keyword_set(ps) eq 1) then begin	
	!p.font=1
	!p.charsize=1.75
	!x.thick=3
	!y.thick=3
	!p.thick=4
endif

!p.font=1
!p.charsize=2.5
loadct, 0, /silent

val=!p.color

;==========================================================================

if not keyword_set(ps) then window,0
if keyword_set(ps) then psopen, filename='rad_cond_scatter.eps'

q=where(use eq 1 and ir_data eq 1 and wradiated ge 0 and wthermal_5 gt 0 and energy_tot gt 0)
radfit=where(use eq 1 and ir_data eq 1 and wradiated ge 0 and wthermal_5 gt 0 and energy_tot gt 0 and wradiated lt 30000)

;plot wthermal against bolo
plot,  wthermal_5[q]/1e3+wmag_5[q]/1e3, wradiated[q]/1e3, psym=symcat(18), ytitle='Energy (kJ)', xtitle='W!lthermal!n+W!lmagnetic!n (kJ)', xrange=[0,400], yrange=[1,400], symsize=1.25, /nodata, /ylog

xerror=(wthermal_5[q]/1e3+wmag_5[q]/1e3)*0.1
yerr_rad=(wradiated[q]/1e3)*0.18
yerr_th=(energy_tot[q])*0.18

!p.color=truecolor('gray')
oploterror, ((wthermal_5[q]/1e3)+(wmag_5[q]/1e3)), ((wradiated[q]/1e3)), xerror, yerr_rad, psym=3
oploterror, ((wthermal_5[q]/1e3)+(wmag_5[q]/1e3)), (energy_tot[q]), xerror, yerr_th, psym=3
!p.color=val

oplot,  wthermal_5[q]/1e3+wmag_5[q]/1e3, wradiated[q]/1e3, psym=symcat(18), color=truecolor('royalblue'), symsize=1.75

usersym, [-1,1,1,-1,-1], [1,1,-1,-1,1], /fill
oplot, wthermal_5[q]/1e3+wmag_5[q]/1e3, energy_tot[q], psym=symcat(16), color=truecolor('firebrick'), symsize=2.0

if keyword_set(ps) then !p.color=truecolor('black')
legend_at, ['Radiated energy', 'Divertor energy'],psym=[18,16], colors=[truecolor('royalblue'), truecolor('firebrick')], /bottom, /right, charsize=1.75
start=[0.0,1.0]
result_rad=mpfitfun('lin', wthermal_5[radfit]/1e3+wmag_5[radfit]/1e3,wradiated[radfit]/1e3, yerr_rad,start, perror=error_rad, dof=dof_rad, bestnorm=bestnorm_rad)
result_th=mpfitfun('linear', wthermal_5[q]/1e3+wmag_5[q]/1e3, energy_tot[q], yerr_th, start, perror=error_th, dof=dof_th, bestnorm=bestnorm_th)

print, 'Error rad: ', error_rad[1]*sqrt(bestnorm_rad/dof_rad) ;from mpfitfun header
print, 'Error th : ', error_th[1]*sqrt(bestnorm_th/dof_th)

;stop

yval_rad=(result_rad[1]*findgen(400))+result_rad[0]
oplot, findgen(400), yval_rad, color=truecolor('royalblue'), thick=4

yval_th=(result_th[1]*findgen(400))+result_th[0]
oplot, findgen(400), yval_th, color=truecolor('firebrick'), thick=4

xyouts, 0.82, 0.8, strtrim(string(round(result_th[1]*100)),2)+'% W!ltotal!n', charsize=1.75, color=truecolor('firebrick'), /normal

xyouts, 0.83, 0.58, strtrim(string(round(result_rad[1]*100)),2)+'% W!ltotal!n', charsize=1.75, color=truecolor('royalblue'), /normal

if keyword_set(ps) then psclose

;==========================================================================

r=where(use eq 1 and ir_data eq 1 and wthermal_5 gt 0 and energy_tot gt 0 and wradiated ge 0)

if not keyword_set(ps) then window,1
if keyword_set(ps) then psopen, filename='energy_balance.eps'

plot, wthermal_5[r]/1e3+wmag_5[r]/1e3, energy_tot[r]+wradiated[r]/1e3, xtitle='W!lthermal!n+W!lmagnetic!n (kJ)', ytitle='W!ldivertor!n+W!lradiated!n (kJ)', psym=8, xrange=[0,400], yrange=[0,400], /iso, /nodata
xerr=0.1*(wthermal_5[r]/1e3+wmag_5[r]/1e3)
yerr=0.18*(energy_tot[r]+wradiated[r]/1e3)
!p.color=truecolor('lightgrey')
oploterror, ((wthermal_5[r]/1e3)+(wmag_5[r]/1e3)), (energy_tot[r]+(wradiated[r]/1e3)), xerr, yerr, psym=3
!p.color=val
oplot,  wthermal_5[r]/1e3+wmag_5[r]/1e3, energy_tot[r]+wradiated[r]/1e3, color=truecolor('blue'), psym=8, symsize=1.25
oplot, [0,400], [0,400], linestyle=3, color=truecolor('black')
;xyouts, 0.55, 0.90, '

;fit line thru points - tweak yerror to improve chi sq
start=[0.0,1.0]
result=mpfitfun('lin', wthermal_5[r]/1e3+wmag_5[r]/1e3,energy_tot[r]+wradiated[r]/1e3, yerr, start, perror=error)
;w_ratio_interp[q])yvals=([0,(wthermal_5[r]/1e3+wmag_5[r]/1e3),400]*result[1])+result[0]
;oplot, [0,(wthermal_5[r]/1e3+wmag_5[r]/1e3),400], yvals
yval=(result[1]*findgen(400))+result[0]
oplot, findgen(400), yval, color=truecolor('black')
if keyword_set(ps) then psclose

;============================================================================
if not keyword_set(ps) then begin
	window, 3
	!p.color=val
	print, !p.color
endif

if keyword_set(ps) then begin
	psopen, filename='broadening.eps'
	!p.color=0
endif

r=where(use eq 1 and ir_data eq 1 and wthermal_5 gt 0 and energy_tot gt 0 and wradiated ge 0)

plot, peak_pow_upp_out_d[r]/1e3, expansion_upp_out[r], psym=8, yrange=[0,15], ytitle=greek('lambda')+'!ld!n/'+greek('lambda')+'!ls!n', xtitle='Heat flux (MW/m!u2!n)', /nodata

oplot, peak_pow_upp_out_d[r]/1e3, expansion_upp_out[r], psym=8, color=truecolor('royalblue'), symsize=1.5
oplot, peak_pow_upp_inn_d[r]/1e3, expansion_upp_inn[r], psym=symcat(18), color=truecolor('olivedrab'), symsize=1.5
oplot, peak_pow_low_out_d[r]/1e3, expansion_low_out[r], psym=symcat(14), color=truecolor('firebrick'), symsize=1.5
oplot, peak_pow_low_inn_d[r]/1e3, expansion_low_inn[r], psym=symcat(15), color=truecolor('goldenrod'), symsize=1.5

legend_at, ['Upper OSP', 'Upper ISP', 'Lower OSP', 'Lower ISP'],psym=[16,18,14, 15], colors=[truecolor('royalblue'), truecolor('olivedrab'), truecolor('firebrick'), truecolor('goldenrod')], /top, /right, charsize=1.75
if keyword_set(ps) then psclose

;plot of the heat flux width broadening during the disruption]
;-contour of two timeslices?

if not keyword_set(ps) then begin
	window, 5
	!p.color=val
endif

if keyword_set(ps) then begin
	psopen, filename='divertorheatload.eps'
	!p.color=0
endif

loadct,0

ip=getdata('amc_plasma current', 23598)
xsx=getdata('xsx_hcaml#1', 23598)
q=getdata('ait_qprofile_osp', 23598)

;need to adjust TQ time so SXR drop and heat load match....cough,cough...
offset=-0.001
tq=ttq(23598)+offset


xrange=[-2,8]

!p.charsize=2.0

plot, (ip.time-tq)*1000,ip.data/1e3, xrange=xrange, ytitle='I!lp!n (MA)', yrange=[0,1.5], ys=9, yticks=3, position=[0.12,0.75,0.85,0.95], charsize=0.001
axis, yaxis=0, ytitle='I!lp!n (MA)', yticks=3, yrange=[0,1.5]
axis,xaxis=0, charsize=.001, yticks=7
axis, yaxis=1, yrange=[-10,30], /save, ytitle='Signal (mv)', ys=1, yticks=4, color=truecolor('royalblue')
oplot, (xsx.time-tq)*1000, xsx.data*1000, color=truecolor('royalblue')

loadct,5
cp_shade, transpose(q.data/1e3),(q.time-tq)*1000, q.x, /showscale, ytitle='Major radius (m)', xtitle='T-T(TQ) (ms)', /noerase, position=[0.12,0.15,0.90,0.69], ztitle='Heat flux (MW/m!u2!n)', xrange=xrange

xyouts, 0.12, 0.695, 'HEAT FLUX TO DIVERTOR', charsize=1.75, /normal
xyouts, 0.12, 0.955, 'PLASMA CURRENT', charsize=1.75, /normal
xyouts, 0.30, 0.955, 'CORE SOFT X RAY', charsize=1.75, /normal, color=truecolor('royalblue')
xyouts, 0.72, 0.955, 'MAST#23598', charsize=1.75, /normal

if keyword_set(ps) then psclose

if(keyword_set(ps) eq 1) then begin
	!p.font=-1
	!p.charsize=0
endif

stop

END

FUNCTION linear, x, p
	y=p[0]+p[1]*x
	return, y
END

FUNCTION lin, x, p
	y=p[1]*x
	return, y
END
