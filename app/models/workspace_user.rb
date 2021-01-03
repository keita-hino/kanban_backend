class WorkspaceUser < ApplicationRecord
  ##
  # relations
  ##

  belongs_to :user
  belongs_to :workspace
end
