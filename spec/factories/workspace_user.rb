# frozen_string_literal: true

FactoryBot.define do
  factory :workspace_user do
    association :workspace
    association :user
  end
end
