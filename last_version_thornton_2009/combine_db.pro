PRO combine_db

restore, 'disruption_efit_0709_flattop.sav'
	
	;shots2=shots
	;duration2=duration
	;ip_disruption2=ip_disruption
	;ip_end_time2=ip_end_time
	;ip_flattop2=ip_flattop
	;ip_flattop_yn2=ip_flattop_yn
	;ttq2=ttq
	;ip_maximum2=ip_maximum
	;isol_change2=isol_change
	;isol_constant2=isol_constant
	;nbi_cease2=nbi_cease
	;nbi_constant2=nbi_constant
	;nbi_disruption2=nbi_disruption
	;nbi_max2=nbi_max
	;w_maximum2=w_maximum
	;w_disrupt2=w_disrupt
	;w_flattop2=w_flattop
	;w_ratio2=w_ratio
	
; 	a2=betan_5
; 	b2=betan_25
; 	c2=betap_5
; 	d2=betap_25
; 	e2=betat_5
; 	f2=betat_25
; 	g2=btoroidal_5
; 	h2=btoroidal_25
; 	i2=ccl_max
; 	j2=ccl_maxtime
; 	k2=ccl_peak
; 	l2=ccu_max
; 	m2=ccu_maxtime
; 	n2=ccu_peak
; 	o2=CHISQ_EXP
; 	p2=CQ_IPDROP
; 	q2=CQ_RATE
; 	r2=CQ_RATEMAX 
; 	s2=CQ_TIME
; 	t2=DENSITY_25 
; 	u2=DENSITY_5
; 	v2=DISRUPTING
; 	w2=DIVL_MAXTIME
; 	x2=DIVL_MAX 
; 	y2=DIVL_PEAK
; 	z2=DIVU 
; 	aa2=DIVU_MAX
; 	ab2=DIVU_MAXTIME 
; 	ac2=DIVU_PEAK 
; 	ad2=DRSEP_25 
; 	ae2=DRSEP_5 
; 	af2=DURATION
; 	ag2=ELONGATION_25
; 	ah2=ELONGATION_5
; 	ai2=FHALO 
; 	aj2=GLOBALTQTIME
; 	ak2=HALO_PEAKTIME
; 	al2=HL_TRANS
; 	am2=HMODESHOT
; 	an2=HMODE_EVER
; 	ao2=IP_DISRUPTION 
; 	ap2=IP_END_TIME
; 	aq2=IP_FLATTOP
; 	ar2=IP_FLATTOP_YN
; 	as2=IP_MAXIMUM
; 	at2=ISOL_CHANGE
; 	au2=ISOL_CONSTANT
; 	av2=LI_25
; 	aw2=LI_5
; 	ax2=MINORRADIUS_25
; 	ay2=MINORRADIUS_5 
; 	az2=NBI_CEASE 
; 	ba2=NBI_CONSTANT
; 	bb2=NBI_DISRUPTION
; 	bc2=NBI_MAX
; 	bd2=P2L_MAX 
; 	be2=P2L_MAXTIME 
; 	bf2=P2L_PEAK
; 	bg2=P2U_MAX 
; 	bh2=P2U_MAXTIME 
; 	bi2=P2U_PEAK 
; 	bj2=P3L_MAX 
; 	bk2=P3L_MAXTIME 
; 	bl2=P3L_PEAK
; 	bm2=Q0_25 
; 	bn2=Q0_5
; 	bo2=Q95_25 
; 	bp2=Q95_5 
; 	bq2=RMSE_EXP 
; 	br2=RMSE_LIN
; 	bs2=SHOTS
; 	bt2=STATUS_EXP 
; 	bu2=SXR_L1TTQ 
; 	bv2=TAU12
; 	bw2=TAU2
; 	bx2=TPF
; 	by2=TQ_STAGES
; 	bz2=TTQ 
; 	ca2=TTQ_OK
; 	cb2=TTQ_SXR
; 	cc2=USE
; 	cd2=USE_HL
; 	ce2=USE_TQ
; 	cf2=VDE_DIRECTION
; 	cg2=WMAX_HL
; 	ch2=W_DISRUPT
; 	ci2=W_FLATTOP
; 	cj2=W_MAXIMUM
; 	ck2=W_RATIO 
; 	cl2=W_RATIOHL
; 	cm2=XPOINT 
; 	cn2=ZMAGAXIS
; 	cp2=ZMAGNETIC

	zzz12=area_flattop
	a2=betan_5
	b2=betan_25
	zzz22=betan_midflattop
	c2=betap_5
	d2=betap_25
	e2=betat_5
	f2=betat_25
	zzz32=betat_midflattop
	g2=btoroidal_5
	h2=btoroidal_25
	zzz42=btoroidal_midflattop
	zzz52=btotal_5
	zzz62=btotal_25
	i2=ccl_max
	j2=ccl_maxtime
	k2=ccl_peak
	l2=ccu_max
	m2=ccu_maxtime
	n2=ccu_peak
	o2=CHISQ_EXP
	p2=CQ_IPDROP
	q2=CQ_RATE
	r2=CQ_RATEMAX 
	s2=CQ_TIME
	t2=DENSITY_25 
	u2=DENSITY_5
	zzz72=density_midflattop
	v2=DISRUPTING
	zzz82=disruption
	w2=DIVL_MAXTIME
	x2=DIVL_MAX 
	y2=DIVL_PEAK
	z2=DIVU 
	aa2=DIVU_MAX
	ab2=DIVU_MAXTIME 
	ac2=DIVU_PEAK 
	ad2=DRSEP_25 
	ae2=DRSEP_5
	zzz92=drsep_midflattop
	af2=DURATION
	ag2=ELONGATION_25
	ah2=ELONGATION_5
	zzz102=fig_good
	zzz112=flattoptime
	ai2=FHALO 
	aj2=GLOBALTQTIME
	zzz122=good_tq
	ak2=HALO_PEAKTIME
	al2=HL_TRANS
	;am2=HMODESHOT
	an2=HMODE_EVER
	zzz132=ip_25
	ao2=IP_DISRUPTION 
	ap2=IP_END_TIME
	aq2=IP_FLATTOP
	ar2=IP_FLATTOP_YN
	as2=IP_MAXIMUM
	zzz142=ip_midflattop
	at2=ISOL_CHANGE
	au2=ISOL_CONSTANT
	av2=LI_25
	aw2=LI_5
	zzz152=li_midflattop
	zzz162=lp_calc_flattop
	ax2=MINORRADIUS_25
	ay2=MINORRADIUS_5
	zzz172=minorradius_flattop
	az2=NBI_CEASE 
	ba2=NBI_CONSTANT
	bb2=NBI_DISRUPTION
	bc2=NBI_MAX
	zzz182=nbi_midflattop
	bd2=P2L_MAX 
	be2=P2L_MAXTIME 
	bf2=P2L_PEAK
	bg2=P2U_MAX 
	bh2=P2U_MAXTIME 
	bi2=P2U_PEAK 
	bj2=P3L_MAX 
	bk2=P3L_MAXTIME 
	bl2=P3L_PEAK
	bm2=Q0_25 
	bn2=Q0_5
	bo2=Q95_25 
	bp2=Q95_5 
	zzz192=qa_25
	zzz202=qa_5
	zzz212=qa_flattop
	zzz222=radius_25
	zzz232=radius_5
	zzz242=radius_flattop
	zzz252=resistance_flattop
	bq2=RMSE_EXP 
	br2=RMSE_LIN
	bs2=SHOTS
	bt2=STATUS_EXP 
	bu2=SXR_L1TTQ 
	bv2=TAU12
	bw2=TAU2
	bx2=TPF
	zzz262=temp_flattop
	zzz272=time_flattop
	by2=TQ_STAGES
	bz2=TTQ 
	ca2=TTQ_OK
	cb2=TTQ_SXR
	cc2=USE
	cd2=USE_HL
	ce2=USE_TQ
	cf2=VDE_DIRECTION
	cg2=WMAX_HL
	zzz282=wthermal_25
	ch2=W_DISRUPT
	ci2=W_FLATTOP
	cj2=W_MAXIMUM
	zzz292=w_midflattop
	ck2=W_RATIO 
	cl2=W_RATIOHL
	;cm2=XPOINT
	zzz302=yag_good
	cn2=ZMAGAXIS
	zzz312=ZMAGAXIS_midflattop
	;cp2=ZMAGNETIC

