function everything()

print('Waiting for possible chunk loading...')
sleep(2) --wait for chunk loading


--------configurations

--sensors--
AR_Sensor_Prefix=''
side=sensors.getController()

--actuators--
BC_side='back'
BCbustransceiver_side='bottom'
ACcolors={c_power=colors.purple,c_ice=colors.blue,c_uran=colors.lime,c_retriever=colors.brown}
mon_side='top' --it is optional to have a monitor


--id tags--
ucell_name='item.itemCellUran'--replace 0 by number till
uneardepleted_name='item.itemCellUranEmpty'
ureenriched_name='item.itemCellUranEnriched'
ice_name='tile.ice'

--------configurations end

message={}
function update(arg)
	term.clear()
	if #arg>0 then message=arg end
	for i, v in ipairs(message) do print(v) end
	if power==true then s='On' else s='Off' end
	print('Power '..s)
	print('maxUran:'..tostring(maxUran)..'. To depletion:'..tostring((10000-maxUran-params.Umin)/params.Uspeed/60)..' mn.')
	print('min_iceslots:'..tostring(min_iceslots))
	print('ice_missing:'..tostring(ice_missing))
	print('n_to_withdraw:'..tostring(n_to_withdraw))
	print('n_slots_free:'..tostring(n_slots_free))
	params=getSavedParams()
	updateReactorsState()
	for i,reactor in pairs(reactors) do
		if not compress(reactor.ice_slots_start)==compress(reactor.ice_slots) then
				error('Ice slots changed in Reactor '..reactor.name..'. Pos:'..reactor.pos)
		end
	end
end

