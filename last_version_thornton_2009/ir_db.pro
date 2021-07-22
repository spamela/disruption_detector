PRO ir_db

restore, 'cameras.sav'
path = '/net/fuslsa/data/MAST_IMAGES/'

framerate_mwir=make_array(n_elements(shots))
xsize_mwir=make_array(n_elements(shots))
ysize_mwir=make_array(n_elements(shots))
view_mwir=strarr(n_elements(shots))
framerate_lwir=make_array(n_elements(shots))
xsize_lwir=make_array(n_elements(shots))
ysize_lwir=make_array(n_elements(shots))
view_lwir=strarr(n_elements(shots))

for i=0, n_elements(shots)-1 do begin
;for i=0, 1 do begin	
	print,shots[i]
	;read in the data for the MWIR
	shotstr=strtrim(string(fix(shots[i])),2)
	if(shots[i] ge 10000) then begin
		filename='rir'+'0'+shotstr+'.ipx'
		folder='0'+ strmid(shotstr,0,2)+'/'
	endif
	if(shots[i] lt 10000) then begin
		filename='rir'+'00'+shotstr+'.ipx'
		folder='00'+ strmid(shotstr,0,1)+'/'
	endif
	filepath=path+folder+shotstr+'/'+filename
	
	if(file_test(filepath) eq 1 and shots[i] ne 18475)then begin
		desc=ipx_open(filepath)
		location=where(desc.frametime gt ttq[i])
    
    		if(location[0] eq -1) then begin
        		framerate_mwir[i]=-1
        		xsize_mwir[i]=-1
        		ysize_mwir[i]=-1
        		view_mwir[i]='n'
        		goto, nextshot
    		endif
	
		 if(desc.header.numframes eq 1) then begin
        		framerate_mwir[i]=-2
        		xsize_mwir[i]=-2
        		ysize_mwir[i]=-2
        		view_mwir[i]='n'
        		goto, nextshot
    		endif
    		
    		if(desc.header.numframes eq 1) then begin
        		framerate_mwir[i]=-2
        		xsize_mwir[i]=-2
        		ysize_mwir[i]=-2
        		view_mwir[i]='n'
        		goto, nextshot
    		endif

    		if(location[0] eq 0) then begin
        		deltat=desc.frametime[location[0]+1]-desc.frametime[location[0]]
        		framerate_mwir[i]=1/deltat
        		xsize_mwir[i]=desc.header.width
        		ysize_mwir[i]=desc.header.height
        		view_mwir[i]=desc.header.view
        		goto, nextshot
    		endif

    		if(n_elements(location) eq 1) then begin
         		deltat=desc.frametime[location[0]]-desc.frametime[location[0]-1]
         		framerate_mwir[i]=1/deltat
         		xsize_mwir[i]=desc.header.width
         		ysize_mwir[i]=desc.header.height
         		view_mwir[i]=desc.header.view
         		goto, nextshot
    		endif
    		
    		deltat=desc.frametime[location[0]+1]-desc.frametime[location[0]]
    		framerate_mwir[i]=1/deltat
    		
    		xsize_mwir[i]=desc.header.width
    		ysize_mwir[i]=desc.header.height
    		view_mwir[i]=desc.header.view
	endif
	
	nextshot:
	;get the LWIR data -----------------------------------------------------------------------------------------------
	shotstr=strtrim(string(fix(shots[i])),2)
	if(shots[i] ge 10000) then begin
		filename='rit'+'0'+shotstr+'.ipx'
		folder='0'+ strmid(shotstr,0,2)+'/'
	endif
	if(shots[i] lt 10000) then begin
		filename='rit'+'00'+shotstr+'.ipx'
		folder='00'+ strmid(shotstr,0,1)+'/'
	endif
	filepath=path+folder+shotstr+'/'+filename
	
	if(file_test(filepath) eq 1 and shots[i] ne 18475)then begin
		desc=ipx2open(filepath)
		location=where(desc.frametime gt ttq[i])
    
    		if(location[0] eq -1) then begin
        		framerate_lwir[i]=-1
        		xsize_lwir[i]=-1
        		ysize_lwir[i]=-1
        		view_lwir[i]='n'
        		goto, nextshot2
    		endif
	
		 if(desc.fileinfo.numframes eq 1) then begin
        		framerate_lwir[i]=-2
        		xsize_lwir[i]=-2
        		ysize_lwir[i]=-2
        		view_lwir[i]='n'
        		goto, nextshot2
    		endif
    		
    		if(desc.fileinfo.numframes eq 1) then begin
        		framerate_lwir[i]=-2
        		xsize_lwir[i]=-2
        		ysize_lwir[i]=-2
        		view_lwir[i]='n'
        		goto, nextshot2
    		endif

    		if(location[0] eq 0) then begin
        		deltat=desc.frametime[location[0]+1]-desc.frametime[location[0]]
        		framerate_lwir[i]=1/deltat
        		xsize_lwir[i]=desc.fileinfo.width
        		ysize_lwir[i]=desc.fileinfo.height
        		view_lwir[i]=desc.fileinfo.view
        		goto, nextshot2
    		endif

    		if(n_elements(location) eq 1) then begin
         		deltat=desc.frametime[location[0]]-desc.frametime[location[0]-1]
         		framerate_lwir[i]=1/deltat
         		xsize_lwir[i]=desc.fileinfo.width
         		ysize_lwir[i]=desc.fileinfo.height
         		view_lwir[i]=desc.fileinfo.view
         		goto, nextshot2
    		endif
    		
    		deltat=desc.frametime[location[0]+1]-desc.frametime[location[0]]
    		framerate_lwir[i]=1/deltat
    		
    		xsize_lwir[i]=desc.fileinfo.width
    		ysize_lwir[i]=desc.fileinfo.height
    		view_lwir[i]=desc.fileinfo.view
	endif
	
	nextshot2:
	
endfor

save, filename='ircamera_db.sav'
	
END