restore, 'disruption_efit_ITPA_060709.sav'

; 	shots1=shots
; 	duration1=duration
; 	ip_disruption1=ip_disruption
; 	ip_end_time1=ip_end_time
; 	ip_flattop1=ip_flattop
; 	ip_flattop_yn1=ip_flattop_yn
; 	ttq1=ttq
; 	ip_maximum1=ip_maximum
; 	isol_change1=isol_change
; 	isol_constant1=isol_constant
; 	nbi_cease1=nbi_cease
; 	nbi_constant1=nbi_constant
; 	nbi_disruption1=nbi_disruption
; 	nbi_max1=nbi_max
; 	w_maximum1=w_maximum
; 	w_disrupt1=w_disrupt
; 	w_flattop1=w_flattop
; 	w_ratio1=w_ratio
	
	zzz1=area_flattop
	a=betan_5
	b=betan_25
	zzz2=betan_midflattop
	c=betap_5
	d=betap_25
	e=betat_5
	f=betat_25
	zzz3=betat_midflattop
	g=btoroidal_5
	h=btoroidal_25
	zzz4=btoroidal_midflattop
	zzz5=btotal_5
	zzz6=btotal_25
	i=ccl_max
	j=ccl_maxtime
	k=ccl_peak
	l=ccu_max
	m=ccu_maxtime
	n=ccu_peak
	o=CHISQ_EXP
	p=CQ_IPDROP
	q=CQ_RATE
	r=CQ_RATEMAX 
	s=CQ_TIME
	t=DENSITY_25 
	u=DENSITY_5
	zzz7=density_midflattop
	v=DISRUPTING
	zzz8=disruption
	w=DIVL_MAXTIME
	x=DIVL_MAX 
	y=DIVL_PEAK
	z=DIVU 
	aa=DIVU_MAX
	ab=DIVU_MAXTIME 
	ac=DIVU_PEAK 
	ad=DRSEP_25 
	ae=DRSEP_5
	zzz9=drsep_midflattop
	af=DURATION
	ag=ELONGATION_25
	ah=ELONGATION_5
	zzz10=fig_good
	zzz11=flattoptime
	ai=FHALO 
	aj=GLOBALTQTIME
	zzz12=good_tq
	ak=HALO_PEAKTIME
	al=HL_TRANS
	;am=HMODESHOT
	an=HMODE_EVER
	zzz13=ip_25
	ao=IP_DISRUPTION 
	ap=IP_END_TIME
	aq=IP_FLATTOP
	ar=IP_FLATTOP_YN
	as=IP_MAXIMUM
	zzz14=ip_midflattop
	at=ISOL_CHANGE
	au=ISOL_CONSTANT
	av=LI_25
	aw=LI_5
	zzz15=li_midflattop
	zzz16=lp_calc_flattop
	ax=MINORRADIUS_25
	ay=MINORRADIUS_5
	zzz17=minorradius_flattop
	az=NBI_CEASE 
	ba=NBI_CONSTANT
	bb=NBI_DISRUPTION
	bc=NBI_MAX
	zzz18=nbi_midflattop
	bd=P2L_MAX 
	be=P2L_MAXTIME 
	bf=P2L_PEAK
	bg=P2U_MAX 
	bh=P2U_MAXTIME 
	bi=P2U_PEAK 
	bj=P3L_MAX 
	bk=P3L_MAXTIME 
	bl=P3L_PEAK
	bm=Q0_25 
	bn=Q0_5
	bo=Q95_25 
	bp=Q95_5 
	zzz19=qa_25
	zzz20=qa_5
	zzz21=qa_flattop
	zzz22=radius_25
	zzz23=radius_5
	zzz24=radius_flattop
	zzz25=resistance_flattop
	bq=RMSE_EXP 
	br=RMSE_LIN
	bs=SHOTS
	bt=STATUS_EXP 
	bu=SXR_L1TTQ 
	bv=TAU12
	bw=TAU2
	bx=TPF
	zzz26=temp_flattop
	zzz27=time_flattop
	by=TQ_STAGES
	bz=TTQ 
	ca=TTQ_OK
	cb=TTQ_SXR
	cc=USE
	cd1=USE_HL
	ce=USE_TQ
	cf=VDE_DIRECTION
	cg=WMAX_HL
	zzz28=wthermal_25
	ch=W_DISRUPT
	ci=W_FLATTOP
	cj=W_MAXIMUM
	zzz29=w_midflattop
	ck=W_RATIO 
	cl=W_RATIOHL
	;cm=XPOINT
	zzz30=yag_good
	cn=ZMAGAXIS
	zzz31=ZMAGAXIS_midflattop
	;cp=ZMAGNETIC
	