function getReactors()
	reactors={}
	for i,sensor in ipairs(sensors.getSensors(side)) do
		if sensor:sub(0,#AR_Sensor_Prefix)==AR_Sensor_Prefix then
		if (not sensors.getAvailableReadings(side, sensor)[1]=='No Readings found') or sensors.getAvailableReadings(side, sensor)[1]=='TargetInfo' then
		if sensors.getSensorInfo(side, sensor).cardType=='IndustrialCraft2 SensorModule' then
			for j, target in ipairs(sensors.getAvailableTargetsforProbe(side,sensor,'ReactorContent')) do
				name='AR Reactor '..sensor:match('^'..AR_Sensor_Prefix..'(.*)')..' '..tostring(i)..':'..tostring(j)
				size=6*(3+tonumber(sensors.getSensorReadingAsDict(side,sensor,target,'Reactor').size))
				pos=target:match('(%d+,%d+,%d+)$')
				reactor={name=name, target=target, sensor=sensor, size=size, pos=pos}
				reactors[target]=reactor
			end
		end end end
	end
	new_reactors={}
	for i,v in pairs(reactors) do new_reactors[#new_reactors+1]=v end
	reactors=new_reactors
	if #reactors==0 then print('No reactors found. Check adjacency of sensors, type of card and sensors name prefix:'..AR_Sensor_Prefix) end
	return reactors
end




function UpdateReactorState(reactor)
	local n_slots_filled=0
	local ice_missing=0
	local n_to_withdraw=0
	local maxUran=0
	local ice_slots={}
	local min_iceslots=64
	
	for i,v in pairs(sensors.getSensorReadingAsDict(side,reactor.sensor,reactor.target,'ReactorContent')) do
		n_slots_filled=n_slots_filled+1
		if v:sub(-2-#ice_name,-3)==ice_name then
			qty=tonumber(string.match(v,'^(%d*)%*'))
			ice_missing=ice_missing+64-qty
			ice_slots[#ice_slots+1]=i
			min_iceslots=math.min(min_iceslots,qty)
		elseif v:sub(-2-#uneardepleted_name,-3)==uneardepleted_name then
			n_to_withdraw=n_to_withdraw+tonumber(v:match('^(%d+)%*'))
		elseif v:sub(-2-#ureenriched_name,-3)==ureenriched_name then
			n_to_withdraw=n_to_withdraw+tonumber(v:match('^(%d+)%*'))
		elseif v:match(ucell_name..'@') then
			m=v:match('@(%d+)$')
			if m==nil then m=0 end
			maxUran=math.max(m,maxUran)
		end
	end
	table.sort(ice_slots)
	reactor.ice_missing=ice_missing
	reactor.n_to_withdraw=n_to_withdraw
	reactor.n_slots_filled=n_slots_filled
	reactor.maxUran=maxUran
	reactor.ice_slots=ice_slots
	reactor.min_iceslots=min_iceslots
end

function aggregateReactors(reactors)
	if #reactors==0 then error('No reactors to aggregate.') end
	t_size=0
	for i, reactor in pairs(reactors) do
			UpdateReactorState(reactor)
			reactor.ice_slots_start=reactor.ice_slots
			t_size=t_size+reactor.size
	end
	print('Reactors aggregated. Total size:'..tostring(t_size))
end

function compress(a)
	s=''
	for i=1,#a do
		s=s..a[i]
	end
	return s
end

function updateReactorsState()
	ice_missing=0
	n_to_withdraw=0
	n_slots_filled=0
	maxUran=0
	min_iceslots=64
	n_t_ice_slots=0
	for i,reactor in pairs(reactors) do
		UpdateReactorState(reactor)
		ice_missing=ice_missing+reactor.ice_missing
		n_to_withdraw=n_to_withdraw+reactor.n_to_withdraw
		n_slots_filled=n_slots_filled+reactor.n_slots_filled
		maxUran=math.max(reactor.maxUran,maxUran)
		min_iceslots=math.min(min_iceslots,reactor.min_iceslots)
		n_t_ice_slots=n_t_ice_slots+#reactor.ice_slots
	end
	n_slots_free=t_size-n_slots_filled
end


message={}


rs.setBundledOutput(BC_side,0)
BCnumbers={'1','2','4','8','16','32','64','128','256','512','1024','2048','4096','8192','16384','32768'}
BCstate={}
for i=1,#BCnumbers do
	BCstate[BCnumbers[i]]=false
end
function setColor(c,Bool)
	BCstate[tostring(c)]=Bool
	BCnumber=0
	for i=1,#BCnumbers do
		if BCstate[BCnumbers[i]]==true then
			BCnumber=BCnumber+tonumber(BCnumbers[i])
		end
	end
	rs.setBundledOutput(BC_side,BCnumber)
end
power=false
function Power(Bool)
    if not (power==Bool) then
    	power=Bool
		setColor(ACcolors.c_power,Bool)
		if Bool==true then s='On' else s='Off' end
		print('Power '..s)
	end
end
function Ice(Bool)
	setColor(ACcolors.c_ice,Bool)
end
function Retriever(Bool)
	setColor(ACcolors.c_retriever,Bool)
end
function Uran(Bool)
	setColor(ACcolors.c_uran,Bool)
end
--fill functions--

function fillUran()
	update{}
	if n_slots_free > 0 then
		update{'Inserting '..tostring(n_slots_free)..' Uranium cells.'}
		Uran(true)
		while n_slots_free>0 do sleep(params.main_delay) update{} end
		Uran(false)
	end
end

function retrieve()
	update{}
	if n_to_withdraw>0 then
		update{'Retrieving '..tostring(n_to_withdraw)..' near depleted and/or re-enriched cells.'}
		Retriever(true)
		while n_to_withdraw>0 do sleep(params.main_delay) update{} end
		Retriever(false)
	end
end

function fillIce()
	update{'Filling with ice.'}
	if ice_missing>0 then
		Ice(true)
		while ice_missing>0 do sleep(params.main_delay) update{} end
		Ice(false)
	end
end


function auto()
	update{}
	while true do
		while 10000-maxUran<=params.Umin do
		    Power(false)
		    update{'Almost depleted cells detected. Entering depletion cycle'}
		    sleep(params.excess_ice_delay)
		    retrieve()
			fillUran()
			fillIce()
			if 10000-maxUran<params.Umin then
				update{}
				sleep(params.excess_ice_delay)
				Power(true)
				ti=os.clock()
				sleep_duration=(10000-maxUran)/params.Uspeed+params.depletion_delay
				while os.clock()-ti<sleep_duration do
					update{}
					sleep(params.main_delay)
				end
				Power(false)
				update{}
			end
		end
		if (n_slots_free>0 or n_to_withdraw>0) then
			Power(false)
			update{'Empty slots near-depleted/re-enriched cells detected.'}
		    sleep(params.excess_ice_delay)
			retrieve()
			fillUran()
		end
		fillIce()
		Ice(true)
		Power(true)
		while (not (10000-maxUran<=params.Umin)) and n_slots_free==0 and n_to_withdraw==0 do
		    update{'In main loop.'}
		    sleep(params.main_delay)
		end
		Ice(false)
		Power(false)
		sleep(1)
	end
end

function saveReactors(reactors)
	file=fs.open('disk/AR_reactors','w')
	for i,reactor in  pairs(reactors) do
		s='Entry{name=\''..reactor.name..'\', target=\''..reactor.target..'\', sensor=\''..reactor.sensor..'\', size=\''..reactor.size..'\', pos=\''..reactor.pos..'\', ice_slots_start=\''..compress(reactor.ice_slots_start)..'\'}'
		file.writeLine(s)
	end
	file.close()
end

function getSavedReactors()
	local reactors = {}
    function Entry (b) reactors[#reactors+1] = b  end
    dofile("disk/AR_reactors")
    for i, r in pairs(reactors) do
    	r.size=tonumber(r.size)
    end
    return reactors
end


function saveParams(params)
	file=fs.open('disk/AR_params','w')
	for i,v in  pairs(params) do
		s='Entry{\''..tostring(i)..'\',\''..tostring(v)..'\'}'
		file.writeLine(s)
	end
	file.close()
end

function getSavedParams()
	params = {}
	if fs.exists('disk/AR_params') then
    	function Entry (b) params[b[1]]=tonumber(b[2])  end
    	dofile("disk/AR_params")
    end
    return params
end

if fs.exists('disk/AR_reactors') then
	print('Found saved reactors in disk/AR_reactors.\nTo reset and choose reactors, delete the file and reboot.')
	reactors=getSavedReactors()
else
	print('List of reactors not found. Waiting for human interaction, press enter to proceed.')
	read()
	pre_reactors=getReactors()
	reactors={}
	print('Listing reactors, enter \y\+enter to confirm or \'n\'+enter to discard.')
	for i, reactor in pairs(pre_reactors) do
		for n, v in pairs(reactor) do print(n..':'..v) end
		r=0 while not (r=='y' or r=='n') do r=tostring(read()) end
		print('Choice registed')
		if r=='y' then print('Keeping reactor for AR.') reactors[i]=reactor end
	end
end

aggregateReactors(reactors)
updateReactorsState()
saveReactors(reactors)
print('Reactors saved to disk/AR_reactors')

rs.setOutput(BCbustransceiver_side,true)


if fs.exists('disk/AR_params') then
	print('Found operational parameters file.\nTo modify, edit disk/AR_params and save.')
	params=getSavedParams()
else
	print('List of parameters not found. Waiting for human interaction, press enter to proceed.')
	read()
	function check_edit(table)
		for i,v in pairs(table) do
			print(i)
			print('set to:'..tostring(v))
			print('Edit?y/n+enter')
			repeat r=read() until (r=='y' or r=='n')
			if tostring(r)=='y' then 
			print('Write the desired value, and press enter.')
				v=tonumber(tostring(read()))
			end
			params[i]=v
		end
	end
	params={}
	aggregateReactors(reactors)
	updateReactorsState()
	check_edit({Umin=20,Uspeed=1,excess_ice_delay=5,depletion_delay=5,main_delay=5})
	saveParams(params)
	print('Parameters saved to disk/AR_params')
end

aggregateReactors(reactors)
if peripheral.isPresent('top') then if peripheral.getType('top')=='monitor' then monitor=peripheral.wrap('top') term.redirect(monitor) end end

auto()

end

local status, err = pcall(everything)
if not status then rs.setOutput(BCbustransceiver_side,false) print(err) end