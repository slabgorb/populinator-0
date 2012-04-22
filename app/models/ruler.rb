class Ruler < Person
  @@titles = YAML::load(File.read(File.join(Rails.root, 'words', 'titles.yml')))
  field :title, :type => String
  belongs_to :settlement
  before_create :set_title
  protected
  def set_title
    unless self.title.present?
      if self.settlement.present?
        pop = settlement.population
        @@titles.each{ |k,v| self.title = v if k < pop }
        self.title = @@titles.last unless self.title.present?
      end
    end
  end
end
