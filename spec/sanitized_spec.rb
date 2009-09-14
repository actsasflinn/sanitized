require File.dirname(__FILE__) + '/spec_helper'
require 'activerecord'

setup_rails_database

class ArmyGuy < ActiveRecord::Base
  sanitized :name
  sanitized :rank, :elements => ['a']
end

describe ArmyGuy do
  include ArmyGuySpecHelper

  describe "name" do
    it "should not allow tags" do
      army_guy = ArmyGuy.new(:name => "<b>Joe Snuffy</b>")
      army_guy.rank.should_not match any_tag
    end
  end

  describe "rank" do
    before(:each) do
      @army_guy = ArmyGuy.create(:name => any_name, :rank => '<a href="http://example.com/"><b>Cpt</b></a>')
    end

    it "should allow anchor tags" do
      @army_guy.rank.should match an_anchor_tag
    end

    it "should not allow bold tags" do
      @army_guy.rank.should_not match a_bold_tag
    end
  end

  describe "notes" do
    it "should allow tags" do
      notes = "<p>This soldier is <strong>top notch</strong>. He goes above and beyond and is a joy to work with.</p>"
      army_guy = ArmyGuy.create(:name => any_name, :rank => any_rank, :notes => notes)
      army_guy.notes.should == notes
    end
  end
end
