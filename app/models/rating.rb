class Rating < ApplicationRecord
    belongs_to :rated_user, class_name: 'User'
    belongs_to :rating_user, class_name: 'User'
    belongs_to :publish 
    validates :value, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
    after_save :update_rated_user_rating
    private
    def update_rated_user_rating
      rated_user.update_average_rating
    end
 
end
