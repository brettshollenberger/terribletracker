require 'spec_helper'

describe MembershipDecorator do

  describe "actions_dropdown method" do
    let(:membership) { FactoryGirl.create(:membership).decorate }

    it "outputs formatted HTML" do
      expect(membership.actions_dropdown).to include("<div class=\"btn-group\"><a href=\"#\" class=\"btn dropdown-toggle\" data-toggle=\"dropdown\">")
    end
  end

end
