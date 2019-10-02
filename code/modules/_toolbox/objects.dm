/obj/effect/turf_decal/plaque/toolbox
	name = "plaque"
	icon = 'icons/oldschool/ss13sign1rowdecals.dmi'
	var/ismain = 0
/obj/effect/turf_decal/plaque/toolbox/New()
	. = ..()
	if(ismain)
		if(!isturf(loc))
			qdel(src)
			return
		var/startx = x-3
		for(var/i=1,i<=7,i++)
			var/turf/T = locate(startx,y,z)
			if(istype(T))
				var/obj/effect/turf_decal/plaque/toolbox/P = new(T)
				if(T == loc)
					P = src
				else
					P = new(T)
				P.icon_state = "S[i]"
			startx++
		ismain = 0

//rapid parts exchanger can now replace apc cells

//broken
/*
/obj/machinery/power/apc/exchange_parts(mob/user, obj/item/storage/part_replacer/W)
	if(!istype(W) || !cell)
		return FALSE
	if(!W.works_from_distance && ((!usr.Adjacent(src)) || (cant_parts_exchange())))
		return FALSE
	for(var/obj/item/stock_parts/cell/C in W.contents)
		if(C.maxcharge > cell.maxcharge)
			var/atom/movable/oldcell = cell
			if(W.remove_from_storage(C))
				C.doMove(oldcell.loc)
				if(W.handle_item_insertion(oldcell, 1))
					cell = C
					W.notify_user_of_success(user,C,oldcell)
					W.play_rped_sound()
					return TRUE
	return ..()

/obj/machinery/power/apc/cant_parts_exchange()
	if(!panel_open)
		return 1

/obj/machinery/proc/cant_parts_exchange()
	if(flags_1 & NODECONSTRUCT_1)
		return 1


/obj/item/storage/part_replacer/proc/notify_user_of_success(mob/user,atom/newitem,atom/olditem)
	if(!user || !newitem || !olditem)
		return
	to_chat(user, "<span class='notice'>[olditem.name] replaced with [newitem.name].</span>")

//Cells construct with fullhealth
/obj/machinery/rnd/production/proc/Make_Cells_Fucking_Full_Charge_Because_Thats_So_Gay(obj/item/stock_parts/cell/C)
	if(istype(C))
		C.charge = C.maxcharge
		C.update_icon()
*/
//reinforced delivery window. allows items to be placed on tables underneath it
/obj/structure/window/reinforced/fulltile/delivery
	name = "reinforced delivery window"
	icon = 'icons/oldschool/objects.dmi'
	icon_state = "delivery_window"
	flags_1 = 0
	smooth = SMOOTH_FALSE
	canSmoothWith = list()
	glass_amount = 5
	CanAtmosPass = ATMOS_PASS_YES

/obj/structure/window/reinforced/fulltile/delivery/unanchored
	anchored = FALSE

//animal cookies
/obj/item/reagent_containers/food/snacks/cracker
	var/copied = 0

/obj/item/reagent_containers/food/snacks/cracker/New()
	var/list/available = list()
	for(var/mob/living/M in range(3,get_turf(src)))
		if(istype(M,/mob/living/carbon/monkey) || (istype(M,/mob/living/simple_animal) && !istype(M,/mob/living/simple_animal/hostile) && !istype(M,/mob/living/simple_animal/bot) && !istype(M,/mob/living/simple_animal/slime)))
			available += M
	var/choice
	if(available.len)
		choice = pick(available)
	if(choice)
		copy_animal(choice)
	. = ..()

/obj/item/reagent_containers/food/snacks/cracker/proc/copy_animal(atom/A)
	if(!A)
		return
	overlays.Cut()
	var/matrix/M = new()
	transform = M
	name = "animal cracker"
	desc = "Its a [A.name]!"
	var/icon/mask = icon(A.icon,initial(A.icon_state),dir = 4)
	mask.Blend(rgb(255,255,255))
	mask.BecomeAlphaMask()
	var/icon/cracker = new/icon('icons/oldschool/objects.dmi', "crackertexture")
	cracker.AddAlphaMask(mask)
	var/image/overlay = image(cracker)
	overlays += overlay
	/*var/image/shades = new()
	shades.icon = A.icon
	shades.icon_state = A.icon_state
	shades.overlays += A.overlays
	shades.color = list(0.30,0.30,0.30,0, 0.60,0.60,0.60,0, 0.10,0.10,0.10,0, 0,0,0,1, 0,0,0,0)
	shades.alpha = round(255*0.5,1)
	overlays += shades*/
	M *= 0.6
	transform = M

