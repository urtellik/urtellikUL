selectCurrentLine()
copy()
deleteLine()

clearWindow("urtellikUL.oocChannelMessage")
appendBuffer("urtellikUL.oocChannelMessage")
raiseEvent("urtellikUL.oocChannelMessage",
	multimatches[2][1],
	multimatches[2][2],
	multimatches[2][3],
	multimatches[2][4])
