
# sets the value of one element to that of the other
# copies e1 into e2
copyVal = (giver, taker) ->
  $(taker).val($(giver).val());

regionName = () ->


regionArea = () ->


populationCalc() ->



# function initialize() {
# 	populationCalc();
# }

# function regionName() {
# 	var sRegionName = document.formLFP.region_name.value;
# 	document.formLFP.region_001.value = sRegionName;
# 	document.formLFP.region_002.value = sRegionName;
# 	document.formLFP.region_003.value = sRegionName;
# }

# function regionArea() {
# 	var iRegionArea = document.formLFP.regionarea_m2.value;
# 	document.formLFP.area_001.value = iRegionArea;
# 	populationCalc();
# }

# function populationCalc() {
# 	document.formLFP.pop_kingdom.value = (document.formLFP.density_m2.options[document.formLFP.density_m2.selectedIndex].value * document.formLFP.regionarea_m2.value);
# 	 // assumes 1 square mile supports a maximum of 180 people
# 	document.formLFP.arable_m2.value = parseInt(document.formLFP.pop_kingdom.value / 180);
# 	document.formLFP.arable_acres.value = parseInt(document.formLFP.arable_m2.value) * 640;
# 	document.formLFP.wilderness_m2.value = parseInt(document.formLFP.regionarea_m2.value) - parseInt(document.formLFP.arable_m2.value);
# 	document.formLFP.wilderness_acres.value = parseInt(document.formLFP.wilderness_m2.value) * 640;
# 	document.formLFP.arable_percent.value = (parseInt((parseInt(document.formLFP.arable_m2.value) / parseInt(document.formLFP.regionarea_m2.value)) * 100) + "%");
# 	// Calculate population distribution based on total number of inhabitants
# 	if (document.formLFP.pop_kingdom.value < 20) {
# 		document.formLFP.pop_villages.value = 0;
# 		document.formLFP.pop_towns.value = 0;
# 		document.formLFP.pop_cities.value = 0;
# 		document.formLFP.pop_bigcities.value = 0;
# 	}
# 	else if (document.formLFP.pop_kingdom.value < 15000) {
# 		document.formLFP.pop_villages.value = parseInt(document.formLFP.pop_kingdom.value * .98);
# 		document.formLFP.pop_towns.value = 0;
# 		document.formLFP.pop_cities.value = 0;
# 		document.formLFP.pop_bigcities.value = 0;
# 	}
# 	else if (document.formLFP.pop_kingdom.value < 300000) {
# 	    document.formLFP.pop_villages.value = parseInt(document.formLFP.pop_kingdom.value * .89);
#     	document.formLFP.pop_towns.value = parseInt(document.formLFP.pop_kingdom.value * .09);
# 	    document.formLFP.pop_cities.value = 0;
#     	document.formLFP.pop_bigcities.value = 0;
# 	}
# 	else if (document.formLFP.pop_kingdom.value < 2400000) {
# 	    document.formLFP.pop_villages.value = parseInt(document.formLFP.pop_kingdom.value * .89);
#     	document.formLFP.pop_towns.value = parseInt(document.formLFP.pop_kingdom.value * .06);
# 	    document.formLFP.pop_cities.value = parseInt(document.formLFP.pop_kingdom.value * .03);
#     	document.formLFP.pop_bigcities.value = 0;
# 	}
# 	else {
# 		document.formLFP.pop_villages.value = parseInt(document.formLFP.pop_kingdom.value * .89);
# 	    document.formLFP.pop_towns.value = parseInt(document.formLFP.pop_kingdom.value * .06);
#     	document.formLFP.pop_cities.value = parseInt(document.formLFP.pop_kingdom.value * .025);
# 	    document.formLFP.pop_bigcities.value = parseInt(document.formLFP.pop_kingdom.value * .005);
# 	}
# 	// Calculate hermit population (itinerants and isolated individuals)
# 	document.formLFP.pop_hermits.value = document.formLFP.pop_kingdom.value - (parseInt(document.formLFP.pop_villages.value) + parseInt(document.formLFP.pop_towns.value) + parseInt(document.formLFP.pop_cities.value) + parseInt(document.formLFP.pop_bigcities.value));
# 	// Calculate number of settlements based on average populations for each
# 	document.formLFP.num_villages.value = Math.ceil(document.formLFP.pop_villages.value / 450);
# 	document.formLFP.num_towns.value = Math.ceil(document.formLFP.pop_towns.value / 5000);
# 	document.formLFP.num_cities.value = Math.ceil(document.formLFP.pop_cities.value / 12000);
# 	// Determine the presence of big cities
# 	if (Math.sqrt(document.formLFP.pop_kingdom.value) > 0) {
# 		document.formLFP.num_bigcities.value = Math.ceil(document.formLFP.pop_bigcities.value / (Math.sqrt(document.formLFP.pop_kingdom.value) * 15));
# 	}
# 	else {
# 		document.formLFP.num_bigcities.value = 0;
# 	}
# 	// Determine average populations for each settlement type
# 	if (document.formLFP.num_villages.value > 0) {
# 		document.formLFP.avg_villagepop.value = Math.ceil(document.formLFP.pop_villages.value / document.formLFP.num_villages.value);
# 	} else {
# 		document.formLFP.avg_villagepop.value = "N/A"
# 	}
# 	if (document.formLFP.num_towns.value > 0) {
# 		document.formLFP.avg_townpop.value = Math.ceil(document.formLFP.pop_towns.value / document.formLFP.num_towns.value);
# 	} else {
# 		document.formLFP.avg_townpop.value = "N/A"
# 	}
# 	if (document.formLFP.num_cities.value > 0) {
# 		document.formLFP.avg_citypop.value = Math.ceil(document.formLFP.pop_cities.value / document.formLFP.num_cities.value);
# 	} else {
# 		document.formLFP.avg_citypop.value = "N/A"
# 	}
# 	if (document.formLFP.num_bigcities.value > 0) {
# 		document.formLFP.avg_bigcitypop.value = Math.ceil(document.formLFP.pop_bigcities.value / document.formLFP.num_bigcities.value);
# 	} else {
# 		document.formLFP.avg_bigcitypop.value = "N/A"
# 	}
# 	// Determine distance between each settlement type
# 	if (document.formLFP.num_villages.value > 1) {
# 		document.formLFP.dist_villages.value = Math.round(Math.sqrt(document.formLFP.regionarea_m2.value / document.formLFP.num_villages.value));
# 	} else {
# 	    document.formLFP.dist_villages.value = "N/A";
# 	}
# 	if (document.formLFP.num_towns.value > 1) {
# 		document.formLFP.dist_towns.value = Math.round(Math.sqrt(document.formLFP.regionarea_m2.value / document.formLFP.num_towns.value));
# 	} else {
# 	    document.formLFP.dist_towns.value = "N/A";
# 	}
# 	if (document.formLFP.num_cities.value > 1) {
# 		document.formLFP.dist_cities.value = Math.round(Math.sqrt(document.formLFP.regionarea_m2.value / (parseInt(document.formLFP.num_cities.value) + parseInt(document.formLFP.num_bigcities.value))));
# 	} else {
# 		document.formLFP.dist_cities.value = "N/A";
# 	}
# 	if (document.formLFP.pop_kingdom.value >= 27300000) {
# 		document.formLFP.num_universities.value = parseInt(document.formLFP.pop_kingdom.value / 27300000);
# 	} else {
# 	    document.formLFP.num_universities.value = 0;
# 	}
# 	// Calculate livestock numbers
# 	//document.formLFP.num_livestock.value = parseInt(document.formLFP.pop_kingdom.value * 2.2);
# 	//document.formLFP.num_fowl.value = parseInt(document.formLFP.num_livestock.value * .68);
# 	//document.formLFP.num_meat.value = parseInt(document.formLFP.num_livestock.value) - parseInt(document.formLFP.num_fowl.value);
# 	// Let's figure out how many fortresses are in the region
# 	fortCalc();
# }