;combine the two

	betan_5=[a,a2]
	betan_25=[b,b2]
	betap_5=[c,c2]
	betap_25=[d,d2]
	betat_5=[e,e2]
	betat_25=[f,f2]
	btoroidal_5=[g,g2]
	btoroidal_25=[h,h2]
	ccl_max=[i,i2]
	ccl_maxtime=[j,j2]
	ccl_peak=[k,k2]
	ccu_max=[l,l2]
	ccu_maxtime=[m,m2]
	ccu_peak=[n,n2]
	CHISQ_EXP=[o,o2]
	CQ_IPDROP=[p,p2]
	CQ_RATE=[q,q2]
	CQ_RATEMAX=[r,r2]
	CQ_TIME=[s,s2]
	DENSITY_25=[t,t2]
	DENSITY_5=[u,u2]
	DISRUPTING=[v,v2]
	DIVL_MAXTIME=[w,w2]
	DIVL_MAX=[x,x2]
	DIVL_PEAK=[y,y2]
	DIVU=[z,z2] 
	DIVU_MAX=[aa,aa2]
	DIVU_MAXTIME=[ab,ab2]
	DIVU_PEAK=[ac,ac2]
	DRSEP_25=[ad,ad2]
	DRSEP_5=[ae,ae2]
	DURATION=[af,af2]
	ELONGATION_25=[ag,ag2]
	ELONGATION_5=[ah,ah2]
	FHALO=[ai,ai2]
	GLOBALTQTIME=[aj,aj2]
	HALO_PEAKTIME=[ak,ak2]
	HL_TRANS=[al,al2]
	;HMODESHOT=[am,am2]
	HMODE_EVER=[an,an2]
	IP_DISRUPTION=[ao,ao2] 
	IP_END_TIME=[ap,ap2]
	IP_FLATTOP=[aq,aq2]
	IP_FLATTOP_YN=[ar,ar2]
	IP_MAXIMUM=[as,as2]
	ISOL_CHANGE=[at,at2]
	ISOL_CONSTANT=[au,au2]
	LI_25=[av,av2]
	LI_5=[aw,aw2]
	MINORRADIUS_25=[ax,ax2]
	MINORRADIUS_5=[ay,ay2]
	NBI_CEASE=[az,az2]
	NBI_CONSTANT=[ba,ba2]
	NBI_DISRUPTION=[bb,bb2]
	NBI_MAX=[bc,bc2]
	P2L_MAX=[bd,bd2]
	P2L_MAXTIME=[be,be2]
	P2L_PEAK=[bf,bf2]
	P2U_MAX=[bg,bg2]
	P2U_MAXTIME=[bh,bh2] 
	P2U_PEAK=[bi,bi2]
	P3L_MAX=[bj,bj2] 
	P3L_MAXTIME=[bk,bk2] 
	P3L_PEAK=[bl,bl2]
	Q0_25=[bm,bm2]
	Q0_5=[bn,bn2]
	Q95_25=[bo,bo2]
	Q95_5=[bp,bp2]
	RMSE_EXP=[bq,bq2] 
	RMSE_LIN=[br,br2]
	SHOTS=[bs,bs2]
	STATUS_EXP=[bt,bt2] 
	SXR_L1TTQ=[bu,bu2] 
	TAU12=[bv,bv2]
	TAU2=[bw,bw2]
	TPF=[bx,bx2]
	TQ_STAGES=[by,by2]
	TTQ=[bz,bz2]
	TTQ_OK=[ca,ca2]
	TTQ_SXR=[cb,cb2]
	USE=[cc,cc2]
	USE_HL=[cd1,cd2]
	USE_TQ=[ce,ce2]
	VDE_DIRECTION=[cf,cf2]
	WMAX_HL=[cg,cg2]
	W_DISRUPT=[ch,ch2]
	W_FLATTOP=[ci,ci2]
	W_MAXIMUM=[cj,cj2]
	W_RATIO=[ck,ck2] 
	W_RATIOHL=[cl,cl2]
	;XPOINT=[cm,cm2]
	ZMAGAXIS=[cn,cn2]
	;ZMAGNETIC=[cp,cp2]
	area_flattop=[zzz1,zzz2]
	betan_midflattop=[zzz2,zzz22]
	betat_midflattop=[zzz3,zzz32]
	btoroidal_midflattop=[zzz4,zzz42]
	btotal_25=[zzz5, zzz52]
	btotal_5=[zzz6,zzz6]
	density_midflattop=[zzz7,zzz72]
	disruption=[zzz8,zzz82]
	drsep_midflattop=[zzz9,zzz92]
	fig_good=[zzz10,zzz102]
	flattoptime=[zzz11,zzz112]
	good_tq=[zzz12,zzz122]
	ip_25=[zzz13,zzz132]
	ip_midflattop=[zzz14,zzz142]
	li_midflattop=[zzz15,zzz152]
	lp_calc_flattop=[zzz16,zzz162]
	minorradius_flattop=[zzz17,zzz172]
	nbi_midflattop=[zzz18,zzz182]
	qa_25=[zzz19,zzz192]
	qa_5=[zzz20,zzz202]
	qa_flattop=[zzz21,zzz212]
	radius_25=[zzz22,zzz222]
	radius_5=[zzz23,zzz232]
	radius_flattop=[zzz24,zzz242]
	resistance_flattop=[zzz25,zzz252]
	temp_flattop=[zzz26,zzz262]
	time_flattop=[zzz27,zzz272]
	wthermal_25=[zzz28,zzz282]
	w_midflattop=[zzz29,zzz292]
	yag_good=[zzz30,zzz302]
	zmagaxis_midflattop=[zzz31,zzz312]
	
