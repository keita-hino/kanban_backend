class Task < ApplicationRecord
  ##
  # enums
  ##

  enum status: {
    unstarted: 1,
    in_progress: 2,
    done: 3
  }

end