# function fortCalc() {
# 	// Determine number of active, ruined, and total fortifications
# 	var ruinFort = Math.round((document.formLFP.pop_kingdom.value / 5000000) * (Math.sqrt(document.formLFP.age_kingdom.value)));
# 	var actvFort = Math.round(document.formLFP.pop_kingdom.value / 50000);
# 	var allFort = ruinFort + actvFort;
# 	var percentRuin = ruinFort / allFort;
# 	// Break out fortification types; adjust percentages to suit your campaign
# 	var totalCastles = Math.round(allFort * .20);
# 	var totalKeeps = Math.round (allFort * .50);
# 	var totalTowers = allFort - (totalCastles + totalKeeps);
# 	document.formLFP.num_forts.value = allFort;
# 	// Break-out the number and disposition of Castles
# 	document.formLFP.num_castles.value = totalCastles;
# 	if (ruinFort > 0) {
# 		var ruinCastles = Math.ceil(totalCastles * percentRuin);
# 		var actvCastles = totalCastles - ruinCastles;
# 	} else {
# 		var ruinCastles = 0;
# 		var actvCastles = totalCastles;
# 	}
# 	document.formLFP.act_castleSet.value = Math.round(actvCastles * .75);
# 	document.formLFP.act_castleWld.value = actvCastles - parseInt(document.formLFP.act_castleSet.value);
# 	document.formLFP.abn_castleSet.value = Math.round(ruinCastles * .25);
# 	document.formLFP.abn_castleWld.value = ruinCastles - parseInt(document.formLFP.abn_castleSet.value);
# 	// Break-out the number and disposition of Keeps
# 	document.formLFP.num_keeps.value = totalKeeps;
# 	if (ruinFort > 0) {
# 		var ruinKeeps = Math.ceil(totalKeeps * percentRuin);
# 		var actvKeeps = totalKeeps - ruinKeeps;
# 	} else {
# 		var ruinKeeps = 0;
# 		var actvKeeps = totalKeeps;
# 	}
# 	document.formLFP.act_keepSet.value = Math.round(actvKeeps * .75);
# 	document.formLFP.act_keepWld.value = actvKeeps - parseInt(document.formLFP.act_keepSet.value);
# 	document.formLFP.abn_keepSet.value = Math.round(ruinKeeps * .25);
# 	document.formLFP.abn_keepWld.value = ruinKeeps - parseInt(document.formLFP.abn_keepSet.value);
# 	// Break-out the number and disposition of Towers
# 	document.formLFP.num_towers.value = totalTowers;
# 	if (ruinFort > 0) {
# 		var ruinTowers = Math.ceil(totalTowers * percentRuin);
# 		var actvTowers = totalTowers - ruinTowers;
# 	} else {
# 		var ruinTowers = 0;
# 		var actvTowers = totalTowers;
# 	}
# 	document.formLFP.act_towerSet.value = Math.round(actvTowers * .75);
# 	document.formLFP.act_towerWld.value = actvTowers - parseInt(document.formLFP.act_towerSet.value);
# 	document.formLFP.abn_towerSet.value = Math.round(ruinTowers * .25);
# 	document.formLFP.abn_towerWld.value = ruinTowers - parseInt(document.formLFP.abn_towerSet.value);
# 	// Calculate totals
# 	document.formLFP.tot_forts.value = parseInt(document.formLFP.num_castles.value) + parseInt(document.formLFP.num_keeps.value) + parseInt(document.formLFP.num_towers.value);
# 	document.formLFP.act_fortsSet.value = parseInt(document.formLFP.act_castleSet.value) + parseInt(document.formLFP.act_keepSet.value) + parseInt(document.formLFP.act_towerSet.value);
# 	document.formLFP.act_fortsWld.value = parseInt(document.formLFP.act_castleWld.value) + parseInt(document.formLFP.act_keepWld.value) + parseInt(document.formLFP.act_towerWld.value);
# 	document.formLFP.abn_fortsSet.value = parseInt(document.formLFP.abn_castleSet.value) + parseInt(document.formLFP.abn_keepSet.value) + parseInt(document.formLFP.abn_towerSet.value);
# 	document.formLFP.abn_fortsWld.value = parseInt(document.formLFP.abn_castleWld.value) + parseInt(document.formLFP.abn_keepWld.value) + parseInt(document.formLFP.abn_towerWld.value);
# }