; 	shots=[shots1, shots2]
; 	duration=[duration1, duration2]
; 	ip_disruption=[ip_disruption1, ip_disruption2]
; 	ip_end_time=[ip_end_time1, ip_end_time2]
; 	ip_flattop=[ip_flattop1, ip_flattop2]
; 	ip_flattop_yn=[ip_flattop_yn1, ip_flattop_yn2]
; 	ttq=[ttq1,ttq2]
; 	ip_maximum=[ip_maximum1, ip_maximum2]
; 	isol_change=[isol_change1, isol_change2]
; 	isol_constant=[isol_constant1, isol_constant2]
; 	nbi_cease=[nbi_cease1, nbi_cease2]
; 	nbi_constant=[nbi_constant1, nbi_constant2]
; 	nbi_disruption=[nbi_disruption1, nbi_disruption2]
; 	nbi_max=[nbi_max1, nbi_max2]
; 	w_maximum=[w_maximum1, w_maximum2]
; 	w_disrupt=[w_disrupt1, w_disrupt2]
; 	w_flattop=[w_flattop1, w_flattop2]
; 	w_ratio=[w_ratio1, w_ratio2]

; save, shots, duration, ip_disruption, ip_end_time, ip_flattop, ip_flattop_yn, ttq, ip_maximum, isol_change, isol_constant, nbi_cease, nbi_constant, nbi_disruption, nbi_max, w_maximum, w_disrupt, w_flattop, w_ratio, filename='disruption_efit_M7.savkk'

