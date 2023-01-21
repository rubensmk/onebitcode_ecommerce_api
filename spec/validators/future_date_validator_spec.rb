require "rails_helper"

class Validatable
  include ActiveModel::Validations
  attr_accessor :date

  validates :date, future_date: true
end

describe FutureDateValidator do
  subject { Validatable.new }

  context "when date is before current date" do
    before { subject.date = 1.day.ago }

    it "is invalid" do
      expect(subject).not_to be_valid
    end

    it "adds a error on model" do
      subject.valid?
      expect(subject.errors.keys).to include(:date)
    end
  end

  context "when date is current date" do
    before { subject.date = Time.zone.now }

    it "is invalid" do
      expect(subject).not_to be_valid
    end

    it "adds a error on model" do
      subject.valid?
      expect(subject.errors.keys).to include(:date)
    end
  end

  context "when date is after current date" do
    before { subject.date = Time.zone.now + 1.day }

    it "is valid" do
      expect(subject).to be_valid
    end
  end
end