# function cityAutoCalc() {
# 	document.formLFP.pop_total.value = document.formLFP.pop_size.options[document.formLFP.pop_size.selectedIndex].value;
# 	cityCalc();
# }
# // Calculate physical area of settlement, based on population
# function cityCalc() {
# 	var iCityPop = document.formLFP.pop_total.value;
# 	// A settled area greater than 3,000 population shifts from rural to urban;
# 	// Adjust this value according to your campaign:
# 	if (iCityPop < 3001) 	{
# 	 	 // Rural agriculture supports 1.25 people per acre
# 	 	 iReqAcres = roundTo((iCityPop / 1.25),2);
# 		 document.formLFP.citysize_m2.value = roundTo((iReqAcres / 640),2);
# 	} else {
# 		// Urban agriculture supports ~60 people per acre
# 		iReqAcres = roundTo((iCityPop / 60),2);
# 		document.formLFP.citysize_m2.value = roundTo((iReqAcres / 640),2);
# 	}
#   	document.formLFP.citysize_acres.value = iReqAcres;
# 	totalPop = document.formLFP.pop_total.value;
# 	// Initialise values for each population segment: nobles, officers, clergy, freeholders, hirelings, and citizens
# 	nobleCalc();
# 	officerCalc();
# 	clergyCalc();
# 	freeholderCalc();
# 	citizenCalc();
# 	buildCalc();
# }

