# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task do
  let(:task) { create(:task) }

  context 'validation' do
    subject { task.validate }

    context 'name(タスク名)' do
      it '必須になっていること' do
        task.name = nil
        is_expected.to be_falsey
      end
      it '101文字以上は入力不可になっていること' do
        task.name = 'a' * 101
        is_expected.to be_falsey
      end
    end
    context 'datail(詳細)' do
      it '201文字以上は入力不可になっていること' do
        task.detail = 'a' * 201
        is_expected.to be_falsey
      end
    end
  end
end
