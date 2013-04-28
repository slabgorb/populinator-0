class Ruler < Person
  @@titles = YAML::load(File.read(File.join(Rails.root, 'words', ENV['POP_LANGUAGE'], 'titles.yml')))
  field :title, type: String
  belongs_to :settlement
  after_create :set_title
  def set_title
    unless self.title.present?
      if self.settlement.present?
        pop = settlement.population
        @@titles.each{ |k,v| self.title = v.capitalize if k < pop }
        self.title = @@titles.to_a.last unless self.title.present?
      end
      save
    end
  end
end