# // BREAK POINT FOR FUNCTIONS
# function nobleCalc() {
# 	// Determine the size of the ruling family
# 	document.formLFP.num_family.value = Math.round(6 * Math.random()) + 1; // 2-7 family members
# 	// Assume 1 servant/2 nobles, 1 guard/3 nobles, 1 serjeant/6 guards; adjust as needed
# 	document.formLFP.num_servants.value = roundOrPercent(document.formLFP.num_family.value / 2.0);
# 	document.formLFP.num_guards.value = roundOrPercent(document.formLFP.num_family.value / 3.0);
# 	document.formLFP.num_serjeants.value = roundOrPercent(document.formLFP.num_guards.value / 6.0);
# 	// Populate ruling house (family and support staff)
# 	document.formLFP.num_rulinghouse.value = parseInt(document.formLFP.num_family.value) + parseInt(document.formLFP.num_servants.value) + parseInt(document.formLFP.num_guards.value) + parseInt(document.formLFP.num_serjeants.value);
# 	// Populate other noble households; 1 house per 450 population
# 	document.formLFP.num_noblehouses.value = roundOrPercent(document.formLFP.pop_total.value / 450);
# 	tempNobles = 0;
# 	// Determine size of each house separately
# 	for (i = 0; i < document.formLFP.num_noblehouses.value; i++) {
# 		randNobles = roundOrPercent(Math.round(8 * Math.random()) + 2); // 3-10 nobles/house
# 		tempNobles += parseInt(randNobles);
# 	}
# 	document.formLFP.num_nobles.value = tempNobles;
# 	// Total noble population
# 	noblePop = parseInt(document.formLFP.num_rulinghouse.value) + parseInt(document.formLFP.num_nobles.value);
# 	document.formLFP.ovr_nobles.value = noblePop;
# 	return true;
# }

