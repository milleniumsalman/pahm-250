class Question < ActiveRecord::Base
  
    has_many :answers, :dependent => :destroy
    accepts_nested_attributes_for :answers, :reject_if => lambda { |a| a[:answer].blank? }, :allow_destroy => true

    validates :question, :presence => true
    validates :hint, :presence => true

  #  private

    def self.generate_random
      @a ||= (1..600).to_a.shuffle[1,75]

    end
    
    
end
