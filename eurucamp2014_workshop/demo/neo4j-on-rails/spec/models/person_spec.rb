require 'rails_helper'
require 'app/models/person'

describe Person, :type => :model do

  describe "validation" do
    let (:person)         { Person.create :name => "purbon", :email => "purbon@purbon.com" }

    it "should raise an exception when creating an invalid person" do
      expect(person.valid?).to eq(true)
    end

    describe "uniqueness" do
      let! (:another_person) { Person.create :name => "purbon", :email => "this is another email" }

      it "should not validate a person with the same name as a one before" do
        expect(another_person.valid?).to eq(false)
      end
    end

  end
end