# function officerCalc() {
# 	officerPop = 0;
# 	// Initialise individual officers; modify according to level of local law enforcement
# 	var numReeve = 80 * document.formLFP.thug_zeal.options[document.formLFP.thug_zeal.selectedIndex].value; // base 80%
# 	var numMessor = 75 * document.formLFP.thug_zeal.options[document.formLFP.thug_zeal.selectedIndex].value; // base 80%
# 	var numWoodward = 70 * document.formLFP.thug_zeal.options[document.formLFP.thug_zeal.selectedIndex].value; // base 80%
# 	var numConstable = 90 * document.formLFP.thug_zeal.options[document.formLFP.thug_zeal.selectedIndex].value; // base 90%
# 	// Determine the presence of each officer
# 	// There is only one of each; staff may be drawn from the pool of law enforcement officers (see below)
# 	if (Math.round(100 * Math.random()) < numReeve) {
# 		document.formLFP.num_reeve.value = 1;
# 		officerPop = officerPop + 1;
# 	} else {
# 		document.formLFP.num_reeve.value = 0;
# 	}
# 	if (Math.round(100 * Math.random()) < numMessor) {
# 		document.formLFP.num_messor.value = 1;
# 		officerPop = officerPop + 1;
# 	} else {
# 		document.formLFP.num_messor.value = 0;
# 	}
# 	if (Math.round(100 * Math.random()) < numWoodward) {
# 		document.formLFP.num_woodward.value = 1;
# 		officerPop = officerPop + 1;
# 	} else {
# 		document.formLFP.num_woodward.value = 0;
# 	}
# 	if (Math.round(100 * Math.random()) < numConstable) {
# 		document.formLFP.num_constable.value = 1;
# 		officerPop = officerPop + 1;
# 	} else {
# 		document.formLFP.num_constable.value = 0;
# 	}
# 	// Average of 1 law enforcement officer per 150 population; could assist any officer above
# 	document.formLFP.num_thugs.value = roundOrPercent(document.formLFP.pop_total.value * document.formLFP.thug_zeal.options[document.formLFP.thug_zeal.selectedIndex].value / 150);
# 	// Total officer population and populate the form
# 	officerPop = officerPop + parseInt(document.formLFP.num_thugs.value);
# 	document.formLFP.ovr_officers.value = officerPop;
# 	return true;
# }

# function clergyCalc() {
# 	// 1 cleric/120 population; 1 priest/30 clergy
# 	document.formLFP.num_clergy.value = roundOrPercent(document.formLFP.pop_total.value / 120);
# 	document.formLFP.num_priests.value = roundOrPercent(document.formLFP.num_clergy.value / 30);
# 	// Total clergy population and populate the form
# 	clergyPop = parseInt(document.formLFP.num_clergy.value) + parseInt(document.formLFP.num_priests.value);
# 	document.formLFP.ovr_clergy.value = clergyPop;
# 	return true;
# }

