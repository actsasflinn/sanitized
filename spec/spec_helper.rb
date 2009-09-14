$:.unshift(File.dirname(__FILE__) + '/../lib/')

require 'rubygems'

begin
  require 'redgreen'
rescue LoadError
  nil
end

SANITIZED_ROOT = "#{File.dirname(__FILE__)}/.." unless defined? SANITIZED_ROOT
RAILS_ROOT = "#{SANITIZED_ROOT}/../../.."       unless defined? RAILS_ROOT
RAILS_ENV  = 'test'                             unless defined? RAILS_ENV

class Array
  def random
    self.sort_by{rand}.first
  end
end

module ArmyGuySpecHelper
  def any_name
    last   = %w[Washington Adams Jefferson Madison Monroe Adams Jackson Van\ Buren Harrison Tyler Polk].random
    first  = %w[George John Thomas James James John Andrew Martin William John James].random
    middle = ['A'..'Z'].random
    "#{last}, #{first} #{middle}."
  end

  def any_rank
    %w[PVT PV2 PFC SPC SGT SSG SFC MSG SGM CW1 CW2 CW3 CW4 CW5 LT2 LT1 CPT MAJ COL GEN].random
  end

  def any_tag
    /<(\/?)([A-Z][A-Z0-9]*)\b[^>]*>/i
  end

  def an_anchor_tag
    /<(\/?)a\b[^>]*>/i
  end

  def a_bold_tag
    /<(\/?)b\b[^>]*>/i
  end
end

def setup_rails_database
  require "#{RAILS_ROOT}/config/environment"

  # Only run if there is not already a connection
  unless ActiveRecord::Base.connected?
    db = YAML.load(IO.read("#{SANITIZED_ROOT}/spec/resources/config/database.yml"))
    ActiveRecord::Base.configurations = {'test' => db[ENV['DB'] || 'sqlite3']}
    ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['test'])
  end

  ActiveRecord::Migration.verbose = false
  load "#{SANITIZED_ROOT}/spec/resources/schema.rb"

  require "#{SANITIZED_ROOT}/init"
end
