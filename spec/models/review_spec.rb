require 'rails_helper'

describe Review, type: :model do
  describe "validations" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :content }
    it { should validate_presence_of :rating }
    it { should validate_numericality_of(:rating).only_integer.is_greater_than(0).is_less_than(6)}
  end

  describe "relationships" do
    it { should belong_to :item}
  end
end