# function freeholderCalc() {
# 	// Freeholders exist as a function of overall population size
# 	// Values based on S. John Ross' "Medieval Demographics Made Easy" (http://www.io.com/~sjohn/demog.htm)
# 	document.formLFP.num_adventurers.value = roundOrPercent(document.formLFP.pop_total.value / 3000);
# 	document.formLFP.num_apothecaries.value = roundOrPercent(document.formLFP.pop_total.value / 2800);
# 	document.formLFP.num_armourers.value = roundOrPercent(document.formLFP.pop_total.value / 1500);
# 	document.formLFP.num_artists.value = roundOrPercent(document.formLFP.pop_total.value / 2000);
# 	document.formLFP.num_butchers.value = roundOrPercent(document.formLFP.pop_total.value / 1100);
# 	document.formLFP.num_chandlers.value = roundOrPercent(document.formLFP.pop_total.value / 600);
# 	document.formLFP.num_charcoalers.value = roundOrPercent(document.formLFP.pop_total.value / 400);
# 	document.formLFP.num_cobblers.value = roundOrPercent(document.formLFP.pop_total.value / 150);
# 	document.formLFP.num_entertainers.value = roundOrPercent(document.formLFP.pop_total.value / 1200);
# 	document.formLFP.num_foresters.value = roundOrPercent(document.formLFP.pop_total.value / 800);
# 	document.formLFP.num_furriers.value = roundOrPercent(document.formLFP.pop_total.value / 250);
# 	document.formLFP.num_glassworkers.value = roundOrPercent(document.formLFP.pop_total.value / 950);
# 	document.formLFP.num_innkeepers.value = roundOrPercent(document.formLFP.pop_total.value / 2000);
# 	document.formLFP.num_jewelers.value = roundOrPercent(document.formLFP.pop_total.value / 400);
# 	document.formLFP.num_litigants.value = roundOrPercent(document.formLFP.pop_total.value / 800);
# 	document.formLFP.num_locksmiths.value = roundOrPercent(document.formLFP.pop_total.value / 1800);
# 	document.formLFP.num_masons.value = roundOrPercent(document.formLFP.pop_total.value / 500);
# 	document.formLFP.num_metalsmiths.value = roundOrPercent(document.formLFP.pop_total.value / 300);
# 	document.formLFP.num_millers.value = roundOrPercent(document.formLFP.pop_total.value / 250);
# 	document.formLFP.num_ostlers.value = roundOrPercent(document.formLFP.pop_total.value / 600);
# 	document.formLFP.num_outfitters.value = roundOrPercent(document.formLFP.pop_total.value / 1500);
# 	document.formLFP.num_physicians.value = roundOrPercent(document.formLFP.pop_total.value / 600);
# 	document.formLFP.num_potters.value = roundOrPercent(document.formLFP.pop_total.value / 450);
# 	document.formLFP.num_roofers.value = roundOrPercent(document.formLFP.pop_total.value / 1800);
# 	document.formLFP.num_ropemakers.value = roundOrPercent(document.formLFP.pop_total.value / 1800);
# 	document.formLFP.num_sages.value = roundOrPercent(document.formLFP.pop_total.value / 1800);
# 	document.formLFP.num_salters.value = roundOrPercent(document.formLFP.pop_total.value / 600);
# 	document.formLFP.num_scribes.value = roundOrPercent(document.formLFP.pop_total.value / 2000);
# 	document.formLFP.num_shipwrights.value = roundOrPercent(document.formLFP.pop_total.value / 2400);
# 	document.formLFP.num_tailors.value = roundOrPercent(document.formLFP.pop_total.value / 250);
# 	document.formLFP.num_tanners.value = roundOrPercent(document.formLFP.pop_total.value / 1200);
# 	document.formLFP.num_taverns.value = roundOrPercent(document.formLFP.pop_total.value / 450);
# 	document.formLFP.num_teamsters.value = roundOrPercent(document.formLFP.pop_total.value / 1400);
# 	document.formLFP.num_timberwrights.value = roundOrPercent(document.formLFP.pop_total.value / 700);
# 	document.formLFP.num_tinkers.value = roundOrPercent(document.formLFP.pop_total.value / 800);
# 	document.formLFP.num_vintners.value = roundOrPercent(document.formLFP.pop_total.value / 900);
# 	document.formLFP.num_weaponcrafters.value = roundOrPercent(document.formLFP.pop_total.value / 1000);
# 	document.formLFP.num_weavers.value = roundOrPercent(document.formLFP.pop_total.value / 600);
# 	document.formLFP.num_woodcrafters.value = roundOrPercent(document.formLFP.pop_total.value / 300);
# 	document.formLFP.num_yeomen.value = roundOrPercent(iReqAcres / 450);
# 	// Total freeholder population and populate the form
# 	freeholderPop = parseInt(document.formLFP.num_adventurers.value) + parseInt(document.formLFP.num_apothecaries.value) + parseInt(document.formLFP.num_armourers.value) + parseInt(document.formLFP.num_artists.value) + parseInt(document.formLFP.num_butchers.value) + parseInt(document.formLFP.num_chandlers.value) + parseInt(document.formLFP.num_charcoalers.value) + parseInt(document.formLFP.num_cobblers.value) + parseInt(document.formLFP.num_entertainers.value) + parseInt(document.formLFP.num_foresters.value) + parseInt(document.formLFP.num_furriers.value) + parseInt(document.formLFP.num_glassworkers.value) + parseInt(document.formLFP.num_innkeepers.value) + parseInt(document.formLFP.num_jewelers.value) + parseInt(document.formLFP.num_litigants.value) + parseInt(document.formLFP.num_locksmiths.value) + parseInt(document.formLFP.num_masons.value) + parseInt(document.formLFP.num_metalsmiths.value) + parseInt(document.formLFP.num_millers.value) + parseInt(document.formLFP.num_ostlers.value) + parseInt(document.formLFP.num_outfitters.value) + parseInt(document.formLFP.num_physicians.value) + parseInt(document.formLFP.num_potters.value) + parseInt(document.formLFP.num_roofers.value) + parseInt(document.formLFP.num_ropemakers.value) + parseInt(document.formLFP.num_sages.value) + parseInt(document.formLFP.num_salters.value) + parseInt(document.formLFP.num_scribes.value) + parseInt(document.formLFP.num_shipwrights.value) + parseInt(document.formLFP.num_tailors.value) + parseInt(document.formLFP.num_tanners.value) + parseInt(document.formLFP.num_taverns.value) + parseInt(document.formLFP.num_teamsters.value) + parseInt(document.formLFP.num_timberwrights.value) + parseInt(document.formLFP.num_tinkers.value) + parseInt(document.formLFP.num_vintners.value) + parseInt(document.formLFP.num_weaponcrafters.value) + parseInt(document.formLFP.num_weavers.value) + parseInt(document.formLFP.num_woodcrafters.value) + parseInt(document.formLFP.num_yeomen.value);
# 	document.formLFP.ovr_freeholders.value = freeholderPop;
# 	return true;
# }

