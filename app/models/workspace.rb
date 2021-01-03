# frozen_string_literal: true

class Workspace < ApplicationRecord
  ##
  # relations
  ##

  has_many :tasks
end
