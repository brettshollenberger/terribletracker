require 'spec_helper'

describe MembershipDecorator do
  let(:membership) { FactoryGirl.create(:membership).decorate }

  describe "actions_dropdown method" do

    it "outputs formatted HTML" do
      expect(membership.actions_dropdown).to include("<div class=\"btn-group\"><a href=\"#\" class=\"btn dropdown-toggle\" data-toggle=\"dropdown\">")
    end
  end

  describe "team_actions_dropdown" do
    it "outputs formatted HTML" do
      expect(membership.team_actions_dropdown).to include('<div class="btn-group"><a href="#" class="btn dropdown-toggle" data-toggle="dropdown">Action')
    end
  end

end
