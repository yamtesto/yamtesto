require 'spec_helper'

describe Job do
  before(:each) do
    @valid_attributes = {
      :company => "value for company",
      :title => "value for title"
    }
  end

  it "should create a new instance given valid attributes" do
    Job.create!(@valid_attributes)
  end
end
