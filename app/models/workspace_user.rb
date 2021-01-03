# frozen_string_literal: true

class WorkspaceUser < ApplicationRecord
  ##
  # relations
  ##

  belongs_to :user
  belongs_to :workspace
end
