[
 {:name =>'receive' , :description => 'received a',  :effect => '{|a,t| a.own t }'},
 {:name =>'marriage', :description => 'was married', :effect => '{|a,b| a.marry b }'},
 {:name =>'damage'  , :description => 'was hurt',    :effect => '{|a, i| a.damage i }'},
 {:name =>'heal'    , :description => 'was healed',  :effect => '{|a, i| a.heal i}'}
].each { |e| Event.create(e) }