//**********************
//Chemical Reagents Book
//**********************

// broken stuff
/*
/obj/item/book/manual/wiki/chemistry/Initialize(roundstart)
	. = ..()
	if(roundstart)
		var/bookcount = 0
		for(var/obj/item/book/manual/falaskian_chemistry/F in loc)
			bookcount++
		if(!bookcount)
			new /obj/item/book/manual/falaskian_chemistry(loc)

/obj/item/book/manual/falaskian_chemistry
	name = "Full Guide to Chemical Recipes"
	desc = "A full list of every chemical recipe in the known universe."
	author = "Mangoulium XCIX"
	unique = 1
	icon_state = "book8"
	window_size = "970x710"

/obj/item/book/manual/falaskian_chemistry/New()
	..()
	var/image/I = new()
	I.icon = 'icons/obj/chemical.dmi'
	I.icon_state = "dispenser"
	I.transform = I.transform*0.5
	overlays += I

/obj/item/book/manual/falaskian_chemistry/update_icon()

/obj/item/book/manual/falaskian_chemistry/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/pen))
		return
	. = ..()

/obj/item/book/manual/falaskian_chemistry/attack_self(mob/user)
	if(is_blind(user))
		to_chat(user, "<span class='warning'>As you are trying to read, you suddenly feel very stupid!</span>")
		return
	if(ismonkey(user))
		to_chat(user, "<span class='notice'>You skim through the book but can't comprehend any of it.</span>")
		return
	if(dat)
		var/sizex = 970
		var/sizey = 710
		if(window_size)
			var/xlocation = findtext(window_size,"x",1,length(window_size)+1)
			if(xlocation && isnum(text2num(copytext(window_size,1,xlocation))) && isnum(text2num(copytext(window_size,xlocation,length(window_size)+1))))
				sizex = text2num(copytext(window_size,1,xlocation))
				sizey = text2num(copytext(window_size,xlocation,length(window_size)+1))
		var/datum/browser/popup = new(user, "book", "[name]", sizex, sizey)
		popup.set_content(dat)
		popup.open()
		title = name
		user.visible_message("[user] opens a book titled \"[title]\" and begins reading intently.")
		user.SendSignal(COMSIG_ADD_MOOD_EVENT, "book_nerd", /datum/mood_event/book_nerd)
		onclose(user, "book")
	else
		to_chat(user, "<span class='notice'>This book is completely blank!</span>")

/obj/item/book/manual/falaskian_chemistry/Initialize()
	. = ..()
	if(!dat)
		for(var/obj/item/book/manual/falaskian_chemistry/F in world)
			if(F == src)
				continue
			if(F.dat)
				dat = F.dat
				break
	if(!dat)
		populate_reagents()

/obj/item/book/manual/falaskian_chemistry/proc/populate_reagents()
	var/list/reactions = list()
	for(var/path in typesof(/datum/chemical_reaction))
		var/datum/chemical_reaction/C = new path()
		if(!C.name || !C.id || !C.results || !C.results.len)
			qdel(C)
			continue
		for(var/t in C.results)
			reactions[t] = C
	var/list/all_reagents = list()
	var/list/crafted_reagents = list(
		"Medicine" = list(),
		"Toxin" = list(),
		"Ethanol" = list(),
		"Consumable" = list(),
		"Drug" = list(),
		"Other Various Chemicals" = list())
	for(var/path in typesof(/datum/reagent))
		var/datum/reagent/R = new path()
		if(!R.id || R.id == "reagent")
			qdel(R)
			continue
		all_reagents[R.id] = R
		if(R.id in reactions)
			if(istype(R,/datum/reagent/medicine))
				crafted_reagents["Medicine"][R.name] = R
			else if(istype(R,/datum/reagent/toxin))
				crafted_reagents["Toxin"][R.name] = R
			else if(istype(R,/datum/reagent/consumable))
				if(istype(R,/datum/reagent/consumable/ethanol))
					crafted_reagents["Ethanol"][R.name] = R
				else
					crafted_reagents["Consumable"][R.name] = R
			else if(istype(R,/datum/reagent/drug))
				crafted_reagents["Drug"][R.name] = R
			else
				crafted_reagents["Other Various Chemicals"][R.name] = R
		else
			qdel(R)
	for(var/cat in crafted_reagents)
		crafted_reagents[cat] = sortList(crafted_reagents[cat])
	dat = "<h1>All Chemical Recipes In The Known Universe</h1>"
	dat += "Written by [author].<BR>"
	for(var/cat in crafted_reagents)
		dat += "<h2>[cat]</h2><br>"
		for(var/crafted in crafted_reagents[cat])
			var/datum/reagent/R = crafted_reagents[cat][crafted]
			dat += "<B>[R.name]</B><BR>"
			if(R.description)
				dat += "[R.description]<BR>"
			var/datum/chemical_reaction/C = reactions[R.id]
			dat += "<B>Formula:</B> "
			var/totalparts = 0
			for(var/i=1,i<=C.required_reagents.len,i++)
				var/t = C.required_reagents[i]
				var/parts = "1 part"
				if(C.required_reagents[t] && isnum(C.required_reagents[t]))
					parts = C.required_reagents[t]
					totalparts += parts
					if(parts > 1)
						parts = "[parts] parts"
					else
						parts = "[parts] part"
				var/partname = t
				if(t in all_reagents)
					var/datum/reagent/R2 = all_reagents[t]
					partname = R2.name
				dat += "[parts] [partname]"
				if(i < C.required_reagents.len)
					dat += ", "
			dat += "<BR>"
			if(C.required_catalysts.len)
				dat += "<B>Catalyst"
				if(C.required_catalysts.len > 1)
					dat += "s"
				dat += ":</B> "
				for(var/t in C.required_catalysts)
					var/units = 1
					if(C.required_catalysts[t])
						units = C.required_catalysts[t]
					if(units > 1)
						units = "[units] units"
					else
						units = "[units] unit"
					var/catalystname = t
					if(t in all_reagents)
						var/datum/reagent/R2 = all_reagents[t]
						catalystname = R2.name
					dat += "[units] of [catalystname]"
				dat += "<BR>"
			var/craftedunits = C.results[R.id]
			if(totalparts && craftedunits && totalparts != craftedunits)
				if(craftedunits > 1)
					craftedunits = "[craftedunits] units"
				else
					craftedunits = "[craftedunits] unit"
				dat += "Results in [craftedunits] for every [totalparts] units in reagents.<BR>"
			if(C.required_temp)
				var/heated = "heated"
				if(C.is_cold_recipe)
					heated = "cooled"
				dat += "Must be [heated] to a temperature of [C.required_temp]<BR>"
			dat += "<BR>"

//Making it so borgs can set up the engine -falaskian
/obj/machinery/portable_atmospherics/MouseDrop_T(atom/dropping, mob/user)
	if(istype(dropping, /obj/item/tank) && isturf(dropping.loc) && user.Adjacent(src) && dropping.Adjacent(user))
		src.attackby(dropping, user)
	else
		return ..()

/obj/machinery/power/rad_collector/MouseDrop_T(atom/dropping, mob/user)
	if(istype(dropping, /obj/item/tank/internals/plasma) && isturf(dropping.loc) && user.Adjacent(src) && dropping.Adjacent(user))
		src.attackby(dropping, user)
	else
		return ..()

/obj/machinery/power/port_gen/MouseDrop_T(atom/dropping, mob/user)
	if(istype(dropping, /obj/item/stack/sheet) && isturf(dropping.loc) && user.Adjacent(src) && dropping.Adjacent(user))
		src.attackby(dropping, user)
	else
		return ..()

//making certain things again useable by silicons. -falaskian
/obj/machinery/power/rad_collector/attack_robot(mob/user)
	return attack_hand(user)

/obj/machinery/power/rad_collector/attack_ai(mob/user)
	return attack_hand(user)

/obj/structure/tank_dispenser/attack_robot(mob/user)
	return attack_hand(user)

/obj/machinery/conveyor_switch/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/conveyor_switch/attack_robot(mob/user)
	return attack_hand(user)

/obj/machinery/disposal/bin/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/disposal/bin/attack_robot(mob/user)
	return attack_hand(user)

/obj/machinery/field/generator/attack_robot(mob/user)
	return attack_hand(user)

/obj/machinery/particle_accelerator/control_box/attack_robot(mob/user)
	if(construction_state == 2)
		attack_hand(user)
	else
		return ..()

//Degenerals large airlocks

/obj/machinery/door/airlock/glass_large/security
	name = "large glass airlock"
	icon = 'icons/oldschool/airlock_large_security.dmi'
	overlays_file = 'icons/obj/doors/airlocks/glass_large/overlays.dmi'
	opacity = 0
	assemblytype = /obj/structure/door_assembly/large_sec
	glass = TRUE
	bound_width = 64 // 2x1

/obj/structure/door_assembly/large_sec
	name = "security airlock assembly"
	icon = 'icons/oldschool/airlock_large_security.dmi'
	overlays_file = 'icons/obj/doors/airlocks/glass_large/overlays.dmi'
	glass_type = /obj/machinery/door/airlock/glass_large/security
	airlock_type = /obj/machinery/door/airlock/glass_large/security
	bound_width = 64 // 2x1

//make shuttles bolt the door on launch
/obj/docking_port/mobile/proc/bolt_and_unbolt_exits(unbolt = 0)
	var/area/A = get_area(src)
	var/list/airlocks = list()
	for(var/area/related in A.related)
		for(var/obj/machinery/door/airlock/airlock in related)
			if(airlock in airlocks)
				continue
			airlocks += airlock
			var/has_space = 0
			for(var/turf/T in orange(1,airlock))
				if(T.x != airlock.x && T.y != airlock.y)
					continue
				if(T.density)
					continue
				if(istype(T,/turf/open/space))
					has_space = 1
					break
				var/area/TA = get_area(T)
				if(TA.type != related.type)
					has_space = 1
					break
			if(has_space)
				if(!unbolt)
					airlock.bolt()
				else
					airlock.unbolt()

//disease logging
/datum/disease/proc/log_disease_transfer_attempt(atom/cause,atom/victim,method)
	if(istype(victim,/mob/living/carbon))
		var/mob/living/carbon/C = victim
		if(!C.CanContractDisease(src))
			return
	var/logtext = "DISEASE: Disease transfer attempt. Disease name: "
	if(istype(src,/datum/disease/advance))
		logtext += "Advanced(Symptoms:"
		var/datum/disease/advance/A = src
		var/symptomcount = 1
		for(var/datum/symptom/S in A.symptoms)
			logtext += "[S.name]"
			if(symptomcount < A.symptoms.len)
				logtext += ","
		logtext += ")"
	else
		logtext += "[name]"
	if(method)
		logtext += " Transfer method: "
		var/transfermethod = "Unknown"
		if(isnum(method) || isnum(text2num(method)))
			var/nummethod = "[method]"
			var/list/methods = list(
				"[TOUCH]" = "Contact",
				"[INGEST]" = "Injestion",
				"[VAPOR]" = "Breathing Vapor",
				"[PATCH]" = "Patch",
				"[INJECT]" = "Direct Blood Injection"
				)
			if(methods[nummethod])
				transfermethod = "[methods[nummethod]]"
		else
			transfermethod = "[method]"
		logtext += "[transfermethod] "
	var/causetext = "No Origin"
	var/victimtext = "No Victim"
	if(istype(cause))
		var/atom/tool_used
		if(!istype(cause,/mob/living))
			var/atom/find_mob = cause
			var/timeout = 15
			while(timeout > 0 && find_mob && !istype(find_mob,/mob))
				find_mob = find_mob.loc
				timeout--
			if(istype(find_mob, /mob/living))
				tool_used = cause
				cause = find_mob
		if(istype(cause,/mob/living))
			var/mob/living/living = cause
			var/theckey = "no-ckey"
			if(living.ckey)
				theckey = "[living.ckey]"
			causetext = "[living.real_name]([theckey])"
		else
			causetext = "[cause.name]"
		var/turf/T = get_turf(cause)
		if(T)
			causetext += "([T.x],[T.y],[T.z]"
			var/area/A = get_area(T)
			if(A)
				causetext += " \"[A.name]\""
			causetext += ")"
		if(tool_used)
			causetext += " Tool used: [tool_used.name]"
		causetext += " "
	if(istype(victim))
		if(istype(victim,/mob/living))
			var/mob/living/living = victim
			var/theckey = "no-ckey"
			if(living.ckey)
				theckey = "[living.ckey]"
			victimtext = "[living.real_name]([theckey])"
		else
			victimtext = "[victim.name]"
		var/turf/T = get_turf(victim)
		if(T)
			victimtext += "([T.x],[T.y],[T.z]"
			var/area/A = get_area(T)
			if(A)
				victimtext += " \"[A.name]\""
			victimtext += ")"
		victimtext += " "
	logtext += "Origin: [causetext] Victim: [victimtext]"
	if(istype(victim,/mob/living))
		var/mob/living/V = victim
		V.log_message("<font color='orange'>[logtext]</font>", INDIVIDUAL_ATTACK_LOG)
	log_game(logtext)
	return logtext
*/