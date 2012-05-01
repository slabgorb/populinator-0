[
 {:category => 'life', :name =>'die'     ,:description => 'died',        :effect => '{|a| a.die! }'},
 {:category => 'life',:name =>'receive' ,:description => 'received a',  :effect => '{|a,t| a.own t }'},
 {:category => 'life',:name =>'marriage',:description => 'was married', :effect => '{|a,b| a.marry b }'},
 {:category => 'life',:name =>'damage'  ,:description => 'was hurt',    :effect => '{|a, i| a.damage i }'},
 {:category => 'life',:name =>'heal'    ,:description => 'was healed',  :effect => '{|a, i| a.heal i}'},
 {:category => 'disaster',:name =>'famine'  ,:description => 'had a famine',:effect => '{|settlement, virulence| settlement.beings.each{|b| b.die! if rand < virulence and b.alive? }}'},
 {:category => 'disaster',:name =>'epidemic'  ,:description => 'had an epidemic',:effect => '{|settlement, virulence| settlement.beings.each{|b| b.die! if rand < virulence and b.alive? }}'},
 {:category => 'disaster',:name =>'flood'  ,:description => 'had a flood',:effect => '{|settlement, virulence| settlement.beings.each{|b| b.die! if rand < virulence and b.alive? }}'}
 
 
].each { |e| Event.create(e) }

