require "helper"

class CreateTrafficLights < ActiveRecord::Migration
  def self.up
    create_table(:traffic_lights, :force => true) do |t|
      t.string :state
      t.string :name
      t.timestamps
    end
  end
end

set_up_db CreateTrafficLights

class TrafficLight < ActiveRecord::Base
  include ActiveModel::Transitions

  state_machine do
    state :off
    state :on

    event :start do
      transitions :to => :on, :from => [:off]
    end
  end
end

class TestActiveModelBug < Test::Unit::TestCase
  def setup
    @light = TrafficLight.create!
  end

  test "buggy" do
    result = TrafficLight.select("id, name").where("updated_at = ?", @light.updated_at)
    puts result.inspect
  end
end