save, betan_5,betan_25,	betap_5,betap_25,betat_5,betat_25,btoroidal_5,btoroidal_25,ccl_max,ccl_maxtime,	ccl_peak,ccu_max,ccu_maxtime,ccu_peak,CHISQ_EXP,CQ_IPDROP,CQ_RATE,CQ_RATEMAX,CQ_TIME,DENSITY_25,DENSITY_5,DISRUPTING,DIVL_MAXTIME,DIVL_MAX,DIVL_PEAK,DIVU,DIVU_MAX,DIVU_MAXTIME,DIVU_PEAK,DRSEP_25,DRSEP_5 ,DURATION,	ELONGATION_25    ,	ELONGATION_5,	FHALO ,GLOBALTQTIME,HALO_PEAKTIME,HL_TRANS,HMODE_EVER,IP_DISRUPTION,IP_END_TIME,IP_FLATTOP,IP_FLATTOP_YN,IP_MAXIMUM,ISOL_CHANGE,ISOL_CONSTANT,LI_25,LI_5,MINORRADIUS_25,MINORRADIUS_5 ,NBI_CEASE ,	NBI_CONSTANT,$
	NBI_DISRUPTION,$
	NBI_MAX,$
	P2L_MAX ,$
	P2L_MAXTIME,$ 
	P2L_PEAK,$
	P2U_MAX ,$
	P2U_MAXTIME,$ 
	P2U_PEAK ,$
	P3L_MAX ,$
	P3L_MAXTIME,$ 
	P3L_PEAK,$
	Q0_25 ,$
	Q0_5,$
	Q95_25,$ 
	Q95_5 ,$
	RMSE_EXP,$ 
	RMSE_LIN,$
	SHOTS,$
	STATUS_EXP,$ 
	SXR_L1TTQ ,$
	TAU12,$
	TAU2,$
	TPF,$
	TQ_STAGES ,$
	TTQ ,$
	TTQ_OK,$
	TTQ_SXR,$
	USE,$
	USE_HL,$
	USE_TQ,$
	VDE_DIRECTION,$
	WMAX_HL,$
	W_DISRUPT,$
	W_FLATTOP,$
	W_MAXIMUM,$
	W_RATIO ,$
	W_RATIOHL,$
	
	ZMAGAXIS,$
	
	area_flattop, $
	betan_midflattop,$
	betat_midflattop,$
	btoroidal_midflattop,$
	btotal_25,$
	btotal_5,$
	density_midflattop,$
	disruption,$
	drsep_midflattop,$
	fig_good,$
	flattoptime,$
	good_tq,$
	ip_25,$
	ip_midflattop,$
	li_midflattop,$
	lp_calc_flattop,$
	minorradius_flattop,$
	nbi_midflattop,$
	qa_25,$
	qa_5,$
	qa_flattop,$
	radius_25,$
	radius_5,$
	radius_flattop,$
	resistance_flattop,$
	temp_flattop,$
	time_flattop,$
	wthermal_25,$
	w_midflattop,$
	yag_good,$
	zmagaxis_midflattop,$
filename='disruption_efit_0709_full.sav'


	
END