# function citizenCalc() {
# 	// First figure out how many hirelings exist: 1 hireling per 300 population
# 	// Hirelings are considered bearers, porters, guides, trappers, or outdoorsmen who may go with adventurers
# 	document.formLFP.ovr_hirelings.value = roundOrPercent(document.formLFP.pop_total.value / 300);
# 	hirelingPop = parseInt(document.formLFP.ovr_hirelings.value);
# 	// The remaining population are considered citizens
# 	// i.e., everyone who's *not* a noble, officer, clergy, freeholder, or hireling
# 	noncitizenPop = parseInt(noblePop + officerPop + clergyPop + freeholderPop + hirelingPop);
# 	document.formLFP.ovr_citizens.value = parseInt(document.formLFP.pop_total.value) - noncitizenPop;
# 	citizenPop = document.formLFP.ovr_citizens.value;
# 	// Calculate the buildings required to house these people
# 	buildCalc();
# }

# function buildCalc() {
# 	// Noble housing: 1 mansion per noble household, plus 1 for the ruling house
# 	var nobleBldg = parseInt(document.formLFP.num_noblehouses.value) + 1;
# 	// Churches: 1 temple, shrine, or church per 16 clergy
# 	if (parseInt(clergyPop < 1)) {
# 		clergyBldg = 0;
# 	} else {
# 		clergyBldg = Math.round(clergyPop / 16) + 1;
# 	}
# 	// Freeholders: 1 business/residence per freeholder
# 	var freeholderBldg = parseInt(document.formLFP.ovr_freeholders.value);
# 	// Add industrial buildings for non-residential businesses
# 	var industryBldg = parseInt(document.formLFP.num_armourers.value) + parseInt(document.formLFP.num_butchers.value) + parseInt(document.formLFP.num_metalsmiths.value) + parseInt(document.formLFP.num_millers.value) +  parseInt(document.formLFP.num_ostlers.value) + parseInt(document.formLFP.num_salters.value) + parseInt(document.formLFP.num_shipwrights.value) + parseInt(document.formLFP.num_tanners.value) + parseInt(document.formLFP.num_timberwrights.value) + parseInt(document.formLFP.num_weaponcrafters.value);
# 	freeholderBldg = freeholderBldg + industryBldg;
# 	// Municipal buildings: 1 building/10 law enforcement agents
# 	// Buildings consist of: town hall, watch stations, garrisons & barracks, etc.
# 	var officerBldg = Math.round(parseInt(document.formLFP.ovr_officers.value) / 10);
# 	// Determine how many homes are required for the rest of the population
# 	// We'll break out the freeholder families, since their homes are already accounted for
# 	var freeholderFamilies = Math.round(parseInt(document.formLFP.ovr_freeholders.value) * 4.0);
# 	// Determine the "normal" population of citizens and hirelings
# 	var normalPop = parseInt(document.formLFP.ovr_citizens.value) + parseInt(document.formLFP.ovr_hirelings.value);
# 	// Remove freeholder families from the rabble
# 	normalPop = normalPop - freeholderFamilies;
# 	// Assume an average household is 4.75 people
# 	var citizenBldg = Math.round(normalPop / 4.75);
# 	// Add up the totals and populate the form
# 	var totalBldg = nobleBldg + clergyBldg + freeholderBldg + officerBldg + citizenBldg;
# 	document.formLFP.bldg_nobles.value = nobleBldg;
# 	document.formLFP.bldg_clergy.value = clergyBldg;
# 	document.formLFP.bldg_freeholders.value = freeholderBldg;
# 	document.formLFP.bldg_officers.value = officerBldg;
# 	document.formLFP.bldg_citizens.value = citizenBldg;
# 	document.formLFP.bldg_total.value = totalBldg;
# 	return true;
# }

