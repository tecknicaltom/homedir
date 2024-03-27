" Automatically perdorm an :all if opening 5 or fewer files
if !&diff
	let num_bufs = len(getbufinfo())
	if num_bufs > 1 && num_bufs <= 5
		silent all
	endif
endif