# // Math functions; do not edit
# function roundOrPercent(bizPercent) {
# 	if (bizPercent < 1) {
# 	    // Random 1d100 roll to see if business exists
# 		var percentRoll = Math.round(100 * Math.random());
# 	    if (percentRoll < Math.round(bizPercent * 100)) {
# 	        bizPercent = 1;
# 		} else {
# 			bizPercent = 0;
# 		}
# 	} else {
# 		// We want to capture the complete bizPercent value
# 		// e.g., a bizPercent of 2.63 indicates two businesses, with a 63% chance of a third
# 		// so we'll take the whole number and process the fraction separately
# 		// First is extracting the whole number (e.g., 2.63 = 2)
# 		var bizWhole = Math.floor(bizPercent);
# 		// Then we deal with the value to the right of the decimal
# 		// There's probably a more efficient way to do this, so bear with me as I explain my logic:
# 		// Round bizPercent up to the nearest whole and hold it in bizTemp (e.g., 2.63 = 3)
# 		var bizTemp = Math.ceil(bizPercent);
# 		// Subtract bizPercent from bizTemp (e.g., 3 - 2.63 = 0.37)
# 		bizTemp = bizTemp - bizPercent;
# 		// Subtract bizTemp from 1 to get back to our original fraction (e.g., 1 - 0.37 = 0.63)
# 		var bizFraction = 1 - bizTemp;
# 		// Now we can do our random roll thing
# 		var percentRoll = Math.round(100 * Math.random());
# 		if (percentRoll < Math.round(bizFraction * 100)) {
# 	        bizPercent = bizWhole + 1;
# 		} else {
# 			bizPercent = bizWhole;
# 		}
# 	}
# 	return bizPercent;
# }
# function roundTo(base, precision) {
# 	var m = Math.pow(10,precision);
# 	var a = Math.round(base * m) / m;
# 	return a;
# }
# // End math functions
